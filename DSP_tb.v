module DSP_tb();
    // Parameters
    parameter A0REG = 0;
    parameter A1REG = 1;
    parameter B0REG = 0;
    parameter B1REG = 1;
    parameter CREG = 1;
    parameter DREG = 1;
    parameter MREG = 1;
    parameter PREG = 1;
    parameter CARRYINREG = 1;
    parameter CARRYOUTREG = 1;
    parameter OPMODEREG = 1;
    parameter RSTTYPE = "SYN";  
    parameter B_IN = "DIRECT";
    parameter CARRYINSEL = "OPMODE5";

    // Inputs
    reg [17:0] A, B, BCIN, D;
    reg [47:0] C, PCIN;
    reg CLK, CARRYIN, RSTA, RSTB, RSTM, RSTP, RSTC, RSTD, RSTCARRYIN, RSTOPMODE;
    reg CEA, CEB, CEM, CEP, CEC, CED, CECARRYIN, CEOPMODE;
    reg [7:0] OPMODEin;

    // Outputs
    wire [47:0] PCOUT, P;
    wire [17:0] BCOUT;
    wire [35:0] M;
    wire CARRYOUT, CARRYOUTF;

    // Instantiate DUT
    DSP DUT (
        .A(A), .B(B), .D(D), .C(C), .CLK(CLK), .CARRYIN(CARRYIN), .OPMODEin(OPMODEin),
        .RSTA(RSTA), .RSTB(RSTB), .RSTM(RSTM), .BCIN(BCIN), .RSTP(RSTP), .RSTC(RSTC), 
        .RSTD(RSTD), .RSTCARRYIN(RSTCARRYIN), .RSTOPMODE(RSTOPMODE),
        .CEA(CEA), .CEB(CEB), .CEM(CEM), .CEP(CEP), .CEC(CEC), .CED(CED), 
        .CECARRYIN(CECARRYIN), .CEOPMODE(CEOPMODE),
        .PCIN(PCIN), .PCOUT(PCOUT), .BCOUT(BCOUT), .M(M), .P(P), 
        .CARRYOUT(CARRYOUT), .CARRYOUTF(CARRYOUTF)
    );

    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK; 
    end

    initial begin
        // Initialize inputs
        RSTA = 0; RSTB = 0; RSTM = 0; RSTP = 0; RSTC = 0; 
        RSTD = 0; RSTCARRYIN = 0; RSTOPMODE = 0;
        CEA = 0; CEB = 0; CEM = 0; CEP = 0; CEC = 0; 
        CED = 0; CECARRYIN = 0; CEOPMODE = 0;
        A = 0; B = 0; D = 0; C = 0; BCIN = 0; PCIN = 0; CARRYIN = 0; OPMODEin = 0;

    
        // Verify Reset Operation
        @(negedge CLK);
        RSTA = 1; RSTB = 1; RSTM = 1; RSTP = 1; RSTC = 1; 
        RSTD = 1; RSTCARRYIN = 1; RSTOPMODE = 1;
        BCIN = $random; D = $random; A = $random; B = $random; C = $random; PCIN = $random;

        @(negedge CLK); 
        if ((PCOUT !== 0) || (P !== 0) || (BCOUT !== 0) || (M !== 0) || (CARRYOUT !== 0) || (CARRYOUTF !== 0)) begin
            $display("ERROR: Reset failed! Outputs are not zero.");
        end else begin
            $display("SUCCESS: Reset verified successfully.");
        end

        // Deassert reset
        RSTA = 0; RSTB = 0; RSTM = 0; RSTP = 0; RSTC = 0; 
        RSTD = 0; RSTCARRYIN = 0; RSTOPMODE = 0;
        CEA = 1; CEB = 1; CEM = 1; CEP = 1; CEC = 1; 
        CED = 1; CECARRYIN = 1; CEOPMODE = 1;


        // Verify DSP Path 1
        OPMODEin = 8'b11011101;
        A = 18'd20;  
        B = 18'd10;  
        C = 48'd350; 
        D = 18'd25;  
        BCIN = $random;
        PCIN = $random;
        CARRYIN = $random;

        // Wait for 4 negative clock edges
        repeat(4) @(negedge CLK);

        if ((BCOUT === 18'hf) && (M === 36'h12c) && (P === 48'h32) && (CARRYOUT === 0) && (CARRYOUTF === 0)) begin
            $display("SUCCESS: Path 1 passed! P = %h", P);
        end else begin
            $display("ERROR: Path 1 failed! BCOUT=%h (exp hf), M=%h (exp h12c), P=%h (exp h32)", BCOUT, M, P);
        end

        // Verify DSP Path 2
        OPMODEin = 8'b00010000;
        A = 18'd20;
        B = 18'd10;
        C = 48'd350;
        D = 18'd25;
        BCIN = $random;
        PCIN = $random;
        CARRYIN = $random;

        // Wait for 3 negative clock edges 
        repeat(3) @(negedge CLK);

        if ((BCOUT === 18'h23) && (M === 36'h2bc) && (P === 48'h0) && (CARRYOUT === 0) && (CARRYOUTF === 0)) begin
            $display("SUCCESS: Path 2 passed! P = %h", P);
        end else begin
            $display("ERROR: Path 2 failed! BCOUT=%h (exp h23), M=%h (exp h2bc), P=%h (exp 0)", BCOUT, M, P);
        end


        //Verify DSP Path 3
        OPMODEin = 8'b00001010;
        A = 18'd20;
        B = 18'd10;
        C = 48'd350;
        D = 18'd25;
        BCIN = $random;
        PCIN = $random;
        CARRYIN = $random;

        repeat(3) @(negedge CLK);
        if ((BCOUT === 18'ha) && (M === 36'hc8)) begin
            $display("SUCCESS: Path 3 passed! BCOUT = %h, M = %h, P = %h", BCOUT, M, P);
        end else begin
            $display("ERROR: Path 3 failed! BCOUT=%h (exp ha), M=%h (exp hc8)", BCOUT, M);
        end

   
        // Verify DSP Path 4
        OPMODEin = 8'b10100111;
        A = 18'd5;
        B = 18'd6;
        C = 48'd350;
        D = 18'd25;
        PCIN = 48'd3000;
        BCIN = $random;
        CARRYIN = $random;

        repeat(3) @(negedge CLK);
        if ((BCOUT === 18'h6) && (M === 36'h1e) && (P === 48'hfe6fffec0bb1) && (CARRYOUT === 1) && (CARRYOUTF === 1)) begin
            $display("SUCCESS: Path 4 passed! P = %h", P);
        end else begin
            $display("ERROR: Path 4 failed! BCOUT=%h (exp h6), M=%h (exp h1e), P=%h (exp hfe6fffec0bb1), Carry=%b", BCOUT, M, P, CARRYOUT);
        end

        #20;
        $stop;
    end

    // Monitor Output
    initial begin
        $monitor("Time=%0t ns | OPMODE=%b | A=%d | B=%d | D=%d | BCOUT=%h | M=%h | P=%h | Carry=%b", 
                 $time, OPMODEin, A, B, D, BCOUT, M, P, CARRYOUT);
    end

endmodule