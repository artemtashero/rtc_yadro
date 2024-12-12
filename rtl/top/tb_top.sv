`timescale 1ns/100ps

module tb_top;

  import tb_top_package::*;

  rtc_am_pkg::rtc_am__in_t hwif_in;
  rtc_am_pkg::rtc_am__out_t hwif_out;

  logic        ir_in;           
  logic        clk_external;      
  logic        CLK_APB;             
  logic        rstn;   
  logic        PENABLE;                     
  logic        PREADY;                              
  logic [31:0] PRDATA;                                    
  logic        PSLVERR;                                 
  logic        PSEL;                              
  logic        PWRITE;                
  logic [31:0] PADDR;                   
  logic [31:0] PWDATA;                        
  logic        ir_out;                    

  rtc_top DUT (
    .ir_i           (ir_in),
    .clk_external_i (clk_external),  
    .CLK_APB        (CLK_APB),
    .rstn_i         (rstn),
    .PENABLE        (PENABLE),
    .PREADY         (PREADY),
    .PRDATA         (PRDATA),  
    .PSLVERR        (PSLVERR),  
    .PSEL           (PSEL),  
    .PWRITE         (PWRITE),    
    .PADDR          (PADDR),      
    .PWDATA         (PWDATA),      
    .ir_o           (ir_out)        
  );

  //clk generation
  initial begin
    CLK_APB = 0;
    forever #10 CLK_APB = ~CLK_APB;
  end

  initial begin
    clk_external = 0;
    forever #20 clk_external = ~clk_external;
  end

  task write_req_assert(input logic [31:0] ADDR, input logic [31:0] DATA);
    @(posedge CLK_APB);
    PADDR = ADDR;
    PWDATA = DATA;
    PSEL = 1;
    PWRITE = 1;
    PENABLE = 1;
    end_req();
    read_req_assert(ADDR, DATA);
  endtask

  task write_req(input logic [31:0] ADDR, input logic [31:0] DATA);
    @(posedge CLK_APB);
    PADDR = ADDR;
    PWDATA = DATA;
    PSEL = 1;
    PWRITE = 1;
    PENABLE = 1;
    end_req();
  endtask

  task read_req_assert(input logic [31:0] ADDR, input logic [31:0] DATA);
    @(posedge CLK_APB);
    PADDR = ADDR;
    PSEL = 1;
    PWRITE = 0;
    PENABLE = 1;
    @(posedge PREADY);
    @(posedge CLK_APB);
    $display("here");
    assert (PRDATA == DATA) else $display("Invalid Data: %0t", $realtime);
    end_req();
  endtask

  task read_req(input logic [31:0] ADDR);
    @(posedge CLK_APB);
    PADDR = ADDR;
    PSEL = 1;
    PWRITE = 0;
    PENABLE = 1;
    end_req();
  endtask

  task end_req();
    @(posedge CLK_APB);
    PENABLE = 0;
    PADDR = 0;
    PWDATA = 0;
    PWRITE = 0;
    PSEL = 0;
  endtask

  task start_rtc();
    write_req_assert(CONFIG_REG, 32'b0000);
    write_req_assert(CONFIG_REG, 32'b0001);
    write_req_assert(CONST_REG, 32'd2);
    write_req_assert(ENABLE_REG, 32'h1);
    write_req_assert(ENABLE_REG, 32'h1);
  endtask
  
  task switch_to_clk_external();
    write_req_assert(CONFIG_REG, 32'b0011);
    #300;
  endtask

  task disable_rtc();
    write_req_assert(ENABLE_REG, 32'h0);
  endtask

  task enable_rtc();
    write_req_assert(ENABLE_REG, 32'h1);
  endtask

  task check_switch_24h();
    disable_rtc();
    enable_rtc();
    write_req_assert(INIT_SEC_REG, 32'd57);
    write_req_assert(INIT_MIN_REG, 32'd59);
    write_req_assert(INIT_HOURS_REG, 32'd23);
    write_req_assert(INIT_DOW_REG, 32'd7);
    write_req_assert(INIT_DOM_REG, 32'd31);
    write_req_assert(INIT_MONTH_REG, 32'd12);
    write_req_assert(INIT_YEAR_REG, 32'd2000);
    write_req_assert(CONFIG_REG, 32'b1001);
    write_req_assert(CONFIG_REG, 32'b0001);
  endtask

  task check_switch_24h_leap_year_FEB();
    disable_rtc();
    enable_rtc();
    write_req_assert(INIT_SEC_REG, 32'd57);
    write_req_assert(INIT_MIN_REG, 32'd59);
    write_req_assert(INIT_HOURS_REG, 32'd23);
    write_req_assert(INIT_DOW_REG, 32'd7);
    write_req_assert(INIT_DOM_REG, 32'd28);
    write_req_assert(INIT_MONTH_REG, 32'd2);
    write_req_assert(INIT_YEAR_REG, 32'd2004);
    write_req_assert(CONFIG_REG, 32'b1001);
    write_req_assert(CONFIG_REG, 32'b0001);
    write_req_assert(CONFIG_REG, 32'b0001);
  endtask

  task check_switch_24h_not_leap_year_FEB();
    disable_rtc();
    enable_rtc();
    write_req_assert(INIT_SEC_REG, 32'd57);
    write_req_assert(INIT_MIN_REG, 32'd59);
    write_req_assert(INIT_HOURS_REG, 32'd23);
    write_req_assert(INIT_DOW_REG, 32'd7);
    write_req_assert(INIT_DOM_REG, 32'd28);
    write_req_assert(INIT_MONTH_REG, 32'd2);
    write_req_assert(INIT_YEAR_REG, 32'd2003);
    write_req_assert(CONFIG_REG, 32'b1001);
    write_req_assert(CONFIG_REG, 32'b0001);
    write_req_assert(CONFIG_REG, 32'b0001);
  endtask

  task check_switch_12h_AM_to_PM();
    disable_rtc();
    enable_rtc();
    write_req_assert(INIT_SEC_REG, 32'd57);
    write_req_assert(INIT_MIN_REG, 32'd59);
    write_req_assert(INIT_HOURS_REG, 32'b01_001011);
    write_req_assert(INIT_DOW_REG, 32'd7);
    write_req_assert(INIT_DOM_REG, 32'd31);
    write_req_assert(INIT_MONTH_REG, 32'd12);
    write_req_assert(INIT_YEAR_REG, 32'd2000);
    write_req_assert(CONFIG_REG, 32'b1101);
    write_req_assert(CONFIG_REG, 32'b0101);
  endtask

  task check_switch_12h_PM_to_AM();
    disable_rtc();
    enable_rtc();
    write_req_assert(INIT_SEC_REG, 32'd57);
    write_req_assert(INIT_MIN_REG, 32'd59);
    write_req_assert(INIT_HOURS_REG, 32'b11_001011);
    write_req_assert(INIT_DOW_REG, 32'd7);
    write_req_assert(INIT_DOM_REG, 32'd31);
    write_req_assert(INIT_MONTH_REG, 32'd12);
    write_req_assert(INIT_YEAR_REG, 32'd2000);
    write_req_assert(CONFIG_REG, 32'b1101);
    write_req_assert(CONFIG_REG, 32'b0101);
  endtask

  task read_cur_value();
    read_req(CUR_SEC_REG);
    read_req(CUR_MIN_REG);
    read_req(CUR_HOURS_REG);
    read_req(CUR_DOW_REG);
    read_req(CUR_DOM_REG);
    read_req(CUR_MONTH_REG);
    read_req(CUR_YEAR_REG);
  endtask

  task wrong_addr();
    read_req(32'hFFFF_FFFF);
  endtask

  task ir_input();
    @(posedge CLK_APB);
    ir_in = 1;
    @(posedge CLK_APB);
    ir_in = 0;
    read_req(IR_IN_SEC_REG);
    read_req(IR_IN_MIN_REG);
    read_req(IR_IN_HOURS_REG);
    read_req(IR_IN_DOW_REG);
    read_req(IR_IN_DOM_REG);
    read_req(IR_IN_MONTH_REG);
    read_req(IR_IN_YEAR_REG);
  endtask

  task ir_output();
    write_req_assert(IR_OUT_SEC_REG, 32'd59);
    write_req_assert(IR_OUT_MIN_REG, 32'd59);
    write_req_assert(IR_OUT_HOURS_REG, 32'd23);
    write_req_assert(IR_OUT_DOW_REG, 32'd7);
    write_req_assert(IR_OUT_DOM_REG, 32'd31);
    write_req_assert(IR_OUT_MONTH_REG, 32'd12);
    write_req_assert(IR_OUT_YEAR_REG, 32'd2000);
    check_switch_24h();
  endtask


  //main
  initial begin
    rstn = 1;
    #20;
    rstn = 0;
    #20;
    rstn = 1;
    #20;
    disable_rtc();
    #300;
    enable_rtc();
    #300;
    start_rtc();
    #300;
    check_switch_24h();
    #300;
    disable_rtc();
    #300;
    enable_rtc();
    #300;
    read_cur_value();
    #300;
    wrong_addr();
    #300;
    ir_input();
    #300;
    ir_output();
    #600;
    check_switch_12h_AM_to_PM();
    #300;
    check_switch_12h_PM_to_AM();
    #300;
    check_switch_24h_leap_year_FEB();
    #300;
    check_switch_24h_not_leap_year_FEB();
    #300;
    switch_to_clk_external();
    #300;
    $stop;
  end

endmodule