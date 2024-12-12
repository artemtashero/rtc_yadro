package tb_top_package;
  localparam ENABLE_REG = 32'h0;
  localparam CONFIG_REG = 32'h4;
  localparam CONST_REG  = 32'h24;

  localparam CUR_SEC_REG   = 32'h08;
  localparam CUR_MIN_REG   = 32'h0C;
  localparam CUR_HOURS_REG = 32'h10; //{25'b0, mode_AM_PM[6:6], mode_12_24[5:5], init_hours[4:0]}
  localparam CUR_DOW_REG   = 32'h14;
  localparam CUR_DOM_REG   = 32'h18;
  localparam CUR_MONTH_REG = 32'h1C;
  localparam CUR_YEAR_REG  = 32'h20;

  localparam INIT_SEC_REG   = 32'h28;
  localparam INIT_MIN_REG   = 32'h2C;
  localparam INIT_HOURS_REG = 32'h30; //{25'b0, mode_AM_PM[6:6], mode_12_24[5:5], init_hours[4:0]}
  localparam INIT_DOW_REG   = 32'h34;
  localparam INIT_DOM_REG   = 32'h38;
  localparam INIT_MONTH_REG = 32'h3C;
  localparam INIT_YEAR_REG  = 32'h40;

  localparam IR_IN_SEC_REG   = 32'h44;
  localparam IR_IN_MIN_REG   = 32'h48;
  localparam IR_IN_HOURS_REG = 32'h4C; //{25'b0, mode_AM_PM[6:6], mode_12_24[5:5], init_hours[4:0]}
  localparam IR_IN_DOW_REG   = 32'h50;
  localparam IR_IN_DOM_REG   = 32'h54;
  localparam IR_IN_MONTH_REG = 32'h58;
  localparam IR_IN_YEAR_REG  = 32'h5C;

  localparam IR_OUT_SEC_REG   = 32'h60;
  localparam IR_OUT_MIN_REG   = 32'h64;
  localparam IR_OUT_HOURS_REG = 32'h68; //{25'b0, mode_AM_PM[6:6], mode_12_24[5:5], init_hours[4:0]}
  localparam IR_OUT_DOW_REG   = 32'h6C;
  localparam IR_OUT_DOM_REG   = 32'h70;
  localparam IR_OUT_MONTH_REG = 32'h74;
  localparam IR_OUT_YEAR_REG  = 32'h78;
endpackage