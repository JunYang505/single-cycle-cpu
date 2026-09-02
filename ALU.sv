module ALU (
    input logic [31:0] SrcA,
    input logic [31:0] SrcB,
    input logic [2:0] ALUControl,

    output logic [31:0] ALUresult,
    output logic zero
);

    always_comb begin 
        case (ALUControl)
            3'b000: ALUresult = SrcA + SrcB;
            3'b001: ALUresult = SrcA - SrcB;
            3'b010: ALUresult = SrcA & SrcB;
            3'b011: ALUresult = SrcA | SrcB;
            3'b100: ALUresult = SrcA ^ SrcB;
            /*
            3'b101: ALUresult = ;
            3'b110: ALUresult = ;
            3'b111: ALUresult = ;
            */
            default: ALUresult = 0;
        endcase
    end

    assign zero = (ALUresult == 0);


endmodule

