module RegisterFile_tb ();

    logic WE3;
    logic clk;

    logic [4:0]A1;
    logic [4:0]A2;
    logic [4:0]A3;
    
    logic [31:0]WD3;

    logic [31:0]RD1;
    logic [31:0]RD2;

    integer errors;
    integer i;

    RegisterFile dut(

        .WE3(WE3),
        .clk(clk),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .WD3(WD3),
        .RD1,
        .RD2

    );

     initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        errors = 0;
        WE3 = 0;
        A1 = 0;
        A2 = 0;
        A3 = 0;
        WD3 = 0;

        @(negedge clk);
        WE3 = 1;
        A3 = 5'd5;
        WD3 = 32'h12345678;

        @(posedge clk);
        #1;

        @(negedge clk);
        WE3 = 0;
        A3 = 5'd5;
        WD3 = 32'hFFFFFFFF;

        @(posedge clk);
        #1;

        A1 = 5'd5;
        #1;

        if (RD1 !== 32'h12345678)
            errors = errors + 1;

        @(negedge clk);
        WE3 = 1;
        A3 = 5'd0;
        WD3 = 32'hFFFFFFFF;

        @(posedge clk);
        #1;

        A1 = 5'd0;
        A2 = 5'd0;
        #1;

        if (RD1 !== 32'h00000000 ||
            RD2 !== 32'h00000000)
            errors = errors + 1;

        for (i = 1; i < 32; i = i + 1) begin
            @(negedge clk);
            WE3 = 1;
            A3 = i;
            WD3 = 32'h00000000;

            @(posedge clk);
            #1;

            A1 = i;
            #1;

            if (RD1 !== 32'h00000000)
                errors = errors + 1;
        end

        for (i = 1; i < 32; i = i + 1) begin
            @(negedge clk);
            WE3 = 1;
            A3 = i;
            WD3 = 32'hFFFFFFFF;

            @(posedge clk);
            #1;

            A1 = i;
            #1;

            if (RD1 !== 32'hFFFFFFFF)
                errors = errors + 1;
        end

        WE3 = 0;

        $display("%0d", errors);
        $finish;
    end

endmodule