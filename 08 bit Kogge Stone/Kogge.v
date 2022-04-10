// 8-bit Kogge Stone

module Kogge(A,B,Cin,Sum);

parameter N=8;

input [N-1:0] A, B;
input Cin;
output [N:0] Sum;

wire [N:0] C;
wire [N-1:0] S;

wire P[4:1][N-1:-N/2];
wire G[4:1][N-1:-N/2];

// Initialize with 1, so that we can use then in P,G generation in next stages
// These lines are written to help bypassing the P & G and not writing special code for them

genvar a1, a2;

generate
	for(a1=1; a1<4; a1=a1+1) begin: ini1			// from Stage 1 to 2nd last stage
		for(a2=-N/2; a2<0; a2=a2+1) begin: ini2		// all the negative indexes
			assign P[a1][a2] = 1'b1;
			assign G[a1][a2] = 1'b0;
		end
	end
endgenerate


assign C[0] = Cin;


// Stage-1

genvar i;

generate
	for(i=0; i<N; i=i+1) begin: stage1
		PG I1 (A[i], B[i], P[1][i], G[1][i]);		
	end
endgenerate


// Stage-2

genvar j;

generate
	for(j=0; j<N; j=j+1) begin: stage2B
		PG_Nx I2 (P[1][j], G[1][j], P[1][j-1], G[1][j-1], P[2][j], G[2][j]);
	end
endgenerate


// Stage-3

genvar k;

generate
	for(k=0; k<N; k=k+1) begin: stage3B
		PG_Nx I3 (P[2][k], G[2][k], P[2][k-2], G[2][k-2], P[3][k], G[3][k]);
	end
endgenerate


// Stage-4

genvar q;

generate
	for(q=0; q<N; q=q+1) begin: stage4B
		PG_Nx I4 (P[3][q], G[3][q], P[3][q-4], G[3][q-4], P[4][q], G[4][q]);
	end
endgenerate


// Carry

genvar r;

generate
	for(r=0; r<N; r=r+1) begin: carry
		assign C[r+1] = G[4][r] | (P[4][r] & C[0]);
	end
endgenerate


// Sum

genvar s;

generate
	for(s=0; s<N; s=s+1) begin: sum
		assign S[s] = P[1][s] ^ C[s];
	end
endgenerate

assign Sum = {C[N],S};

endmodule



module PG (A, B, P, G);
input A, B;
output reg P, G;

always@(*)
	begin
		P = A ^ B;
		G = A & B;
	end
endmodule

module PG_Nx (P_1, G_1, P_2, G_2, P, G);
input P_1, G_1, P_2, G_2;
output reg P, G;

always@(*)
	begin
		P = P_1 & P_2;				// P_i . P_{i-1}
		G = (P_1 & G_2) | G_1;		// (G_i + (P_i . G_{i-1}))
	end
endmodule
