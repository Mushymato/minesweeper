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
	
	output reg d_enable,
	output reg d_cursor,
	output reg d_reveal,
	
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
	
	// wire [7:0] random;
	// reg [3:0] x, y;
	// integer bombcount;
	// fibonacci_lfsr_nbit f (
	// 	.clock(clock),
	// 	.reset(reset),
	// 	.data(random)
	// );
	
	reg [3:0] c_state, n_state;
	localparam	S_INIT		= 4'b0000,
				S_SET_BOMB	= 4'b0001,
				S_GAME		= 4'b0010,
				S_MOVE		= 4'b0011,
				S_MOVE_SET	= 4'b0100,
				S_REVEAL	= 4'b0101,
				S_WIN		= 4'b0110,
				S_LOSE		= 4'b0111;

	assign cs = c_state;
				
	always @(*) begin: state_table
		case(c_state)
			S_INIT: n_state = restart ? S_INIT : S_GAME;
			// S_INIT: n_state = restart ? S_INIT : S_SET_BOMB;
			// S_SET_BOMB: n_state = bombcount == 0 ? S_GAME : S_SET_BOMB;
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
			d_enable <= 0;
			//x <= 0;
			//y <= 0;
        end else begin
			d_enable <= 1'b0;
			d_cursor <= 1'b0;
			d_reveal <= 1'b0;
			case(c_state)
				S_INIT: begin
					cursorGrid[0] <= 1'b0;
					bombGrid <= 9'b10010000;
					// bombcount <= GRID_SIZE;
				end
				// S_SET_BOMB: begin
				// 	// x: random[3:0]
				// 	// y: random[7:4]
					
				// 	x <= (random[3:0] > 4'b1001) ? x <= random[3:0] >> 1'b1 : x <= random[3:0];
				// 	y <= (random[7:4] > 4'b1001) ? y <= random[7:4] >> 1'b1 : y <= random[7:4];
					
				// 	bombGrid[x*GRID_SIZE + y] = 1'b1;
				// 	bombcount = bombcount - 1;
				// end
				S_GAME: begin
					d_enable <= 1'b1;
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
					d_enable <= 1'b1;
					d_cursor <= 1'b1;
				end
				S_REVEAL: begin
					revealGrid <= revealGrid | cursorGrid;
					d_enable <= 1'b1;
					d_reveal <= 1'b1;
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