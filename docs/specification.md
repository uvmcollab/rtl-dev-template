# Debouncer RTL Notes

## Overview

The `debouncer` module filters short pulses on `sw_i` and only updates the debounced output after the input has remained stable for a programmable amount of time.

The implementation works in two stages:

1. `sw_i` is first synchronized into the `clk_i` domain using the two flip-flop chain `ff1` and `ff2`.
2. A counter measures how long the synchronized value remains unchanged. When the stable interval reaches the programmed threshold, the debounced output is updated.

Because the debounce logic operates on the synchronized copy of the input, the raw asynchronous signal is not used directly for qualification.

## Timing Model

The debounce threshold is:

```text
CounterMax = ClkFreq * StableTime / 1_000_000
```

where:

- `ClkFreq` is in Hz
- `StableTime` is in us

This means the synchronized input must remain stable for `CounterMax` clock cycles to be accepted.

There is also a synchronization latency of approximately 2 clock cycles due to `ff1` and `ff2`.

Therefore:

```text
Debounce qualification: CounterMax stable cycles
Total response latency: approximately 2 + CounterMax clock cycles
```

Example for `ClkFreq = 100_000_000` and `StableTime = 1`:

```text
CounterMax = 100
Clock period = 10 ns
Required stable time = 100 cycles = 1 us
Total latency from raw sw_i to db_level_o ~= 102 cycles = 1.02 us
```

## Counter Operation

The counter is cleared whenever a change is detected between the synchronizer stages:

```text
clear_cnt = ff1 ^ ff2
```

As long as `ff1` and `ff2` differ, the input is considered unstable and the counter is reset. Once both match, the counter starts counting the stable interval. When the counter reaches terminal count, `ena_cnt` asserts and the debounced output is updated.

## Outputs

- `db_level_o`
  Debounced level version of `sw_i`. It changes only after the synchronized input has remained stable for the configured debounce interval.

- `db_tick_o`
  One-clock pulse generated on the rising transition of `db_level_o`.

## Boundary Condition

The original RTL accepts the debounced value when the stable interval reaches the threshold exactly. In other words, the design behavior is:

```text
stable for CounterMax cycles or more
```

A new transition may begin propagating through the synchronizer at the same time that the previous stable interval qualifies. This is expected and is not an error in this implementation. The counter restarts for the new transition while the already qualified stable value is still allowed to update the output.

## Design Note

This behavior is intentional because the debounce decision is made using the synchronized copy of the input (`ff2`), not the raw asynchronous `sw_i`. As a result, the module is robust to asynchronous input timing and avoids using the unsynchronized signal in the qualification logic.


## References

[Digikey TechForum - Debounce Logic Circuit](https://forum.digikey.com/t/debounce-logic-circuit-vhdl/12573)