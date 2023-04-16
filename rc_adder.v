// ripple carry adder 
module rc_adder_24bit (
    input  wire [23:0] a   ,
    input  wire [23:0] b   ,
    input  wire        cin ,
    output wire [23:0] sum ,
    output wire        cout
);

    wire [24:0] c_inter;

    assign c_inter[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 24; i=i+1) begin
            fulladder i_fa (
                .a   (a[i]),
                .b   (b[i]),
                .cin (c_inter[i]),
                .sum (sum[i]),
                .cout(c_inter[i+1])
            );
        end
    endgenerate

    assign cout = c_inter[24];

endmodule

module fulladder (
    input  wire a   ,
    input  wire b   ,
    input  wire cin ,
    output wire sum ,
    output wire cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a | b));

endmodule