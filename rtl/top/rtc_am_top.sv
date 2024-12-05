module rtc_am_top(
  apb_if.sp    apb_sp_b,
  //interface?
);
rtc_am_pkg::rtc_am__in_t hwif_in;
rtc_am_pkg::rtc_am__out_t hwif_out;

rtc_am rtc_am(
  .clk    (apb_sp_b.PCLK),
  .arst_n (apb_sp_b.PRESETn),

  .s_abp (apb_sp_b),
  .hwif_in (hwif_in),
  .hwif_out (hwif_out)
);
endmodule