transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/ca_lab/midterm-project {C:/Users/User/Desktop/ca_lab/midterm-project/shift_register.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/ca_lab/midterm-project {C:/Users/User/Desktop/ca_lab/midterm-project/tb_shift_register.v}

