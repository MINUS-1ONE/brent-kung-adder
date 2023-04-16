module bk_adder_24bit (
    input  wire [23:0] a   ,
    input  wire [23:0] b   ,
    input  wire        cin ,
    output wire [23:0] sum ,
    output wire        cout
);
    
    wire p_cin;
    wire g_cin;
    wire p0_init;
    wire g0_init;

    wire [23:0] p;
    wire [23:0] g;

    wire [11:0] p_level1;
    wire [11:0] g_level1;

    wire [5:0] p_level2;
    wire [5:0] g_level2;

    wire [2:0] p_level3;
    wire [2:0] g_level3;

    wire p_level4;
    wire g_level4;

    wire p_level5;
    wire g_level5;

    wire [1:0] p_level6;
    wire [1:0] g_level6;

    wire [4:0] p_level7;
    wire [4:0] g_level7;

    wire [10:0] p_level8;
    wire [10:0] g_level8;

// generator P[23:0] G[23:0]
    
    
    assign p_cin = 1'b0;
    assign g_cin = cin;

    pg_gen i_pg_gen_0 (
        .a_i(a[0]),
        .b_i(b[0]),
        .p_i(p0_init),
        .g_i(g0_init)
    );

    pg_node i_pg_node_level0 (
        .p_1  (p_cin),
        .g_1  (g_cin),
        .p_2  (p0_init),
        .g_2  (g0_init),
        .p_out(p[0]),
        .g_out(g[0])
    );

    genvar i;
    generate
        for(i=1; i<24; i=i+1) begin
            pg_gen i_pg_gen (
                .a_i(a[i]), 
                .b_i(b[i]), 
                .p_i(p[i]), 
                .g_i(g[i])
            );
        end
    endgenerate

// level1 pg
    generate
        for(i=0; i<12; i=i+1) begin
            pg_node i_pg_node_level1 (
                .p_1(p[i*2]), 
                .g_1(g[i*2]), 
                .p_2(p[i*2 + 1]), 
                .g_2(g[i*2 + 1]), 
                .p_out(p_level1[i]), 
                .g_out(g_level1[i])
            );
 
        end
    endgenerate

// level2 pg
    generate
        for(i=0; i<6; i=i+1) begin
            pg_node i_pg_node_level2 (
                .p_1  (p_level1[i*2]),
                .g_1  (g_level1[i*2]),
                .p_2  (p_level1[i*2 + 1]),
                .g_2  (g_level1[i*2 + 1]),
                .p_out(p_level2[i]),
                .g_out(g_level2[i])
            );
        end
    endgenerate

// level3 pg 
    generate
        for(i=0; i<3; i=i+1) begin
            pg_node i_pg_node_level3 (
                .p_1  (p_level2[i*2]),
                .g_1  (g_level2[i*2]),
                .p_2  (p_level2[i*2 + 1]),
                .g_2  (g_level2[i*2 + 1]),
                .p_out(p_level3[i]),
                .g_out(g_level3[i])
            );
        end
    endgenerate

// level4 pg -> bit 15
    pg_node i_pg_node_level4 (
        .p_1  (p_level3[0]),
        .g_1  (g_level3[0]),
        .p_2  (p_level3[1]),
        .g_2  (g_level3[1]),
        .p_out(p_level4),
        .g_out(g_level4)
    );

// level5 pg -> bit 23
    pg_node i_pg_node_level5 (
        .p_1  (p_level4),
        .g_1  (g_level4),
        .p_2  (p_level3[2]),
        .g_2  (g_level3[2]),
        .p_out(p_level5),
        .g_out(g_level5)
    );

// level6 pg
    wire [1:0] p_level6_in_1;
    wire [1:0] g_level6_in_1;

    assign p_level6_in_1[0] = p_level3[0];
    assign g_level6_in_1[0] = g_level3[0];
    assign p_level6_in_1[1] = p_level4;
    assign g_level6_in_1[1] = g_level4;

    generate
        for(i=0; i<2; i=i+1) begin
            pg_node i_pg_node_level6 (
                .p_1  (p_level6_in_1[i]),
                .g_1  (g_level6_in_1[i]),
                .p_2  (p_level2[i*2+2]), // 2 or 4
                .g_2  (g_level2[i*2+2]), // 2 or 4
                .p_out(p_level6[i]),
                .g_out(g_level6[i])
            );
        end
    endgenerate

// level7 pg
    wire [4:0] p_level7_in_1;
    wire [4:0] g_level7_in_1;

    assign p_level7_in_1[0] = p_level2[0];
    assign g_level7_in_1[0] = g_level2[0];
    assign p_level7_in_1[1] = p_level3[0];
    assign g_level7_in_1[1] = g_level3[0];
    assign p_level7_in_1[2] = p_level6[0];
    assign g_level7_in_1[2] = g_level6[0];
    assign p_level7_in_1[3] = p_level4;
    assign g_level7_in_1[3] = g_level4;
    assign p_level7_in_1[4] = p_level6[1];
    assign g_level7_in_1[4] = g_level6[1];

    generate
        for(i=0; i<5; i=i+1) begin
            pg_node i_pg_node_level7 (
                .p_1  (p_level7_in_1[i]),
                .g_1  (g_level7_in_1[i]),
                .p_2  (p_level1[i*2 + 2]), // level1 2/4/6/8/10
                .g_2  (g_level1[i*2 + 2]),
                .p_out(p_level7[i]),
                .g_out(g_level7[i])
            );
        end
    endgenerate

// level8 pg
    wire [10:0] p_level8_in_1;
    wire [10:0] g_level8_in_1;

    assign p_level8_in_1[0] = p_level1[0];
    assign g_level8_in_1[0] = g_level1[0];
    assign p_level8_in_1[1] = p_level2[0];
    assign g_level8_in_1[1] = g_level2[0];
    assign p_level8_in_1[2] = p_level7[0];
    assign g_level8_in_1[2] = g_level7[0];
    assign p_level8_in_1[3] = p_level3[0];
    assign g_level8_in_1[3] = g_level3[0];
    assign p_level8_in_1[4] = p_level7[1];
    assign g_level8_in_1[4] = g_level7[1];
    assign p_level8_in_1[5] = p_level6[0];
    assign g_level8_in_1[5] = g_level6[0];
    assign p_level8_in_1[6] = p_level7[2];
    assign g_level8_in_1[6] = g_level7[2];
    assign p_level8_in_1[7] = p_level4;
    assign g_level8_in_1[7] = g_level4;
    assign p_level8_in_1[8] = p_level7[3];
    assign g_level8_in_1[8] = g_level7[3];
    assign p_level8_in_1[9] = p_level6[1];
    assign g_level8_in_1[9] = g_level6[1];
    assign p_level8_in_1[10] = p_level7[4];
    assign g_level8_in_1[10] = g_level7[4];

    generate
        for(i=0; i<11; i=i+1) begin
            pg_node i_pg_node_level8 (
                .p_1  (p_level8_in_1[i]),
                .g_1  (g_level8_in_1[i]),
                .p_2  (p[i*2 + 2]), // p 2/4/6/8/10/12/14/16/18/20/22
                .g_2  (g[i*2 + 2]),
                .p_out(p_level8[i]),
                .g_out(g_level8[i])
            );
        end
    endgenerate


// Sum and Cout generate
    wire [23:0] p_end;
    wire [23:0] g_end;
    wire [23:0] c_i;

    generate
        for(i=0; i<11; i=i+1) begin
            assign p_end[i*2 + 2] = p_level8[i];
            assign g_end[i*2 + 2] = g_level8[i];
        end
        for(i=0; i<5; i=i+1) begin
            assign p_end[i*4 + 5] = p_level7[i];
            assign g_end[i*4 + 5] = g_level7[i];
        end
        for(i=0; i<2; i=i+1) begin
            assign p_end[i*8 + 11] = p_level6[i];
            assign g_end[i*8 + 11] = g_level6[i];
        end
    endgenerate

    assign p_end[23] = p_level5;
    assign g_end[23] = g_level5;
    
    assign p_end[15] = p_level4;
    assign g_end[15] = g_level4;

    assign p_end[7] = p_level3[0];
    assign g_end[7] = g_level3[0];

    assign p_end[3] = p_level2[0];
    assign g_end[3] = g_level2[0];

    assign p_end[1] = p_level1[0];
    assign g_end[1] = g_level1[0];

    assign p_end[0] = p[0];
    assign g_end[0] = g[0];

// c[i] = G[i]
     assign c_i[23:0] = g_end[23:0];

    assign sum[0] = p0_init ^ cin;

    generate
        for(i=1; i<24; i=i+1) begin
            assign sum[i] = p[i] ^ c_i[i-1];
        end
    endgenerate

    assign cout = c_i[23];

endmodule


// pg_gen module for generate p & g by original input number A & B
module pg_gen (
    input wire a_i,
    input wire b_i,
    output wire p_i,
    output wire g_i
);

    assign p_i = a_i ^ b_i;
    assign g_i = a_i & b_i;

endmodule

// pg_node module for p' & g' merge with p'' & g'' to generate p & g of next level
module pg_node (
    input  wire p_1  ,
    input  wire g_1  ,
    input  wire p_2  ,
    input  wire g_2  ,
    output wire p_out,
    output wire g_out
);

    assign p_out = p_2 & p_1;
    assign g_out = g_2 | (g_1 & p_2);


endmodule