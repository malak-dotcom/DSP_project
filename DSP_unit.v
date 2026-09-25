module DSP_unit #(parameter width=18,XREG=1,RSTTYPE="SYN")(X,clk,rst,CEX,Xout);
input [width-1:0]X;
input clk;
input rst;
input CEX;
output [width-1:0]Xout;
reg [width-1:0]Xreg;
generate
   if(XREG && RSTTYPE=="SYN")begin
       always @(posedge clk)begin
           if(rst)
              Xreg<=1'b0;
           else if(CEX)
              Xreg<=X;
       end
   end
   else if(XREG && RSTTYPE=="ASYN")begin
        always @(posedge clk , posedge rst)begin
           if(rst)
              Xreg<=1'b0;
           else if(CEX)
              Xreg<=X;
        end
   end
endgenerate
assign Xout=(XREG==0)? X:Xreg;
endmodule
