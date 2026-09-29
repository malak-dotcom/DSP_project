module DSP_unit #(parameter width=18, XREG=1, RSTTYPE="SYN")(
    input [width-1:0] X,
    input clk,
    input rst,
    input CEX,
    output [width-1:0] Xout
);

    generate
        if (XREG != 0) begin
            reg [width-1:0] Xreg;
            
            if (RSTTYPE == "SYN") begin
                always @(posedge clk) begin
                    if (rst)
                        Xreg <= {width{1'b0}};
                    else if (CEX)
                        Xreg <= X;
                end
            end
            else if (RSTTYPE == "ASYN") begin
                always @(posedge clk or posedge rst) begin
                    if (rst)
                        Xreg <= {width{1'b0}};
                    else if (CEX)
                        Xreg <= X;
                end
            end
            
            assign Xout = Xreg;
        end
        else begin
            assign Xout = X;
        end
    endgenerate

endmodule