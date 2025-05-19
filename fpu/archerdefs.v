//
// SPDX-License-Identifier: CERN-OHL-P-2.0+
//
// Copyright (C) 2021-2024 Embedded and Reconfigurable Computing Lab, American University of Beirut
// Contributed by:
// Mazen A. R. Saghir <mazen@aub.edu.lb>
//
// This source is distributed WITHOUT ANY EXPRESS OR IMPLIED WARRANTY,
// INCLUDING OF MERCHANTABILITY, SATISFACTORY QUALITY AND FITNESS FOR
// A PARTICULAR PURPOSE. Please see the CERN-OHL-P v2 for applicable
// conditions.
// Source location: https://github.com/ERCL-AUB/archer/rv32i_single_cycle
//
// Archer constant definitions

// architectural constants
`define	XLEN            32
`define	ADDRLEN         10
`define	LOG2_XRF_SIZE   5
`define	ALUOPS_SIZE	    5
`define FP_SIGN_WIDTH    1
`define FP_EXP_WIDTH     8
`define FP_MANT_WIDTH    23
`define FP_TRUNCATE    3'b001

// ALU operations
`define	ALU_OP_ADD	4'b0000
`define	ALU_OP_SUB	4'b1000
`define	ALU_OP_AND	4'b0111
`define	ALU_OP_OR	4'b0110
`define ALU_OP_XOR	4'b0100
`define	ALU_OP_SLL	4'b0001
`define ALU_OP_SRL	4'b0101
`define	ALU_OP_SRA	4'b1101
`define ALU_OP_SLT	4'b0010
`define	ALU_OP_SLTU	4'b0011

// Floating-point ALU operations
`define F_ALU_OP_ADD   4'b0000 
`define F_ALU_OP_SUB   4'b0001  
`define F_ALU_OP_MUL   4'b0010 
`define F_ALU_OP_MIN   4'b0011 
`define F_ALU_OP_MAX   4'b0100 
`define F_ALU_OP_EQ    4'b0101  
`define F_ALU_OP_LT    4'b0110  
`define F_ALU_OP_LE    4'b0111  

// branch conditions
`define	BR_COND_EQ	3'b000
`define BR_COND_NE	3'b001
`define BR_COND_LT	3'b100
`define BR_COND_GE	3'b101
`define BR_COND_LTU	3'b110
`define	BR_COND_GEU	3'b111

// instruction opcodes
`define	OPCODE_LUI	7'b0110111
`define	OPCODE_AUIPC	7'b0010111
`define	OPCODE_JAL	7'b1101111
`define OPCODE_JALR	7'b1100111
`define OPCODE_BRANCH	7'b1100011 // branch instruction
`define OPCODE_LOAD	7'b0000011 // load instruction
`define OPCODE_STORE	7'b0100011 // store instruction
`define	OPCODE_IMM	7'b0010011 // immediate arithmetic, logic, shift, and slt instructions
`define OPCODE_RTYPE	7'b0110011 // R-Type arithmetic, logic, shift, and slt instructions
`define OPCODE_FLOAT  7'b1010011 // Floating point instructions
`define OPCODE_FLOAD  7'b0000111 // Floating point load instructions
`define OPCODE_FSTORE 7'b0100111 // Floating point store instructions

// Floating-point instruction formats (funct7) for specific operations
`define FUNCT7_FADD_S   7'b0000000
`define FUNCT7_FSUB_S   7'b0000100
`define FUNCT7_FMUL_S   7'b0001000
`define FUNCT7_FMIN_MAX 7'b0010100
`define FUNCT7_FCMP     7'b1010000

// Floating-point instruction formats (rs2/funct3 for compare and min/max)
`define RS2_FMIN        3'b000
`define RS2_FMAX        3'b001 
`define RS2_FEQ         3'b010 
`define RS2_FLT         3'b001 
`define RS2_FLE         3'b000 