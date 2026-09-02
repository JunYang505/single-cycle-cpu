module ALU_tb ();
    logic [31:0] SrcA;
    logic [31:0] SrcB;
    logic [2:0] ALUControl;

    logic [31:0] ALUresult;
    logic zero;

    integer errors;
        
    ALU dut (
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUControl(ALUControl),
        .ALUresult(ALUresult),
        .zero(zero)
    );

    initial begin
        errors = 0;

        SrcA = 32'd10;
        SrcB = 32'd5;
        ALUControl = 3'b000;
        #10;
        if (ALUresult !== 32'd15 || zero !== 1'b0)
            errors = errors + 1;

        SrcA = 32'd0;
        SrcB = 32'd0;
        ALUControl = 3'b000;
        #10;
        if (ALUresult !== 32'd0 || zero !== 1'b1)
            errors = errors + 1;

        SrcA = 32'hFFFFFFFF;
        SrcB = 32'd1;
        ALUControl = 3'b000;
        #10;
        if (ALUresult !== 32'h00000000 || zero !== 1'b1)
            errors = errors + 1;

        SrcA = 32'd10;
        SrcB = 32'd5;
        ALUControl = 3'b001;
        #10;
        if (ALUresult !== 32'd5 || zero !== 1'b0)
            errors = errors + 1;

        SrcA = 32'd5;
        SrcB = 32'd5;
        ALUControl = 3'b001;
        #10;
        if (ALUresult !== 32'd0 || zero !== 1'b1)
            errors = errors + 1;

        SrcA = 32'd0;
        SrcB = 32'd1;
        ALUControl = 3'b001;
        #10;
        if (ALUresult !== 32'hFFFFFFFF || zero !== 1'b0)
            errors = errors + 1;

        SrcA = 32'd12;
        SrcB = 32'd10;
        ALUControl = 3'b010;
        #10;
        if (ALUresult !== 32'd8 || zero !== 1'b0)
            errors = errors + 1;

        SrcA = 32'hFFFFFFFF;
        SrcB = 32'h00000000;
        ALUControl = 3'b010;
        #10;
        if (ALUresult !== 32'h00000000 || zero !== 1'b1)
            errors = errors + 1;

        SrcA = 32'h12345678;
        SrcB = 32'hFFFFFFFF;
        ALUControl = 3'b010;
        #10;
        if (ALUresult !== 32'h12345678 || zero !== 1'b0)
            errors = errors + 1;

        SrcA = 32'd12;
        SrcB = 32'd10;
        ALUControl = 3'b011;
        #10;
        if (ALUresult !== 32'd14 || zero !== 1'b0)
            errors = errors + 1;

        SrcA = 32'h00000000;
        SrcB = 32'h00000000;
        ALUControl = 3'b011;
        #10;
        if (ALUresult !== 32'h00000000 || zero !== 1'b1)
            errors = errors + 1;

        SrcA = 32'h12345678;
        SrcB = 32'hFFFFFFFF;
        ALUControl = 3'b011;
        #10;
        if (ALUresult !== 32'hFFFFFFFF || zero !== 1'b0)
            errors = errors + 1;

        $display("%0d", errors);
        $finish;
    end

endmodule