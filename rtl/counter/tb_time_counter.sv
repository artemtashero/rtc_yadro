`timescale 1ns / 1ps

module tb_time_counter;

  // Inputs
  logic        clk_1Hz;
  logic        rstn;
  logic        mode;
  logic        en_preset;
  logic [ 5:0] init_sec;
  logic [ 5:0] init_min;
  logic [ 5:0] init_hour;
  logic [ 1:0] init_mode;
  logic [ 2:0] init_day_of_week;
  logic [ 4:0] init_day_of_month;
  logic [ 3:0] init_month;
  logic [11:0] init_year;

  // Outputs
  logic [ 5:0] cur_sec;
  logic [ 5:0] cur_min;
  logic [ 5:0] cur_hour;
  logic [ 1:0] cur_mode;
  logic [ 2:0] cur_day_of_week;
  logic [ 4:0] cur_day_of_month;
  logic [ 3:0] cur_month;
  logic [11:0] cur_year;

  time_counter dut (
    .clk_1Hz_i(clk_1Hz), 
    .rstn_i(rstn), 
    .mode_i(mode), 
    .en_preset_i(en_preset), 
    .init_sec_i(init_sec), 
    .init_min_i(init_min), 
    .init_hour_i(init_hour), 
    .init_mode_i(init_mode),
    .init_day_of_week_i(init_day_of_week), 
    .init_day_of_month_i(init_day_of_month), 
    .init_month_i(init_month), 
    .init_year_i(init_year), 
    .cur_sec_o(cur_sec), 
    .cur_min_o(cur_min), 
    .cur_hour_o(cur_hour),
    .cur_mode_o(cur_mode),
    .cur_day_of_week_o(cur_day_of_week), 
    .cur_day_of_month_o(cur_day_of_month), 
    .cur_month_o(cur_month), 
    .cur_year_o(cur_year)
  );

  initial begin
    clk_1Hz = 0;
    forever #5 clk_1Hz = ~clk_1Hz; 
  end

  // Initial Reset
  initial begin
    rstn = 1;
    #20;
    rstn = 0;
    #20;
    rstn = 1;
  end

  // Test Stimuli
  initial begin
    // Initialize Inputs
    mode = 0; // Start in 24-hour mode
    en_preset = 0;
    //init_sec = 0;
    //init_min = 0;
    //init_hour = 0;
    //init_mode = 2'b00;
    //init_day_of_week = 1; // Sunday
    //init_day_of_month = 1;
    //init_month = 1; // January
    //init_year = 20; // Year 2020

    // Wait for reset to finish
    #200;

    // Enable preset to set initial time
    en_preset = 1;
    init_sec = 50;
    init_min = 59;
    init_hour = 23;
    init_day_of_week = 5; // Friday
    init_day_of_month = 31;
    init_month = 12; // December
    init_year = 11'd2021; // Year 2021
    #20; // Apply preset for 1 second
    en_preset = 0;

    // Change to 12-hour mode
    #400; // Wait for the next few cycles
    mode = 1;
    en_preset = 1;
    init_sec = 50;
    init_min = 59;
    init_hour = 11;
    init_mode = 2'b11;
    init_day_of_week = 5; // Friday
    init_day_of_month = 31;
    init_month = 12; // December
    init_year = 11'd2021; // Year 2021
    #20; // Apply preset for 1 second
    en_preset = 0;

    #400; // Wait for the next few cycles
    mode = 1;
    en_preset = 1;
    init_sec = 50;
    init_min = 59;
    init_hour = 11;
    init_mode = 2'b01;
    init_day_of_week = 5; // Friday
    init_day_of_month = 31;
    init_month = 12; // December
    init_year = 11'd2021; // Year 2021
    #20; // Apply preset for 1 second
    en_preset = 0;

    
    #10000; // Simulate for a significant duration to see the time change

    // End of simulation
    $finish;
  end

endmodule

//task test1();
//    en_preset = 1;
//    init_sec = 50;
//    init_min = 59;
//    init_hour = 23;
//    init_day_of_week = 5; // Friday
//    init_day_of_month = 31;
//    init_month = 12; // December
//    init_year = 21; // Year 2021
//    @(posedge clk);
//    assert(cur_sec == 51 && cur_min = 59);
//    repeat 20
//    @(posedge clk);
//    assert();
//endtask
