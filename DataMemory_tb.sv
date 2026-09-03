module DataMemory_tb ();

    logic WE;
    logic clk;

    logic [31:0]A;
    logic [31:0]WD;

    logic [31:0]RD;

    integer errors;

    DataMemory dut (

        .WE(WE),
        .clk(clk),
        .A(A),
        .WD(WD),
        .RD(RD)

    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        errors = 0;

        A = 32'd8;
        WD = 32'd100;
        WE = 1;

        @(posedge clk);
        #1;

        WE = 0;
        #1;

        if (RD !== 32'd100)
            errors = errors + 1;

        WD = 32'd999;

        @(posedge clk);
        #1;

        if (RD !== 32'd100)
            errors = errors + 1;

        WE = 1;
        WD = 32'd200;

        @(posedge clk);
        #1;

        WE = 0;
        #1;

        if (RD !== 32'd200)
            errors = errors + 1;

        $display("%0d", errors);
        $finish;
    end

endmodule
