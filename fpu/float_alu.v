`include "archerdefs.v"

module fpu (
    input [`XLEN-1:0] inputA,
    input [`XLEN-1:0] inputB,
    input [11:0] imm,
    input [`ALUOPS_SIZE-1:0] FPU_OP,
    output reg [`XLEN-1:0] result
);

wire signA = inputA[31];
wire [7:0] expA = inputA[30:23];
wire [22:0] mantA = inputA[22:0];
wire [23:0] mantissaA = (expA != 0) ? {1'b1, mantA} : {1'b0, mantA};

wire signB = inputB[31];
wire [7:0] expB = inputB[30:23];
wire [22:0] mantB = inputB[22:0];
wire [23:0] mantissaB = (expB != 0) ? {1'b1, mantB} : {1'b0, mantB};

wire zeroA = (expA == 0) && (mantA == 0);
wire zeroB = (expB == 0) && (mantB == 0);
wire infA = (expA == 8'hFF) && (mantA == 0);
wire infB = (expB == 8'hFF) && (mantB == 0);
wire nanA = (expA == 8'hFF) && (mantA != 0);
wire nanB = (expB == 8'hFF) && (mantB != 0);

function [`XLEN-1:0] add_fp;
    input signA, signB;
    input [23:0] mantissaA, mantissaB;
    input [7:0] expA, expB;
    input zeroA, zeroB, nanA, nanB;
    input infA, infB;
    reg [24:0] sum;
    reg sign_res;
    reg [7:0] exp_res;
    reg [23:0] shifted_mantissaA, shifted_mantissaB;
    reg [7:0] exp_diff;
    integer shift_left;
    begin
        if (nanA || nanB)
            add_fp = 32'h7FC00000; // NaN
        else if (infA || infB) begin
            if (infA && infB && (signA != signB))
                add_fp = 32'h7FC00000; // inf - inf = NaN
            else
                add_fp = infA ? {signA, 8'hFF, 23'b0} : {signB, 8'hFF, 23'b0};
        end
        else if (zeroA && zeroB)
            add_fp = {signA & signB, 8'h00, 23'b0};
        else begin
            if (expA > expB) begin
                exp_diff = expA - expB;
                shifted_mantissaB = mantissaB >> exp_diff;
                shifted_mantissaA = mantissaA;
                exp_res = expA;
            end else begin
                exp_diff = expB - expA;
                shifted_mantissaA = mantissaA >> exp_diff;
                shifted_mantissaB = mantissaB;
                exp_res = expB;
            end

            if (signA == signB) begin
                sum = shifted_mantissaA + shifted_mantissaB;
                sign_res = signA;
            end else begin
                if (shifted_mantissaA > shifted_mantissaB) begin
                    sum = shifted_mantissaA - shifted_mantissaB;
                    sign_res = signA;
                end else begin
                    sum = shifted_mantissaB - shifted_mantissaA;
                    sign_res = signB;
                end
            end

            if (sum[24]) begin
                sum = sum >> 1;
                exp_res = exp_res + 1;
            end else begin
                shift_left = 0;
                while ((shift_left < 24) && !sum[23 - shift_left])
                    shift_left = shift_left + 1;
                if (shift_left > 0) begin
                    sum = sum << shift_left;
                    exp_res = exp_res - shift_left;
                    if (exp_res > 8'hFF) exp_res = 8'hFF;
                end
            end

            if (exp_res == 0) sum = 0;
            add_fp = {sign_res, exp_res, sum[22:0]};
        end
    end
endfunction

function [`XLEN-1:0] sub_fp;
    input signA, signB;
    input [23:0] mantissaA, mantissaB;
    input [7:0] expA, expB;
    input zeroA, zeroB, nanA, nanB;
    input infA, infB;
    begin
        sub_fp = add_fp(signA, ~signB, mantissaA, mantissaB, expA, expB, zeroA, zeroB, nanA, nanB, infA, infB);
    end
endfunction

function [`XLEN-1:0] mul_fp;
    input signA, signB;
    input [23:0] mantissaA, mantissaB;
    input [7:0] expA, expB;
    input zeroA, zeroB, nanA, nanB;
    input infA, infB;
    reg sign_res;
    reg [7:0] exp_res;
    reg [47:0] product;
    begin
        if (nanA || nanB)
            mul_fp = 32'h7FC00000;
        else if ((infA && zeroB) || (zeroA && infB))
            mul_fp = 32'h7FC00000;
        else if (zeroA || zeroB)
            mul_fp = {signA ^ signB, 8'h00, 23'b0};
        else if (infA || infB)
            mul_fp = {signA ^ signB, 8'hFF, 23'b0};
        else begin
            product = mantissaA * mantissaB;
            sign_res = signA ^ signB;
            exp_res = expA + expB - 127;
            if (product[47]) begin
                product = product >> 1;
                exp_res = exp_res + 1;
            end
            if (exp_res > 8'hFE) exp_res = 8'hFF;
            mul_fp = {sign_res, exp_res, product[45:23]};
        end
    end
endfunction

function [0:0] eq_fp;
    input signA, signB;
    input [23:0] mantissaA, mantissaB;
    input [7:0] expA, expB;
    begin
        if ((expA == 0) && (mantissaA == 0) && (expB == 0) && (mantissaB == 0))
            eq_fp = 1'b1;
        else
            eq_fp = (signA == signB) && (expA == expB) && (mantissaA == mantissaB);
    end
endfunction

function [0:0] lt_fp;
    input signA, signB;
    input [23:0] mantissaA, mantissaB;
    input [7:0] expA, expB;
    begin
        if (signA != signB)
            lt_fp = signA;
        else if (signA)
            lt_fp = (expA > expB) || ((expA == expB) && (mantissaA > mantissaB));
        else
            lt_fp = (expA < expB) || ((expA == expB) && (mantissaA < mantissaB));
    end
endfunction

function [0:0] le_fp;
    input signA, signB;
    input [23:0] mantissaA, mantissaB;
    input [7:0] expA, expB;
    begin
        le_fp = lt_fp(signA, signB, mantissaA, mantissaB, expA, expB) || eq_fp(signA, signB, mantissaA, mantissaB, expA, expB);
    end
endfunction

function [`XLEN-1:0] min_fp;
    input [`XLEN-1:0] inputA, inputB;
    input signA, signB;
    input [23:0] mantissaA, mantissaB;
    input [7:0] expA, expB;
    input zeroA, zeroB, nanA, nanB;
    begin
        if (nanA || nanB)
            min_fp = 32'h7FC00000;
        else if (lt_fp(signA, signB, mantissaA, mantissaB, expA, expB))
            min_fp = inputA;
        else
            min_fp = inputB;
    end
endfunction

function [`XLEN-1:0] max_fp;
    input [`XLEN-1:0] inputA, inputB;
    input signA, signB;
    input [23:0] mantissaA, mantissaB;
    input [7:0] expA, expB;
    input zeroA, zeroB, nanA, nanB;
    begin
        if (nanA || nanB)
            max_fp = 32'h7FC00000;
        else if (lt_fp(signA, signB, mantissaA, mantissaB, expA, expB))
            max_fp = inputB;
        else
            max_fp = inputA;
    end
endfunction

always @(*) begin
    case (FPU_OP)
        `F_ALU_OP_ADD: result = add_fp(signA, signB, mantissaA, mantissaB, expA, expB, zeroA, zeroB, nanA, nanB, infA, infB);
        `F_ALU_OP_SUB: result = sub_fp(signA, signB, mantissaA, mantissaB, expA, expB, zeroA, zeroB, nanA, nanB, infA, infB);
        `F_ALU_OP_MUL: result = mul_fp(signA, signB, mantissaA, mantissaB, expA, expB, zeroA, zeroB, nanA, nanB, infA, infB);
        `F_ALU_OP_MIN: result = min_fp(inputA, inputB, signA, signB, mantissaA, mantissaB, expA, expB, zeroA, zeroB, nanA, nanB);
        `F_ALU_OP_MAX: result = max_fp(inputA, inputB, signA, signB, mantissaA, mantissaB, expA, expB, zeroA, zeroB, nanA, nanB);
        `F_ALU_OP_EQ : result = {31'b0, eq_fp(signA, signB, mantissaA, mantissaB, expA, expB)};
        `F_ALU_OP_LT : result = {31'b0, lt_fp(signA, signB, mantissaA, mantissaB, expA, expB)};
        `F_ALU_OP_LE : result = {31'b0, le_fp(signA, signB, mantissaA, mantissaB, expA, expB)};
        default      : result = 32'b0;
    endcase
end

endmodule
