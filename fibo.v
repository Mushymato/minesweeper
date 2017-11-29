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
