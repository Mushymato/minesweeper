module display (
	input clock,
	input GRID_SIZE,

	output reg writeEn

);
endmodule


module drawEmptyBoard (
	input clock,
	input GRID_SIZE,
	output reg writeEn,
	output reg [7:0] x,
	output reg [6:0] y,
	output colour
);

	reg [1:0] c_state, n_state;
	localparam	S_DRAW_BOX		= 2'b00,
				S_SHIFT_X		= 2'b01,
				S_SHIFT_Y		= 2'b10;



	integer i = 0;

	always @(*) 
	begin: draw_states
		case(c_state)
			S_DRAW_BOX: begin
				if (i < GRID_SIZE) begin
					n_state = S_SHIFT_X;
				end
				else if (i == GRID_SIZE) begin
					n_state = S_SHIFT_Y;
				end

			end 
			S_SHIFT_X: begin
				n_state = S_DRAW_BOX;
				i = i + 1;
			end
			S_SHIFT_Y: begin
				i = 0;
				n_state = S_DRAW_BOX;
			end
		endcase
	end

	always @(*) 
	begin: registers


		
	end


endmodule

module drawBox (
	input clock,
	input [7:0]cur_x,
	input [6:0]cur_y,
	output reg [7:0]x,
	output reg [6:0]y,
	output reg [2:0]colour
);

	reg column = 7'd0;
	reg row = 6'd0;

	reg [1:0] c_state, n_state;
	localparam	S_DRAW_LINE		= 2'b00,
				S_DRAW_LR		= 2'b01;

	always @(posedge clock) begin
		if (row == 6'd0 | row == 6'd7) begin
			if (column < 7'd8) begin
				x <= cur_x + column;
				y <= cur_y;
				colour <= 3'b111;
				column <= column + 7'd1;
			end
			else begin
				row <= row + 6'd1;
				column <= cur_x;
			end
		end
		else if (row < 6'd7) begin
			if (column == 7'd0 | column == 7'd7) begin
				x <= cur_x + column;
				y <= cur_y;
				colour <= 3'b111;
				column <= column + 7'd1;
			end
			else if (column > 7'd7) begin
				row <= row + 6'd1;
				column <= cur_x;
			end
		end
	end
	

endmodule