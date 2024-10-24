
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2"
Implementation2default:default2
xc7a35t2default:defaultZ17-347h px
�
0Got license for feature '%s' and/or device '%s'
310*common2"
Implementation2default:default2
xc7a35t2default:defaultZ17-349h px
�
�The version limit for your license is '%s' and will expire in %s days. A version limit expiration means that, although you may be able to continue to use the current version of tools or IP with this license, you will not be eligible for any updates or new releases.
519*common2
8888.122default:default2
-173222default:defaultZ17-1223h px
u
,Running DRC as a precondition to command %s
1349*	planAhead2#
write_bitstream2default:defaultZ12-1349h px
M
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px
�
Rule violation (%s) %s - %s
20*drc2
CFGBVS-12default:default2G
3Missing CFGBVS and CONFIG_VOLTAGE Design Properties2default:default2�
�Neither the CFGBVS nor CONFIG_VOLTAGE voltage property is set in the current_design.  Configuration bank voltage select (CFGBVS) must be set to VCCO or GND, and CONFIG_VOLTAGE must be set to the correct configuration voltage, in order to determine the I/O voltage support for the pins in bank 0.  It is suggested to specify these either using the 'Edit Device Properties' function in the GUI or directly in the XDC file using the following syntax:

 set_property CFGBVS value1 [current_design]
 #where value1 is either VCCO or GND

 set_property CONFIG_VOLTAGE value2 [current_design]
 #where value2 is the voltage provided to configuration bank 0

Refer to the device configuration user guide for more information.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPIP-12default:default2$
Input pipelining2default:default2�
vDSP design_1_i/PWM_gen_0/inst/count_duty0 input A B is not pipelined. Pipelining DSP48 input will improve performance.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPIP-12default:default2$
Input pipelining2default:default2�
vDSP design_1_i/PWM_gen_1/inst/count_duty0 input A B is not pipelined. Pipelining DSP48 input will improve performance.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPIP-12default:default2$
Input pipelining2default:default2�
}DSP design_1_i/rgb2hsv_top_0/inst/h_dividend_reg input A B is not pipelined. Pipelining DSP48 input will improve performance.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPIP-12default:default2$
Input pipelining2default:default2�
}DSP design_1_i/rgb2hsv_top_0/inst/s_dividend_reg input A B is not pipelined. Pipelining DSP48 input will improve performance.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPIP-12default:default2$
Input pipelining2default:default2�
�DSP design_1_i/servo_ctrl_0/inst/u_pwm_gen_x/pwm_thres3 input A B is not pipelined. Pipelining DSP48 input will improve performance.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPIP-12default:default2$
Input pipelining2default:default2�
�DSP design_1_i/servo_ctrl_0/inst/u_pwm_gen_y/pwm_thres3 input A B is not pipelined. Pipelining DSP48 input will improve performance.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP design_1_i/PWM_gen_0/inst/count_duty0 output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP design_1_i/PWM_gen_1/inst/count_duty0 output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP design_1_i/rgb2hsv_top_0/inst/h_dividend_reg output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP design_1_i/rgb2hsv_top_0/inst/s_dividend_reg output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP design_1_i/servo_ctrl_0/inst/u_pwm_gen_x/pwm_thres3 output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP design_1_i/servo_ctrl_0/inst/u_pwm_gen_y/pwm_thres3 output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
	RTSTAT-102default:default2%
No routable loads2default:default2�
�3 net(s) have no routable loads. The problem net(s) are design_1_i/vga_0_Vcnt_signal[8], design_1_i/vga_0_Vcnt_signal[9], design_1_i/vga_0_Vcnt_signal[10].2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
UCIO-12default:default2.
Unconstrained Logical Port2default:default2�
�8 out of 44 logical ports have no user assigned specific location constraint (LOC). This may cause I/O contention or incompatibility with the board power or connectivity affecting performance, signal integrity or in extreme cases cause damage to the device or the components to which it is connected. To correct this violation, specify all pin locations. This design will fail to generate a bitstream unless all logical ports have a user specified site LOC constraint defined.  To allow bitstream creation with unspecified pin locations (not recommended), use this command: set_property SEVERITY {Warning} [get_drc_checks UCIO-1].  NOTE: When using the Vivado Runs infrastructure (e.g. launch_runs Tcl command), add this command to a .tcl file and add that file as a pre-hook for write_bitstream step for the implementation run.  Problem ports: vauxn14, vauxn15, vauxn6, vauxn7, vauxp14, vauxp15, vauxp6, vauxp7.2default:defaultZ23-20h px
d
DRC finished with %s
1905*	planAhead2)
0 Errors, 15 Warnings2default:defaultZ12-3199h px
f
BPlease refer to the DRC report (report_drc) for more information.
1906*	planAheadZ12-3200h px
<
Loading data files...
1271*designutilsZ12-1165h px
;
Loading site data...
1273*designutilsZ12-1167h px
<
Loading route data...
1272*designutilsZ12-1166h px
<
Processing options...
1362*designutilsZ12-1514h px
9
Creating bitmap...
1249*designutilsZ12-1141h px
4
Creating bitstream...
7*	bitstreamZ40-7h px
d
Writing bitstream %s...
11*	bitstream2*
./design_1_wrapper.bit2default:defaultZ40-11h px
C
Bitgen Completed Successfully.
1606*	planAheadZ12-1842h px
p
QWebTalk data collection is enabled (User setting is ON. Install Setting is ON.).
118*projectZ1-118h px
W
Releasing license: %s
83*common2"
Implementation2default:defaultZ17-83h px
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2%
write_bitstream: 2default:default2
00:00:212default:default2
00:00:212default:default2
1409.3242default:default2
288.7582default:defaultZ17-268h px
b
File %s does not exist
147*	vivadotcl2(
design_1_wrapper.mmi2default:defaultZ4-319h px


End Record