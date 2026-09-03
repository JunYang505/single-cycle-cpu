module ControlUnit_tb ();

    logic [31:0] Instr;
    logic zero;

    logic RegWrite;
    logic [1:0] ImmSrc;
    logic ALUSrc;
    logic [2:0] ALUControl;
    logic MemWrite;
    logic [1:0] ResultSrc;
    logic PCSrc;

    integer errors;

    ControlUnit dut (
        .Instr(Instr),
        .zero(zero),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .ALUControl(ALUControl),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .PCSrc(PCSrc)
    );

    task check(
        input logic [31:0] instruction,
        input logic expectedzero,
        input logic expectedRegWrite,
        input logic [1:0] expectedImmSrc,
        input logic expectedALUSrc,
        input logic [2:0] expectedALUControl,
        input logic expectedMemWrite,
        input logic [1:0] expectedResultSrc,
        input logic expectedPCSrc
    );
        begin
            Instr = instruction;
            zero = expectedzero;
            #1;

            if ({
                RegWrite,
                ImmSrc,
                ALUSrc,
                ALUControl,
                MemWrite,
                ResultSrc,
                PCSrc
            } !== {
                expectedRegWrite,
                expectedImmSrc,
                expectedALUSrc,
                expectedALUControl,
                expectedMemWrite,
                expectedResultSrc,
                expectedPCSrc
            })
                errors = errors + 1;
        end
    endtask

    initial begin
        errors = 0;

        check(
            32'b0000000_00000_00000_000_00000_0110011,
            0, 1, 2'b00, 0, 3'b000, 0, 2'b00, 0
        );

        check(
            32'b0100000_00000_00000_000_00000_0110011,
            0, 1, 2'b00, 0, 3'b001, 0, 2'b00, 0
        );

        check(
            32'b0000000_00000_00000_111_00000_0110011,
            0, 1, 2'b00, 0, 3'b010, 0, 2'b00, 0
        );

        check(
            32'b0000000_00000_00000_110_00000_0110011,
            0, 1, 2'b00, 0, 3'b011, 0, 2'b00, 0
        );

        check(
            32'b0000000_00000_00000_100_00000_0110011,
            0, 1, 2'b00, 0, 3'b100, 0, 2'b00, 0
        );

        check(
            32'b000000000000_00000_000_00000_0010011,
            0, 1, 2'b00, 1, 3'b000, 0, 2'b00, 0
        );

        check(
            32'b000000000000_00000_010_00000_0000011,
            0, 1, 2'b00, 1, 3'b000, 0, 2'b01, 0
        );

        check(
            32'b0000000_00000_00000_010_00000_0100011,
            0, 0, 2'b01, 1, 3'b000, 1, 2'b00, 0
        );

        check(
            32'b0000000_00000_00000_000_00000_1100011,
            0, 0, 2'b10, 0, 3'b001, 0, 2'b00, 0
        );

        check(
            32'b0000000_00000_00000_000_00000_1100011,
            1, 0, 2'b10, 0, 3'b001, 0, 2'b00, 1
        );

        check(
            32'b00000000000000000000_00000_1101111,
            0, 1, 2'b11, 0, 3'b000, 0, 2'b10, 1
        );

        $display("%0d", errors);
        $finish;
    end

endmodule