module div_comp (
  input  logic [31:0] a_i,
  input  logic [31:0] const_i,
  output logic        flag_o
);
  
  always_comb begin
    if (a_i == const_i)
      flag_o = 1;
    else
      flag_o = 0;
  end

endmodule