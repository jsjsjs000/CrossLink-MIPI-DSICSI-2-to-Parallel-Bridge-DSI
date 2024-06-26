/* Verilog netlist generated by SCUBA Diamond (64-bit) 3.13.0.56.2 */
/* Module Version: 1.2 */
/* C:\lscc\diamond\3.13\ispfpga\bin\nt64\scuba.exe -w -n i2c_s -lang verilog -synth synplify -bus_exp 7 -bb -type efb -arch sn5w00 -i2c_left 24 -i2c_general_call_enable none -i2c_iobuffer left -i2c_sda_input_left 0 -i2c_sda_output_left 0 -i2c_rate_left 400 -i2c_fifo_enable none -i2c_fifo_clkstr none -i2c_addr_left 1000010 -i2c_wakeup_addr_match left -i2c_wakeup_fifo_af none -i2c_arbitration_lost none -i2c_txrx_ready left -i2c_overrun left -i2c_intr_gc none -i2c_fifo_intr_gc none -i2c_fifo_nack none -i2c_fifo_mrc none -i2c_fifo_arbit none -i2c_fifo_txsync none -i2c_fifo_txunder none -i2c_fifo_rxover none  */
/* Tue Feb 20 12:31:07 2024 */


`timescale 1 ns / 1 ps
module i2c_s (i2c0acko, i2c0adri, i2c0clki, i2c0csi, i2c0dati, i2c0dato, 
    i2c0i2cirq, i2c0i2cwkup, i2c0pmuwkup, i2c0scl, i2c0sda, i2c0stbi, 
    i2c0wei)/* synthesis NGD_DRC_MASK=1 */;
    input wire [3:0] i2c0adri;
    input wire i2c0clki;
    input wire i2c0csi;
    input wire [9:0] i2c0dati;
    input wire i2c0stbi;
    input wire i2c0wei;
    output wire i2c0acko;
    output wire [9:0] i2c0dato;
    output wire i2c0i2cirq;
    output wire i2c0i2cwkup;
    output wire i2c0pmuwkup;
    inout wire i2c0scl;
    inout wire i2c0sda;

    wire scuba_vlo;
    wire i2c0sdai;
    wire i2c0sdaoen;
    wire i2c0sdao;
    wire i2c0scli;
    wire i2c0scloen;
    wire i2c0sclo;

    VLO scuba_vlo_inst (.Z(scuba_vlo));

    defparam i2c0.I2C_CLK_DIVIDER = 60 ;
    defparam i2c0.SDA_O_DELAY = 0 ;
    defparam i2c0.SDA_I_DELAY = 0 ;
    defparam i2c0.I2C_FIFO_TXALMOSTE = 3 ;
    defparam i2c0.I2C_FIFO_RXALMOSTF = 30 ;
    defparam i2c0.I2C_FIFO_RXOVER = "DISABLED" ;
    defparam i2c0.I2C_FIFO_TXUNDER = "DISABLED" ;
    defparam i2c0.I2C_FIFO_TXSYNC = "DISABLED" ;
    defparam i2c0.I2C_FIFO_INTR_ARBIT = "DISABLED" ;
    defparam i2c0.I2C_FIFO_MRXRDY = "DISABLED" ;
    defparam i2c0.I2C_FIFO_INTR_NACK = "DISABLED" ;
    defparam i2c0.I2C_FIFO_INTR_GC = "DISABLED" ;
    defparam i2c0.I2C_FIFO_CLKSTR = "DISABLED" ;
    defparam i2c0.I2C_FIFO_ENB = "DISABLED" ;
    defparam i2c0.I2C_WAKEUP_MASTER = "DISABLED" ;
    defparam i2c0.I2C_WAKEUP_SLAVE = "ENABLED" ;
    defparam i2c0.I2C_INTR_GC = "DISABLED" ;
    defparam i2c0.I2C_INTR_NACK = "ENABLED" ;
    defparam i2c0.I2C_INTR_TXRXRDY = "ENABLED" ;
    defparam i2c0.I2C_INTR_ARBIT = "DISABLED" ;
    defparam i2c0.I2C_GEN_CALL = "DISABLED" ;
    defparam i2c0.I2C_BUS_PERF = "400kHz" ;
    defparam i2c0.I2C_SLAVE_ADDR = "0b1000010" ;
    defparam i2c0.I2C_ADDRESSING = "7BIT" ;
    I2CA i2c0 (.CSI(i2c0csi), .CLKI(i2c0clki), .STBI(i2c0stbi), .WEI(i2c0wei), 
        .ADRI3(i2c0adri[3]), .ADRI2(i2c0adri[2]), .ADRI1(i2c0adri[1]), .ADRI0(i2c0adri[0]), 
        .DATI9(i2c0dati[9]), .DATI8(i2c0dati[8]), .DATI7(i2c0dati[7]), .DATI6(i2c0dati[6]), 
        .DATI5(i2c0dati[5]), .DATI4(i2c0dati[4]), .DATI3(i2c0dati[3]), .DATI2(i2c0dati[2]), 
        .DATI1(i2c0dati[1]), .DATI0(i2c0dati[0]), .DATO9(i2c0dato[9]), .DATO8(i2c0dato[8]), 
        .DATO7(i2c0dato[7]), .DATO6(i2c0dato[6]), .DATO5(i2c0dato[5]), .DATO4(i2c0dato[4]), 
        .DATO3(i2c0dato[3]), .DATO2(i2c0dato[2]), .DATO1(i2c0dato[1]), .DATO0(i2c0dato[0]), 
        .ACKO(i2c0acko), .I2CIRQ(i2c0i2cirq), .I2CWKUP(i2c0i2cwkup), .PMUWKUP(i2c0pmuwkup), 
        .FIFORST(scuba_vlo), .MRDCMPL(), .SRDWR(), .TXFIFOAE(), .TXFIFOE(), 
        .TXFIFOF(), .RXFIFOE(), .RXFIFOAF(), .RXFIFOF(), .SCLI(i2c0scli), 
        .SCLO(i2c0sclo), .SCLOEN(i2c0scloen), .SDAI(i2c0sdai), .SDAO(i2c0sdao), 
        .SDAOEN(i2c0sdaoen));

    BB Inst2_BB (.I(i2c0sdao), .T(i2c0sdaoen), .O(i2c0sdai), .B(i2c0sda));

    BB Inst1_BB (.I(i2c0sclo), .T(i2c0scloen), .O(i2c0scli), .B(i2c0scl));



    // exemplar begin
    // exemplar end

endmodule
