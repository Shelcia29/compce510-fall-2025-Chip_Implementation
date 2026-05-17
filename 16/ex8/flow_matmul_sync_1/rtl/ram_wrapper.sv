/*
 Author: tero.lehtinen@tuni.fi
 Instantiates a technology specific memory
 */

module ram_wrapper (
  input logic 	      clk_i,   // Clock
  input logic 	      re_i,    // read enable
  input logic 	      we_i,    // write enable
  input logic [7:0]   addr_i,  // address
  input logic [31:0]  wdata_i, // write data
  output logic [31:0] rdata_o  // read data
);

   logic 			   cen_s;
   logic 			   rdwen_s;
   assign cen_s = ~re_i | ~we_i;
   assign rdwen_s = ~we_i; // write has priority over read
   
   IN22FDX_S1DU_BFUG_W00256B032M04C128 i_ram (
     .CLK(clk_i),
     .CEN(cen_s),
     .RDWEN('0),
     .DEEPSLEEP('0),
     .POWERGATE('0),
     .AS(addr_i[0]),
     .AW(addr_i[5:1]),
     .AC(addr_i[7:6]),
     .D(wdata_i),
     .BW('1),
     .T_BIST('0),
     .T_LOGIC('0),
     .T_CEN('1),
     .T_RDWEN('1),
     .T_DEEPSLEEP('0),
     .T_POWERGATE('0),
     .T_AS('0),
     .T_AW('0),
     .T_AC('0),
     .T_D('0),
     .T_BW('0),
     .T_WBT('0),
     .T_STAB('0),
     .MA_SAWL("01"),
     .MA_WL('0),
     .MA_WRAS('0),
     .MA_WRASD('0),
     .RBE('0),
     .RBF0A('0),
     .QRB(),
     .Q(rdata_o),
     .OBSV_CTL()
   );
endmodule // ram_wrapper
