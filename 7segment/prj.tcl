project_new example1 -overwrite

set_global_assignment -name FAMILY MAX10
set_global_assignment -name DEVICE 10M50DAF484C7G

set_global_assignment -name BDF_FILE example1.bdf
set_global_assignment -name VERILOG_FILE 7seg.v
set_global_assignment -name SDC_FILE example1.sdc

set_global_assignment -name TOP_LEVEL_ENTITY seg7
set_location_assignment -to clk PIN_AH10

set_location_assignment PIN_C10 -to rst ;
set_location_assignment PIN_A8 -to tick ;# LED[0]
set_location_assignment PIN_P11 -to clk ;
set_location_assignment PIN_C11 -to start ;
set_location_assignment PIN_D12 -to pause;

set_location_assignment PIN_C14 -to sec1[6] ;
set_location_assignment PIN_E15 -to sec1[5] ;
set_location_assignment PIN_C15 -to sec1[4] ;
set_location_assignment PIN_C16 -to sec1[3] ;
set_location_assignment PIN_E16 -to sec1[2] ;
set_location_assignment PIN_D17 -to sec1[1] ;
set_location_assignment PIN_C17 -to sec1[0] ;

set_location_assignment PIN_C18 -to sec2[6] ;
set_location_assignment PIN_D18 -to sec2[5] ;
set_location_assignment PIN_E18 -to sec2[4] ;
set_location_assignment PIN_B16 -to sec2[3] ;
set_location_assignment PIN_A17 -to sec2[2] ;
set_location_assignment PIN_A18 -to sec2[1] ;
set_location_assignment PIN_B17 -to sec2[0] ;


set_location_assignment PIN_B20 -to min1[6] ;
set_location_assignment PIN_A20 -to min1[5] ;
set_location_assignment PIN_B19 -to min1[4] ;
set_location_assignment PIN_A21 -to min1[3] ;
set_location_assignment PIN_B21 -to min1[2] ;
set_location_assignment PIN_C22 -to min1[1] ;
set_location_assignment PIN_B22 -to min1[0] ;

set_location_assignment PIN_F21 -to min2[6] ;
set_location_assignment PIN_E22 -to min2[5] ;
set_location_assignment PIN_E21 -to min2[4] ;
set_location_assignment PIN_C19 -to min2[3] ;
set_location_assignment PIN_C20 -to min2[2] ;
set_location_assignment PIN_D19 -to min2[1] ;
set_location_assignment PIN_E17 -to min2[0] ;

#set_location_assignment PIN_B8 -to btn1 ;

load_package flow
execute_flow -compile

project_close
