# FPGA-Implementation-of-Post-Quantum-Cryptography-CRYSTALS-Kyber-NTT-Accelerator

![Verilog](https://img.shields.io/badge/Language-Verilog-blue)
![Status](https://img.shields.io/badge/Status-Simulation_Verified-green)
![Standard](https://img.shields.io/badge/Standard-NIST_ML--KEM-orange)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

## 📌 Project Overview

This project presents the hardware design and simulation of a Number Theoretic Transform (NTT) accelerator for the CRYSTALS-Kyber (now standardized as ML-KEM) algorithm.

Kyber is a Lattice-Based cryptosystem selected by NIST as the new public-key standard for Post-Quantum Cryptography (PQC) to replace RSA and AES in the era of quantum computing. The core computational bottleneck of Kyber is polynomial multiplication, which this project accelerates using a custom modular arithmetic unit and a Cooley-Tukey Butterfly engine.

The design was implemented in Verilog HDL and verified via behavioral simulation in ModelSim, demonstrating a correct "Read-Compute-Write" memory access cycle for lattice-based encryption.

## 👥 Authors

- [Bassel Elbahnasy](https://github.com/Bassel1000)
- [Amin Mubarak](https://github.com/aminayssar)
- [Yousef Elsaket](https://github.com/aminayssar)


Date: December 23, 2025

## ⚙️ System Architecture

The accelerator consists of three main subsystems designed to operate modulo the Kyber prime q = 3329:

### 1. The Butterfly Unit (Math Core)

The heart of the design is the Cooley-Tukey Butterfly Unit. It processes two input coefficients ($a, b$) and a pre-computed Twiddle Factor ($w$) to perform three operations in parallel:

- Multiplication: $t = (b \times w) \mod 3329$

- Addition (Even): $E = (a + t) \mod 3329$

- Subtraction (Odd): $O = (a - t) \mod 3329$

### 2. Memory Unit

- Dual-Port RAM: A 256-word x 12-bit memory storing polynomial coefficients. It allows simultaneous access to two different addresses required for the Butterfly input.

- Twiddle ROM: Stores the pre-computed roots of unity ($w$) required for the NTT.

### 3. Control Logic (FSM)

A Finite State Machine (FSM) coordinates the math and memory using a "Read-Modify-Write" architecture:

- LOAD State: Sets read addresses and waits for RAM access.

- STORE State: Passes valid data through the Butterfly unit and enables the Write signal to save results back to memory.

## 📂 File Structure

The design is modularized into the following Verilog source files:

| **File Name**       | **Description**                                                                 |
|---------------------|----------------------------------------------------------------------------------|
| Kyber_NTT_Top.v     | The top-level wrapper wiring the Controller, RAM, and Math Engine together.     |
| NTT_Control.v       | FSM that counters from 0 to 127, handling Read/Write timing and address generation. |
| Butterfly.v         | Instantiates Add, Sub, and Mul modules to perform the full Cooley-Tukey operation. |
| ModAdd.v            | Performs \( A + B \). Checks if sum > 3329 and subtracts modulus if necessary.   |
| ModSub.v            | Performs \( A - B \). Checks if result < 0 and adds modulus if necessary.        |
| ModMul.v            | Performs \( (A \times B) \% 3329 \) (Behavioral model for simulation).            |
| KyberRAM.v          | Dual-port block RAM simulation model (256 depth x 12 width).                     |
| tb_ntt_top.v        | Testbench for verification and waveform generation.                              |

## 🧪 Simulation & Verification

The design was verified using ModelSim. The testbench initializes memory with sequential values and verifies the calculation for specific index pairs.

### Verification Case (Index 0 & Index 128)

- **Inputs**: $a=0$, $b=128$, $w=1$ (Twiddle factor for index 0)

- **Expected Calculation**:

- Intermediate: $t = 128 \times 1 = 128$

- Even Output: $0 + 128 = 128$

- Odd Output: $0 - 128 = -128 \equiv 3201 \pmod{3329}$

**Result**: The simulation successfully updated Memory[0] to 128 and Memory[128] to 3201, confirming the correctness of the modular arithmetic and FSM timing.

## 📜 License

Distributed under the MIT License. See `LICENSE` for more information.
