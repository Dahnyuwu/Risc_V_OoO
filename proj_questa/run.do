project compileall
vsim -voptargs=+acc work.Datapath_TB
do wave_datapath.do
run 1700ns