module div_counter (
  input  logic        clk_i,
  input  logic [31:0] const_i,
  input  logic        enable_i,
  input  logic        rstn_i,
  output logic [31:0] cur_value_o
);

  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i)
      cur_value_o <= 32'b0;
    else if (enable_i && (cur_value_o == const_i))
      cur_value_o <= 32'b0;
    else if (enable_i)
      cur_value_o <= cur_value_o + 1;
    else if (!enable_i)
      cur_value_o <= 32'b0;
  end

endmodule