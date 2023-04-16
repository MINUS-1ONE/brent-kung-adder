// =============================================================================
// Filename: cla_adder_64bit.v
// -----------------------------------------------------------------------------
// This file implements a hierarchical 64-bit carry-look-ahead (CLA) adder.
// =============================================================================


// ----------------------------------------------------
// Part I: 64-bit CLA adder
// ----------------------------------------------------
// TODO: please implement 64-bit CLA adder here
module cla_64bit(
	input wire	[63:0]	a,
	input wire	[63:0]	b, 
	input wire			cin, 
	output wire	[63:0]	sum,
	output wire			cout
);

wire [3:0] p, g;	// internal variables
wire [4:0] c;		// carry

assign c[0] = cin;
assign cout = c[4];

// four 16bit adder with Carry Look Ahead(CLA)
cla_16bit a4_0(.a(a[15:0]), .b(b[15:0]), .cin(c[0]), .pg(p[0]), .gg(g[0]), .sum(sum[15:0]));
cla_16bit a4_1(.a(a[31:16]), .b(b[31:16]), .cin(c[1]), .pg(p[1]), .gg(g[1]), .sum(sum[31:16]));
cla_16bit a4_2(.a(a[47:32]), .b(b[47:32]), .cin(c[2]), .pg(p[2]), .gg(g[2]), .sum(sum[47:32]));
cla_16bit a4_3(.a(a[63:48]), .b(b[63:48]), .cin(c[3]), .pg(p[3]), .gg(g[3]), .sum(sum[63:48]));

// carry look ahead unit
clu clu_64(.p(p), .g(g), .c0(c[0]), .pg(pg), .gg(gg), .cout(c[4:1]));
 
endmodule


// ----------------------------------------------------
// Part II: 16-bit CLA adder
// ----------------------------------------------------
module cla_16bit(
	input wire	[15:0]	a,		// operator 1
	input wire	[15:0]	b, 		// operator 2
	input wire			cin, 	// carry in
	output wire	[15:0]	sum,	// sum
	output wire			cout,	// carry out
	output wire			pg,		// group propagate
	output wire			gg		// group generate
);

wire [3:0] p, g;	// internal variables
wire [4:0] c;		// carry

assign c[0] = cin;
assign cout = c[4];

// four 4bit adder with Carry Look Ahead(CLA)
cla_4bit a4_0(.a(a[3:0]), .b(b[3:0]), .cin(c[0]), .pg(p[0]), .gg(g[0]), .sum(sum[3:0]));
cla_4bit a4_1(.a(a[7:4]), .b(b[7:4]), .cin(c[1]), .pg(p[1]), .gg(g[1]), .sum(sum[7:4]));
cla_4bit a4_2(.a(a[11:8]), .b(b[11:8]), .cin(c[2]), .pg(p[2]), .gg(g[2]), .sum(sum[11:8]));
cla_4bit a4_3(.a(a[15:12]), .b(b[15:12]), .cin(c[3]), .pg(p[3]), .gg(g[3]), .sum(sum[15:12]));

// carry look ahead unit
clu clu_16(.p(p), .g(g), .c0(c[0]), .pg(pg), .gg(gg), .cout(c[4:1]));

endmodule


// ----------------------------------------------------
// Part III: 4-bit CLA adder
// ----------------------------------------------------
module cla_4bit(
	input wire	[3:0]	a,			// operator 1
	input wire	[3:0]	b, 			// operator 2
	input wire			cin, 		// carry in
	output wire	[3:0]	sum,		// sum
	output wire			cout,		// carry out
	output wire 		pg, 		// group propagate
	output wire			gg			// group generate
);

 
wire [3:0] p,g; 	// internal variables
wire [4:0] c;		// carry
 
assign p = a^b;		//propagate
assign g = a&b; 	//generate
 
assign c[0] = cin;
assign cout = c[4];

clu clu_4(.p(p), .g(g), .c0(c[0]), .pg(pg), .gg(gg), .cout(c[4:1]));

assign sum = p^c;

endmodule

// ----------------------------------------------------
// Part IV: carry look-ahead unit
// ----------------------------------------------------
module clu(
	input wire	[3:0]	p,
	input wire	[3:0]	g,
	input wire			c0,		
	output wire			pg,		// group generate
	output wire			gg,		// group propagate
	output wire [4:1]	cout	// carrys C1 to C4
);

wire [4:0]	c;	// internal variables

assign cout = c[4:1];
assign pg = &p;
assign gg = g[3] | (g[2]&p[3]) | (g[1]&p[3]&p[2]) | (g[0]&p[3]&p[2]&p[1]);
assign c[1] = g[0] | (p[0]&c0);
assign c[2] = g[1] | (g[0]&p[1]) | (c0&p[0]&p[1]);
assign c[3] = g[2] | (g[1]&p[2]) | (g[0]&p[1]&p[2]) | (c0&p[0]&p[1]&p[2]);
assign c[4] = g[3] | (g[2]&p[3]) | (g[1]&p[2]&p[3]) | (g[0]&p[1]&p[2]&p[3]) | (c0&p[0]&p[1]&p[2]&p[3]);

endmodule

