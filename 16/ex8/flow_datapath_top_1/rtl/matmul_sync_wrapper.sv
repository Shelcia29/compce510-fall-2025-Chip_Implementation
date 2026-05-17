/*
 Modified from matmul from COMP.CE.250:
 Added input flipflops
 tero.lehtinen@tuni.fi
 */

module matmul_sync_wrapper (
  input  logic        clk_i,
  input  logic        rst_ni,
  input  logic [31:0] operand_a_i,
  input  logic [31:0] operand_b_i,
  input  logic [31:0] operand_a_offset_i,
  input  logic [31:0] operand_b_offset_i,
  output logic [63:0] result_o
);

   logic [31:0]   operand_a_i_s;
   logic [31:0]   operand_b_i_s;

   always_comb begin
      operand_a_i_s = operand_a_i + operand_a_offset_i;
      operand_b_i_s = operand_b_i + operand_b_offset_i;
   end

   matmul_sync i_mul_a (.clk_i(clk_i),
			.rst_ni(rst_ni),
			.operand_a_i(operand_a_i_s),
			.operand_b_i(operand_b_i_s),
			.result_o(result_o));
endmodule // matmul_sync_wrapper


