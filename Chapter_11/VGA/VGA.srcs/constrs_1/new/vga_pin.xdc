#op0:
set_property -dict {PACKAGE_PIN AC21 IOSTANDARD LVCMOS33} [get_ports {op0[1]}]
set_property -dict {PACKAGE_PIN AD24 IOSTANDARD LVCMOS33} [get_ports {op0[0]}]

#op1:
set_property -dict {PACKAGE_PIN AA7 IOSTANDARD LVCMOS33} [get_ports {op1[1]}]
set_property -dict {PACKAGE_PIN Y6 IOSTANDARD LVCMOS33} [get_ports {op1[0]}]

#dp:
set_property -dict {PACKAGE_PIN C4 IOSTANDARD LVCMOS33} [get_ports {dp}]

#Led_select:
set_property -dict {PACKAGE_PIN D3 IOSTANDARD LVCMOS33} [get_ports {Led_select[1]}]
set_property -dict {PACKAGE_PIN D25 IOSTANDARD LVCMOS33} [get_ports {Led_select[0]}]

#sseg:
set_property -dict {PACKAGE_PIN A2 IOSTANDARD LVCMOS33} [get_ports {sseg[6]}]
set_property -dict {PACKAGE_PIN D4 IOSTANDARD LVCMOS33} [get_ports {sseg[5]}]
set_property -dict {PACKAGE_PIN E5 IOSTANDARD LVCMOS33} [get_ports {sseg[4]}]
set_property -dict {PACKAGE_PIN B4 IOSTANDARD LVCMOS33} [get_ports {sseg[3]}]
set_property -dict {PACKAGE_PIN B2 IOSTANDARD LVCMOS33} [get_ports {sseg[2]}]
set_property -dict {PACKAGE_PIN E6 IOSTANDARD LVCMOS33} [get_ports {sseg[1]}]
set_property -dict {PACKAGE_PIN C3 IOSTANDARD LVCMOS33} [get_ports {sseg[0]}]

set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]
