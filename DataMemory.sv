module DataMemory (

    input logic WE,
    input logic clk,

    input logic [31:0]A,
    input logic [31:0]WD,

    output logic [31:0]RD

);

    logic [31:0] memory [0:255];

    always_ff @( posedge clk ) begin
        if (WE)
            memory[A/4] <= WD;      
    end

    assign RD = memory[A/4];
endmodule