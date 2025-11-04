onerror {resume}
quietly virtual function -install /Datapath_TB/UUT/IQI/SR3 -env /Datapath_TB { (concat_noflatten)&{/Datapath_TB/UUT/IQI/SR3/rs2_va_out, /Datapath_TB/UUT/IQI/SR3/rs2_tag_out }} Rs2_TAG
quietly virtual function -install /Datapath_TB/UUT/IQI/SR3 -env /Datapath_TB { (concat_noflatten)&{/Datapath_TB/UUT/IQI/SR3/rs1_va_out, /Datapath_TB/UUT/IQI/SR3/rs1_tag_out }} Rs1_TAG
quietly virtual function -install /Datapath_TB/UUT/DU -env /Datapath_TB/UUT/DU { (concat_noflatten)&{/Datapath_TB/UUT/DU/disp_rs1_tag_va, /Datapath_TB/UUT/DU/disp_rs1_tag }} Disp_Rs1_TAG
quietly virtual function -install /Datapath_TB/UUT/DU -env /Datapath_TB/UUT/DU { (concat_noflatten)&{/Datapath_TB/UUT/DU/disp_rs2_tag_va, /Datapath_TB/UUT/DU/disp_rs2_tag }} Disp_Rs2_TAG
quietly virtual function -install /Datapath_TB/UUT/IQI/SR2 -env /Datapath_TB/UUT/IQI/SR2 { (concat_noflatten)&{/Datapath_TB/UUT/IQI/SR2/rs1_va_out, /Datapath_TB/UUT/IQI/SR2/rs1_tag_out }} Rs1_TAG
quietly virtual function -install /Datapath_TB/UUT/IQI/SR2 -env /Datapath_TB/UUT/IQI/SR2 { &{/Datapath_TB/UUT/IQI/SR2/rs2_va_out, /Datapath_TB/UUT/IQI/SR2/rs2_tag_out }} Rs2_TAG
quietly virtual function -install /Datapath_TB/UUT/IQI/SR2 -env /Datapath_TB/UUT/IQI/SR2 { (concat_noflatten)&{/Datapath_TB/UUT/IQI/SR2/rs2_va_out, /Datapath_TB/UUT/IQI/SR2/rs2_tag_out }} Rs2_TTAG
quietly virtual function -install /Datapath_TB/UUT/IQI/SR1 -env /Datapath_TB/UUT/IQI/SR1 { (concat_noflatten)&{/Datapath_TB/UUT/IQI/SR1/rs1_va_out, /Datapath_TB/UUT/IQI/SR1/rs1_tag_out }} Rs1_TAG
quietly virtual function -install /Datapath_TB/UUT/IQI/SR1 -env /Datapath_TB/UUT/IQI/SR1 { (concat_noflatten)&{/Datapath_TB/UUT/IQI/SR1/rs2_va_out, /Datapath_TB/UUT/IQI/SR1/rs2_tag_out }} Rs2_TAG
quietly virtual function -install /Datapath_TB/UUT/IQI/SR0 -env /Datapath_TB/UUT/IQI/SR0 { (concat_noflatten)&{/Datapath_TB/UUT/IQI/SR0/rs1_va_out, /Datapath_TB/UUT/IQI/SR0/rs1_tag_out }} Rs1_TAG
quietly virtual function -install /Datapath_TB/UUT/IQI/SR0 -env /Datapath_TB/UUT/IQI/SR0 { (concat_noflatten)&{/Datapath_TB/UUT/IQI/SR0/rs2_va_out, /Datapath_TB/UUT/IQI/SR0/rs2_tag_out }} Rs2_TAG
quietly virtual signal -install /Datapath_TB/UUT { (concat_noflatten) (context /Datapath_TB/UUT )&{cdb_va , cdb_tag }} CDB_TAG
quietly virtual function -install /Datapath_TB/UUT/IQM/SR3 -env /Datapath_TB/UUT/IQM/SR3 { (concat_noflatten)&{/Datapath_TB/UUT/IQM/SR3/rs1_va_out, /Datapath_TB/UUT/IQM/SR3/rs1_tag_out }} Rs1_TAG
quietly virtual function -install /Datapath_TB/UUT/IQM/SR3 -env /Datapath_TB/UUT/IQM/SR3 { (concat_noflatten)&{/Datapath_TB/UUT/IQM/SR3/rs2_va_out, /Datapath_TB/UUT/IQM/SR3/rs2_tag_out }} Rs2_TAG
quietly virtual function -install /Datapath_TB/UUT/IQM/SR2 -env /Datapath_TB/UUT/IQM/SR2 { (concat_noflatten)&{/Datapath_TB/UUT/IQM/SR2/rs1_va_out, /Datapath_TB/UUT/IQM/SR2/rs1_tag_out }} Rs1_TAG
quietly virtual function -install /Datapath_TB/UUT/IQM/SR2 -env /Datapath_TB/UUT/IQM/SR2 { (concat_noflatten)&{/Datapath_TB/UUT/IQM/SR2/rs2_va_out, /Datapath_TB/UUT/IQM/SR2/rs2_tag_out }} Rs2_TAG
quietly virtual function -install /Datapath_TB/UUT/IQM/SR1 -env /Datapath_TB/UUT/IQM/SR1 { (concat_noflatten)&{/Datapath_TB/UUT/IQM/SR1/rs1_va_out, /Datapath_TB/UUT/IQM/SR1/rs1_tag_out }} Rs1_TAG
quietly virtual function -install /Datapath_TB/UUT/IQM/SR1 -env /Datapath_TB/UUT/IQM/SR1 { (concat_noflatten)&{/Datapath_TB/UUT/IQM/SR1/rs2_va_out, /Datapath_TB/UUT/IQM/SR1/rs2_tag_out }} Rs2_TAG
quietly virtual function -install /Datapath_TB/UUT/IQM/SR0 -env /Datapath_TB/UUT/IQM/SR0 { &{/Datapath_TB/UUT/IQM/SR0/rs2_va_out, /Datapath_TB/UUT/IQM/SR0/rs2_tag_out }} Rs2_TAG
quietly virtual function -install /Datapath_TB/UUT/IQM/SR0 -env /Datapath_TB/UUT/IQM/SR0 { (concat_noflatten)&{/Datapath_TB/UUT/IQM/SR0/rs2_va_out, /Datapath_TB/UUT/IQM/SR0/rs2_tag_out }} Rs2_TAG001
quietly virtual function -install /Datapath_TB/UUT/IQM/SR0 -env /Datapath_TB/UUT/IQM/SR0 { (concat_noflatten)&{/Datapath_TB/UUT/IQM/SR0/rs1_va_out, /Datapath_TB/UUT/IQM/SR0/rs1_tag_out }} Rs1_TAG
quietly virtual function -install /Datapath_TB/UUT/DU -env /Datapath_TB { &{/Datapath_TB/UUT/DU/disp_valid_int, /Datapath_TB/UUT/DU/disp_valid_mul, /Datapath_TB/UUT/DU/disp_valid_div, /Datapath_TB/UUT/DU/disp_valid_lw_sw }} Selector
quietly virtual function -install /Datapath_TB/UUT/DU -env /Datapath_TB/UUT/DU { (concat_noflatten)&{/Datapath_TB/UUT/DU/disp_valid_int, /Datapath_TB/UUT/DU/disp_valid_mul, /Datapath_TB/UUT/DU/disp_valid_div, /Datapath_TB/UUT/DU/disp_valid_lw_sw }} valid
quietly virtual function -install /Datapath_TB/UUT/IQD/SR3 -env /Datapath_TB/UUT/IQD/SR3 { (concat_noflatten)&{/Datapath_TB/UUT/IQD/SR3/rs1_va_out, /Datapath_TB/UUT/IQD/SR3/rs1_tag_out }} Rs1_TAG
quietly virtual function -install /Datapath_TB/UUT/IQD/SR3 -env /Datapath_TB/UUT/IQD/SR3 { (concat_noflatten)&{/Datapath_TB/UUT/IQD/SR3/rs2_va_out, /Datapath_TB/UUT/IQD/SR3/rs2_tag_out }} Rs2_TAG
quietly virtual function -install /Datapath_TB/UUT/IQD/SR2 -env /Datapath_TB/UUT/IQD/SR2 { &{/Datapath_TB/UUT/IQD/SR2/rs1_va_out, /Datapath_TB/UUT/IQD/SR2/rs1_tag_out }} Rs1_TAG
quietly virtual function -install /Datapath_TB/UUT/IQD/SR2 -env /Datapath_TB/UUT/IQD/SR2 { (concat_noflatten)&{/Datapath_TB/UUT/IQD/SR2/rs1_va_out, /Datapath_TB/UUT/IQD/SR2/rs1_tag_out }} Rs1_TAG001
quietly virtual function -install /Datapath_TB/UUT/IQD/SR2 -env /Datapath_TB/UUT/IQD/SR2 { (concat_noflatten)&{/Datapath_TB/UUT/IQD/SR2/rs2_va_out, /Datapath_TB/UUT/IQD/SR2/rs2_tag_out }} Rs2_TAG
quietly virtual function -install /Datapath_TB/UUT/IQD/SR1 -env /Datapath_TB/UUT/IQD/SR1 { (concat_noflatten)&{/Datapath_TB/UUT/IQD/SR1/rs1_va_out, /Datapath_TB/UUT/IQD/SR1/rs1_tag_out }} Rs1_TAG
quietly virtual function -install /Datapath_TB/UUT/IQD/SR1 -env /Datapath_TB/UUT/IQD/SR1 { &{/Datapath_TB/UUT/IQD/SR1/rs2_va_out, /Datapath_TB/UUT/IQD/SR1/rs2_tag_out }} Rs2_TAG
quietly virtual function -install /Datapath_TB/UUT/IQD/SR1 -env /Datapath_TB/UUT/IQD/SR1 { (concat_noflatten)&{/Datapath_TB/UUT/IQD/SR1/rs2_va_out, /Datapath_TB/UUT/IQD/SR1/rs2_tag_out }} Rs2_TAG001
quietly virtual function -install /Datapath_TB/UUT/IQD/SR0 -env /Datapath_TB/UUT/IQD/SR0 { (concat_noflatten)&{/Datapath_TB/UUT/IQD/SR0/rs1_va_out, /Datapath_TB/UUT/IQD/SR0/rs1_tag_out }} Rs1_TAG
quietly virtual function -install /Datapath_TB/UUT/IQD/SR0 -env /Datapath_TB/UUT/IQD/SR0 { (concat_noflatten)&{/Datapath_TB/UUT/IQD/SR0/rs2_va_out, /Datapath_TB/UUT/IQD/SR0/rs2_tag_out }} Rs2_TAG
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Control_Signals /Datapath_TB/clk
add wave -noupdate -expand -group Control_Signals /Datapath_TB/rst
add wave -noupdate -expand -group PC_Instruct /Datapath_TB/UUT/IFQu/ifq_pc_out
add wave -noupdate -expand -group PC_Instruct /Datapath_TB/UUT/IFQu/ifq_inst
add wave -noupdate -group Dispatcher -color White /Datapath_TB/UUT/DU/Disp_Rs1_TAG
add wave -noupdate -group Dispatcher -color White /Datapath_TB/UUT/DU/disp_rs1_data
add wave -noupdate -group Dispatcher -color White /Datapath_TB/UUT/DU/Disp_Rs2_TAG
add wave -noupdate -group Dispatcher -color White /Datapath_TB/UUT/DU/disp_rs2_data
add wave -noupdate -group Dispatcher -color Gray75 /Datapath_TB/UUT/DU/disp_rd_tag
add wave -noupdate -expand -group CDB -color Khaki /Datapath_TB/UUT/cdb_b_taken
add wave -noupdate -expand -group CDB -color Khaki /Datapath_TB/UUT/cdb_b
add wave -noupdate -expand -group CDB -color Khaki /Datapath_TB/UUT/CDB_TAG
add wave -noupdate -expand -group CDB -color Khaki /Datapath_TB/UUT/cdb_data
add wave -noupdate -divider Integer
add wave -noupdate -group SR3 -color Coral /Datapath_TB/UUT/IQI/SR3/Rs1_TAG
add wave -noupdate -group SR3 -color Coral /Datapath_TB/UUT/IQI/SR3/rs1_data_out
add wave -noupdate -group SR3 -color Coral /Datapath_TB/UUT/IQI/SR3/Rs2_TAG
add wave -noupdate -group SR3 -color Coral /Datapath_TB/UUT/IQI/SR3/rs2_data_out
add wave -noupdate -group SR3 -color Gray75 /Datapath_TB/UUT/IQI/SR3/rd_tag_out
add wave -noupdate -group SR3 /Datapath_TB/UUT/IQI/SR3/valid_out
add wave -noupdate -group SR2 -color Goldenrod /Datapath_TB/UUT/IQI/SR2/Rs1_TAG
add wave -noupdate -group SR2 -color Goldenrod /Datapath_TB/UUT/IQI/SR2/rs1_data_out
add wave -noupdate -group SR2 -color Goldenrod /Datapath_TB/UUT/IQI/SR2/Rs2_TTAG
add wave -noupdate -group SR2 -color Goldenrod /Datapath_TB/UUT/IQI/SR2/rs2_data_out
add wave -noupdate -group SR2 -color Gray75 /Datapath_TB/UUT/IQI/SR2/rd_tag_out
add wave -noupdate -group SR2 /Datapath_TB/UUT/IQI/SR2/valid_out
add wave -noupdate -group SR1 -color {Sky Blue} /Datapath_TB/UUT/IQI/SR1/Rs1_TAG
add wave -noupdate -group SR1 -color {Sky Blue} /Datapath_TB/UUT/IQI/SR1/rs1_data_out
add wave -noupdate -group SR1 -color {Sky Blue} /Datapath_TB/UUT/IQI/SR1/Rs2_TAG
add wave -noupdate -group SR1 -color {Sky Blue} /Datapath_TB/UUT/IQI/SR1/rs2_data_out
add wave -noupdate -group SR1 -color Gray75 /Datapath_TB/UUT/IQI/SR1/rd_tag_out
add wave -noupdate -group SR1 /Datapath_TB/UUT/IQI/SR1/valid_out
add wave -noupdate -group SR0 -color Violet /Datapath_TB/UUT/IQI/SR0/Rs1_TAG
add wave -noupdate -group SR0 -color Violet /Datapath_TB/UUT/IQI/SR0/rs1_data_out
add wave -noupdate -group SR0 -color Violet /Datapath_TB/UUT/IQI/SR0/Rs2_TAG
add wave -noupdate -group SR0 -color Violet /Datapath_TB/UUT/IQI/SR0/rs2_data_out
add wave -noupdate -group SR0 -color Gray75 /Datapath_TB/UUT/IQI/SR0/rd_tag_out
add wave -noupdate -group SR0 /Datapath_TB/UUT/IQI/SR0/valid_out
add wave -noupdate -divider Multip
add wave -noupdate -group SR3_M /Datapath_TB/UUT/IQM/SR3/Rs1_TAG
add wave -noupdate -group SR3_M /Datapath_TB/UUT/IQM/SR3/rs1_data_out
add wave -noupdate -group SR3_M /Datapath_TB/UUT/IQM/SR3/Rs2_TAG
add wave -noupdate -group SR3_M /Datapath_TB/UUT/IQM/SR3/rs2_data_out
add wave -noupdate -group SR3_M /Datapath_TB/UUT/IQM/SR3/rd_tag_out
add wave -noupdate -group SR3_M /Datapath_TB/UUT/IQM/SR3/valid_out
add wave -noupdate -group SR2_M /Datapath_TB/UUT/IQM/SR2/Rs1_TAG
add wave -noupdate -group SR2_M /Datapath_TB/UUT/IQM/SR2/rs1_data_out
add wave -noupdate -group SR2_M /Datapath_TB/UUT/IQM/SR2/Rs2_TAG
add wave -noupdate -group SR2_M /Datapath_TB/UUT/IQM/SR2/rs2_data_out
add wave -noupdate -group SR2_M /Datapath_TB/UUT/IQM/SR2/rd_tag_out
add wave -noupdate -group SR2_M /Datapath_TB/UUT/IQM/SR2/valid_out
add wave -noupdate -group SR1_M /Datapath_TB/UUT/IQM/SR1/Rs1_TAG
add wave -noupdate -group SR1_M /Datapath_TB/UUT/IQM/SR1/rs1_data_out
add wave -noupdate -group SR1_M /Datapath_TB/UUT/IQM/SR1/Rs2_TAG
add wave -noupdate -group SR1_M /Datapath_TB/UUT/IQM/SR1/rs2_data_out
add wave -noupdate -group SR1_M /Datapath_TB/UUT/IQM/SR1/rd_tag_out
add wave -noupdate -group SR1_M /Datapath_TB/UUT/IQM/SR1/valid_out
add wave -noupdate -group SR0_M /Datapath_TB/UUT/IQM/SR0/Rs1_TAG
add wave -noupdate -group SR0_M /Datapath_TB/UUT/IQM/SR0/rs1_data_out
add wave -noupdate -group SR0_M /Datapath_TB/UUT/IQM/SR0/Rs2_TAG001
add wave -noupdate -group SR0_M /Datapath_TB/UUT/IQM/SR0/rs2_data_out
add wave -noupdate -group SR0_M /Datapath_TB/UUT/IQM/SR0/rd_tag_out
add wave -noupdate -group SR0_M /Datapath_TB/UUT/IQM/SR0/valid_out
add wave -noupdate -divider Divis
add wave -noupdate -group SR3_D /Datapath_TB/UUT/IQD/SR3/Rs1_TAG
add wave -noupdate -group SR3_D /Datapath_TB/UUT/IQD/SR3/rs1_data_out
add wave -noupdate -group SR3_D /Datapath_TB/UUT/IQD/SR3/Rs2_TAG
add wave -noupdate -group SR3_D /Datapath_TB/UUT/IQD/SR3/rs2_data_out
add wave -noupdate -group SR3_D /Datapath_TB/UUT/IQD/SR3/rd_tag_out
add wave -noupdate -group SR3_D /Datapath_TB/UUT/IQD/SR3/valid_out
add wave -noupdate -group SR2_D /Datapath_TB/UUT/IQD/SR2/Rs1_TAG001
add wave -noupdate -group SR2_D /Datapath_TB/UUT/IQD/SR2/rs1_data_out
add wave -noupdate -group SR2_D /Datapath_TB/UUT/IQD/SR2/Rs2_TAG
add wave -noupdate -group SR2_D /Datapath_TB/UUT/IQD/SR2/rs2_data_out
add wave -noupdate -group SR2_D /Datapath_TB/UUT/IQD/SR2/rd_tag_out
add wave -noupdate -group SR2_D /Datapath_TB/UUT/IQD/SR2/valid_out
add wave -noupdate -group SR1_D /Datapath_TB/UUT/IQD/SR1/Rs1_TAG
add wave -noupdate -group SR1_D /Datapath_TB/UUT/IQD/SR1/rs1_data_out
add wave -noupdate -group SR1_D /Datapath_TB/UUT/IQD/SR1/Rs2_TAG001
add wave -noupdate -group SR1_D /Datapath_TB/UUT/IQD/SR1/rs2_data_out
add wave -noupdate -group SR1_D /Datapath_TB/UUT/IQD/SR1/rd_tag_out
add wave -noupdate -group SR1_D /Datapath_TB/UUT/IQD/SR1/valid_out
add wave -noupdate -group SR0_D /Datapath_TB/UUT/IQD/SR0/Rs1_TAG
add wave -noupdate -group SR0_D /Datapath_TB/UUT/IQD/SR0/rs1_data_out
add wave -noupdate -group SR0_D /Datapath_TB/UUT/IQD/SR0/Rs2_TAG
add wave -noupdate -group SR0_D /Datapath_TB/UUT/IQD/SR0/rs2_data_out
add wave -noupdate -group SR0_D /Datapath_TB/UUT/IQD/SR0/rd_tag_out
add wave -noupdate -group SR0_D /Datapath_TB/UUT/IQD/SR0/valid_out
add wave -noupdate -group {Register File} -expand /Datapath_TB/UUT/DU/RF/registerOut
add wave -noupdate -group RST_Token -childformat {{{/Datapath_TB/UUT/DU/RST_I/token[1]} -radix hexadecimal}} -expand -subitemconfig {{/Datapath_TB/UUT/DU/RST_I/token[1]} {-height 15 -radix hexadecimal}} /Datapath_TB/UUT/DU/RST_I/token
add wave -noupdate -group TAG_Table -expand /Datapath_TB/UUT/DU/TF/tag_table
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {440 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 362
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {483 ns}
