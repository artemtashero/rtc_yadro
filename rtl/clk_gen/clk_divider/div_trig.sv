module div_trig (
  input  logic enable_i,
  input  logic clk_i,
  input  logic rstn_i,
  input  logic D_i,
  output logic Q_o
);

  always_ff @( posedge clk_i or negedge rstn_i ) begin
    if (!rstn_i)
      Q_o <= 0;
    else if (enable_i)
      Q_o <= D_i;
  end

endmodule