module clk_gen (
  input  logic        clk_external_i,
  input  logic        gen_en_i,
  input  logic        rstn_i,
  input  logic        sel_clk_i,
  input  logic [31:0] const_i,
  output logic        clk_1Hz_o
);
  
  logic clk_ro;
  logic clk_mux;

  divider div (
    .clk_i(clk_mux),
    .const_i(const_i),
    .enable_i(gen_en_i),
    .rstn_i(rstn_i),
    .clk_o(clk_1Hz_o)
  );

  ring_oscillator ro (
    .enable_i(gen_en_i),
    .clk_o(clk_ro)
  );
  defparam ro.INVERTERS_PER_RING=5; //Must be odd number
  // defparam ro.INVERTER_DELAY=1;

  always_comb begin 
    case (sel_clk_i)
      '0      : clk_mux = clk_ro;
      '1      : clk_mux = clk_external_i;
      default : clk_mux = clk_ro;
    endcase
  end
  
endmodule