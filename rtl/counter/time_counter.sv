module time_counter(
  input  logic        enable_i,                 // Сигнал включения счетчика
  input  logic        clk_1Hz_i,              // Тактовый сигнал
  input  logic        rstn_i,                 // Сигнал сброса
  input  logic        mode_i,                 // Режим отображения времени (1-12 часов, 0-24 часа)
  input  logic        en_preset_i,            // Сигнал разрешения записи начала отсчета   
  input  logic [ 5:0] init_sec_i,             // Начальные секунды
  input  logic [ 5:0] init_min_i,             // Начальные минуты
  input  logic [ 5:0] init_hour_i,            // Начальные часы
  input  logic [ 1:0] init_mode_i,            // Начальный режим
  input  logic [ 2:0] init_day_of_week_i,     // Начальный день недели
  input  logic [ 4:0] init_day_of_month_i,    // Начальный день месяца
  input  logic [ 3:0] init_month_i,           // Начальный месяц
  input  logic [11:0] init_year_i,            // Начальный год
  output logic [ 5:0] cur_sec_o,              // Секунды (00-59)
  output logic [ 5:0] cur_min_o,              // Минуты (00-59)
  output logic [ 5:0] cur_hour_o,             // Часы (00-23 или 01-12)
  output logic [ 1:0] cur_mode_o,             // Текущий режим
  output logic [ 2:0] cur_day_of_week_o,      // День недели (1[воскресенье]-7[понедельник])
  output logic [ 4:0] cur_day_of_month_o,     // День месяца (01-31)
  output logic [ 3:0] cur_month_o,            // Месяц (01-12)
  output logic [11:0] cur_year_o              // Год
);

  logic [4:0] max_day_in_month;

  //define max day
  always_comb begin
    if (cur_month_o == 2) begin
      if ((cur_year_o[1:0] == 0 && cur_year_o != 2100) || (cur_year_o  == 2000))
        max_day_in_month = 29;
      else
        max_day_in_month = 28;
    end else if (cur_month_o == 4 || cur_month_o == 6 || cur_month_o == 9 || cur_month_o == 11)
      max_day_in_month   = 30;
    else
      max_day_in_month   = 31;
  end
  
  always_ff @(posedge clk_1Hz_i or negedge rstn_i) begin
    //rst value
    if (!rstn_i) begin
      cur_sec_o           <= 0; 
      cur_min_o           <= 0; 
      cur_day_of_week_o   <= 1;
      cur_day_of_month_o  <= 1; 
      cur_month_o         <= 1; 
      cur_year_o          <= 2000;
      if (mode_i) begin
        cur_mode_o        <= 2'b01;
        cur_hour_o        <= 12;
      end else begin
        cur_mode_o        <= 2'b00;
        cur_hour_o        <= 0;
      end
    end

    //enable value without preset
    else if (enable_i && !en_preset_i) begin
      cur_sec_o           <= 0; 
      cur_min_o           <= 0; 
      cur_day_of_week_o   <= 1;
      cur_day_of_month_o  <= 1; 
      cur_month_o         <= 1; 
      cur_year_o          <= 2000;
      if (mode_i) begin
        cur_mode_o        <= 2'b01;
        cur_hour_o        <= 12;
      end else begin
        cur_mode_o        <= 2'b00;
        cur_hour_o        <= 0;
      end
    end

    //enable value with preset
    else if (enable_i && en_preset_i) begin
      cur_sec_o           <= init_sec_i;
      cur_min_o           <= init_min_i;
      cur_hour_o          <= init_hour_i;
      cur_day_of_week_o   <= init_day_of_week_i;
      cur_day_of_month_o  <= init_day_of_month_i;
      cur_month_o         <= init_month_i;
      cur_year_o          <= init_year_i;
      cur_mode_o          <= init_mode_i;
    end

    //counter 
    else begin
      //sec counter
      cur_sec_o <= cur_sec_o + 1;

      //min counter
      if (cur_sec_o == 59) begin
        cur_sec_o <= 0;
        cur_min_o <= cur_min_o + 1;
      end

      //hour counter
      if ((cur_min_o == 59) && (cur_sec_o == 59)) begin
        cur_min_o  <= 0;
        cur_hour_o <= cur_hour_o + 1;
      end

      //day of month and day of week counter with am/pm flag
      if (mode_i) begin
        cur_mode_o[0] <= 1;
        if ((cur_mode_o[1]) && (cur_hour_o == 11) && (cur_min_o == 59) && (cur_sec_o == 59)) begin
          cur_mode_o[1]      <= ~cur_mode_o[1];
          cur_day_of_month_o <= cur_day_of_month_o + 1;
          cur_day_of_week_o  <= cur_day_of_week_o  + 1;
        end 
        else if ((!cur_mode_o[1]) && (cur_hour_o == 11) && (cur_min_o == 59) && (cur_sec_o == 59)) 
          cur_mode_o[1] <= ~cur_mode_o[1];
        if ((cur_hour_o == 12) && (cur_min_o == 59) && (cur_sec_o == 59)) 
          cur_hour_o <= 1;
      end 
      else begin
        cur_mode_o <= 0;
        if (cur_hour_o == 23) begin
          cur_hour_o         <= 0;
          cur_day_of_month_o <= cur_day_of_month_o + 1;
          cur_day_of_week_o  <= cur_day_of_week_o  + 1;
        end
      end

      //month counter
      if ((cur_day_of_month_o == max_day_in_month) && (cur_hour_o == (mode_i ? 11 : 23)) && (cur_min_o == 59) && (cur_sec_o == 59) && (cur_mode_o[1] == 1)) begin
        cur_day_of_month_o <= 1;
        cur_month_o        <= cur_month_o + 1;
      end

      //day of week counter
      if ((cur_day_of_week_o == 7))
        cur_day_of_week_o <= 1;

      //year counter
      if ((cur_month_o == 12) && (cur_day_of_month_o == max_day_in_month) && (cur_hour_o == (mode_i ? 11 : 23)) && (cur_min_o == 59) && (cur_sec_o == 59) && (cur_mode_o[1] == 1)) begin
        cur_month_o <= 1;
        cur_year_o  <= cur_year_o + 1;
      end
    end
  end

endmodule





      // if (cur_sec_o == 59) begin
      //   cur_sec_o <= 0;
      //   if (cur_min_o == 59) begin
      //     cur_min_o <= 0;
      //     if (cur_hour_o == (mode_i ? 11 : 23)) begin
      //       cur_hour_o <= 0;
      //       if (mode_i) begin
      //         cur_mode_o[0] <= 1;
      //         cur_mode_o[1] <= ~cur_mode_o[1];
      //       end else
      //         cur_mode_o = 2'b00;
      //       if (cur_day_of_month_o == max_day_in_month) begin
      //         cur_day_of_month_o <= 1;
      //         if (cur_month_o == 12) begin
      //           cur_month_o <= 1;
      //           cur_year_o <= cur_year_o + 1;
      //         end else 
      //           cur_month_o <= cur_month_o + 1;
      //       end else 
      //         cur_day_of_month_o <= cur_day_of_month_o + 1;
      //     end else 
      //       cur_hour_o <= cur_hour_o + 1;
      //   end else 
      //     cur_min_o <= cur_min_o + 1;
      // end else 
      //   cur_sec_o <= cur_sec_o + 1;


      // if ((cur_hour_o == (!mode_i ?  23 : (cur_mode_o[1]) ? 12 : 11)) && (cur_min_o == 59) && (cur_sec_o == 59)) begin
      //   cur_hour_o <= 0;
      //   if (cur_mode_o[1] == 0) begin
      //   cur_day_of_month_o <= cur_day_of_month_o + 1;
      //   cur_day_of_week_o  <= cur_day_of_week_o + 1;
      //   end
      // end


      // if (mode_i) begin
      //   cur_mode_o[0] <= 1;
      //   if ((cur_hour_o == 11) && (cur_min_o == 59) && (cur_sec_o == 59)) 
      //     cur_mode_o[1] <= ~cur_mode_o[1];
      // end else
      //   cur_mode_o <= 2'b00;
