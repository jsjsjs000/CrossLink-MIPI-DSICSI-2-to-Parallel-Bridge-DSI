#=============================================================================
# Eval sim script generated by IPExpress/Clarity   02/21/2024    13:11:33 
# IP package: CSI-2/DSI D-PHY Receiver 1.6                             
# Lattice IP Core Simulation Script for Evaluation (Verilog)                  
# Copyright(c) 2015 Lattice Semiconductor Corporation. All rights reserved.   
#=============================================================================

# WARNING - Changes to this file should be performed by re-running IPexpress or
# modifying the .LPC file and regenerating the core. Other changes may lead to 
# inconsistent simulation and/or implementation results.                       

#-- Set Diamond SW installation directory -- 
#-- Modify this path for localization of "Diamond" 
set diamond_dir C:/lscc/diamond/3.13 

#-- Simulation work library creation -- 
cd "C:/Users/p2119/Desktop/CrossLink-MIPI-DSICSI-2-to-Parallel-Bridge-DSI/ipk/rx_dphy/dphy_rx_eval/rx_dphy/sim/aldec"
     workspace create dphy_rx_space
     design create rx_dphy_design .
     design open rx_dphy_design

#-- Lattice device library support -- 
cd "C:/Users/p2119/Desktop/CrossLink-MIPI-DSICSI-2-to-Parallel-Bridge-DSI/ipk/rx_dphy/dphy_rx_eval/rx_dphy/sim/aldec"
set diamond_dir C:/lscc/diamond/3.13 
set sim_working_folder .

do dphyrx_rtl.do
run -all 
