https://stackoverflow.com/a/20145147
module fibonacci_lfsr_nbit
   #(parameter BITS = 8)
   (
    input             clk,
    input             rst_n,

    output reg [7:0] data
    );

   reg [7:0] data_next;
   always_comb begin
      data_next = data;
      repeat(BITS) begin
         data_next = {(data_next[7]^data_next[5]^data_next[4]^data_next[3]), data_next[7:1]};
      end
   end

   always_ff @(posedge clk or negedge reset) begin
      if(!rst_n)
         data <= 8'h1f;
      else
         data <= data_next;
      end
   end

endmodule
