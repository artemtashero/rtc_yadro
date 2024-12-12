module rtc_top (
  input  logic        ir_i,
  input  logic        clk_external_i,
  input  logic        CLK_APB,
  input  logic        rstn_i,
  input  logic        PENABLE,
  input  logic        PSEL,
  input  logic        PWRITE,
  input  logic [31:0] PADDR,
  input  logic [31:0] PWDATA,
  output logic        PSLVERR,
  output logic [31:0] PRDATA,
  output logic        ir_o,
  output logic        PREADY
);
  
  logic        clk_1Hz;
  logic        gen_en_rf;
  logic        sel_clk_rf;
  logic [31:0] const_rf;
  logic        enable_rf;
  logic        mode_rf;
  logic        en_preset_rf;
  logic [ 5:0] init_sec_rf;
  logic [ 5:0] init_min_rf;
  logic [ 4:0] init_hour_rf;
  logic [ 1:0] init_mode_rf;
  logic [ 2:0] init_day_of_week_rf;
  logic [ 4:0] init_day_of_month_rf;
  logic [ 3:0] init_month_rf;
  logic [11:0] init_year_rf;
  logic [ 5:0] cur_sec_rf;
  logic [ 5:0] cur_min_rf;
  logic [ 4:0] cur_hour_rf;
  logic [ 1:0] cur_mode_rf;
  logic [ 2:0] cur_day_of_week_rf;
  logic [ 4:0] cur_day_of_month_rf;
  logic [ 3:0] cur_month_rf;
  logic [11:0] cur_year_rf;
  logic [ 5:0] ir_in_sec_rf;
  logic [ 5:0] ir_in_min_rf;
  logic [ 4:0] ir_in_hour_rf;
  logic [ 1:0] ir_in_mode_rf;
  logic [ 2:0] ir_in_day_of_week_rf;
  logic [ 4:0] ir_in_day_of_month_rf;
  logic [ 3:0] ir_in_month_rf;
  logic [11:0] ir_in_year_rf;
  logic [ 5:0] ir_out_sec_rf;
  logic [ 5:0] ir_out_min_rf;
  logic [ 4:0] ir_out_hour_rf;
  logic [ 1:0] ir_out_mode_rf;
  logic [ 2:0] ir_out_day_of_week_rf;
  logic [ 4:0] ir_out_day_of_month_rf;
  logic [ 3:0] ir_out_month_rf;
  logic [11:0] ir_out_year_rf;

  rtc_am_pkg::rtc_am__in_t hwif_in;
  rtc_am_pkg::rtc_am__out_t hwif_out;
 
  always_comb begin
    //CLK GEN signals
    gen_en_rf  = hwif_out.config_reg.gen_en.value;
    sel_clk_rf = hwif_out.config_reg.sel_clk.value;
    const_rf   = hwif_out.const_reg.const_.value;
    //---------------------------------------------------

    //TIME COUNTER signals
    enable_rf            = hwif_out.enable_reg.enable.value;
    mode_rf              = hwif_out.config_reg.sel_mode.value;
    en_preset_rf         = hwif_out.config_reg.en_preset.value;
    init_sec_rf          = hwif_out.init_sec_reg.sec.value;
    init_min_rf          = hwif_out.init_min_reg.min.value;
    init_hour_rf         = hwif_out.init_hours_reg.hour.value;
    init_mode_rf         = { hwif_out.init_hours_reg.mode_AM_PM.value, hwif_out.init_hours_reg.mode_12_24.value };
    init_day_of_week_rf  = hwif_out.init_day_of_week_reg.day_of_week.value;
    init_day_of_month_rf = hwif_out.init_day_of_month_reg.day_of_month.value;
    init_month_rf        = hwif_out.init_month_reg.month.value;
    init_year_rf         = hwif_out.init_year_reg.year.value;

    hwif_in.cur_sec_reg.sec.next                   = cur_sec_rf;
    hwif_in.cur_min_reg.min.next                   = cur_min_rf;
    hwif_in.cur_hours_reg.hour.next                = cur_hour_rf;
    hwif_in.cur_hours_reg.mode_12_24.next          = cur_mode_rf[0];
    hwif_in.cur_hours_reg.mode_AM_PM.next          = cur_mode_rf[1];
    hwif_in.cur_day_of_week_reg.day_of_week.next   = cur_day_of_week_rf;
    hwif_in.cur_day_of_month_reg.day_of_month.next = cur_day_of_month_rf;
    hwif_in.cur_month_reg.month.next               = cur_month_rf;
    hwif_in.cur_year_reg.year.next                 = cur_year_rf;
    //---------------------------------------------------

    //INTERRUPT CONTROL signals
    hwif_in.ir_in_sec_reg.sec.next                   = ir_in_sec_rf;
    hwif_in.ir_in_min_reg.min.next                   = ir_in_min_rf;
    hwif_in.ir_in_hours_reg.hour.next                = ir_in_hour_rf;
    hwif_in.ir_in_hours_reg.mode_12_24.next          = ir_in_mode_rf[0];
    hwif_in.ir_in_hours_reg.mode_AM_PM.next          = ir_in_mode_rf[1];
    hwif_in.ir_in_day_of_week_reg.day_of_week.next   = ir_in_day_of_week_rf;
    hwif_in.ir_in_day_of_month_reg.day_of_month.next = ir_in_day_of_month_rf;
    hwif_in.ir_in_month_reg.month.next               = ir_in_month_rf;
    hwif_in.ir_in_year_reg.year.next                 = ir_in_year_rf;

    ir_out_sec_rf          = hwif_out.ir_out_sec_reg.sec.value;
    ir_out_min_rf          = hwif_out.ir_out_min_reg.min.value;
    ir_out_hour_rf         = hwif_out.ir_out_hours_reg.hour.value;
    ir_out_mode_rf         = { hwif_out.ir_out_hours_reg.mode_AM_PM.value, hwif_out.ir_out_hours_reg.mode_12_24.value };
    ir_out_day_of_week_rf  = hwif_out.ir_out_day_of_week_reg.day_of_week.value;
    ir_out_day_of_month_rf = hwif_out.ir_out_day_of_month_reg.day_of_month.value;
    ir_out_month_rf        = hwif_out.ir_out_month_reg.month.value;
    ir_out_year_rf         = hwif_out.ir_out_year_reg.year.value;
    //---------------------------------------------------
  end

  clk_gen  gen (
    .clk_external_i        (clk_external_i),
    .gen_en_i              (gen_en_rf),
    .rstn_i                (rstn_i),
    .sel_clk_i             (sel_clk_rf),
    .const_i               (const_rf),
    .clk_1Hz_o             (clk_1Hz)
  );

  time_counter tc (
    .enable_i              (enable_rf),               
    .clk_1Hz_i             (clk_1Hz),      
    .rstn_i                (rstn_i),           
    .mode_i                (mode_rf),                
    .en_preset_i           (en_preset_rf),          

    .init_sec_i            (init_sec_rf),         
    .init_min_i            (init_min_rf),          
    .init_hour_i           (init_hour_rf),          
    .init_mode_i           (init_mode_rf),           
    .init_day_of_week_i    (init_day_of_week_rf),     
    .init_day_of_month_i   (init_day_of_month_rf),   
    .init_month_i          (init_month_rf),           
    .init_year_i           (init_year_rf),          

    .cur_sec_o             (cur_sec_rf),              
    .cur_min_o             (cur_min_rf),            
    .cur_hour_o            (cur_hour_rf),           
    .cur_mode_o            (cur_mode_rf),         
    .cur_day_of_week_o     (cur_day_of_week_rf),    
    .cur_day_of_month_o    (cur_day_of_month_rf),  
    .cur_month_o           (cur_month_rf),         
    .cur_year_o            (cur_year_rf)           
  );

  ir_ctrl ir (
    .ir_i                  (ir_i),
    .clk_i                 (CLK_APB),       
    .rstn_i                (rstn_i),

    .cur_sec_i             (cur_sec_rf),
    .cur_min_i             (cur_min_rf),
    .cur_hour_i            (cur_hour_rf),
    .cur_mode_i            (cur_mode_rf),
    .cur_day_of_week_i     (cur_day_of_week_rf),
    .cur_day_of_month_i    (cur_day_of_month_rf),
    .cur_month_i           (cur_month_rf),
    .cur_year_i            (cur_year_rf),

    .ir_out_sec_i          (ir_out_sec_rf),              
    .ir_out_min_i          (ir_out_min_rf),              
    .ir_out_hour_i         (ir_out_hour_rf),             
    .ir_out_mode_i         (ir_out_mode_rf),             
    .ir_out_day_of_week_i  (ir_out_day_of_week_rf),      
    .ir_out_day_of_month_i (ir_out_day_of_month_rf),     
    .ir_out_month_i        (ir_out_month_rf),            
    .ir_out_year_i         (ir_out_year_rf),

    .ir_in_sec_o           (ir_in_sec_rf),              
    .ir_in_min_o           (ir_in_min_rf),              
    .ir_in_hour_o          (ir_in_hour_rf),             
    .ir_in_mode_o          (ir_in_mode_rf),             
    .ir_in_day_of_week_o   (ir_in_day_of_week_rf),      
    .ir_in_day_of_month_o  (ir_in_day_of_month_rf),     
    .ir_in_month_o         (ir_in_month_rf),            
    .ir_in_year_o          (ir_in_year_rf),
    .ir_o                  (ir_o)
  );

  rtc_am rf (
    .clk      (CLK_APB),
    .arst_n   (rstn_i),
    .PENABLE  (PENABLE),
    .PREADY   (PREADY),
    .PRDATA   (PRDATA),
    .PSLVERR  (PSLVERR),
    .PSEL     (PSEL),
    .PWRITE   (PWRITE),
    .PADDR    (PADDR),
    .PWDATA   (PWDATA),
    .hwif_in  (hwif_in),
    .hwif_out (hwif_out)
  );

endmodule