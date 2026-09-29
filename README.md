# Spartan-6 DSP48A1 Slice Implementation & Verification

> A comprehensive Verilog design, self-checking testbench, and Vivado synthesis/implementation flow for the Xilinx Spartan-6 **DSP48A1** digital signal processing slice[cite: 4], featuring configurable pipeline registers and dynamic operational modes.

---

## 📋 Project Overview
The **DSP48A1** slice is a foundational building block in FPGA families like Spartan-6, tailored for math-intensive applications and high-performance digital signal processing (DSP)[cite: 4]. This project includes:
1. **Flexible Register Unit (`DSP_unit`):** Supports configurable data widths, synchronous/asynchronous resets (`SYN`/`ASYNC`), and clock enables (`CE`).
2. **Main DSP Module (`DSP`):** Integrates a Pre-Adder/Subtracter, Multiplier, Post-Adder/Subtracter, and `OPMODE`-controlled X and Z multiplexers.
3. **Verification Environment (`DSP_tb.v`):** A self-checking testbench covering reset operations and four distinct data paths (Paths 1 to 4).

---

## ⚙️ Architecture & Default Parameters
The design operates with the following default attributes and parameters:
* **Pipeline Registers:**
  * `A0REG = 0`, `A1REG = 1`
  * `B0REG = 0`, `B1REG = 1`
  * `CREG = 1`, `DREG = 1`
  * `MREG = 1`, `PREG = 1`
  * `CARRYINREG = 1`, `CARRYOUTREG = 1`
  * `OPMODEREG = 1`
* **Configuration Attributes:**
  * `RSTTYPE = "SYNC"` (Synchronous reset)[cite: 4]
  * `B_IN = "DIRECT"` (Direct B-port or cascaded `BCIN`)[cite: 4]
  * `CARRYINSEL = "OPMODE5"` (Carry-in source selection)[cite: 4]

---

## 📂 File Structure
* `DSP.v`: The core top-level module containing the DSP48A1 architecture and `DSP_unit`.
* `DSP_tb.v`: Self-checking testbench validating reset functionality and test paths 1 through 4.
* `DSP_spesifications.pdf`: Official datasheet and hardware specification for the DSP48A1 slice[cite: 4].
* `DSP_TB_Description.pdf`: Detailed stimulus descriptions and flow diagrams for test paths[cite: 5].

---

## 📊 Testbench Verification Paths
The testbench automatically validates the design through the following scenarios:
1. **Reset Operation:** Asserts all active-high resets and verifies that all outputs (`P`, `M`, `BCOUT`, `CARRYOUT`) drop to zero[cite: 5].
2. **Path 1:** Tests pre-subtraction, multiplier, and post-subtraction using `OPMODE = 8'b11011101`[cite: 5].
3. **Path 2:** Tests pre-addition with zero-routing via Mux X and Mux Z using `OPMODE = 8'b00010000`[cite: 5].
4. **Path 3:** Tests accumulator/P-feedback routing using `OPMODE = 8'b00001010`[cite: 5].
5. **Path 4:** Tests post-subtraction with concatenated `D:A:B` and `PCIN` inputs using `OPMODE = 8'b10100111`[cite: 5].

---

## 🛠️ Simulation & Implementation Flow

### 1. Simulation (QuestaSim)
* Compile `DSP.v` and `DSP_tb.v` in QuestaSim.
* Run the simulation and check the transcript window for automatic `SUCCESS` confirmation messages for each path.

### 2. Synthesis & Implementation (Xilinx Vivado)
* Create a new Vivado project and select a target part capable of supporting the large I/O footprint:
  ```text
  xc7a200tffg1156-3
