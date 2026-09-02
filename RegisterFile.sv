module RegisterFile(
    input logic WE3,
    input logic clk,

    input logic [4:0]A1,
    input logic [4:0]A2,
    input logic [4:0]A3,
    
    input logic [31:0]WD3,

    output logic [31:0]RD1,
    output logic [31:0]RD2

); 
    
    logic [31:0] registers [0:31];

    always_ff @(posedge clk) begin
        if (WE3 && A3 != 0)
        registers[A3] <= WD3;
    end

    assign RD1 = ( A1 == 0 ) ? 0 : registers[A1];
    assign RD2 = ( A2 == 0 ) ? 0 : registers[A2];


endmodule