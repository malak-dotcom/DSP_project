module DSP 
//parameters
           #(parameter
             A0REG=0,
             A1REG=1,
             B0REG=0,
             B1REG=1,
             CREG=1,
             DREG=1,
             MREG=1,
             PREG=1,
             CARRYINREG=1,
             CARRYOUTREG=1,
             OPMODEREG=1,
             RSTTYPE="SYN",  
             B_IN="DIRECT",
             CARRYINSEL="OPMODE5"
              )

//inputs & outputs
(A,B,D,C,CLK,CARRYIN,OPMODEin,
RSTA,RSTB,RSTM,BCIN,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,
CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,
PCIN,PCOUT,
BCOUT,P,M,CARRYOUT,CARRYOUTF);
input  [17:0]A,B,BCIN,D;
input  [47:0] C,PCIN;
input  CLK,CARRYIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;
input  [7:0] OPMODEin;
output [47:0]PCOUT,P;
output [17:0] BCOUT;
output [35:0] M;
output CARRYOUT,CARRYOUTF;

//internal signals
wire [7:0]OPMODE;
wire [17:0] Bmux,Dout,Bout,Aout,B1,B1out,A1,A1out,pre_a_s;
reg  [48:0] post_a_s_result;
wire [47:0] Cout;
wire  [47:0] post_a_s;
reg  [47:0] mux_x,mux_z;
wire [35:0] multiplier,Mout;
wire CYO,CY1,CIN;

//instantiation
DSP_unit #(.width(8),.XREG(OPMODEREG),.RSTTYPE(RSTTYPE)) OPMODE_REG(.X(OPMODEin),.clk(CLK),.rst(RSTOPMODE),.CEX(CEOPMODE),.Xout(OPMODE));
DSP_unit #(.width(18),.XREG(DREG),.RSTTYPE(RSTTYPE)) D_REG(.X(D),.clk(CLK),.rst(RSTD),.CEX(CED),.Xout(Dout));
DSP_unit #(.width(18),.XREG(B0REG),.RSTTYPE(RSTTYPE)) B0_REG(.X(Bmux),.clk(CLK),.rst(RSTB),.CEX(CEB),.Xout(Bout));
DSP_unit #(.width(18),.XREG(A0REG),.RSTTYPE(RSTTYPE)) A0_REG(.X(A),.clk(CLK),.rst(RSTA),.CEX(CEA),.Xout(Aout));
DSP_unit #(.width(48),.XREG(CREG),.RSTTYPE(RSTTYPE)) C_REG(.X(C),.clk(CLK),.rst(RSTC),.CEX(CEC),.Xout(Cout));
DSP_unit #(.width(18),.XREG(B1REG),.RSTTYPE(RSTTYPE)) B1_REG(.X(B1),.clk(CLK),.rst(RSTB),.CEX(CEB),.Xout(B1out));
DSP_unit #(.width(18),.XREG(A1REG),.RSTTYPE(RSTTYPE)) A1_REG(.X(A1),.clk(CLK),.rst(RSTA),.CEX(CEA),.Xout(A1out));
DSP_unit #(.width(36),.XREG(MREG),.RSTTYPE(RSTTYPE)) M_REG(.X(multiplier),.clk(CLK),.rst(RSTM),.CEX(CEM),.Xout(Mout));
DSP_unit #(.width(1),.XREG(CARRYINREG),.RSTTYPE(RSTTYPE)) CY1_REG(.X(CY1),.clk(CLK),.rst(RSTCARRYIN),.CEX(CECARRYIN),.Xout(CIN));
DSP_unit #(.width(1),.XREG(CARRYOUTREG),.RSTTYPE(RSTTYPE)) CYO_REG(.X(CYO),.clk(CLK),.rst(RSTCARRYIN),.CEX(CECARRYIN),.Xout(CARRYOUT));
DSP_unit #(.width(48),.XREG(PREG),.RSTTYPE(RSTTYPE)) P_REG(.X(post_a_s),.clk(CLK),.rst(RSTP),.CEX(CEP),.Xout(P));

//Pre-Adder/Subtractor
assign BCOUT=B1out;
generate
   if(B_IN=="DIRECT")
       assign Bmux=B;
   else if(B_IN=="CASCADE")
       assign Bmux=BCIN;
   else
       assign Bmux=18'b0;
endgenerate
assign pre_a_s=(OPMODE[6]==0)? Bout+Dout : Bout-Dout;

//multiplier
assign B1=(OPMODE[4]==0)? Bout : pre_a_s;
assign A1=Aout;
assign multiplier=B1out*A1out;
assign M=Mout;

//mux_x
always @(*)
begin
   case(OPMODE[1:0])
   2'b00:  mux_x=48'b0;
   2'b01:  mux_x={multiplier,12'b0};
   2'b10:  mux_x=PCOUT;
   2'b11:  mux_x={D[11:0],A[17:0],B[17:0]};
   endcase
end

//mux_z
always @(*)
begin
   case(OPMODE[3:2])
   2'b00:  mux_z=48'b0;
   2'b01:  mux_z=PCIN;
   2'b10:  mux_z=PCOUT;
   2'b11:  mux_z=Cout;
   endcase
end

//post adder/subtractor
assign PCOUT=P;
always @(*)
begin
   case(OPMODE[7])
   1'b0: post_a_s_result=mux_x+mux_z+CIN;
   1'b1: post_a_s_result=mux_z-(mux_x+CIN);
   endcase
end
assign post_a_s=post_a_s_result[47:0];
assign CARRYOUT=post_a_s_result[48];
assign CARRYOUTF=CARRYOUT;

//carry in register
generate
   if(CARRYINSEL=="OPMODE5")
      assign CY1=OPMODE[5];
   else if(CARRYINSEL=="CARRYIN")
      assign  CY1=CARRYIN;
   else 
      assign  CY1=0;
endgenerate

endmodule
