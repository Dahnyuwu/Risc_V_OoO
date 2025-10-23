onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Datapath_TB/UUT/clk
add wave -noupdate /Datapath_TB/UUT/rst
add wave -noupdate /Datapath_TB/UUT/IFQu/PC_in
add wave -noupdate /Datapath_TB/UUT/IFQu/PC_out
add wave -noupdate /Datapath_TB/UUT/IFQu/inst
add wave -noupdate /Datapath_TB/UUT/DU/RST_I/token
add wave -noupdate -group TAG /Datapath_TB/UUT/DU/TF/cdb_tag_va
add wave -noupdate -group TAG /Datapath_TB/UUT/DU/TF/cdb_tag
add wave -noupdate -group TAG /Datapath_TB/UUT/DU/TF/rd
add wave -noupdate -group TAG /Datapath_TB/UUT/DU/TF/full
add wave -noupdate -group TAG /Datapath_TB/UUT/DU/TF/empty
add wave -noupdate -group TAG /Datapath_TB/UUT/DU/TF/rd_va
add wave -noupdate -group TAG /Datapath_TB/UUT/DU/TF/tag_out
add wave -noupdate -group TAG /Datapath_TB/UUT/DU/TF/write_p
add wave -noupdate -group TAG /Datapath_TB/UUT/DU/TF/read_p
add wave -noupdate -group TAG /Datapath_TB/UUT/DU/TF/WEROut
add wave -noupdate -expand -group RST /Datapath_TB/UUT/DU/RST_I/rs1_add
add wave -noupdate -expand -group RST /Datapath_TB/UUT/DU/RST_I/rs2_add
add wave -noupdate -expand -group RST /Datapath_TB/UUT/DU/RST_I/rd_add
add wave -noupdate -expand -group RST /Datapath_TB/UUT/DU/RST_I/w_data_ena1
add wave -noupdate -expand -group RST /Datapath_TB/UUT/DU/RST_I/w_data_ena2
add wave -noupdate -expand -group RST /Datapath_TB/UUT/DU/RST_I/clk
add wave -noupdate -expand -group RST /Datapath_TB/UUT/DU/RST_I/rst
add wave -noupdate -expand -group RST /Datapath_TB/UUT/DU/RST_I/w_data1
add wave -noupdate -expand -group RST /Datapath_TB/UUT/DU/RST_I/w_data2
add wave -noupdate -expand -group RST /Datapath_TB/UUT/DU/RST_I/rs1_tag
add wave -noupdate -expand -group RST /Datapath_TB/UUT/DU/RST_I/rs2_tag
add wave -noupdate -expand -group RST /Datapath_TB/UUT/DU/RST_I/rs1_tag_va
add wave -noupdate -expand -group RST /Datapath_TB/UUT/DU/RST_I/rs2_tag_va
add wave -noupdate -expand -group RST /Datapath_TB/UUT/DU/RST_I/rw_rf
add wave -noupdate -expand -group RST /Datapath_TB/UUT/DU/RST_I/token
add wave -noupdate -expand -group RST -radix binary /Datapath_TB/UUT/DU/RST_I/wer_en1
add wave -noupdate -expand -group RST /Datapath_TB/UUT/DU/RST_I/wer_en2
add wave -noupdate -expand -group Dispatch /Datapath_TB/UUT/DU/Di/rd_tag
add wave -noupdate -expand -group Dispatch /Datapath_TB/UUT/DU/Di/rs1_tag
add wave -noupdate -expand -group Dispatch /Datapath_TB/UUT/DU/Di/rs2_tag
add wave -noupdate -expand -group Dispatch /Datapath_TB/UUT/DU/Di/rs1_tag_va
add wave -noupdate -expand -group Dispatch /Datapath_TB/UUT/DU/Di/rs2_tag_va
add wave -noupdate -expand -group Dispatch /Datapath_TB/UUT/DU/Di/rs1_data
add wave -noupdate -expand -group Dispatch /Datapath_TB/UUT/DU/Di/rs2_data
add wave -noupdate -expand -group Dispatch /Datapath_TB/UUT/DU/Di/opcode
add wave -noupdate -expand -group Dispatch /Datapath_TB/UUT/DU/Di/dispatch_out
add wave -noupdate -expand -group EQ -radix binary /Datapath_TB/UUT/DU/EQ/disp
add wave -noupdate -expand -group EQ -radix binary /Datapath_TB/UUT/DU/EQ/cdb_tag
add wave -noupdate -expand -group EQ /Datapath_TB/UUT/DU/EQ/cdb_data
add wave -noupdate -expand -group EQ /Datapath_TB/UUT/DU/EQ/rd_va
add wave -noupdate -expand -group EQ /Datapath_TB/UUT/DU/EQ/cdb_va_in
add wave -noupdate -expand -group EQ /Datapath_TB/UUT/DU/EQ/rs1_data
add wave -noupdate -expand -group EQ /Datapath_TB/UUT/DU/EQ/rs2_data
add wave -noupdate -expand -group EQ /Datapath_TB/UUT/DU/EQ/opcode
add wave -noupdate -expand -group EQ /Datapath_TB/UUT/DU/EQ/rd_tag
add wave -noupdate -expand -group EQ /Datapath_TB/UUT/DU/EQ/cdb_va_out
add wave -noupdate -expand -group EQ -radix hexadecimal -childformat {{{/Datapath_TB/UUT/DU/EQ/registerOut[3]} -radix hexadecimal} {{/Datapath_TB/UUT/DU/EQ/registerOut[2]} -radix hexadecimal} {{/Datapath_TB/UUT/DU/EQ/registerOut[1]} -radix hexadecimal} {{/Datapath_TB/UUT/DU/EQ/registerOut[0]} -radix hexadecimal}} -subitemconfig {{/Datapath_TB/UUT/DU/EQ/registerOut[3]} {-height 15 -radix hexadecimal} {/Datapath_TB/UUT/DU/EQ/registerOut[2]} {-height 15 -radix hexadecimal} {/Datapath_TB/UUT/DU/EQ/registerOut[1]} {-height 15 -radix hexadecimal} {/Datapath_TB/UUT/DU/EQ/registerOut[0]} {-height 15 -radix hexadecimal}} /Datapath_TB/UUT/DU/EQ/registerOut
add wave -noupdate -expand -group EQ /Datapath_TB/UUT/DU/EQ/in_2_0
add wave -noupdate -expand -group EQ /Datapath_TB/UUT/DU/EQ/in_2_1
add wave -noupdate -expand -group EQ /Datapath_TB/UUT/DU/EQ/w_ena_1
add wave -noupdate -expand -group EQ /Datapath_TB/UUT/DU/EQ/w_ena_2_0
add wave -noupdate -expand -group EQ /Datapath_TB/UUT/DU/EQ/w_ena_2_1
add wave -noupdate -expand -group CDB /Datapath_TB/UUT/DU/CDB_U/rs1_data
add wave -noupdate -expand -group CDB /Datapath_TB/UUT/DU/CDB_U/rs2_data
add wave -noupdate -expand -group CDB /Datapath_TB/UUT/DU/CDB_U/opcode
add wave -noupdate -expand -group CDB /Datapath_TB/UUT/DU/CDB_U/cdb_tag_in
add wave -noupdate -expand -group CDB /Datapath_TB/UUT/DU/CDB_U/cdb_va_in
add wave -noupdate -expand -group CDB /Datapath_TB/UUT/DU/CDB_U/cdb_data
add wave -noupdate -expand -group CDB /Datapath_TB/UUT/DU/CDB_U/cdb_tag_out
add wave -noupdate -expand -group CDB /Datapath_TB/UUT/DU/CDB_U/cdb_va_out
add wave -noupdate /Datapath_TB/UUT/DU/rs1_data_m_
add wave -noupdate /Datapath_TB/UUT/DU/rs2_data_m_
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {48 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 316
configure wave -valuecolwidth 197
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
WaveRestoreZoom {0 ns} {104 ns}
