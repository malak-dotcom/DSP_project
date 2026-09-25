module DSP_tb();
//parameters
parameter     A0REG=0;
parameter     A1REG=1;
parameter     B0REG=0;
parameter     B1REG=1;
parameter     CREG=1;
parameter     DREG=1;
parameter     MREG=1;
parameter     PREG=1;
parameter     CARRYINREG=1;
parameter     CARRYOUTREG=1;
parameter     OPMODEREG=1;
parameter     RSTTYPE="SYN";  
parameter     B_IN="DIRECT";
parameter     CARRYINSEL="OPMODE5";
//inputs
reg  [17:0]A,B,BCIN,D;
reg  [47:0] C,PCIN;
reg  CLK,CARRYIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;
reg  [7:0] OPMODEin;
//0utputs
wire [47:0]PCOUT,P;
wire [17:0] BCOUT;
wire [35:0] M;
wire CARRYOUT,CARRYOUTF;

DSP DUT (A,B,D,C,CLK,CARRYIN,OPMODEin,
RSTA,RSTB,RSTM,BCIN,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,
CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,
PCIN,PCOUT,
BCOUT,P,M,CARRYOUT,CARRYOUTF);
initial begin
    CLK=0;
    forever 
      #5 CLK=~CLK; 
   
end


initial begin
    RSTA=1;
    RSTB=1;
    RSTM=1;
    BCIN=1;
    RSTP=1;
    RSTC=1;
    RSTD=1;
    RSTCARRYIN=1;
    RSTOPMODE=1;
    OPMODEin=$random;
    A=$random;
    B=$random;
    BCIN=$random;
    D=$random;
    C=$random;
    PCIN=$random;
    CEA=$random;
    CEB=$random;
    CEM=$random;
    CEP=$random;
    CEC=$random;
    CED=$random;
    CECARRYIN=$random;
    CEOPMODE=$random;
    CARRYIN=$random;
    if((PCOUT || P|| BCOUT || M || CARRYOUT || CARRYOUTF) !=0)begin
        $display("error");
    end
    @(negedge CLK)
    RSTA=0;
    RSTB=0;
    RSTM=0;
    BCIN=0;
    RSTP=0;
    RSTC=0;
    RSTD=0;
    RSTCARRYIN=0;
    RSTOPMODE=0;
    CEA=1;
    CEB=1;
    CEM=1;
    CEP=1;
    CEC=1;
    CED=1;
    CECARRYIN=1;
    CEOPMODE=1;    
    OPMODEin=8'b11011101;
    A = 18'h00020;
    B = 18'h00010;
    C = 48'h000000000350;
    D = 18'h00025;
    BCIN=$random;
    PCIN=$random;
    CARRYIN=$random;
    repeat(4) @(negedge CLK);
    $stop;
end
initial begin
    $monitor("A=%0h || B=%0h || D=%0h || C=%0h || CLK=%0h || CARRYIN=%0h || OPMODEin=%0h || RSTA=%0h || RSTB=%0h || RSTM=%0h || BCIN=%0h || RSTP=%0h || RSTC=%0h || RSTD=%0h || RSTCARRYIN=%0h || RSTOPMODE=%0h || CEA=%0h 
    || CEB=%0h || CEM=%0h || CEP%0h || CEC=%0h || CED=%0h || CECARRYIN=%0h || CEOPMODE=%0h || PCIN=%0h || PCOUT=%0h || BCOUT=%0h || P=%0h || M=%0h || CARRYOUT=%0h || CARRYOUTF=%0h ",
              A,B,D,C,CLK,CARRYIN,OPMODEin,RSTA,RSTB,RSTM,BCIN,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,PCIN,PCOUT,BCOUT,P,M,CARRYOUT,CARRYOUTF);
    
end
endmodule
