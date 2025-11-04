onerror {resume}
quietly virtual function -install /Issue_Queue_TB -env /Issue_Queue_TB { (concat_noflatten)&{/Issue_Queue_TB/disp_rs1_tag_va, /Issue_Queue_TB/disp_rs1_tag }} Disp_rs1_TAG
quietly virtual function -install /Issue_Queue_TB -env /Issue_Queue_TB { (concat_noflatten)&{/Issue_Queue_TB/disp_rs2_tag_va, /Issue_Queue_TB/disp_rs2_tag }} Disp_rs2_TAG
quietly virtual function -install /Issue_Queue_TB -env /Issue_Queue_TB { (concat_noflatten)&{/Issue_Queue_TB/cdb_va, /Issue_Queue_TB/cdb_tag }} CDB_TAG
quietly virtual function -install /Issue_Queue_TB/UUT/SR3 -env /Issue_Queue_TB/UUT/SR3 { (concat_noflatten)&{/Issue_Queue_TB/UUT/SR3/rs1_va_out, /Issue_Queue_TB/UUT/SR3/rs1_tag_out }} SR3_Rs1_TAG
quietly virtual function -install /Issue_Queue_TB/UUT/SR3 -env /Issue_Queue_TB/UUT/SR3 { (concat_noflatten)&{/Issue_Queue_TB/UUT/SR3/rs2_va_out, /Issue_Queue_TB/UUT/SR3/rs2_tag_out }} SR3_Rs2_TAG
quietly virtual function -install /Issue_Queue_TB -env /Issue_Queue_TB { (concat_noflatten)&{/Issue_Queue_TB/disp_valid_int, /Issue_Queue_TB/cdb_va }} Shift_Update
quietly virtual function -install /Issue_Queue_TB/UUT/SR2 -env /Issue_Queue_TB/UUT/SR2 { (concat_noflatten)&{/Issue_Queue_TB/UUT/SR2/rs1_va_out, /Issue_Queue_TB/UUT/SR2/rs1_tag_out }} Rs2_TAG
quietly virtual function -install /Issue_Queue_TB/UUT/SR2 -env /Issue_Queue_TB/UUT/SR2 { (concat_noflatten)&{/Issue_Queue_TB/UUT/SR2/rs2_va_out, /Issue_Queue_TB/UUT/SR2/rs2_tag_out }} Rs2_TAG001
quietly virtual function -install /Issue_Queue_TB/UUT/SR2 -env /Issue_Queue_TB/UUT/SR2 { (concat_noflatten)&{/Issue_Queue_TB/UUT/SR2/rs1_va_out, /Issue_Queue_TB/UUT/SR2/rs1_tag_out }} Rs1_TAG
quietly virtual function -install /Issue_Queue_TB/UUT/SR2 -env /Issue_Queue_TB/UUT/SR2 { (concat_noflatten)&{/Issue_Queue_TB/UUT/SR2/rs2_va_out, /Issue_Queue_TB/UUT/SR2/rs2_tag_out }} Rs2_TAG002
quietly virtual function -install /Issue_Queue_TB/UUT/SR1 -env /Issue_Queue_TB/UUT/SR1 { (concat_noflatten)&{/Issue_Queue_TB/UUT/SR1/rs2_va_out, /Issue_Queue_TB/UUT/SR1/rs2_tag_out }} Rs2_TAG
quietly virtual function -install /Issue_Queue_TB/UUT/SR1 -env /Issue_Queue_TB/UUT/SR1 { (concat_noflatten)&{/Issue_Queue_TB/UUT/SR1/rs1_va_out, /Issue_Queue_TB/UUT/SR1/rs1_tag_out }} Rs1_TAG
quietly virtual function -install /Issue_Queue_TB/UUT/SR0 -env /Issue_Queue_TB/UUT/SR0 { (concat_noflatten)&{/Issue_Queue_TB/UUT/SR0/rs2_va_out, /Issue_Queue_TB/UUT/SR0/rs2_tag_out }} Rs2_TAG
quietly virtual function -install /Issue_Queue_TB/UUT/SR0 -env /Issue_Queue_TB/UUT/SR0 { (concat_noflatten)&{/Issue_Queue_TB/UUT/SR0/rs1_va_out, /Issue_Queue_TB/UUT/SR0/rs1_tag_out }} Rs1_TAG
quietly WaveActivateNextPane {} 0
add wave -noupdate /Issue_Queue_TB/UUT/clk
add wave -noupdate /Issue_Queue_TB/UUT/rst
add wave -noupdate /Issue_Queue_TB/Shift_Update
add wave -noupdate -expand -group RS_Disp -color Gray60 /Issue_Queue_TB/Disp_rs1_TAG
add wave -noupdate -expand -group RS_Disp -color Gray60 /Issue_Queue_TB/disp_rs1_data
add wave -noupdate -expand -group RS_Disp -color Gray60 /Issue_Queue_TB/Disp_rs2_TAG
add wave -noupdate -expand -group RS_Disp -color Gray60 /Issue_Queue_TB/disp_rs2_data
add wave -noupdate -expand -group CDB -color Gold /Issue_Queue_TB/CDB_TAG
add wave -noupdate -expand -group CDB -color Gold /Issue_Queue_TB/cdb_data
add wave -noupdate -expand -group SR3_TAGs -color Coral /Issue_Queue_TB/UUT/SR3/SR3_Rs1_TAG
add wave -noupdate -expand -group SR3_TAGs -color Coral /Issue_Queue_TB/UUT/SR3/rs1_data_out
add wave -noupdate -expand -group SR3_TAGs -color Coral /Issue_Queue_TB/UUT/SR3/SR3_Rs2_TAG
add wave -noupdate -expand -group SR3_TAGs -color Coral /Issue_Queue_TB/UUT/SR3/rs2_data_out
add wave -noupdate -expand -group SR3_TAGs /Issue_Queue_TB/UUT/SR3/valid_out
add wave -noupdate -expand -group SR2_TAGs -color Violet /Issue_Queue_TB/UUT/SR2/Rs1_TAG
add wave -noupdate -expand -group SR2_TAGs -color Violet /Issue_Queue_TB/UUT/SR2/rs1_data_out
add wave -noupdate -expand -group SR2_TAGs -color Violet /Issue_Queue_TB/UUT/SR2/Rs2_TAG002
add wave -noupdate -expand -group SR2_TAGs -color Violet /Issue_Queue_TB/UUT/SR2/rs2_data_out
add wave -noupdate -expand -group SR2_TAGs /Issue_Queue_TB/UUT/SR2/valid_out
add wave -noupdate -expand -group SR1_TAGs -color {Cornflower Blue} /Issue_Queue_TB/UUT/SR1/Rs1_TAG
add wave -noupdate -expand -group SR1_TAGs -color {Cornflower Blue} /Issue_Queue_TB/UUT/SR1/rs1_data_out
add wave -noupdate -expand -group SR1_TAGs -color {Cornflower Blue} /Issue_Queue_TB/UUT/SR1/Rs2_TAG
add wave -noupdate -expand -group SR1_TAGs -color {Cornflower Blue} /Issue_Queue_TB/UUT/SR1/rs2_data_out
add wave -noupdate -expand -group SR1_TAGs /Issue_Queue_TB/UUT/SR1/valid_out
add wave -noupdate -expand -group SR0_TAGs -color {Medium Sea Green} /Issue_Queue_TB/UUT/SR0/Rs1_TAG
add wave -noupdate -expand -group SR0_TAGs -color {Medium Sea Green} /Issue_Queue_TB/UUT/SR0/rs1_data_out
add wave -noupdate -expand -group SR0_TAGs -color {Medium Sea Green} /Issue_Queue_TB/UUT/SR0/Rs2_TAG
add wave -noupdate -expand -group SR0_TAGs -color {Medium Sea Green} /Issue_Queue_TB/UUT/SR0/rs2_data_out
add wave -noupdate -expand -group SR0_TAGs /Issue_Queue_TB/UUT/SR0/valid_out
add wave -noupdate -expand -group Output /Issue_Queue_TB/UUT/issue_a
add wave -noupdate -expand -group Output /Issue_Queue_TB/UUT/issue_b
add wave -noupdate -expand -group Output /Issue_Queue_TB/UUT/issue_rd_tag
add wave -noupdate -expand -group Output /Issue_Queue_TB/UUT/issue_opcode
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1787 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 343
configure wave -valuecolwidth 111
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
WaveRestoreZoom {5120 ns} {5204 ns}
