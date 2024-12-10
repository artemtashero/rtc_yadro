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
  output logic [ 1:0] cur_mode_o,             // Текущий режим (0 бит - 12/24, 1 бит - АМ/РМ)
  output logic [ 2:0] cur_day_of_week_o,      // День недели (1[воскресенье]-7[понедельник])
  output logic [ 4:0] cur_day_of_month_o,     // День месяца (01-31)
  output logic [ 3:0] cur_month_o,            // Месяц (01-12)
  output logic [11:0] cur_year_o              // Год
);

  logic [4:0] max_day_in_month;

  always_comb begin
    sec_59     = (cur_sec_o == 59);
    min_59     = (cur_min_o == 59);
    hour_11    = (cur_hour_o == 11);
    hour_12    = (cur_hour_o == 12);
    hour_23    = (cur_hour_o == 23);
    flag_AM    = (cur_mode_o[1] == 0);
    flag_PM    = (cur_mode_o[1] == 1);
    DoM_max    = (cur_day_of_month_o == max_day_in_month);
    DoW_7      = (cur_day_of_week_o == 7);
    month_12   = (cur_month_o == 12);

    month_feb  = (cur_month_o == 2);
    leap_year  = ((cur_year_o[1:0] == 0 && cur_year_o != 2100) || (cur_year_o  == 2000));
    month_30d  = (cur_month_o == 4 || cur_month_o == 6 || cur_month_o == 9 || cur_month_o == 11);

    mode_12    = (mode_i == 1);
    mode_24    = (mode_i == 0);
  end

  always_comb begin : defining_number_of_days_in_month
    if (month_feb) begin : if_feb
      if (leap_year) begin : if_leap_year
        max_day_in_month = 29;
      end
      else begin : if_usual_year
        max_day_in_month = 28;
      end
    end else if (month_30d) begin : if_month_with_30d
      max_day_in_month   = 30;
    end
    else begin : if_month_with_31d
      max_day_in_month   = 31;
    end
  end
  
  always_ff @(posedge clk_1Hz_i or negedge rstn_i) begin
    if (!rstn_i) begin : reset_value
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

    else if (enable_i && !en_preset_i) begin : write_default_value_when_enable
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

    else if (enable_i && en_preset_i) begin : write_initial_value_when_enable
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
    else begin : time_and_date_counter

      cur_sec_o <= cur_sec_o + 1;

      if (sec_59) begin : min_counter
        cur_sec_o <= 0;
        cur_min_o <= cur_min_o + 1;
      end

      if (min_59 && sec_59) begin : hour_counter
        cur_min_o  <= 0;
        cur_hour_o <= cur_hour_o + 1;
      end

      if (mode_12) begin : DoW_DoM_counter_12h_mode
        cur_mode_o[0]   <= 1;

        if (flag_PM && hour_11 && min_59 && sec_59) begin : next_day
          cur_mode_o[1]      <= ~cur_mode_o[1];
          cur_day_of_month_o <= cur_day_of_month_o + 1;
          cur_day_of_week_o  <= cur_day_of_week_o  + 1;
        end

        else if (flag_AM && hour_11 && min_59 && sec_59) begin : AM_to_PM_switch
          cur_mode_o[1] <= ~cur_mode_o[1];
        end

        if (DoW_7 && flag_PM && hour_11 && min_59 && sec_59) begin : DoW_loop
          cur_day_of_week_o <= 1;
        end

        if (hour_12 && min_59 && sec_59) begin : hour_loop
          cur_hour_o    <= 1;
        end
      end 
      else begin : DoW_DoM_counter_24h_mode
        cur_mode_o <= 2'b00;

        if (hour_23 && min_59 && sec_59) begin : next_day_and_hour_loop
          cur_hour_o         <= 0;
          cur_day_of_month_o <= cur_day_of_month_o + 1;
          cur_day_of_week_o  <= cur_day_of_week_o  + 1;
        end

        if (DoW_7 && hour_23 && min_59 && sec_59) begin : DoW_loop
          cur_day_of_week_o <= 1;
        end
      end

      if (mode_12 && DoM_max && flag_PM && hour_11 && min_59 && sec_59) begin : month_counter_12h_mode
        cur_day_of_month_o <= 1;
        cur_month_o        <= cur_month_o + 1;
      end
      else if (mode_24 && DoM_max && hour_23 && min_59 && sec_59) begin : month_counter_24h_mode
        cur_day_of_month_o <= 1;
        cur_month_o        <= cur_month_o + 1;
      end

      if (mode_12 && month_12 && DoM_max && flag_PM && hour_11 && min_59 && sec_59) begin : year_counter_12h_mode 
        cur_month_o <= 1;
        cur_year_o  <= cur_year_o + 1;
      end
      else if (mode_24 && month_12 && DoM_max && hour_23 && min_59 && sec_59) begin : year_counter_24h_mode
        cur_month_o <= 1;
        cur_year_o  <= cur_year_o + 1;
      end

    end
  end

endmodule