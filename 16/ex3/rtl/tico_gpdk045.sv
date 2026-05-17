// Project: Ballast

module tico_ctand
  (
   input logic a, b,
   output logic z
   );

   CLKAND2X4 inst_CLKAND2X4
     (
      .A(a), 
      .B(b),
      .Y(z)
      );
endmodule // tico_ctand

module tico_ctinv
  (
   input logic a,
   output logic z
   );

   CLKINVX4 inst_CLKINVX4
     (
      .A(a),
      .Y(z)
      );
endmodule // tico_ctinv

module tico_ctbuf
  (
   input logic a,
   output logic z
   );

   CLKBUFX8 inst_CLKBUFX8
     (
      .A(a),
      .Y(z)
      );
endmodule // tico_ctinv

module tico_ctor
  (
   input logic a, b,
   output logic z
   );

   OR2X4 inst_OR2X4
     (
      .A(a), 
      .B(b),
      .Y(z)
      );
endmodule // tico_ctor

module tico_ctsync
  (
   input logic clk, rst_n, data_in,
   output logic data_out
   );

   logic 	sync1, sync2;
   SDFFRX4 inst_SDFFRX4_sync1
     (
      .SI(1'b0),
      .D(data_in),
      .SE(1'b0),
      .CK(clk),
      .RN(rst_n),
      .Q(sync1)
      );
   SDFFRX4 inst_SDFFRX4_sync2
     (
      .SI(1'b0),
      .D(sync1),
      .SE(1'b0),
      .CK(clk),
      .RN(rst_n),
      .Q(sync2)
      );

   assign data_out = sync2;
endmodule // tico_ctsync

module tico_ctsync3
  (
   input logic clk, rst_n, data_in,
   output logic data_out
   );

   logic 	sync1, sync2, sync3;
   
   SDFFRX4 inst_SDFFRX4_sync1
     (
      .SI(1'b0),
      .D(data_in),
      .SE(1'b0),
      .CK(clk),
      .RN(rst_n),
      .Q(sync1)
      );
   SDFFRX4 inst_SDFFRX4_sync2
     (
      .SI(1'b0),
      .D(sync1),
      .SE(1'b0),
      .CK(clk),
      .RN(rst_n),
      .Q(sync2)
      );
   SDFFRX4 inst_SDFFRX4_sync3
     (
      .SI(1'b0),
      .D(sync2),
      .SE(1'b0),
      .CK(clk),
      .RN(rst_n),
      .Q(sync3)
      );

   assign data_out = sync3;
endmodule // tico_ctsync3

module tico_ctff
  (
   input logic clk, rst_n, data_in,
   output logic data_out
   );

   logic 	data;
   
   SDFFRX4 inst_SDFFRX4
     (
      .SI(1'b0),
      .D(data_in),
      .SE(1'b0),
      .CK(clk),
      .RN(rst_n),
      .Q(data)
      );

   assign data_out = data;
endmodule // tico_ctsync

module tico_ctcg
  (
   input logic clk, enable,
   output logic clk_out
   );

   TLATNTSCAX4 inst_TLATNTSCAX4
     (
      .SE(1'b0),
      .E(enable),
      .CK(clk),
      .ECK(clk_out)
      );
endmodule // tico_ctcg

module tico_ctmux
  (
   input logic a, b, s,
   output logic z
   );

   CLKMUX2X4 inst_CLKMUX2X4
     (
      .A(a),
      .B(b),
      .S0(s),
      .Y(z)
      );
endmodule // tico_ctmux

module tico_ctxor
  (
   input logic a, b,
   output logic z
   );

   CLKXOR2X4 inst_CLKXOR2X4
     (
      .A(a), 
      .B(b),
      .Y(z)
      );
   
endmodule // tico_ctxor

//////////////////////////////////////////////////
// High speed variants
//////////////////////////////////////////////////
module tico_hs_ctinv
  (
   input logic a,
   output logic z
   );

   CLKINVX12 inst_CLKINVX12
     (
      .A(a),
      .Y(z)
      );
endmodule // tico_hs_ctinv

