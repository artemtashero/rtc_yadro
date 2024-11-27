module ring_oscillator #(
  parameter INVERTERS_PER_RING,
  parameter INVERTER_DELAY
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
    for(i=0; i<INVERTERS_PER_RING; i=i+1) begin
      if (i == 0)
        not #(INVERTER_DELAY) (wires[i], enable_i ? wires[INVERTERS_PER_RING-1] : 0);
      else
        not #(INVERTER_DELAY) (wires[i], wires[i-1]);
    end
  endgenerate

endmodule