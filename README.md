# Single-Cycle RISC-V RV32I Processor

A single-cycle 32-bit RISC-V processor written in SystemVerilog and implemented on the Digilent Basys 3 FPGA board. The design was built to practice RTL design, computer architecture, FPGA implementation, Vivado simulation, timing closure, and hardware bring-up.

## Overview

This project implements a small RV32I-style CPU datapath with instruction fetch, decode, execute, control logic, a 32-entry register file, instruction ROM, and Basys 3 hardware output. The design was simulated in Vivado, synthesized and implemented for the Artix-7 FPGA on the Basys 3, then tested on the physical board using switches, LEDs, the seven-segment display, and the center reset button.

The current FPGA build meets timing with an 11 ns clock constraint, which is approximately 90.9 MHz.

## Features

- Single-cycle datapath: fetch -> decode -> execute
- SystemVerilog RTL implementation
- 32-bit datapath and register values
- 32-entry register file with `x0` hardwired to zero
- Instruction ROM initialized with a test program
- ALU support for arithmetic, logic, shifts, and comparisons
- Branch and jump control logic
- Basys 3 top-level wrapper
- Switch-selectable register display
- Seven-segment display output
- `btnC` reset support
- Vivado simulation, synthesis, implementation, and bitstream generation

## Repository Structure

```text
RISC-V-System-Verilog/
  README.md
  src/
    Design/
      alu.sv
      basys3_top.sv
      ctrl_unit.sv
      ex_stage.sv
      id_stage.sv
      if_stage.sv
      regfile.sv
      rom.sv
      seven_seg_ctrl.sv
      top_level.sv
    Constraints/
      basys3.xdc
    Testbench/
      basys3_top_tb.sv
```

## Module Overview

| Module | Description |
|---|---|
| `top_level.sv` | Connects the CPU stages and control logic into the full datapath. |
| `if_stage.sv` | Manages the program counter and fetches instructions from ROM. |
| `id_stage.sv` | Decodes instruction fields, generates immediates, and reads the register file. |
| `ex_stage.sv` | Runs ALU operations and resolves branch/jump targets. |
| `ctrl_unit.sv` | Generates datapath control signals from opcode/funct fields. |
| `alu.sv` | Performs 32-bit arithmetic, logic, shift, and comparison operations. |
| `regfile.sv` | Implements the 32-register RISC-V register file with `x0 = 0`. |
| `rom.sv` | Stores the test program used during simulation and FPGA testing. |
| `basys3_top.sv` | Maps the CPU to Basys 3 switches, LEDs, reset button, and seven-segment display. |
| `seven_seg_ctrl.sv` | Drives the multiplexed Basys 3 seven-segment display. |
| `basys3.xdc` | Defines Basys 3 pin mappings and the clock constraint. |
| `basys3_top_tb.sv` | Simulation testbench for validating the top-level behavior. |

## FPGA Demo

On the Basys 3 board:

- `SW[4:0]` selects which register (`x0` to `x31`) is shown.
- `LED[4:0]` mirrors the switch value.
- The seven-segment display shows the selected register value.
- `btnC` resets the CPU.

The switches select a register number; they are not the value being displayed. For example, `00011` selects register `x3`, and the display shows the contents stored in `x3`.

## Hardware Test Results

These values were observed during hardware testing after programming the Basys 3:

| Switches | Selected Register | Expected Display |
|---|---:|---:|
| `00000` | `x0` | `0000` |
| `00001` | `x1` | `0005` |
| `00010` | `x2` | `0003` |
| `00011` | `x3` | `0008` |
| `00100` | `x4` | `0002` |
| `01000` | `x8` | `0028` |

Reset behavior was also verified: pressing `btnC` drives the display to `0`, and releasing it allows the CPU to restart and return to the expected register value.

## Timing

The design was implemented in Vivado for the Basys 3 Artix-7 FPGA and met timing with the following clock constraint:

```tcl
create_clock -add -name sys_clk_pin -period 11.00 -waveform {0 5.5} [get_ports clk]
```

This corresponds to a target frequency of approximately 90.9 MHz. Further optimization or pipelining would be needed to reliably target a 10 ns / 100 MHz clock constraint.

## Tools and Hardware

- SystemVerilog
- Xilinx Vivado 2018.3
- Digilent Basys 3 FPGA board
- Xilinx Artix-7 `xc7a35t`

## Future Work

- Add a 5-stage pipelined version
- Add hazard detection and forwarding
- Expand verification with a stronger testbench or UVM environment
- Add data memory support for more complete load/store testing
- Improve timing to target the Basys 3 100 MHz onboard clock
