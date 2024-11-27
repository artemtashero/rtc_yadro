module divider (
  input  logic        clk_i,
  input  logic [31:0] const_i,
  input  logic        enable_i,
  input  logic        rstn_i,
  output logic        clk_o
);

  logic [31:0] div_counter_out;
  logic trig_fb;

  div_counter divider_counter (
    .clk_i(clk_i),
    .const_i(const_i),
    .enable_i(enable_i),
    .rstn_i(rstn_i),
    .cur_value_o(div_counter_out)
  );

  div_comp divider_comp (
    .a_i(div_counter_out),
    .const_i(const_i),
    .flag_o(comp_out)
  );

  div_trig divider_trig (
    .enable_i(comp_out),
    .clk_i(clk_i),
    .rstn_i(rstn_i),
    .D_i(trig_fb),
    .Q_o(clk_o)
  );

  assign trig_fb = ~clk_o;

endmodule