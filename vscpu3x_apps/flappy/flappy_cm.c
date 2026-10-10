/* A dot that jumps when the button is pressed.
 *
 * Addresses, per main_memory.v in the caravel_vscpu3x RTL:
 *   8254 = GPIO out: MOSI 1 (IO27), SCK 2 (IO28), CS 4 active low (IO29),
 *          D/C 8 (IO30)
 *   8255 = GPIO in:  bit 0 = IO16 = GPIO_IN[0], the button
 *
 * These are two separate registers. Reading 8254 returns the output register,
 * not the inputs; that is the usual thing to get wrong here.
 *
 * The display is driven exactly like oled_test: the 17 command bytes set
 * horizontal addressing over the full window, then every frame streams 1024
 * data bytes and the address pointer wraps on its own. No address-window
 * commands are sent after init.
 *
 * Because the stream index in horizontal addressing is page * 128 + column, a
 * run of 8 consecutive indices is an 8x8 dot sitting on one page. So the whole
 * frame is "is this byte inside the dot's window", and nothing is buffered.
 *
 * Button held -> the dot moves up a page per frame. Released -> it falls.
 */
#define GPIO_OUT (*((unsigned int *)8254))
#define GPIO_IN  (*((unsigned int *)8255))

#define DOT_COL 60         /* left column of the dot */

unsigned int init_commands[17] = {174, 32, 0, 33, 0, 127, 34, 0, 7, 129, 207, 161, 200, 166, 141, 20, 175};

void spi_byte(unsigned int value, unsigned int dc) {
    unsigned int count;
    unsigned int pins;

    count = 0;
    while (count < 8) {
        pins = dc;
        if (value & 128) {
            pins = pins | 1;
        }

        GPIO_OUT = pins;
        GPIO_OUT = pins | 2;
        GPIO_OUT = pins;

        value = value << 1;
        count = count + 1;
    }
}

int main(void) {
    unsigned int i;
    unsigned int raw;
    unsigned int btn;
    unsigned int page;
    unsigned int lo;
    unsigned int hi;
    unsigned int v;

    GPIO_OUT = 4;
    GPIO_OUT = 0;

    i = 0;
    while (i < 17) {
        spi_byte(init_commands[i], 0);
        i = i + 1;
    }

    page = 4;

    while (1) {
        raw = GPIO_IN;
        btn = raw & 1;

        if (btn != 0) {
            if (page > 0) {
                page = page - 1;
            }
        }
        if (btn < 1) {
            if (page < 7) {
                page = page + 1;
            }
        }

        /* byte index = page * 128 + column */
        lo = (page << 7) + DOT_COL;
        hi = lo + 8;

        i = 0;
        while (i < 1024) {
            v = 0;
            if (i > lo - 1) {
                if (i < hi) {
                    v = 255;
                }
            }
            spi_byte(v, 8);
            i = i + 1;
        }
    }
    return 0;
}
