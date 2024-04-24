//   ==================================================================
//   >>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
//   ------------------------------------------------------------------
//   Copyright (c) 2014 by Lattice Semiconductor Corporation
//   ALL RIGHTS RESERVED 
//   ------------------------------------------------------------------
//
//   Permission:
//
//      Lattice SG Pte. Ltd. grants permission to use this code
//      pursuant to the terms of the Lattice Reference Design License Agreement. 
//
//
//   Disclaimer:
//
//      This VHDL or Verilog source code is intended as a design reference
//      which illustrates how these types of functions can be implemented.
//      It is the user's responsibility to verify their design for
//      consistency and functionality through the use of formal
//      verification methods.  Lattice provides no warranty
//      regarding the use or functionality of this code.
//
//   --------------------------------------------------------------------
//
//                  Lattice SG Pte. Ltd.
//                  101 Thomson Road, United Square #07-02 
//                  Singapore 307591
//
//
//                  TEL: 1-800-Lattice (USA and Canada)
//                       +65-6631-2000 (Singapore)
//                       +1-503-268-8001 (other locations)
//
//                  web: http://www.latticesemi.com/
//                  email: techsupport@latticesemi.com
//
//   --------------------------------------------------------------------


`timescale 1ns / 1ps

module i2c_target  #(
	parameter I2C_TARGET_ADR_MSB = 5'h10,	// LSB 2bits are "10" for I2C0
	parameter REG_ADR_WIDTH = 4,	// up to 8
	parameter REG_0_DEF_VAL = 8'd0,
	parameter REG_1_DEF_VAL = 8'd0,
	parameter REG_2_DEF_VAL = 8'd0,
	parameter REG_3_DEF_VAL = 8'd0,
	parameter REG_4_DEF_VAL = 8'd0,
	parameter REG_5_DEF_VAL = 8'd0,
	parameter REG_6_DEF_VAL = 8'd0,
	parameter REG_7_DEF_VAL = 8'd0,
	parameter REG_8_DEF_VAL = 8'd0,
	parameter REG_9_DEF_VAL = 8'd0,
	parameter REG_A_DEF_VAL = 8'd0,
	parameter REG_B_DEF_VAL = 8'd0,
	parameter REG_C_DEF_VAL = 8'd0,
	parameter REG_D_DEF_VAL = 8'd0,
	parameter REG_E_DEF_VAL = 8'd0,
	parameter REG_F_DEF_VAL = 8'd0
) (
    input	reset_i,
    input	clk_i,
	// i2c interface
    inout	sda,
    inout	scl,
	// register interface
	output [7:0]	reg_0_data,
	output [7:0]	reg_1_data,
	output [7:0]	reg_2_data,
	output [7:0]	reg_3_data,
	output [7:0]	reg_4_data,
	output [7:0]	reg_5_data,
	output [7:0]	reg_6_data,
	output [7:0]	reg_7_data,
	output [7:0]	reg_8_data,
	output [7:0]	reg_9_data,
	output [7:0]	reg_a_data,
	output [7:0]	reg_b_data,
	output [7:0]	reg_c_data,
	output [7:0]	reg_d_data,
	output [7:0]	reg_e_data,
	output [7:0]	reg_f_data
);

reg [3:0]ip_adri;
reg [9:0]ip_dati;

reg	ip_stbi;
reg ip_csi;
reg ip_wei;

wire [9:0]ip_dato;
wire ip_acko;
wire ip_irq;
wire ip_wkup;

wire [9:0]ip_dato_d;
wire ip_acko_d;
wire ip_irq_d;

localparam DLY = 5;

localparam IP_REG_ADR_CR = 4'd1;
localparam IP_REG_ADR_CMDR = 4'd7;
localparam IP_REG_ADR_INTCR = 4'd5;
localparam IP_REG_ADR_SLAVE_ADR = 4'd4;
localparam IP_REG_ADR_SR = 4'd11;
localparam IP_REG_ADR_INSR = 4'd12;
localparam IP_REG_ADR_RXDR = 4'd9;
localparam IP_REG_ADR_TXDR = 4'd8;

localparam CR_SET				= 9'b0_0000_0001;
localparam CMDR_SET				= 9'b0_0000_0010;
localparam INTCR_SET			= 9'b0_0000_0100;
localparam SLAVE_ADR_MSB_SET	= 9'b0_0000_1000;
localparam WAIT					= 9'b0_0001_0000;
localparam STATUS_READ			= 9'b0_0010_0000;
localparam SUB_ADR_SET			= 9'b0_0100_0000;
localparam REG_WRITE			= 9'b0_1000_0000;
localparam REG_READ				= 9'b1_0000_0000;

reg			r_ip_wkup, r_ip_wkup_det;
reg	[8:0]	r_state;
reg			r_1st_wr_done;


reg [REG_ADR_WIDTH-1:0]	r_reg_adr;
reg [7:0]				r_reg_dat[0:2**REG_ADR_WIDTH-1];

assign reg_0_data = r_reg_dat[0];
assign reg_1_data = r_reg_dat[1];
assign reg_2_data = r_reg_dat[2];
assign reg_3_data = r_reg_dat[3];
assign reg_4_data = r_reg_dat[4];
assign reg_5_data = r_reg_dat[5];
assign reg_6_data = r_reg_dat[6];
assign reg_7_data = r_reg_dat[7];
assign reg_8_data = r_reg_dat[8];
assign reg_9_data = r_reg_dat[9];
assign reg_a_data = r_reg_dat[10];
assign reg_b_data = r_reg_dat[11];
assign reg_c_data = r_reg_dat[12];
assign reg_d_data = r_reg_dat[13];
assign reg_e_data = r_reg_dat[14];
assign reg_f_data = r_reg_dat[15];

always @(posedge clk_i or posedge reset_i) begin
	if(reset_i) begin
		r_1st_wr_done <= 0;
		r_state <= CR_SET;
		r_reg_adr <= 0;
		ip_stbi <= 0;
		ip_adri <= 4'd0;
		ip_dati <= 10'd0;
		ip_csi <= 0;
		ip_wei <= 0;
		ip_adri <= #DLY IP_REG_ADR_CR;
		ip_dati <= #DLY r_reg_dat[r_reg_adr];
		r_reg_dat[0] <= REG_0_DEF_VAL;
		r_reg_dat[1] <= REG_1_DEF_VAL;
		r_reg_dat[2] <= REG_2_DEF_VAL;
		r_reg_dat[3] <= REG_3_DEF_VAL;
		r_reg_dat[4] <= REG_4_DEF_VAL;
		r_reg_dat[5] <= REG_5_DEF_VAL;
		r_reg_dat[6] <= REG_6_DEF_VAL;
		r_reg_dat[7] <= REG_7_DEF_VAL;
		r_reg_dat[8] <= REG_8_DEF_VAL;
		r_reg_dat[9] <= REG_9_DEF_VAL;
		r_reg_dat[10] <= REG_A_DEF_VAL;
		r_reg_dat[11] <= REG_B_DEF_VAL;
		r_reg_dat[12] <= REG_C_DEF_VAL;
		r_reg_dat[13] <= REG_D_DEF_VAL;
		r_reg_dat[14] <= REG_E_DEF_VAL;
		r_reg_dat[15] <= REG_F_DEF_VAL;
	end
	else begin
		case (r_state)
			CR_SET: begin
				r_1st_wr_done <= 0;
				if (ip_acko) begin
					r_state <= #DLY CMDR_SET;
					ip_csi <= #DLY 0;
					ip_stbi <= #DLY 0;
					ip_wei <= #DLY 0;
					ip_adri <= #DLY IP_REG_ADR_CMDR;
				end
				else begin
					r_state <= #DLY CR_SET;
					ip_csi <= #DLY 1;
					ip_stbi <= #DLY 1;
					ip_wei <= #DLY 1;
					ip_adri <= #DLY IP_REG_ADR_CR;
					ip_dati <= #DLY 8'b1010_0000;
				end
			end
			CMDR_SET: begin
				r_1st_wr_done <= 0;
				if (ip_acko) begin
					r_state <= #DLY INTCR_SET;
					ip_csi <= #DLY 0;
					ip_stbi <= #DLY 0;
					ip_wei <= #DLY 0;
					ip_adri <= #DLY IP_REG_ADR_INTCR;
				end
				else begin
					r_state <= #DLY CMDR_SET;
					ip_csi <= #DLY 1;
					ip_stbi <= #DLY 1;
					ip_wei <= #DLY 1;
					ip_adri <= #DLY IP_REG_ADR_CMDR;
					ip_dati <= #DLY 8'b0000_0100;
				end
			end
			INTCR_SET: begin
				r_1st_wr_done <= 0;
				if (ip_acko) begin
					r_state <= #DLY SLAVE_ADR_MSB_SET;
					ip_csi <= #DLY 0;
					ip_stbi <= #DLY 0;
					ip_wei <= #DLY 0;
					ip_adri <= #DLY IP_REG_ADR_SLAVE_ADR;
				end
				else begin
					r_state <= #DLY INTCR_SET;
					ip_csi <= #DLY 1;
					ip_stbi <= #DLY 1;
					ip_wei <= #DLY 1;
					ip_adri <= #DLY IP_REG_ADR_INTCR;
					ip_dati <= #DLY 8'b1000_1100;
				end
			end
			SLAVE_ADR_MSB_SET: begin
				r_1st_wr_done <= 0;
				if (ip_acko) begin
					r_state <= #DLY WAIT;
					ip_csi <= #DLY 0;
					ip_stbi <= #DLY 0;
					ip_wei <= #DLY 0;
					ip_adri <= #DLY IP_REG_ADR_RXDR;
				end
				else begin
					r_state <= #DLY SLAVE_ADR_MSB_SET;
					ip_csi <= #DLY 1;
					ip_stbi <= #DLY 1;
					ip_wei <= #DLY 1;
					ip_adri <= #DLY IP_REG_ADR_SLAVE_ADR;
					ip_dati <= #DLY {3'd0, I2C_TARGET_ADR_MSB};
				end
			end
			WAIT: begin
//				if (~ip_wkup) begin
				if (r_ip_wkup_det) begin
					r_1st_wr_done <= 0;
				end
				if (ip_irq) begin	// Interrupt
					r_state <= #DLY WAIT;
					ip_csi <= #DLY 1;
					ip_stbi <= #DLY 1;
					ip_wei <= #DLY 0;
					ip_adri <= #DLY IP_REG_ADR_INSR;
				end
				else if (ip_acko) begin
					ip_csi <= #DLY 0;
					ip_stbi <= #DLY 0;
					ip_wei <= #DLY 0;
					if (ip_dato[2]) begin
						r_state <= #DLY STATUS_READ;
					end
					else begin
						r_state <= #DLY WAIT;
					end
				end
				else begin
					r_state <= #DLY WAIT;
					ip_csi <= #DLY 0;
					ip_stbi <= #DLY 0;
					ip_wei <= #DLY 0;
				end
			end
			STATUS_READ : begin
				if (~ip_acko) begin
					r_state <= #DLY STATUS_READ;
					ip_csi <= #DLY 1;
					ip_stbi <= #DLY 1;
					ip_wei <= #DLY 0;
					ip_adri <= #DLY IP_REG_ADR_SR;
				end
				else begin
					r_state <= #DLY WAIT;
					ip_csi <= #DLY 0;
					ip_stbi <= #DLY 0;
					ip_wei <= #DLY 0;
					if (~ip_dato[4] & ip_dato[2] & (~r_1st_wr_done)) begin	// sub-address set
						r_state <= #DLY SUB_ADR_SET;
					end
					else if (~ip_dato[4] & ip_dato[2] & r_1st_wr_done) begin	// reg data write
						r_state <= #DLY REG_WRITE;
					end
					else if (ip_dato[4] & ip_dato[2]) begin	// reg data read
						r_state <= #DLY REG_READ;
					end
					else begin
						r_state <= #DLY WAIT;
					end
				end
			end
			SUB_ADR_SET : begin
				if (~ip_acko) begin
					r_state <= #DLY SUB_ADR_SET;
					ip_csi <= #DLY 1;
					ip_stbi <= #DLY 1;
					ip_wei <= #DLY 0;
					ip_adri <= #DLY IP_REG_ADR_RXDR;
				end
				else begin
					r_state <= #DLY WAIT;
					ip_csi <= #DLY 0;
					ip_stbi <= #DLY 0;
					ip_wei <= #DLY 0;
					r_reg_adr <= #DLY ip_dato[REG_ADR_WIDTH-1:0];
					r_1st_wr_done <= 1;
				end
			end
			REG_WRITE : begin
				if (~ip_acko) begin
					r_state <= #DLY REG_WRITE;
					ip_csi <= #DLY 1;
					ip_stbi <= #DLY 1;
					ip_wei <= #DLY 0;
					ip_adri <= #DLY IP_REG_ADR_RXDR;
				end
				else begin
					r_state <= #DLY WAIT;
					ip_csi <= #DLY 0;
					ip_stbi <= #DLY 0;
					ip_wei <= #DLY 0;
					r_reg_dat[r_reg_adr] <= #DLY ip_dato[7:0];
					r_reg_adr <= #DLY r_reg_adr + 1;	// auto address increment
				end
			end
			REG_READ: begin
				if (~ip_acko) begin
					r_state <= #DLY REG_READ;
					ip_csi <= #DLY 1;
					ip_stbi <= #DLY 1;
					ip_wei <= #DLY 1;
					ip_adri <= #DLY IP_REG_ADR_TXDR;
					ip_dati <= #DLY r_reg_dat[r_reg_adr];
				end
				else if (ip_acko) begin
					r_state <= #DLY WAIT;
					ip_csi <= #DLY 0;
					ip_stbi <= #DLY 0;
					ip_wei <= #DLY 0;
					ip_adri <= #DLY IP_REG_ADR_TXDR;
					r_reg_adr <= #DLY r_reg_adr + 1;	// auto address increment
				end
			end
			default : begin
				r_1st_wr_done <= #DLY 0;
				r_state <= #DLY WAIT;
				r_reg_adr <= #DLY 0;
				ip_csi <= #DLY 0;
				ip_stbi <= #DLY 0;
				ip_wei <= #DLY 0;
				ip_adri <= #DLY IP_REG_ADR_TXDR;
				ip_dati <= #DLY r_reg_dat[r_reg_adr];
			end
		endcase
	end
end


i2c_s i2c_ip (	// I2C IP in reg mode
	.i2c0clki		(clk_i),
	
	.i2c0scl		(scl),
	.i2c0sda		(sda),

	.i2c0adri		(ip_adri),		//	I2C IP reg addr 
	.i2c0dati		(ip_dati),		//	I2C IP reg write data
	.i2c0csi		(ip_csi),		//	I2C IP chip select
	.i2c0stbi		(ip_stbi),		//	I2C IP reg strobe
	.i2c0wei		(ip_wei),		//	I2C IP reg write enable (1: write, 0: read)
	
	.i2c0dato		(ip_dato),		//	I2C IP reg read data
	.i2c0acko		(ip_acko),		//	I2C IP acknowledge of reg access
	.i2c0i2cirq		(ip_irq),		//	I2C IP intterrrupt
	.i2c0i2cwkup	(ip_wkup),		//	I2C IP wake-up	
	.i2c0pmuwkup	(ip_pmuwkup)	//	I2C IP PMU wake-up
);

always @(posedge clk_i or posedge reset_i) begin
	if (reset_i) begin
		r_ip_wkup <=0;
		r_ip_wkup_det <=0;
	end
	else begin
		r_ip_wkup <= ip_wkup;
		r_ip_wkup_det <= ~r_ip_wkup & ip_wkup;
	end
end

endmodule
