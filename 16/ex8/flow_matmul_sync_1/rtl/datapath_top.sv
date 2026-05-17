/*
 Author: tero.lehtinen@tuni.fi
 */

module datapath_top (
  input logic 	      clk_i,
  input logic 	      rst_ni,
  input logic [31:0]  operand_a_data_i,
  input logic [31:0]  operand_b_data_i,
  input logic [7:0]   operand_a_addr_i,
  input logic [7:0]   operand_b_addr_i,
  input logic 	      re_a_i,
  input logic 	      re_b_i,
  input logic 	      we_a_i,
  input logic 	      we_b_i,
  output logic [63:0] result_o
);

   parameter NUMSTAGES = 32;
   
   logic [NUMSTAGES-1:0] mem_a_re;
   logic [NUMSTAGES-1:0] mem_a_we ;
   logic [7:0] 		 mem_a_addr [NUMSTAGES-1:0];
   logic [31:0] 	 mem_a_wdata [NUMSTAGES:0];
   logic [31:0] 	 mem_a_rdata [NUMSTAGES-1:0];
   
   logic [NUMSTAGES-1:0] mem_b_re;
   logic [NUMSTAGES-1:0] mem_b_we ;
   logic [7:0] 		 mem_b_addr [NUMSTAGES-1:0];
   logic [31:0] 	 mem_b_wdata [NUMSTAGES:0];
   logic [31:0] 	 mem_b_rdata [NUMSTAGES-1:0];
   
   logic [63:0] 	 matmul_result_s [NUMSTAGES-1:0];
   
   logic [1:0] 		 rst_n_sync;
   logic 		 rst_n_synced;
   
   logic 		 clk_div;
   logic 		 clk_div_n;
   
   tico_hs_ctinv i_clk_div_inv (.a(clk_div), .z(clk_div_n));
   
   tico_ctff i_clk_divider (.clk(clk_i),
			    .rst_n(rst_ni),
			    .data_in(clk_div_n),
			    .data_out(clk_div));

   tico_ctff i_rst_sync1 (.clk(clk_i),
			  .rst_n(rst_ni),
			  .data_in(rst_ni),
			  .data_out(rst_n_sync[0]));
   tico_ctff i_rst_sync2 (.clk(clk_i),
			  .rst_n(rst_ni),
			  .data_in(rst_n_sync[0]),
			  .data_out(rst_n_sync[1]));
   tico_ctand i_rst_sync_and (.a(rst_ni), .b(rst_n_sync[1]), .z(rst_n_sync[0]));

   always_ff @(posedge clk_div or negedge rst_n_synced) begin
      if (~rst_n_synced) begin
	 mem_a_re <= '0;
	 mem_b_re <= '0;
	 mem_a_we <= '0;
	 mem_b_we <= '0;
	 for (int i = 0; i < NUMSTAGES; i++) begin
	    mem_a_addr[i] <= '0;
	    mem_b_addr[i] <= '0;
	 end
      end else begin
	 mem_a_re[0] <= re_a_i;
	 mem_a_re[NUMSTAGES-1:1] <= mem_a_re[NUMSTAGES-2:0];
	 mem_b_re[0] <= re_b_i;
	 mem_b_re[NUMSTAGES-1:1] <= mem_b_re[NUMSTAGES-2:0];
	 mem_a_we[0] <= we_a_i;
	 mem_a_we[NUMSTAGES-1:1] <= mem_a_we[NUMSTAGES-2:0];
	 mem_b_we[0] <= we_b_i;
	 mem_b_we[NUMSTAGES-1:1] <= mem_b_we[NUMSTAGES-2:0];

	 mem_a_addr[0] <= operand_a_addr_i;
	 mem_a_addr[NUMSTAGES-1:1] <= mem_a_addr[NUMSTAGES-2:0];
	 mem_b_addr[0] <= operand_b_addr_i;
	 mem_b_addr[NUMSTAGES-1:1] <= mem_b_addr[NUMSTAGES-2:0];
      end // else: !if(~rst_n_synced)
   end // always_ff @

   // Generate memory and matmul instances
   genvar 	      i;
   generate
      for (i = 0; i < NUMSTAGES; i++) begin
	 ram_wrapper i_mem_a (.clk_i(clk_div),
			      .re_i(mem_a_re[i]),
			      .we_i(mem_a_we[i]),
			      .addr_i(mem_a_addr[i]),
			      .wdata_i(mem_a_wdata[i]),
			      .rdata_o(mem_a_rdata[i]));

	 ram_wrapper i_mem_b (.clk_i(clk_div),
			      .re_i(mem_b_re[i]),
			      .we_i(mem_b_we[i]),
			      .addr_i(mem_b_addr[i]),
			      .wdata_i(mem_b_wdata[i]),
			      .rdata_o(mem_b_rdata[i]));

	 matmul_sync i_mul (.clk_i(clk_div),
			    .rst_ni(rst_n_synced),
			    .op_a_i(mem_a_rdata[i]),
			    .op_b_i(mem_b_rdata[i]),
			    .result_o(matmul_result_s[i]));
	 
	 assign mem_a_wdata[i+1] = matmul_result_s[i][31:0];
	 assign mem_b_wdata[i+1] = matmul_result_s[i][63:32];
      end // for (i = 0; i < 32; i++)
   endgenerate

   assign mem_a_wdata[0] = operand_a_data_i;
   assign mem_b_wdata[0] = operand_b_data_i;
   assign result_o[31:0]  = mem_a_wdata[NUMSTAGES];
   assign result_o[63:32] = mem_b_wdata[NUMSTAGES];
endmodule // datapath_top
