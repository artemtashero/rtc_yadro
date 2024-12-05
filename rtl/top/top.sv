module rtc_top (
  input logic ir_i,
  input logic clk_external_i,
  input logic rstn_i,
  output logic ir_o




  
);
  
  logic clk_1Hz;

  clk_gen  gen (
    .clk_external_i(clk_external_i),
    .gen_en_i(),
    .rstn_i(rstn_i),
    .sel_clk_i(),
    .const_i(),
    .clk_1Hz_o(clk_1Hz)
  );

  time_counter tc (
    .enable_i(),               
    .clk_1Hz_i(clk_1Hz),      
    .rstn_i(rstn_i),           
    .mode_i(),                
    .en_preset_i(),          

    .init_sec_i(),         
    .init_min_i(),          
    .init_hour_i(),          
    .init_mode_i(),           
    .init_day_of_week_i(),     
    .init_day_of_month_i(),   
    .init_month_i(),           
    .init_year_i(),          

    .cur_sec_o(),              
    .cur_min_o(),            
    .cur_hour_o(),           
    .cur_mode_o(),         
    .cur_day_of_week_o(),    
    .cur_day_of_month_o(),  
    .cur_month_o(),         
    .cur_year_o()           
  );

  ir_ctrl ir (
    .ir_i(ir_i),
    .clk_i(),       
    .rstn_i(rstn_i),

    .cur_sec_o(),
    .cur_min_o(),
    .cur_hour_o(),
    .cur_mode_o(),
    .cur_day_of_week_o(),
    .cur_day_of_month_o(),
    .cur_month_o(),
    .cur_year_o()

    .ir_out_sec_i(),              
    .ir_out_min_i(),              
    .ir_out_hour_i(),             
    .ir_out_mode_i(),             
    .ir_out_day_of_week_i(),      
    .ir_out_day_of_month_i(),     
    .ir_out_month_i(),            
    .ir_out_year_i(),

    .ir_in_sec_o(),              
    .ir_in_min_o(),              
    .ir_in_hour_o(),             
    .ir_in_mode_o(),             
    .ir_in_day_of_week_o(),      
    .ir_in_day_of_month_o(),     
    .ir_in_month_o(),            
    .ir_in_year_o(),
    .ir_o()
  );

  rtc_am rf (
    .clk(),
    .arst_n(),
    .s_apb(),
    .hwif_in(),
    .hwif_out()
  );

endmodule