module InstructionMemory_tb ();

    logic [31:0]A;

    logic [31:0]RD;

    integer errors;

InstructionMemory dut (

    .A(A),
    .RD(RD)

);

initial begin
        errors = 0;

        A = 32'h00000000;
        #10;

        if (RD !== 32'h11111111)
            errors = errors + 1;

        A = 32'h00000200;
        #10;

        if (RD !== 32'h22222222)
            errors = errors + 1;

        A = 32'h000003FC;
        #10;

        if (RD !== 32'h33333333)
            errors = errors + 1;

        $display("%0d", errors);
        $finish;
    end

endmodule