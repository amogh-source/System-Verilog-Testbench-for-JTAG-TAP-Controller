# Layered Testbench for JTAG TAP Controller

## Overview

This project implements a **layered SystemVerilog verification environment** for a JTAG (Joint Test Action Group) TAP (Test Access Port) controller.

The TAP controller is modeled as a **16-state finite state machine (FSM)**. The verification environment generates randomized TMS stimulus, drives it to the DUT, monitors the resulting state and output signals, checks the outputs using a scoreboard, collects functional coverage, and verifies state transitions using SystemVerilog Assertions (SVA).

The project demonstrates the use of:

- SystemVerilog classes
- Layered testbench architecture
- Randomized stimulus generation
- Mailboxes
- Virtual interfaces
- Driver and monitor components
- Scoreboard-based checking
- Functional coverage
- SystemVerilog Assertions (SVA)

---

## DUT: JTAG TAP Controller

The Design Under Test (DUT) is a JTAG TAP controller implemented as a finite state machine.

The controller contains the 16 states defined by the JTAG TAP state machine:

### Test Logic Reset
- `TEST_LOGIC_RESET`

### Run-Test/Idle
- `RUN_TEST_IDLE`

### Data Register Path
- `SELECT_DR`
- `CAPTURE_DR`
- `SHIFT_DR`
- `EXIT1_DR`
- `PAUSE_DR`
- `EXIT2_DR`
- `UPDATE_DR`

### Instruction Register Path
- `SELECT_IR`
- `CAPTURE_IR`
- `SHIFT_IR`
- `EXIT1_IR`
- `PAUSE_IR`
- `EXIT2_IR`
- `UPDATE_IR`

State transitions are controlled by the `TMS` signal and occur on the rising edge of `TCK`.

---

## DUT Interface

| Signal | Description |
|--------|-------------|
| `tck` | Test Clock |
| `tms` | Test Mode Select |
| `trst` | Test Reset, active low |
| `cdr1` | Capture-DR indication |
| `sdr1` | Shift-DR indication |
| `udr1` | Update-DR indication |
| `cir1` | Capture-IR indication |
| `sir1` | Shift-IR indication |
| `uir1` | Update-IR indication |
| `state_out[3:0]` | Current TAP controller state |

The `cdr1`, `sdr1`, `udr1`, `cir1`, `sir1`, and `uir1` signals are generated according to the current FSM state.

---

## Verification Environment

The testbench follows a layered verification architecture:

```text
                 +----------------+
                 |    Generator   |
                 +--------+-------+
                          |
                     gen2driv
                      mailbox
                          |
                          v
                 +----------------+
                 |     Driver     |
                 +--------+-------+
                          |
                    Virtual Interface
                          |
                          v
                 +----------------+
                 |      DUT       |
                 | JTAG TAP FSM   |
                 +--------+-------+
                          |
                    Virtual Interface
                          |
                          v
                 +----------------+
                 |    Monitor     |
                 +--------+-------+
                          |
                     mon2scb
                      mailbox
                          |
                          v
                 +----------------+
                 |   Scoreboard   |
                 +----------------+

                 +----------------+
                 |   Assertions   |
                 |      (SVA)     |
                 +----------------+

                 +----------------+
                 |    Coverage    |
                 +----------------+
