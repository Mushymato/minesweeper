module fibo(
	input [3:0] KEY,
	output [9:0] LEDR
);
	wire [7:0] next;
	reg [7:0] idx;
	integer count;
	
	assign LEDR = idx;
	
	fibonacci_lfsr_nbit f (
		.clock(KEY[1]),
		.reset(KEY[0]),
		.data(next)
	);
	
	always @(posedge KEY[1]) begin
		if(!KEY[0]) begin
			idx <= 0;
			count <= 9;
		end else if(~KEY[2]) begin
			count <= 9;
		end else if(count > 0) begin
			count <= count - 1;
			idx <= (next > 8'd80) ? next >> 1'b1: next;
		end
	end

endmodule

//https://stackoverflow.com/a/20145147
module fibonacci_lfsr_nbit
   #(parameter BITS = 8)
   (
    input             clock,
    input             reset,

    output reg [7:0] data
    );

   reg [7:0] data_next;
   always @(*) begin
      data_next = data;
      repeat(BITS) begin
         data_next = {(data_next[7]^data_next[5]^data_next[4]^data_next[3]), data_next[7:1]};
      end
   end

   always @(posedge clock) begin
		if(!reset) begin
			data <= 8'h1f;
		end else begin
			data <= data_next;
		end
	end

endmodule

