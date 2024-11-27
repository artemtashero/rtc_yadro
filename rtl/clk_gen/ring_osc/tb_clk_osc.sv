`timescale 1ns/1ps

module ring_oscillator_tb();

  logic enable_i;
  logic clk_o;

  ring_oscillator ro (
    .en (enable_i),
    .out(clk_o)
  );

  defparam ro.INVERTERS_PER_RING=5;
  defparam ro.INVERTER_DELAY=1;

  initial begin
    #30;
    enable_i = 0;

    #40;
    enable_i = 1;

    #300;
    $finish();
  end
    
endmodule