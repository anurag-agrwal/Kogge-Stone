`timescale 1ns/1ps
module testbench();

parameter N = 4;

reg [N-1:0] A, B;
reg Cin;
wire [N:0] Sum;
reg [N:0] expected;

Kogge dut_instance (.A(A), .B(B), .Cin(Cin), .Sum(Sum));

integer i;

initial begin

	for (i=0; i<2**(2*N+1); i=i+1)
		begin
			{Cin, B, A} = i;
			
			expected = A + B + Cin;
			#10;
			
			if(Sum !== expected)
				begin
					$display("Error: Sum is wrong");
					$stop;
				end
		end
end

endmodule
