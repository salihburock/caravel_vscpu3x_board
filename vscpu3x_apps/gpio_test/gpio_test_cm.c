/* GPIO memory-mapped I/O example: relay two inputs, generate a quadrature pair.
 *
 * The VSCPU reaches the outside world through two memory-mapped registers.
 * They are at DIFFERENT addresses, which is the usual thing to get wrong:
 *
 *   8254  write  -> GPIO output, bit n drives pad IO(27 + n)
 *   8255  read   -> GPIO input,  bit n reads  pad IO(16 + n)
 *
 * Reading 8254 gives back the last value written to the output register, not
 * the inputs. There is no other way in or out: these two addresses are the
 * entire interface.
 *
 * This program shows both directions at once, on the four output pins the
 * board brings out to J3:
 *
 *   out bit 0 (IO27) = in bit 0 (IO16)   relayed straight through
 *   out bit 1 (IO28) = in bit 1 (IO17)   relayed straight through
 *   out bit 2 (IO29) = quadrature A      free-running
 *   out bit 3 (IO30) = quadrature B      90 degrees behind A
 *
 * The quadrature pair steps through a Gray code, so exactly one of the two
 * lines changes at each step:
 *
 *   state   A B   output bits 3:2
 *     0     0 0   00  = 0
 *     1     1 0   01  = 4
 *     2     1 1   11  = 12
 *     3     0 1   10  = 8
 *
 * That is what a rotary encoder produces, and it is easy to confirm on a logic
 * analyzer: the two channels are square waves of equal frequency, offset by a
 * quarter period, and never transition on the same edge.
 */
#define GPIO_OUT (*((unsigned int *)8254))
#define GPIO_IN  (*((unsigned int *)8255))

/* Loop iterations per quadrature step. Raise to slow the pair down. */
#define STEP_LOOPS 2000

/* Output bits 3:2 for each quadrature state, Gray coded. */
unsigned int quad[4] = {0, 4, 12, 8};

int main(void) {
    unsigned int raw;
    unsigned int relay;
    unsigned int state;
    unsigned int wait;

    GPIO_OUT = 0;
    state = 0;

    while (1) {
        /* Read the inputs and keep the two the board wires to J3 */
        raw = GPIO_IN;
        relay = raw & 3;

        /* One write drives all four pins: both relays and both clock phases */
        GPIO_OUT = relay | quad[state];

        state = state + 1;
        state = state & 3;

        wait = 0;
        while (wait < STEP_LOOPS) {
            wait = wait + 1;
        }
    }
    return 0;
}
