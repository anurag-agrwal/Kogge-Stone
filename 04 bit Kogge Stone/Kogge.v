// 4 bit Kogge Stone

module Kogge (A,B,Cin,Sum);

parameter N = 4;

input [N-1:0] A, B;
input Cin;
output [N:0] Sum;

wire P[3:1][N-1:-N/2];
wire G[3:1][N-1:-N/2];

wire [N:0] C;
wire [N-1:0] S;

assign C[0] = Cin;


// Make the wires 1 for the next stages

genvar a1, a2;

generate 
	for (a1=1; a1<3; a1=a1+1) begin: ini1
		for (a2=-N/2; a2<0; a2=a2+1) begin: ini2
			assign P[a1][a2] = 1'b1;
			assign G[a1][a2] = 1'b0;
		end
	end
endgenerate



// Stage - 1

genvar i;

generate
	for (i=0; i<N; i=i+1) begin : stage1
		PG I1 (A[i], B[i], P[1][i], G[1][i]);
	end
endgenerate


// Stage - 2

genvar j;

generate
	for (j=0; j<N; j=j+1) begin : stage2
		PG_NX I2 (P[1][j], G[1][j], P[1][j-1], G[1][j-1], P[2][j], G[2][j]);
	end
endgenerate


// Stage - 3

genvar k;

generate
	for (k=0; k<4; k=k+1) begin : stage3
		PG_NX I3 (P[2][k], G[2][k], P[2][k-2], G[2][k-2], P[3][k], G[3][k]);
	end
endgenerate

// Carry
genvar m;

generate
	for(m=0; m<N; m=m+1) begin: carry
		assign C[m+1] = (P[3][m] & C[0]) | G[3][m];
	end
endgenerate

// Sum
genvar n;

generate
	for(n=0; n<N; n=n+1) begin : sum
		assign S[n] = P[1][n] ^ C[n];		
	end
endgenerate

assign Sum = {C[4],S};

endmodule


module PG(A, B, P, G);
input A, B;
output reg P, G;

always@(*)
begin
	P = A ^ B;
	G = A & B;
end
endmodule


module PG_NX(P_1, G_1, P_2, G_2, P, G);
input P_1, G_1, P_2, G_2;
output reg P,G;

always@(*)
begin
	P = P_1 & P_2;				// P_i . P_{i-1}
	G = (P_1 & G_2) | G_1;		// (G_i + (P_i . G_{i-1}))
end
endmodule




////4 bit Kogge Stone

// module Kogge (A,B,Cin,Sum);

// parameter N = 4;

// input [3:0] A, B;
// input Cin;
// output [4:0] Sum;

// wire P[3:1][N-1:0];
// wire G[3:1][N-1:0];

// wire [N:0] C;
// wire [N-1:0] S;

// assign C[0] = Cin;

////Stage - 1

// genvar i;

// generate
	// for (i=0; i<4; i=i+1) begin : stage1
		// assign P[1][i] = A[i] ^ B[i]; 
		// assign G[1][i] = A[i] & B[i];
	// end
// endgenerate


////Stage - 2

// genvar j;

// assign P[2][0] = P[1][0];
// assign G[2][0] = G[1][0];

// generate
	// for (j=1; j<4; j=j+1) begin : stage2
		
		// assign P[2][j] = P[1][j] & P[1][j-1];
		// assign G[2][j] = G[1][j] | (P[1][j] & G[1][j-1]);
		
	// end
// endgenerate


////Stage - 3

// genvar k;

// assign P[3][0] = P[2][0];
// assign G[3][0] = G[2][0];

// assign P[3][1] = P[2][1];
// assign G[3][1] = G[2][1];

// generate
	
	// for (k=2; k<4; k=k+1) begin : stage3
		// assign P[3][k] = P[2][k] & P[2][k-2];
		// assign G[3][k] = G[2][k] | (P[2][k] & G[2][k-2]);
		
	// end
// endgenerate

// assign C[1] = (P[1][0] & C[0]) | G[1][0];
// assign C[2] = (P[2][1] & C[0]) | G[2][1];
// assign C[3] = (P[3][2] & C[0]) | G[3][2];
// assign C[4] = (P[3][3] & C[0]) | G[3][3];


// genvar l;

// generate
	// for(l=0; l<4; l=l+1) begin : sum
		
		// assign S[l] = P[1][l] ^ C[l];
		
	// end
// endgenerate

// assign Sum = {C[4],S};

// endmodule
