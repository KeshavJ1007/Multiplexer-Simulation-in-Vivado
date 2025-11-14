module mux2to1a(A,B,S,Y);
    input A,B,S;
    output Y;    
    assign Y = (S) ? B : A;
endmodule

module sfom(I,S,Y);
    input [0:3]I;
    input [1:0]S;
    output Y;
    wire y1,y2;
    
    mux2to1a m1(.A(I[0]), .B(I[1]), .S(S[0]), .Y(y1));
    mux2to1a m2(.A(I[2]), .B(I[4]), .S(S[0]), .Y(y2));
    
    mux2to1a m3(.A(y1), .B(y1), .S(S[1]), .Y(Y));
    
endmodule    