module InstructionMemory(

    input logic [31:0]A,

    output logic [31:0]RD
    
);

    logic [31:0] memory [0:255];

    initial begin
        $readmemh("program2.hex", memory);
    end

    assign RD = memory[A/4];

endmodule