// =============================================================================
// Filename: bk_adder_24_tb.v
// -----------------------------------------------------------------------------
// This file exports the testbench for cla_64bit.
// =============================================================================

`timescale 1 ns / 1 ps

module bk_adder_24bit_tb;

// ----------------------------------
// Interface of the module
// ----------------------------------
reg		[23:0]	a, b;
reg 			cin;
wire 	[23:0]	sum;
wire			cout;

wire 	[23:0]	sum_ref;
wire            cout_ref;
// ----------------------------------
// Instantiate the module
// ----------------------------------
bk_adder_24bit uut (
	.a(a),
	.b(b), 
	.cin(cin), 
	.sum(sum),
	.cout(cout)
);

assign {cout_ref, sum_ref} = a + b + cin;
// ----------------------------------
// Input stimulus
// ----------------------------------
initial begin
	$display("qwangdh's brent-kung adder simulation and test is beginning...");
	a    = 24'd98;
	b    = 24'd48;
	cin  = 1'b0;
	#10;
	$display("%0d + %0d + %0d: sum = %0d, cout = %0d, sum should be %0d, cout should be %0d.", a, b, cin, sum, cout, sum_ref, cout_ref);

	// Input stimulus 2: 538+34849+1
	a    = 24'd538;
	b    = 24'd34849;
	cin  = 1'b1;
	#10;
	$display("%0d + %0d + %0d: sum = %0d, cout = %0d, sum should be %0d, cout should be %0d.", a, b, cin, sum, cout, sum_ref, cout_ref);

	// Input stimulus 3: 65793+8723+0
	a    = 24'd65793;
	b    = 24'd8723;
	cin  = 1'b0;
	#10;
	$display("%0d + %0d + %0d: sum = %0d, cout = %0d, sum should be %0d, cout should be %0d.", a, b, cin, sum, cout, sum_ref, cout_ref);

	// Input stimulus 4:2746128+2141202+1
	a    = 24'd2746128;
	b    = 24'd2141202;
	cin  = 1'b1;
	#10;
	$display("%0d + %0d + %0d: sum = %0d, cout = %0d, sum should be %0d, cout should be %0d.", a, b, cin, sum, cout, sum_ref, cout_ref);

	// Input stimulus 5: 34335808+284399+0
	a    = 24'd34335808;
	b    = 24'd284399;
	cin  = 1'b0;
	#10;
	$display("%0d + %0d + %0d: sum = %0d, cout = %0d, sum should be %0d, cout should be %0d.", a, b, cin, sum, cout, sum_ref, cout_ref);

	$finish;
end

endmodule
