project_new example1 -overwrite

set_global_assignment -name FAMILY MAX10
set_global_assignment -name DEVICE 10M50DAF484C7G

set_global_assignment -name BDF_FILE example1.bdf
set_global_assignment -name VERILOG_FILE top.v
set_global_assignment -name SDC_FILE example1.sdc

set_global_assignment -name TOP_LEVEL_ENTITY top_memory
set_location_assignment -to clk PIN_AH10

set_location_assignment PIN_B8 -to rst ;# PUSH BUTTON[0]
set_location_assignment PIN_A8 -to tick ;# LED[0]

#sec1 segment 1

set_location_assignment PIN_C14 -to segment1[0] ;# HEX0[0]
set_location_assignment PIN_E15 -to segment1[1] ;# HEX0[1]
set_location_assignment PIN_C15 -to segment1[2] ;# HEX0[2]
set_location_assignment PIN_C16 -to segment1[3] ;# HEX0[3]
set_location_assignment PIN_E16 -to segment1[4] ;# HEX0[4]
set_location_assignment PIN_D17 -to segment1[5] ;# HEX0[5]
set_location_assignment PIN_C17 -to segment1[6] ;# HEX0[6]
set_location_assignment PIN_D15 -to segment1[7] ;# HEX0[7]

#sec2 segment 2

set_location_assignment PIN_C18 -to segment2[0] ;# HEX1[0]
set_location_assignment PIN_D18 -to segment2[1] ;# HEX1[1]
set_location_assignment PIN_E18 -to segment2[2] ;# HEX1[2]
set_location_assignment PIN_B16 -to segment2[3] ;# HEX1[3]
set_location_assignment PIN_A17 -to segment2[4] ;# HEX1[4]
set_location_assignment PIN_A18 -to segment2[5] ;# HEX1[5]
set_location_assignment PIN_B17 -to segment2[6] ;# HEX1[6]
set_location_assignment PIN_A16 -to segment2[7] ;# HEX1[7]

#min1 segment 3

set_location_assignment PIN_B20 -to segment3[0] ;# HEX2[0]
set_location_assignment PIN_A20 -to segment3[1] ;# HEX2[1]
set_location_assignment PIN_B19 -to segment3[2] ;# HEX2[2]
set_location_assignment PIN_A21 -to segment3[3] ;# HEX2[3]
set_location_assignment PIN_B21 -to segment3[4] ;# HEX2[4]
set_location_assignment PIN_C22 -to segment3[5] ;# HEX2[5]
set_location_assignment PIN_B22 -to segment3[6] ;# HEX2[6]
set_location_assignment PIN_A19 -to segment3[7] ;# HEX2[7]

#min2 segment 4

set_location_assignment PIN_F21 -to segment4[0] ;# HEX3[0]
set_location_assignment PIN_E22 -to segment4[1] ;# HEX3[1]
set_location_assignment PIN_E21 -to segment4[2] ;# HEX3[2]
set_location_assignment PIN_C19 -to segment4[3] ;# HEX3[3]
set_location_assignment PIN_C20 -to segment4[4] ;# HEX3[4]
set_location_assignment PIN_D19 -to segment4[5] ;# HEX3[5]
set_location_assignment PIN_E17 -to segment4[6] ;# HEX3[6]
set_location_assignment PIN_D22 -to segment4[7] ;# HEX3[7]

set_location_assignment PIN_P11 -to clk ;
set_location_assignment PIN_C10 -to start ;
set_location_assignment PIN_C11 -to pause ;
set_location_assignment PIN_D12 -to stop ;
#set_location_assignment PIN_B8 -to btn1 ;

load_package flow
execute_flow -compile

project_close
