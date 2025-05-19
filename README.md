# RV32IF Datapath Design with Floating Point Unit (FPU)

**Course**: EECE 321 – Computer Organization  
**Institution**: American University of Beirut  
**Professor**: Dr. Mazen Saghir  
**Team Members**: Serena Stephan, Tony Abi Haidar, Joud Senan  
**Date**: April 27, 2025

---

## 🛠 Overview

This project extends the RV32I single-cycle datapath by integrating a **Floating Point Unit (FPU)** to support IEEE-754 single-precision operations. It introduces separate datapath components for floating-point arithmetic and register management and supports basic operations such as add, sub, mul, min, max, comparisons, and special-case handling for NaNs and infinities.

---

## 🔧 Tools Used

- **Vivado 2023.1**: Design, synthesis, simulation
- **Vivado Text Editor**: Code editing
- **Vivado XSim**: Simulation
- **Venus Simulator**: Assembly compilation
- **ChatGPT**: Testbench generation

---

## 📂 Project Structure

- `fpu.v`: Implements floating-point operations (`add_fp`, `sub_fp`, `mul_fp`, `max_fp`, `min_fp`, `eq_fp`, `lt_fp`, `le_fp`)
- `float_regfile.v`: Floating-point register file (32 registers)
- `control_unit.v`: Control logic for integer and floating-point instructions
- `archer_rv32if.v`: Top-level single-cycle processor integrating FPU
- `RV32IFtest.s`: Assembly test program
- `RV32IFtest.o`: Machine code (compiled from `RV32IFtest.s`)
- `RV32IF_test_rom.v`: ROM module for loading test program
- `fpu_tb.v`: Testbench for FPU verification

---

## ✅ Key Features

### ✅ Modular FPU Design

- Handles corner cases: ±0, ±∞, NaN, subnormal/normalized numbers
- Returns results in IEEE-754 32-bit format
- Verified via standalone testbench

### ✅ Custom Control Unit

- Dynamically identifies and handles RV32IF instructions
- Generates dedicated signals:
  - `FPUOp`, `FPStart`, `FPRegWrite`, `FPToReg`

### ✅ Dual Register Files

- `regfile.v`: Integer registers (x0 hardwired to zero)
- `float_regfile.v`: Floating-point registers (f0 writable)

### ✅ Full Datapath Integration

- Handles fetch, decode, execute, and write-back stages
- Supports both integer and floating-point logic
- Uses `mux2to1`, `branch_cmp`, `alu`, `immgen`, `rom`, `pc`, `add4`, `sram`, `lmb`

---

## 🧪 Test Cases & Results

| Operation | Inputs | Output |
|----------|--------|--------|
| Addition | 1.1 + 1.15 | `40800000` |
| Subtraction | 5.0 - 2.5 | `40200000` |
| Multiplication | 3.0 * 2.0 | `40c00000` |
| Min | 1.5, 2.5 | `3fc00000` |
| Max | 2.0, 2.5 | `40200000` |
| Equal | 3.25 == 3.25 | `1` |
| Less Than | 1.0 < 1.5 | `1` |
| Less Than or Equal | 2.5 <= 2.5 | `1` |
| +0.0 + +0.0 | — | `00000000` |
| -0.0 + -0.0 | — | `80000000` |
| +Inf + +Inf | — | `7f800000` |
| +Inf + -Inf | — | `7fc00000` |
| NaN + 2.0 | — | `7fc00000` |
| 0 * 0 | — | `00000000` |
| Inf * 0 | — | `7fc00000` |
| +0.0 == -0.0 | — | `1` |
| Tiny Add | 1.1 + 1.15 | `3fa00000` |
| Tiny Sub | — | `2f000000` |
| Tiny Mul | 0.7 * 1.2 | `3f570a3d` |
| Min (-0.2, -0.5) | — | `bf000000` |
| Max (1e-7, -1e-7) | — | `33d6bf95` |
| LE (0.04 <= 0.0399999) | — | `0` |

---

## 📈 Simulation & Verification

- Verified correct FPU operation via:
  - Standalone FPU testbench
  - Assembly-level test program
- Test waveforms generated in Vivado simulator
- Special cases handled and validated (e.g., NaNs, ±0, ±∞)

---

## 🔍 Component Descriptions

### 📌 Control Unit

- Inputs: `instruction`, `BranchCond`
- Outputs: RV32I and FPU control signals (`Jump`, `Lui`, `PCSrc`, `RegWrite`, `FPUOp`, etc.)
- Decodes instruction and manages control flow and operation type (integer vs floating-point)

### 📌 FPU

- Inputs: `inputA`, `inputB`, `imm`, `FPU_OP`
- Output: `result`
- Supports IEEE-754 compliant 32-bit operations with edge-case handling

### 📌 Floating-Point Register File

- Inputs: `clk`, `rst_in`, `FRegWrite`, `rs1`, `rs2`, `rd`, `datain`
- Outputs: `regA`, `regB`
- 32 registers; f0 is writable

### 📌 Top-Level Processor

- Inputs: `clk`, `rst_n`
- Manages full datapath, memory access, branching, and both ALU/FPU logic

---

## 🧠 Team Contributions

- **Joud Senan**: `control_unit.v`, `archer_rv32if.v`, report documentation
- **Serena Stephan**: `float_alu` design, datapath diagram
- **Tony Abi Haidar**: Assembly test programs, `archerdefs.v`, `float_regfile.v`
- **Group Effort**: Testbenches, integration, and debugging

---

## 📜 License

This project was created for educational purposes under the EECE 321 course at AUB. Please cite the original authors when referencing or reusing any part of this work.