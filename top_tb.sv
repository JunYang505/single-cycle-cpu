module top_tb ();

    logic clk;
    logic reset;

    integer errors;
    integer cycles;

    top dut (
        .clk   (clk),
        .reset (reset)
    );

    always #5 clk = ~clk;

    task automatic check_value(
        input logic condition,
        input string message
    );
        begin
            if (condition !== 1'b1) begin
                errors = errors + 1;
                $display(
                    "ERROR: %s, PC = 0x%08h",
                    message,
                    dut.PC
                );
            end
        end
    endtask

    initial begin
        clk    = 1'b0;
        reset  = 1'b1;
        errors = 0;
        cycles = 0;

        repeat (2) @(negedge clk);
        reset = 1'b0;

        #1;

        while ((dut.PC !== 32'd56) && (cycles < 30)) begin
            cycles = cycles + 1;

            case (dut.PC)

                32'd0: begin
                    check_value(
                        dut.Instr == 32'h00500093,
                        "PC=0 instruction incorrect"
                    );

                    check_value(
                        dut.ALUResult == 32'd5 &&
                        dut.Result    == 32'd5 &&
                        dut.RegWrite  == 1'b1,
                        "addi x1, x0, 5 failed"
                    );
                end

                32'd4: begin
                    check_value(
                        dut.Instr     == 32'h00700113 &&
                        dut.ALUResult == 32'd7 &&
                        dut.Result    == 32'd7 &&
                        dut.RegWrite  == 1'b1,
                        "addi x2, x0, 7 failed"
                    );
                end

                32'd8: begin
                    check_value(
                        dut.Instr     == 32'h002081b3 &&
                        dut.ALUResult == 32'd12 &&
                        dut.Result    == 32'd12 &&
                        dut.RegWrite  == 1'b1,
                        "add x3, x1, x2 failed"
                    );
                end

                32'd12: begin
                    check_value(
                        dut.Instr     == 32'h40118233 &&
                        dut.ALUResult == 32'd7 &&
                        dut.Result    == 32'd7 &&
                        dut.RegWrite  == 1'b1,
                        "sub x4, x3, x1 failed"
                    );
                end

                32'd16: begin
                    check_value(
                        dut.Instr     == 32'h0020f2b3 &&
                        dut.ALUResult == 32'd5 &&
                        dut.Result    == 32'd5 &&
                        dut.RegWrite  == 1'b1,
                        "and x5, x1, x2 failed"
                    );
                end

                32'd20: begin
                    check_value(
                        dut.Instr     == 32'h0020e333 &&
                        dut.ALUResult == 32'd7 &&
                        dut.Result    == 32'd7 &&
                        dut.RegWrite  == 1'b1,
                        "or x6, x1, x2 failed"
                    );
                end

                32'd24: begin
                    check_value(
                        dut.Instr     == 32'h0020c3b3 &&
                        dut.ALUResult == 32'd2 &&
                        dut.Result    == 32'd2 &&
                        dut.RegWrite  == 1'b1,
                        "xor x7, x1, x2 failed"
                    );
                end

                32'd28: begin
                    check_value(
                        dut.Instr     == 32'h00302023 &&
                        dut.MemWrite  == 1'b1 &&
                        dut.RegWrite  == 1'b0 &&
                        dut.ALUResult == 32'd0 &&
                        dut.RD2       == 32'd12,
                        "sw x3, 0(x0) failed"
                    );
                end

                32'd32: begin
                    check_value(
                        dut.Instr    == 32'h00002403 &&
                        dut.MemWrite == 1'b0 &&
                        dut.ReadData == 32'd12 &&
                        dut.Result   == 32'd12 &&
                        dut.RegWrite == 1'b1,
                        "lw x8, 0(x0) failed"
                    );
                end

                32'd36: begin
                    check_value(
                        dut.Instr  == 32'h00340463 &&
                        dut.zero   == 1'b1 &&
                        dut.PCSrc  == 1'b1 &&
                        dut.PCNext == 32'd44,
                        "beq failed"
                    );
                end

                32'd40: begin
                    errors = errors + 1;
                    $display("ERROR: beq did not skip PC=40");
                end

                32'd44: begin
                    check_value(
                        dut.Instr    == 32'h0080056f &&
                        dut.PCSrc    == 1'b1 &&
                        dut.PCNext   == 32'd52 &&
                        dut.Result   == 32'd48 &&
                        dut.RegWrite == 1'b1,
                        "jal failed"
                    );
                end

                32'd48: begin
                    errors = errors + 1;
                    $display("ERROR: jal did not skip PC=48");
                end

                32'd52: begin
                    check_value(
                        dut.Instr     == 32'hffa50613 &&
                        dut.ALUResult == 32'd42 &&
                        dut.Result    == 32'd42 &&
                        dut.RegWrite  == 1'b1,
                        "jal link register or final addi failed"
                    );
                end

                default: begin
                    errors = errors + 1;
                    $display(
                        "ERROR: unexpected or unknown PC = 0x%08h",
                        dut.PC
                    );
                end

            endcase

            @(negedge clk);
            #1;
        end

        check_value(
            dut.PC     == 32'd56 &&
            dut.Instr  == 32'h0000006f &&
            dut.PCNext == 32'd56,
            "final loop failed"
        );

        if (cycles >= 30) begin
            errors = errors + 1;
            $display("ERROR: simulation timeout");
        end

        if (errors == 0)
            $display(
                "PASS: complete CPU datapath works in %0d cycles",
                cycles
            );
        else
            $display(
                "FAIL: %0d error(s)",
                errors
            );

        $finish;
    end

endmodule