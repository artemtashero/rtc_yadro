module ir_ctrl (
  input  logic        ir_i,
  input  logic        clk_i,       
  input  logic        rstn_i,
       
  input  logic [ 5:0] cur_sec_i,              
  input  logic [ 5:0] cur_min_i,              
  input  logic [ 5:0] cur_hour_i,             
  input  logic [ 1:0] cur_mode_i,             
  input  logic [ 2:0] cur_day_of_week_i,      
  input  logic [ 4:0] cur_day_of_month_i,     
  input  logic [ 3:0] cur_month_i,            
  input  logic [11:0] cur_year_i,
 
  input  logic [ 5:0] ir_out_sec_i,              
  input  logic [ 5:0] ir_out_min_i,              
  input  logic [ 5:0] ir_out_hour_i,             
  input  logic [ 1:0] ir_out_mode_i,             
  input  logic [ 2:0] ir_out_day_of_week_i,      
  input  logic [ 4:0] ir_out_day_of_month_i,     
  input  logic [ 3:0] ir_out_month_i,            
  input  logic [11:0] ir_out_year_i,

  output logic [ 5:0] ir_in_sec_o,              
  output logic [ 5:0] ir_in_min_o,              
  output logic [ 5:0] ir_in_hour_o,             
  output logic [ 1:0] ir_in_mode_o,             
  output logic [ 2:0] ir_in_day_of_week_o,      
  output logic [ 4:0] ir_in_day_of_month_o,     
  output logic [ 3:0] ir_in_month_o,            
  output logic [11:0] ir_in_year_o,

  output logic        ir_o
);

  assign equal = (cur_sec_i == ir_out_sec_i) && (cur_min_i == ir_out_min_i) && (cur_hour_i == ir_out_hour_i) && (cur_mode_i == ir_out_mode_i) && 
                 (cur_day_of_week_i == ir_out_day_of_week_i) && (cur_day_of_month_i == ir_out_day_of_month_i) && (cur_month_i == ir_out_month_i) && (cur_year_i == ir_out_year_i);

  always_ff @( posedge clk_i or negedge rstn_i ) begin
    if (!rstn_i)
      ir_o <= 0;
      ir_in_sec_o          <= 0;
      ir_in_min_o          <= 0;
      ir_in_hour_o         <= 0;
      ir_in_mode_o         <= 0;
      ir_in_day_of_week_o  <= 0;
      ir_in_day_of_month_o <= 0;
      ir_in_month_o        <= 0;
      ir_in_year_o         <= 0;
    if (equal)
      ir_o <= 1;
    if (ir_i) begin
      ir_in_sec_o          <= cur_sec_i;
      ir_in_min_o          <= cur_min_i;
      ir_in_hour_o         <= cur_hour_i;
      ir_in_mode_o         <= cur_mode_i;
      ir_in_day_of_week_o  <= cur_day_of_week_i;
      ir_in_day_of_month_o <= cur_day_of_month_i;
      ir_in_month_o        <= cur_month_i;
      ir_in_year_o         <= cur_year_i;
    end                                   
  end

endmodule