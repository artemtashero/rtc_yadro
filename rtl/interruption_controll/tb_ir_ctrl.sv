module tb_ir_ctrl;

  // Входные сигналы
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

  // Выходные сигналы
  logic [5:0] ir_in_sec_o;
  logic [5:0] ir_in_min_o;
  logic [5:0] ir_in_hour_o;
  logic [1:0] ir_in_mode_o;
  logic [2:0] ir_in_day_of_week_o;
  logic [4:0] ir_in_day_of_month_o;
  logic [3:0] ir_in_month_o;
  logic [11:0] ir_in_year_o;
  logic ir_o;

  // Экземпляр модуля ir_ctrl
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

  // Генерация тактового сигнала
  always #5 clk_i = ~clk_i;

  // Сценарий теста
  initial begin
    // Инициализация
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
    
    ir_out_sec_i = 6'd0;
    ir_out_min_i = 6'd0;
    ir_out_hour_i = 6'd0;
    ir_out_mode_i = 2'd0;
    ir_out_day_of_week_i = 3'd0;
    ir_out_day_of_month_i = 5'd1;
    ir_out_month_i = 4'd1;
    ir_out_year_i = 12'd2023;

    // Сброс системы
    rstn_i = 0;
    #10 rstn_i = 1;

    // Начало теста
    $display("Starting test");

    // Тест 1: Проверка без нажатия IR
    $display("Test 1: Check IR without input");
    #10;
    if (ir_o != 0) $display("Error: ir_o should be 0");

    // Тест 2: Установка значений, которые совпадают с ir_out
    cur_sec_i = ir_out_sec_i;
    cur_min_i = ir_out_min_i;
    cur_hour_i = ir_out_hour_i;
    cur_mode_i = ir_out_mode_i;
    cur_day_of_week_i = ir_out_day_of_week_i;
    cur_day_of_month_i = ir_out_day_of_month_i;
    cur_month_i = ir_out_month_i;
    cur_year_i = ir_out_year_i;

    // Убедимся, что ir_o становится равным 1, так как значения равны
    #10;
    if (ir_o != 1) $display("Error: ir_o should be 1");

    // Тест 3: Проверка поведения при нажатии кнопки IR
    ir_i = 1;
    #10;

    // Проверим, что значения были переданы на выход
    if (ir_in_sec_o != cur_sec_i) $display("Error: ir_in_sec_o mismatch");
    if (ir_in_min_o != cur_min_i) $display("Error: ir_in_min_o mismatch");
    if (ir_in_hour_o != cur_hour_i) $display("Error: ir_in_hour_o mismatch");
    if (ir_in_mode_o != cur_mode_i) $display("Error: ir_in_mode_o mismatch");
    if (ir_in_day_of_week_o != cur_day_of_week_i) $display("Error: ir_in_day_of_week_o mismatch");
    if (ir_in_day_of_month_o != cur_day_of_month_i) $display("Error: ir_in_day_of_month_o mismatch");
    if (ir_in_month_o != cur_month_i) $display("Error: ir_in_month_o mismatch");
    if (ir_in_year_o != cur_year_i) $display("Error: ir_in_year_o mismatch");

    // Тест завершен
    $display("Test complete");
    $finish;
  end

endmodule
