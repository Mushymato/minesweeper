module game #(
	parameter GRID_SIZE = 3,
	parameter STATE_SIZE = 4
)(
	input clock,
	input reset,
	
	input confirm,
	input restart,
	input readkey,
	input [3:0] udlr,
	
	output reg [1:0] wl,
	output reg [GRID_SIZE*GRID_SIZE-1:0] bombGrid,
	output reg [GRID_SIZE*GRID_SIZE-1:0] revealGrid,
	output reg [GRID_SIZE*GRID_SIZE-1:0] cursorGrid,
	output [STATE_SIZE*(GRID_SIZE*GRID_SIZE)-1:0] states,
	
	output [3:0] cs
);
	wire [GRID_SIZE*GRID_SIZE-1:0] nextCursorGrid;
	reg move;
	reg [1:0] dir;
	board #(
		.GRID_SIZE(GRID_SIZE),
		.STATE_SIZE(STATE_SIZE)
	) b (
		.bombGrid(bombGrid),
		.revealGrid(revealGrid),
		.cursorGrid(cursorGrid),
		.move(move),
		.dir(dir),
		.states(states),
		.nextCursorGrid(nextCursorGrid)
	);
	
	reg [3:0] c_state, n_state;
	localparam	S_INIT		= 4'b0000,
				S_GAME		= 4'b0001,
				S_MOVE		= 4'b0010,
				S_MOVE_SET	= 4'b0011,
				S_REVEAL	= 4'b0100,
				S_WIN		= 4'b0101,
				S_LOSE		= 4'b0110;

	assign cs = c_state;
				
	always @(*) begin: state_table
		case(c_state)
			S_INIT: n_state = restart ? S_INIT : S_GAME;
			S_GAME: begin
				if(wl == 2'b01) begin
					n_state = S_WIN;
				end else if(wl == 2'b10) begin
					n_state = S_LOSE;
				end else if(confirm) begin
					n_state = S_REVEAL;
				end else if(readkey) begin
					n_state = S_MOVE;
				end else begin
					n_state = S_GAME;
				end
			end
			S_MOVE: n_state = readkey ? S_MOVE : S_MOVE_SET;
			S_MOVE_SET: n_state = S_GAME;
			S_REVEAL: n_state = confirm ? S_REVEAL : S_GAME;
			S_WIN: n_state = restart ? S_INIT : S_WIN;
			S_LOSE: n_state = restart ? S_INIT : S_LOSE;
			default: n_state = S_GAME;
		endcase
	end
	
	integer i;
	reg [GRID_SIZE*GRID_SIZE-1:0] tmpNext;
	
	always@(posedge clock)
    begin: state_FFs
        if(!reset) begin
			c_state <= S_INIT;
			move <= 0;
			dir <= 0;
			wl <= 0;
			bombGrid <= 0;
			revealGrid <= 0;
			cursorGrid <= 0;
			tmpNext <= 0;
        end else begin
			case(c_state)
				S_INIT: begin
					bombGrid[8] <= 1'b1;
					bombGrid[5] <= 1'b1;
					cursorGrid[0] <= 1'b1;
				end
				S_GAME: begin
					if(bombGrid == ~revealGrid) begin
						wl <= 2'b01;
					end else begin
						for(i=0; i < GRID_SIZE * GRID_SIZE; i=i+1) begin
							if(bombGrid[i] == 1'b1 && revealGrid[i] == 1'b1) begin
								wl <= 2'b10;
							end
						end
					end
				end
				S_MOVE: begin
					move <= 1'b1;
					case (udlr)
						4'b0001: dir <= 2'b00; // Right
						4'b0010: dir <= 2'b10; // Left
						4'b0100: dir <= 2'b11; // Down
						4'b1000: dir <= 2'b01; // Up
						default: move <= 1'b0;
					endcase
					tmpNext <= nextCursorGrid;
				end
				S_MOVE_SET: begin
					cursorGrid <= tmpNext;
				end
				S_REVEAL: begin
					revealGrid <= revealGrid | cursorGrid;
				end
				default: begin
					move <= 0;
					dir <= 0;
					wl <= 0;
					bombGrid <= 0;
					revealGrid <= 0;
					cursorGrid <= 0;
					tmpNext <= 0;
				end
			endcase
         c_state <= n_state;
		end
    end
	
endmodule

module key_inputs(
	input CLOCK_50,
	input reset,
	
	input PS2_DAT,
	input PS2_CLK,
	
	output reg confirm,
	output reg restart,
	output reg [3:0] udlr
);
	wire valid, makeBreak;
	wire [7:0] outCode;
	
	keyboard_press_driver kpd(
		.CLOCK_50(CLOCK_50),
		.reset(reset),
		.valid(valid),
		.makeBreak(makeBreak),
		.outCode(outCode)
	);
	
	always @(posedge valid) begin
		confirm <= 0;
		restart <= 0;
		udlr <= 0;
		case (outCode)
			8'hE048: udlr <= 4'b1000; // U
			8'hE04B: udlr <= 4'b0010; // L
			8'hE050: udlr <= 4'b0100; // D
			8'hE04D: udlr <= 4'b0001; // R
			8'h002D: confirm <= 1;// X
			8'h002C: restart <= 1;// Z
		endcase
	end
endmodule