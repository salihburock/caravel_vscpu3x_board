# gpio_test

A memory-mapped I/O example: it reads the two inputs the board brings out,
relays them to two output pins, and drives the other two outputs as a
quadrature pair.

Everything happens through two addresses — see
[GPIO](../../vscpu3x_docs/Quickstart.md#gpio-memory-mapped-io):

```c
#define GPIO_OUT (*((unsigned int *)8254))   /* write */
#define GPIO_IN  (*((unsigned int *)8255))   /* read  */
```

## Pins

| Output bit | Pad | J3 | Carries |
|---|---|---|---|
| 0 | IO27 | 7 | relay of input bit 0 |
| 1 | IO28 | 6 | relay of input bit 1 |
| 2 | IO29 | 5 | quadrature A |
| 3 | IO30 | 4 | quadrature B, 90 degrees behind A |

| Input bit | Pad | J3 |
|---|---|---|
| 0 | IO16 | 2 |
| 1 | IO17 | 3 |

To drive an input high, connect it to J3 pin 1 (+3.3 V).

## What you should see

On a logic analyzer, the two relay channels follow the switches directly, and
the two quadrature channels are equal-frequency square waves a quarter period
apart. The pair is Gray coded, so exactly one of them changes at each step:

```
state   A B
  0     0 0
  1     1 0
  2     1 1
  3     0 1
```

That is the signal a rotary encoder produces. `STEP_LOOPS` in the source sets
the step rate; raise it to slow the pair down.

## Upload

```bash
cd vscpu3x_apps/utils
python3 run_test.py gpio_test /dev/ttyUSB0 --memclear
```

104 words, so it fits any of the three cores.
