`include "/tools/PDK_DDK/CORELIB8DLL_3.1.a/verilog/CORELIB8DLL.v"

module ring_oscillator #(
  parameter INVERTERS_PER_RING
  //parameter INVERTER_DELAY
) (
  input  logic enable_i,
  output logic clk_o
);

  // initial begin
  //   assert( (INVERTERS_PER_RING >= 3) && (INVERTERS_PER_RING % 2 != 0) );
  // end

  logic [INVERTERS_PER_RING-1:0] wires;
  assign clk_o = wires[0];
	
	genvar i;
  generate
    ND2LL inv_en (
    	.A(enable_i),
	  	.B(wires[INVERTERS_PER_RING - 1]),
    	.Z(wires[0])
    );

    for (i = 1; i < INVERTERS_PER_RING; i++) begin
	    IVLL inv[i] (
		    .A(wires[i]),
	      .Z(wires[i-1])
	    );
    end
	endgenerate

  //genvar i;
  //generate
  //  for(i=0; i<INVERTERS_PER_RING; i=i+1) begin
  //    if (i == 0)
  //      IVLL (wires[i], enable_i ? wires[INVERTERS_PER_RING-1] : 0);
  //    else
  //      IVLL (wires[i], wires[i-1]);
  //  end
  //endgenerate

endmodule


// module ring_oscillator #(
//   parameter INVERTERS_PER_RING,
//   parameter INVERTER_DELAY
// ) (
//   input  logic enable_i,
//   output logic clk_o
// );

//   // initial begin
//   //   assert( (INVERTERS_PER_RING >= 3) && (INVERTERS_PER_RING % 2 != 0) );
//   // end

//   logic [INVERTERS_PER_RING-1:0] wires;
//   assign clk_o = wires[0];

//   genvar i;
//   generate
//     for(i=0; i<INVERTERS_PER_RING; i=i+1) begin
//       if (i == 0)
//         not #(INVERTER_DELAY) (wires[i], enable_i ? wires[INVERTERS_PER_RING-1] : 0);
//       else
//         not #(INVERTER_DELAY) (wires[i], wires[i-1]);
//     end
//   endgenerate

// endmodule