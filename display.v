module display #(
	parameter GRID_SIZE = 3,
	parameter SIZE = 4,
	parameter STATE_SIZE = 4
)(
	input clock,
	input resetn,
	input d_cursor,
	input d_reveal,
	input [GRID_SIZE*GRID_SIZE-1:0] bombGrid,
	input [GRID_SIZE*GRID_SIZE-1:0] revealGrid,
	input [GRID_SIZE*GRID_SIZE-1:0] cursorGrid,
	input [STATE_SIZE*(GRID_SIZE*GRID_SIZE)-1:0] states,
	
  	output			VGA_CLK,   				//	VGA Clock
	output			VGA_HS,					//	VGA H_SYNC
	output			VGA_VS,					//	VGA V_SYNC
	output			VGA_BLANK_N,				//	VGA BLANK
	output			VGA_SYNC_N,				//	VGA SYNC
	output	[9:0]	VGA_R,   				//	VGA Red[9:0]
	output	[9:0]	VGA_G,	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B,   				//	VGA Blue[9:0]
	
	output [3:0] cs
);
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire plotEn;
		
  	vga_adapter VGA(
			.resetn(resetn),
			.clock(clock),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(plotEn),
			// Signals for the DAC to drive the monitor. 
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";

/* 	genvar k;
	generate
		for(k = GRID_SIZE*GRID_SIZE-1; k >= 0; k = k+1) begin
			drawBox draw(
				.clock(clock),
				.d_enable(d_enable),
				.d_cursor(d_cursor)
			);
		end
		
	endgenerate
 */
  
	drawBox #(
		.SIZE(SIZE),
		.STATE_SIZE(STATE_SIZE)
	)d8(
		.clock(clock),
		.d_cursor(d_cursor),
		.d_reveal(d_reveal),
		.resetn(resetn),
		.box_x(4'd1),
		.box_y(4'd1),
		.cursor_bit(cursorGrid[8]),
		.reveal_bit(revealGrid[8]),
		.state(states[35:32]),
		.x_out(x),
		.y_out(y),
		.colour(colour),
		.plotEn(plotEn),
		.cs(cs)
	);
	
endmodule
 
module drawBox#(
	parameter SIZE = 4,
	parameter STATE_SIZE = 4
)(
	input clock,
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
	output reg plotEn,
	
	output [3:0] cs
);
	
	reg [3:0] x_shift, y_shift;
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
			default: bitmap = 49'b0000000000000000000000000000000000000000000000000;
		endcase
	end

	reg [3:0] c_state, n_state;
	
	assign cs = c_state;
	localparam 	REST 			=4'b0000,
				B_DRAW 			=4'b0001,
				B_X_SHIFT		=4'b0010,
				B_Y_SHIFT		=4'b0011,
				C_DRAW			=4'b0100,
				C_X_SHIFT		=4'b0101,
				C_Y_SHIFT		=4'b0110;



// STATE TABLE
	always @(*) begin
		case (c_state)
			REST: begin
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
			B_DRAW: begin
				if  (x_shift < 4'd8) begin
					n_state <= B_X_SHIFT;
				end
				else if(y_shift < 4'd8) begin
					n_state <= B_Y_SHIFT;
				end
				else begin
					n_state <= REST;
				end
			end
			B_X_SHIFT: n_state <= B_DRAW;
			B_Y_SHIFT: n_state <= B_DRAW;
			C_DRAW: begin
				if  (x_shift < 4'd6) begin
					n_state <= C_X_SHIFT;
				end
				else if(y_shift < 4'd6) begin
					n_state <= C_Y_SHIFT;
				end
				else begin
					n_state <= REST;
				end
			end
			C_X_SHIFT: n_state <= C_DRAW;
			C_Y_SHIFT: n_state <= C_DRAW;
			default: n_state <= REST;
		endcase
	end


// ASSIGN STATES
	always @(posedge clock) begin
		if (!resetn) begin
			c_state <= REST;
			x_shift <= 1'b0;
			y_shift <= 1'b0;
			plotEn <= 0;
			x_out <= 0;
			y_out <=0;
			colour <=0;
			plotEn <=0;
		end
		else begin
			plotEn <= 0;
			case(c_state)
				REST: begin
					x_shift <= 1'b0;
					y_shift <= 1'b0;
				end
				B_DRAW: begin
					x_out <= box_x + x_shift;
					y_out <= box_y + y_shift;
					colour <= cursor_bit ? 3'b100 : 3'b111; //red
					plotEn <= 1'b1;
				end
				B_X_SHIFT: begin
					if (y_shift > 4'd0 && y_shift < 4'd8) begin
						x_shift <= x_shift + 4'd8;
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
					colour <= (reveal_bit & bitmap[(y_shift*7)+x_shift]) ? 3'b111 : 3'b000;
					plotEn <= 1'b1;
				end
				C_X_SHIFT: x_shift <= x_shift + 1'b1;
				C_Y_SHIFT: begin
					x_shift <= 4'd0;
					y_shift <= y_shift + 4'd1;
				end
			endcase
			c_state <= n_state;
		end
	end

endmodule