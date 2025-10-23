onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Datapath_TB/UUT/clk
add wave -noupdate /Datapath_TB/UUT/rst
add wave -noupdate /Datapath_TB/UUT/IFQu/PC_in
add wave -noupdate /Datapath_TB/UUT/IFQu/inst
add wave -noupdate -group Dispatch /Datapath_TB/UUT/DU/opcode
add wave -noupdate -group Dispatch /Datapath_TB/UUT/DU/rd_tag
add wave -noupdate -group Dispatch /Datapath_TB/UUT/DU/rs1_tag_va
add wave -noupdate -group Dispatch /Datapath_TB/UUT/DU/rs1_tag
add wave -noupdate -group Dispatch /Datapath_TB/UUT/DU/rs1_data
add wave -noupdate -group Dispatch /Datapath_TB/UUT/DU/rs2_tag_va
add wave -noupdate -group Dispatch /Datapath_TB/UUT/DU/rs2_tag
add wave -noupdate -group Dispatch /Datapath_TB/UUT/DU/rs2_data
add wave -noupdate -expand -group {Token 3..0} {/Datapath_TB/UUT/DU/RST_I/token[3]}
add wave -noupdate -expand -group {Token 3..0} {/Datapath_TB/UUT/DU/RST_I/token[2]}
add wave -noupdate -expand -group {Token 3..0} {/Datapath_TB/UUT/DU/RST_I/token[1]}
add wave -noupdate -expand -group {Token 3..0} {/Datapath_TB/UUT/DU/RST_I/token[0]}
add wave -noupdate -expand -group {TAG FIFO 3..0} {/Datapath_TB/UUT/DU/TF/tag_table[3]}
add wave -noupdate -expand -group {TAG FIFO 3..0} {/Datapath_TB/UUT/DU/TF/tag_table[2]}
add wave -noupdate -expand -group {TAG FIFO 3..0} {/Datapath_TB/UUT/DU/TF/tag_table[1]}
add wave -noupdate -expand -group {TAG FIFO 3..0} {/Datapath_TB/UUT/DU/TF/tag_table[0]}
add wave -noupdate -expand -group {RF 3..0} {/Datapath_TB/UUT/DU/RF/registerOut[3]}
add wave -noupdate -expand -group {RF 3..0} {/Datapath_TB/UUT/DU/RF/registerOut[2]}
add wave -noupdate -expand -group {RF 3..0} {/Datapath_TB/UUT/DU/RF/registerOut[1]}
add wave -noupdate -expand -group {RF 3..0} {/Datapath_TB/UUT/DU/RF/registerOut[0]}
add wave -noupdate -expand -group CDB /Datapath_TB/UUT/DU/cdb_data
add wave -noupdate -expand -group CDB /Datapath_TB/UUT/DU/cdb_tag
add wave -noupdate -expand -group CDB /Datapath_TB/UUT/DU/cdb_va
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 259
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
WaveRestoreZoom {0 ns} {170 ns}
