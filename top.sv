module top (
    input logic clk,
    input logic reset
);

    logic [31:0] PC;
    logic [31:0] PCNext;
    logic [31:0] PCPlus4;
    logic [31:0] PCTarget;

    logic [31:0] Instr;

    logic [31:0] RD1;
    logic [31:0] RD2;
    logic [31:0] WD3;

    logic [31:0] ImmExt;

    logic [31:0] SrcA;
    logic [31:0] SrcB;
    logic [31:0] ALUResult;
    logic zero;

    logic [31:0] ReadData;

    logic RegWrite;
    logic MemWrite;
    logic ALUSrc;
    logic PCSrc;

    logic [1:0] ImmSrc;
    logic [1:0] ResultSrc;
    logic [2:0] ALUControl;


    PCadd pc_adder (
        .PC(),
        .PCPlus4()
    );


    InstructionMemory instruction_memory (
        .A(),
        .RD()
    );


    ControlUnit control_unit (
        .Instr(),
        .zero(),
        .PCSrc(),
        .ResultSrc(),
        .MemWrite(),
        .ALUControl(),
        .ALUSrc(),
        .ImmSrc(),
        .RegWrite()
    );


    RegisterFile register_file (
        .clk(),
        .WE3(),
        .A1(),
        .A2(),
        .A3(),
        .WD3(),
        .RD1(),
        .RD2()
    );


    Extend extend_unit (
        .Instr(),
        .ImmSrc(),
        .ImmExt()
    );


    ALU alu (
        .SrcA(),
        .SrcB(),
        .ALUControl(),
        .ALUresult(),
        .zero()
    );


    DataMemory data_memory (
        .clk(),
        .WE(),
        .A(),
        .WD(),
        .RD()
    );


endmodule
