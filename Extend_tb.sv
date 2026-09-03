module Extend_tb ();

    logic [31:7]Instr;
    logic [1:0]ImmSrc;
    logic [31:0]ImmExt;

    integer errors;

    Extend dut (
        .Instr(Instr),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );

      task test_i(input logic signed [31:0] value);
        begin
            Instr = '0;
            Instr[31:20] = value[11:0];
            ImmSrc = 2'b00;
            #1;

            if (ImmExt !== value)
                errors = errors + 1;
        end
    endtask

    task test_s(input logic signed [31:0] value);
        begin
            Instr = '0;
            Instr[31:25] = value[11:5];
            Instr[11:7] = value[4:0];
            ImmSrc = 2'b01;
            #1;

            if (ImmExt !== value)
                errors = errors + 1;
        end
    endtask

    task test_b(input logic signed [31:0] value);
        begin
            Instr = '0;
            Instr[31] = value[12];
            Instr[30:25] = value[10:5];
            Instr[11:8] = value[4:1];
            Instr[7] = value[11];
            ImmSrc = 2'b10;
            #1;

            if (ImmExt !== value)
                errors = errors + 1;
        end
    endtask

    task test_j(input logic signed [31:0] value);
        begin
            Instr = '0;
            Instr[31] = value[20];
            Instr[30:21] = value[10:1];
            Instr[20] = value[11];
            Instr[19:12] = value[19:12];
            ImmSrc = 2'b11;
            #1;

            if (ImmExt !== value)
                errors = errors + 1;
        end
    endtask

    initial begin
        errors = 0;

        test_i(-32'sd2048);
        test_i(32'sd2047);
        test_i(32'sd123);

        test_s(-32'sd2048);
        test_s(32'sd2047);
        test_s(32'sd321);

        test_b(-32'sd4096);
        test_b(32'sd4094);
        test_b(32'sd246);

        test_j(-32'sd1048576);
        test_j(32'sd1048574);
        test_j(32'sd123456);

        $display("%0d", errors);
        $finish;
    end

endmodule