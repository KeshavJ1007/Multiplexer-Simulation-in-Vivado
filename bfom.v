module bfom(I,S,Y);
    input wire [0:3] I;
    input wire [1:0] S;
    output reg Y;
    always @(*) begin
        case (S)
            2'b00: Y = I[0];
            2'b01: Y = I[1];
            2'b10: Y = I[2];
            2'b11: Y = I[3];
            default: Y = 1'b0;
        endcase
    end
endmodule