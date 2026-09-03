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
    logic [31:0] Result;

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

    always_ff @(posedge clk) begin
    if (reset)
        PC <= 32'd0;
    else
        PC <= PCNext;
end

    assign PCTarget = PC + ImmExt;
    assign PCNext = (PCSrc == 0) ? PCPlus4 : PCTarget;
    assign SrcB = (ALUSrc == 0) ? RD2 : ImmExt;
    

    PCadd pc_adder (
        .PC(PC),
        .PCPlus4(PCPlus4)
    );


    InstructionMemory instruction_memory (
        .A(PC),
        .RD(Instr)
    );


    ControlUnit control_unit (
        .Instr(Instr),
        .zero(zero),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUControl(ALUControl),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite)
    );


    RegisterFile register_file (
        .clk(clk),
        .WE3(RegWrite),
        .A1(Instr[19:15]),
        .A2(Instr[24:20]),
        .A3(Instr[11:7]),
        .WD3(Result),
        .RD1(RD1),
        .RD2(RD2)
    );
    
    assign SrcA = RD1;

    Extend extend_unit (
        .Instr(Instr[31:7]),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );


    ALU alu (
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUControl(ALUControl),
        .ALUresult(ALUResult),
        .zero(zero)
    );


    DataMemory data_memory (
        .clk(clk),
        .WE(MemWrite),
        .A(ALUResult),
        .WD(RD2),
        .RD(ReadData)
    );

    always_comb begin
        Result = 32'b0;
        case (ResultSrc) 
            2'b00: Result = ALUResult; 
            2'b01: Result = ReadData;
            2'b10: Result = PCPlus4;
            //2'b11:

            default: Result = 32'b0;
        endcase
    end

endmodule
