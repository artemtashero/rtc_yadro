module tb_ir_ctrl;

  logic ir_i;
  logic clk_i;
  logic rstn_i;
  logic [5:0] cur_sec_i;
  logic [5:0] cur_min_i;
  logic [5:0] cur_hour_i;
  logic [1:0] cur_mode_i;
  logic [2:0] cur_day_of_week_i;
  logic [4:0] cur_day_of_month_i;
  logic [3:0] cur_month_i;
  logic [11:0] cur_year_i;
  
  logic [5:0] ir_out_sec_i;
  logic [5:0] ir_out_min_i;
  logic [5:0] ir_out_hour_i;
  logic [1:0] ir_out_mode_i;
  logic [2:0] ir_out_day_of_week_i;
  logic [4:0] ir_out_day_of_month_i;
  logic [3:0] ir_out_month_i;
  logic [11:0] ir_out_year_i;

  logic [5:0] ir_in_sec_o;
  logic [5:0] ir_in_min_o;
  logic [5:0] ir_in_hour_o;
  logic [1:0] ir_in_mode_o;
  logic [2:0] ir_in_day_of_week_o;
  logic [4:0] ir_in_day_of_month_o;
  logic [3:0] ir_in_month_o;
  logic [11:0] ir_in_year_o;
  logic ir_o;

  ir_ctrl uut (
    .ir_i(ir_i),
    .clk_i(clk_i),
    .rstn_i(rstn_i),
    .cur_sec_i(cur_sec_i),
    .cur_min_i(cur_min_i),
    .cur_hour_i(cur_hour_i),
    .cur_mode_i(cur_mode_i),
    .cur_day_of_week_i(cur_day_of_week_i),
    .cur_day_of_month_i(cur_day_of_month_i),
    .cur_month_i(cur_month_i),
    .cur_year_i(cur_year_i),
    .ir_out_sec_i(ir_out_sec_i),
    .ir_out_min_i(ir_out_min_i),
    .ir_out_hour_i(ir_out_hour_i),
    .ir_out_mode_i(ir_out_mode_i),
    .ir_out_day_of_week_i(ir_out_day_of_week_i),
    .ir_out_day_of_month_i(ir_out_day_of_month_i),
    .ir_out_month_i(ir_out_month_i),
    .ir_out_year_i(ir_out_year_i),
    .ir_in_sec_o(ir_in_sec_o),
    .ir_in_min_o(ir_in_min_o),
    .ir_in_hour_o(ir_in_hour_o),
    .ir_in_mode_o(ir_in_mode_o),
    .ir_in_day_of_week_o(ir_in_day_of_week_o),
    .ir_in_day_of_month_o(ir_in_day_of_month_o),
    .ir_in_month_o(ir_in_month_o),
    .ir_in_year_o(ir_in_year_o),
    .ir_o(ir_o)
  );

  always #5 clk_i = ~clk_i;

  initial begin
    clk_i = 0;
    rstn_i = 0;
    ir_i = 0;
    cur_sec_i = 6'd0;
    cur_min_i = 6'd0;
    cur_hour_i = 6'd0;
    cur_mode_i = 2'd0;
    cur_day_of_week_i = 3'd0;
    cur_day_of_month_i = 5'd1;
    cur_month_i = 4'd1;
    cur_year_i = 12'd2023;
    
    #100;
    rstn_i = 1;
    #100;
    ir_out_sec_i = 6'd0;
    ir_out_min_i = 6'd0;
    ir_out_hour_i = 6'd0;
    ir_out_mode_i = 2'd0;
    ir_out_day_of_week_i = 3'd0;
    ir_out_day_of_month_i = 5'd1;
    ir_out_month_i = 4'd1;
    ir_out_year_i = 12'd2023;
    
    #100;
    ir_i = 1;
    #10;

    #200;
    ir_i = 0;
    #200;
    $stop;
  end

endmodule