/*
 Modified from matmul from COMP.CE.250:
 Added input flipflops
 tero.lehtinen@tuni.fi
 */

module matmul_sync #(
  parameter bit       OutputReg    = 0
)(
  input  logic        clk_i,
  input  logic        rst_ni,
  input  logic [31:0] operand_a_i,
  input  logic [31:0] operand_b_i,
  output logic [63:0] result_o
);

   logic [7:0][15:0]  mul_res;
   logic [3:0][15:0]  mul_sum;

   logic [31:0]   operand_a_i_sr;
   logic [31:0]   operand_b_i_sr;
   
   always_ff @(negedge rst_ni or posedge clk_i) begin

      if (!rst_ni) begin
         operand_a_i_sr <= '0;
         operand_b_i_sr <= '0;
      end else begin
         operand_a_i_sr <= operand_a_i;
         operand_b_i_sr <= operand_b_i;
      end // else: !if(!rst_ni)
   end // always_ff @

   
   assign result_o = {mul_sum[0],
                       mul_sum[1],
                       mul_sum[2],
                       mul_sum[3]};

generate
  for (genvar mult = 0; mult < 8; mult++) begin : gen_mults

    localparam int unsigned IdxA = get_a_idx(mult);
    localparam int unsigned IdxB = get_b_idx(mult);
    multiplier #(
      .OperandWidth (8),
      .OutputReg    (OutputReg)
    ) i_mult (
      .clk_i,
      .rst_ni,
      .operand_a_i (operand_a_i_sr[8*(IdxA+1)-1 : 8*IdxA]),
      .operand_b_i (operand_b_i_sr[8*(IdxB+1)-1 : 8*IdxB]),
      .result_o    (mul_res[mult])
    );
  end
endgenerate

generate
  for (genvar sum = 0; sum < 4; sum++)
    assign mul_sum[sum] = mul_res[sum*2] + mul_res[(sum*2)+1];
endgenerate

function automatic int get_a_idx (int idx);
  int result = 0;
  unique case (idx) inside
    0, 2:    result = 3;
    1, 3:    result = 2;
    4, 6:    result = 1;
    default: result = 0;
  endcase
  return result;
endfunction

function automatic int get_b_idx (int idx);
  int result = 0;
    unique case (idx) inside
    0, 4:    result = 3;
    1, 5:    result = 1;
    2, 6:    result = 2;
    default: result = 0;
  endcase
  return result;
endfunction


endmodule : matmul_sync
