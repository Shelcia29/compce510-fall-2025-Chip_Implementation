## 
## 

#Compilation step


read_hdl -sv -library work [list \
./rtl/multiplier.sv \
./rtl/matmul_sync.sv \
./rtl/ram_wrapper.sv \
./rtl/tico_gpdk045.sv \
./rtl/datapath_top.sv \
]
