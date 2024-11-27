`timescale 1ns / 1ps

module tb_clk_gen();

  // Testbench Signals
  logic        clk_external;
  logic        gen_en;
  logic        rstn;
  logic        sel_clk;
  logic [31:0] const_value;
  logic        clk_1Hz;

  // Instantiate the clk_gen module
  clk_gen dut (
    .clk_external_i(clk_external),
    .gen_en_i(gen_en),
    .rstn_i(rstn),
    .sel_clk_i(sel_clk),
    .const_i(const_value),
    .clk_1Hz_o(clk_1Hz)
  );

  // Clock Generation for clk_external
  initial begin
    clk_external = 0;
    forever #5 clk_external = ~clk_external;  // Generate a 100 MHz clock
  end

  // Initial Setup
  initial begin
    // Initialize Inputs
    gen_en = 0;
    rstn = 0;
    sel_clk = 0;
    const_value = 32'h2710;  // Assuming a value for testing

    // const_value = 32'h02FA_F080;  // Assuming a value for testing

    // Reset the system
    #100;
    rstn = 1;
    #100;

    // Enable clock generation
    gen_en = 1;
    #2000000000;  // Wait for some time to observe the clock output

    // Test Clock Source Selection
    sel_clk = 1;  // Switch to external clock
    #100;

    sel_clk = 0;  // Switch back to ring oscillator
    #100;

    // Disable the clock generation
    gen_en = 0;
    #50;

    // Pulse reset while the system is running
    rstn = 0;
    #20;
    rstn = 1;
    #100;

    // Finish the simulation
    $stop;
  end

endmodule
