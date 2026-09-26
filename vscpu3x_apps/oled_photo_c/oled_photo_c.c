/* VSCPU word-addressed GPIO: MOSI=1, SCK=2, CS=4, D/C=8.
 * Built with vscc_static. This compiler emits each pointer store;
 * its C subset does not support volatile. Do not use a host C compiler
 * to build this hardware program.
 */
#define GPIO_OUT (*((unsigned int *)8254))

unsigned int init_commands[17] = {174, 32, 0, 33, 0, 127, 34, 0, 7, 129, 207, 161, 200, 166, 141, 20, 175};

/* Four display bytes per word; first column in bits 31:24.
 * Keep initializers within the compiler limit of 256 entries. */
unsigned int image[256] = {
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 5372, 4244144128, 0, 32960, 4042800156,
    67108864, 2162225400, 941366284, 203164700, 473437184, 0, 32960, 4033902616,
    470555660, 203164700, 943214592, 0, 4258044, 2081164300, 203164860, 4244172800,
    0, 10550524, 3154116608, 0, 53500, 4233887744, 0, 0,
    0, 0, 0, 5, 3221225120, 49376, 4169015047, 50331648,
    0, 34541343, 505158716, 943257840, 4030726144, 0, 3640655791, 50331648,
    0, 0, 0, 0, 3909091135, 825765944, 808983583, 252117248,
    64, 4211080983, 0, 0, 3237674879, 184549376, 0, 0,
    0, 0, 0, 0, 999231, 1027542787, 16777216, 0,
    7192, 1010317360, 808988728, 941498127, 117506048, 0, 34017055, 1008220208,
    942684208, 404495370, 0, 61, 1061094656, 0, 0, 0,
    5, 253705756, 808988728, 808983582, 252117760, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
};

void spi_byte(unsigned int value, unsigned int dc) {
    unsigned int count;
    unsigned int pins;
    for (count = 0; count < 8; count = count + 1) {
        pins = dc;
        if (value >= 128) {
            pins = pins + 1;
            value = value - 128;
        }
        GPIO_OUT = pins;
        GPIO_OUT = pins + 2;
        GPIO_OUT = pins;
        value = value * 2;
    }
}

int main(void) {
    unsigned int i;
    GPIO_OUT = 4;
    GPIO_OUT = 0;
    for (i = 0; i < 17; i = i + 1) {
        spi_byte(init_commands[i], 0);
    }
    for (i = 0; i < 256; i = i + 1) {
        spi_byte(image[i] >> 24, 8);
        spi_byte((image[i] >> 16) & 255, 8);
        spi_byte((image[i] >> 8) & 255, 8);
        spi_byte(image[i] & 255, 8);
    }
    GPIO_OUT = 4;
    return 0;
}
