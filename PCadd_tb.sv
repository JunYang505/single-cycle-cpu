module PCadd_tb();

   logic [31:0]PC; 
   logic [31:0]PCPlus4;

   integer errors;
   
   PCadd dut (
        .PC(PC),
        .PCPlus4(PCPlus4)
    );

    initial begin
        errors = 0;

        PC = 32'h00000000;
        #10;

        if (PCPlus4 !== 32'h00000004)
            errors = errors + 1;

        PC = 32'h00000100;
        #10;

        if (PCPlus4 !== 32'h00000104)
            errors = errors + 1;

        PC = 32'hFFFFFFFC;
        #10;

        if (PCPlus4 !== 32'h00000000)
            errors = errors + 1;

        $display("%0d", errors);
        $finish;
    end

endmodule