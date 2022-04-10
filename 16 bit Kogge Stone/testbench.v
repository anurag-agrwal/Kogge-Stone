`timescale 1ns/1ps
module testbench();

parameter N=16;

reg [N-1:0] A, B;
reg Cin;

wire [N:0] Sum;
reg [N:0] expected;

Kogge dut_instance (.A(A), .B(B), .Cin(Cin), .Sum(Sum));

integer i;

initial begin
		
	for (i=0; i<1000001; i=i+1)
		begin
			A = $random;
			B = $random;
			Cin = $random % 2;
				
			expected = A + B + Cin;
			#2;
				
				if(Sum !== expected)
					begin
						$display("Error: Sum is wromg!");
						$stop;
					end
		end
end


endmodule
