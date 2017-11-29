module display #(
	parameter GRID_SIZE = 3,
	parameter SIZE = 4
	parameter STATE_SIZE = 4
)(
	input clock,
	input [GRID_SIZE*GRID_SIZE-1:0] bombGrid,
	input [GRID_SIZE*GRID_SIZE-1:0] revealGrid,
	input [GRID_SIZE*GRID_SIZE-1:0] cursorGrid,
	input reg [3:0] curr_state,
);
	wire [2:0] colour;


	integer p;
	reg [SIZE-1:0] x;
	reg [SIZE-1:0] y;

	reg [SIZE*(GRID_SIZE * GRID_SIZE)-1:0] ktox;
	reg [SIZE*(GRID_SIZE * GRID_SIZE)-1:0] ktoy;

	always @(*) begin
		p = GRID_SIZE * GRID_SIZE -1;
		for(i=0; i < GRID_SIZE; i=i+1) begin
			for(j=0; i < GRID_SIZE; j=j+1) begin
				ktox[(p+1)*SIZE-1:p*SIZE] <= i;
				ktoy[(p+1)*SIZE-1:p*SIZE] <= j;
				if(p == 0) begin
					break;
				end else begin
					p = p-1;
				end
			end
		end
	end

	genvar k;
	generate
		for(k = GRID_SIZE*GRID_SIZE-1; k >= 0; k = k+1) begin
			drawBox draw(
				.clock(clock),
				.d_enable(d_enable),
				.d_cursor(d_cursor)
			);
		end
		
	endgenerate


// 	reg draw_empty, draw_cursor, draw_reveal, draw_win, draw_lose, auto_reset;

// 	localparam	S_INIT		= 4'b0000,
// 				S_GAME		= 4'b0001,
// 				S_MOVE		= 4'b0010,
// 				S_MOVE_SET	= 4'b0011,
// 				S_REVEAL	= 4'b0100,
// 				S_WIN		= 4'b0101,
// 				S_LOSE		= 4'b0110;

// 	always @(*) 
// 	begin: check_states
// 		case(curr_state)
// 			S_INIT: begin
// 				drawEmpty <= 1'b1;
// 				draw_cursor <= 1'b0;
// 				draw_reveal <= 1'b0;
// 				draw_win <= 1'b0;
// 				draw_lose <= 1'b0;
// 			end
// 			S_GAME: begin
// 				drawEmpty <= 1'b0;
// 				draw_cursor <= 1'b1;
// 				draw_reveal <= 1'b0;
// 				draw_win <= 1'b0;
// 				draw_lose <= 1'b0;
// 			end
// 			S_MOVE: begin
// 				drawEmpty <= 1'b1;
// 				draw_cursor <= 1'b0;
// 			end
// 			S_MOVE_SET: begin
// 				drawEmpty <= 1'b0;
// 				draw_cursor <= 1'b1;
// 			end
// 			S_REVEAL: begin
// 				drawEmpty <= 1'b0;
// 				draw_cursor <= 1'b0;
// 				draw_reveal <= 1'b1;
// 			end
// 			S_WIN: begin
// 				draw_win <= 1'b1;
// 			end
// 			S_LOSE: begin
// 				draw_lose <= 1'b1;
// 			end
// 		endcase
// 	end


// 	wire plot_enable
// 	wire [7:0] box_x;
// 	wire [6:0] box_y;
// 	wire box_En;

// 	drawEmpty d0(
// 		.clock(clock),
// 		.draw_empty(draw_empty),
// 		.boxEn(box_En),
// 		.b_x(box_x),
// 		.b_y(box_y)
// 		);

// 	drawBox d1(
// 		.clock(clock),
// 		.box_Sig(box_En),
// 		.box_x(box_x),
// 		.box_y(box_y),
// 		.x_out(x),
// 		.y_out(y),
// 		.colour(colour),
// 		.plot_Sig(plot_enable)
// 		);

// endmodule
/*
module drawEmpty(
	input clock,
	input d_cursor,
	output reg boxEn,
	output reg [7:0] b_x,
	output reg [6:0] b_y,

);

	reg direction;
	assign direction = 1'b0;
	reg [7:0]curr_x;
	assign curr_x = 8'b0;
	reg [6:0] curr_y;
	assign curr_y = 7'b0;
	assign x = 8'b0;
	assign y = 7'b0;

	reg 

	always @(*) begin
		if (d_cursor) begin



			// if (direction == 0) begin
			// 	colour <= 3'b111;
			// 	if (curr_x < GRID_SIZE * BOX_SIZE) begin
			// 		if (curr_x == 0) begin
			// 			x <= x;
			// 		end
			// 		else begin
			// 			x <= x + 1'b1;
			// 		end
			// 		plotEn <= 1'b1;
			// 	end
			// 	else if (curr_y < GRID_SIZE * BOX_SIZE) begin
			// 		y <= y + 1'b1;
			// 		x <= 8'b0;
			// 	end
			// 	else begin
			// 		x <= 8'b0;
			// 		y <= 8'b0;
			// 		direction <= direction + 1'b1;
			// 	end
			// end
			// else begin
			// 					colour <= 3'b111;
			// 	if (curr_x < GRID_SIZE * BOX_SIZE) begin
			// 		if (curr_x == 0) begin
			// 			x <= x;
			// 		end
			// 		else begin
			// 			x <= x + 1'b1;
			// 		end
			// 		plotEn <= 1'b1;
			// 	end
			// 	else if (curr_y < GRID_SIZE * BOX_SIZE) begin
			// 		y <= y + 1'b1;
			// 		x <= 8'b0;
			// 	end
			// 	else begin
			// 		x <= 8'b0;
			// 		y <= 8'b0;
			// 		direction <= direction + 1'b1;
			// 	end
			// end
		end
	end

endmodule
*/

module drawBox#(
	parameter GRID_SIZE = 3,
	parameter SIZE = 4,
	parameter STATE_SIZE = 4
)(
	input clock,
	input d_enable,
	input d_cursor,
	input d_reveal,
	input resetn,
	input [SIZE-1:0] box_x,
	input [SIZE-1:0] box_y,
	input cursor_bit,
	input reveal_bit,
	input [3:0] state,
	output reg [7:0] x_out,
	output reg [6:0] y_out,
	output reg [2:0] colour,
	output plot_En
);
	


	reg [3:0] x_shift, y_shift;
	assign x_shift = 4'b0;
	assign y_shift = 4'b0;

	reg [48:0] bitmap;
	
	always @(*) begin
		case(state)
			4'd0: bitmap = 49'b0011100010001001100100101010010011001000100011100;
			4'd1: bitmap = 49'b0111110000100000010000001000000101000011000001000;
			4'd2: bitmap = 49'b0111110000010000010000010000010000001000100011100;
			4'd3: bitmap = 49'b0011100010001001000000011000010000001000100011100;
			4'd4: bitmap = 49'b0010000001000001111100010010001010000110000010000;
			4'd5: bitmap = 49'b0011100010001001000000011100000001000000100111110;
			4'd6: bitmap = 49'b0011100010001001000100011110000001000000100011100;
			4'd7: bitmap = 49'b0001000000100000010000010000001000001000000111110;
			4'd8: bitmap = 49'b0011100010001001000100011100010001001000100011100;
			4'd9: bitmap = 49'b0001000011111001111101111111011101001111100001000;
		endcase
	end

	reg [1:0] curr_state, n_state;
	localparam 	B_DRAW 			=4'b0000,
				B_X_SHIFT		=4'b0001,
				B_Y_SHIFT		=4'b0011,
				REST 			=4'b0100,
				C_X_SHIFT		=4'b0101,
				C_Y_SHIFT		=4'b0110,
				C_DRAW			=4'b0111;



// STATE TABLE
	always @(*) begin
		case (curr_state)
			REST: begin
				if (d_enable) begin
					if (d_cursor) begin
						n_state <= B_DRAW;
					end
					else if(d_reveal) begin
						n_state <= C_DRAW;
					end
					else begin
						n_state <= REST;
					end
				end
				else begin
					n_state <= REST;
				end
			end
			B_DRAW: begin
				if  (y_shift < 4'd8) begin
					n_state <= B_X_SHIFT;
				end
				else if(x_shift < 4'd8 ) begin
					n_state <= B_Y_SHIFT;
				end
				else begin
					n_state <= REST;
				end
			end
			B_X_SHIFT: n_state <= B_DRAW;
			B_Y_SHIFT: n_state <= B_DRAW;
			C_DRAW: begin
				if  (y_shift < 4'd7) begin
					n_state <= C_X_SHIFT;
				end
				else if(x_shift < 4'd7 ) begin
					n_state <= C_Y_SHIFT;
				end
				else begin
					n_state <= REST;
				end
			end
			C_X_SHIFT: n_state <= C_DRAW;
			C_Y_SHIFT: n_state <= C_DRAW;
			default: n_state <= REST;
	end


// ASSIGN STATES
	always @(posedge clock) begin
		if (!resetn) begin
			curr_state <= REST;
			x_shift <= 1'b0;
			y_shift <= 1'b0;
			plotEn <= 0;
		end
		else begin
			plotEn <= 0;
			case(curr_state)
				REST: begin
					x_shift <= 1'b0;
					y_shift <= 1'b0;
				end
				B_DRAW: begin
					x_out <= box_x + x_shift;
					y_out <= box_y + y_shift;
					colour <= cursor_bit ? 3'b001 : 3'b111;
					plotEn <= 1'b1;
				end
				B_X_SHIFT: begin
					if (y_shift > 4'd0 || y_shift < 4'd7) begin
						x_shift <= x_shift + 4'd7;
					end
					else begin
						x_shift <= x_shift + 4'd1;
					end
				end
				B_Y_SHIFT: begin
					x_shift <= 4'd0;
					y_shift <= y_shift + 4'd1;
				end
				C_DRAW: begin
					x_out <= box_x + x_shift + 1'b1;
					y_out <= box_y + y_shift + 1'b1;
					colour <= bitmap[(y_shift*7)+x_shift] ? 3'b111 : 3'b000;
					plotEn <= 1'b1;
				end
				C_X_SHIFT: x_shift <= x_shift + 1'b1;
				C_Y_SHIFT: begin
					x_shift <= 4'd0;
					y_shift <= y_shift + 4'd1;
				end
			endcase
			curr_state <= n_state;

		end
	end

endmodule