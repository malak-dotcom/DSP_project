# Configurable DSP Slice Architecture (Verilog)

A robust, highly parameterizable digital signal processing (**DSP**) hardware architecture implemented in **Verilog HDL**, inspired by standard FPGA DSP slices (such as the Xilinx DSP48A1)[cite: 14]. This design supports advanced arithmetic operations, dynamic multiplexing, and configurable pipeline registers.

---

## 🏗️ Architectural Overview & Modules

The project is structured into the following modular hardware components:

1. **Configurable Register Unit (`DSP_unit`)**:
   * A reusable primitive used to instantiate synchronous or asynchronous registers of customizable data widths[cite: 16].
   * Supports both synchronous (`SYN`) and asynchronous (`ASYN`) reset types alongside dedicated clock enable (`CEX`) control signals[cite: 16].

2. **Main DSP Core (`DSP`)**:
   * **Pre-Adder/Subtractor**: Handles preliminary arithmetic on inputs `B` and `D` based on operational configuration[cite: 14].
   * **Multiplier**: Performs dedicated $18 \times 18$ bit multiplication yielding a $36$-bit product output (`M`)[cite: 14].
   * **Multiplexers (`mux_x` & `mux_z`)**: Dynamic data routing multiplexers controlled directly by the `OPMODE` instruction bits[cite: 14].
   * **Post-Adder/Subtractor**: Computes the final $48$-bit result supporting addition, subtraction, carry propagation, and accumulator functions[cite: 14].

3. **Testbench Verification Environment (`DSP_tb`)**:
   * A comprehensive testbench designed to drive randomized and targeted stimuli, test reset behaviors, and monitor input/output transitions through real-time console logging[cite: 15].

---

## ⚙️ Configurable Parameters

The architecture can be fully customized at instantiation using the following parameters:
* **Pipeline Registers**: `A0REG`, `A1REG`, `B0REG`, `B1REG`, `CREG`, `DREG`, `MREG`, `PREG`, `CARRYINREG`, `CARRYOUTREG`, `OPMODEREG`[cite: 14]
* **Reset Style**: `RSTTYPE` (supports `"SYN"` or `"ASYN"` modes)[cite: 14]
* **Routing Selectors**: `B_IN` and `CARRYINSEL`[cite: 14]

---

## 🚀 Getting Started & Simulation

1. **Prerequisites**:
   * An industry-standard Verilog simulator (e.g., **ModelSim**, **Vivado**, or **Icarus Verilog**).

2. **Simulation Workflow**:
   * Add `DSP_unit.v`, `DSP.v`, and `DSP_tb.v` to your simulation project compilation list[cite: 14, 15, 16].
   * Set `DSP_tb` as the top-level testbench module[cite: 15].
   * Run the simulation to observe waveform transitions and verify real-time console monitoring outputs.
