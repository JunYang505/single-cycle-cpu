module ControlUnit (
    input logic [31:0]Instr,
    input logic zero,

    output logic PCSrc,
    output logic [1:0]ResultSrc,
    output logic MemWrite,
    output logic [2:0]ALUControl,
    output logic ALUSrc,
    output logic [1:0]ImmSrc,
    output logic RegWrite
);

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic       funct7b5;

    assign opcode   = Instr[6:0];
    assign funct3   = Instr[14:12];
    assign funct7b5 = Instr[30];

    always_comb begin 
        PCSrc     = 1'b0;
        ResultSrc = 2'b00;
        MemWrite  = 1'b0;
        ALUControl = 3'b000;
        ALUSrc    = 1'b0;
        ImmSrc    = 2'b00;
        RegWrite  = 1'b0;

        case (opcode)
        7'b0110011: //type R
            case (funct3)
                3'b000:
                    case (funct7b5) 
                        1'b0: begin//add
                            PCSrc = 1'b0;
                            ResultSrc = 2'b00;
                            MemWrite = 1'b0;
                            ALUControl = 3'b000;
                            ALUSrc = 1'b0;
                            ImmSrc = 2'b00;
                            RegWrite = 1'b1; end

                        1'b1: begin//sub
                            PCSrc = 1'b0;
                            ResultSrc = 2'b00;
                            MemWrite = 1'b0;
                            ALUControl = 3'b001;
                            ALUSrc = 1'b0;
                            ImmSrc = 2'b00;
                            RegWrite = 1'b1; end

                        default: begin
                            PCSrc = 1'b0;
                            ResultSrc = 2'b00;
                            MemWrite = 1'b0;
                            ALUControl = 3'b000;
                            ALUSrc = 1'b0;                     
                            ImmSrc = 2'b00;
                            RegWrite = 1'b0; end

                    endcase 

                /*3'b001:
                3'b010:
                3'b011:
                */3'b100: begin//xor
                    PCSrc = 1'b0;
                    ResultSrc = 2'b00;
                    MemWrite = 1'b0;
                    ALUControl = 3'b100;
                    ALUSrc = 1'b0;                 
                    ImmSrc = 2'b00;
                    RegWrite = 1'b1; end


                //3'b101:
                3'b110: begin//or
                    PCSrc = 1'b0;
                    ResultSrc = 2'b00;
                    MemWrite = 1'b0;
                    ALUControl = 3'b011;
                    ALUSrc = 1'b0;                        
                    ImmSrc = 2'b00;
                    RegWrite = 1'b1; end

                3'b111: begin//and
                   PCSrc = 1'b0;
                    ResultSrc = 2'b00;
                    MemWrite = 1'b0;
                    ALUControl = 3'b010;
                    ALUSrc = 1'b0;                       
                    ImmSrc = 2'b00;
                    RegWrite = 1'b1; end

            endcase

        7'b0010011: begin//addi
            PCSrc = 1'b0;
            ResultSrc = 2'b00;
            MemWrite = 1'b0;
            ALUControl = 3'b000;
            ALUSrc = 1'b1;                       
            ImmSrc = 2'b00;
            RegWrite = 1'b1; end


        7'b0000011: begin//lw
            PCSrc = 1'b0;
            ResultSrc = 2'b01;
            MemWrite = 1'b0;
            ALUControl = 3'b000;
            ALUSrc = 1'b1;                        
            ImmSrc = 2'b00;
            RegWrite = 1'b1; end

        7'b0100011: begin//sw
            PCSrc = 1'b0;
            ResultSrc = 2'b00;
            MemWrite = 1'b1;
            ALUControl = 3'b000;
            ALUSrc = 1'b1;                        
            ImmSrc = 2'b01;
            RegWrite = 1'b0; end



        7'b1100011: begin//beq
            PCSrc = zero;
            ResultSrc = 2'b00;
            MemWrite = 1'b0;
            ALUControl = 3'b001;
            ALUSrc = 1'b0;                        
            ImmSrc = 2'b10;
            RegWrite = 1'b0; end



        7'b1101111: begin//jal
            PCSrc = 1'b1;
            ResultSrc = 2'b10;
            MemWrite = 1'b0;
            ALUControl = 3'b000;
            ALUSrc = 1'b0;                        
            ImmSrc = 2'b11;
            RegWrite = 1'b1; end


        default: begin
            PCSrc = 1'b0;
            ResultSrc = 2'b00;
            MemWrite = 1'b0;
            ALUControl = 3'b000;
            ALUSrc = 1'b0;                     
            ImmSrc = 2'b00;
            RegWrite = 1'b0; end

        endcase

    end

endmodule