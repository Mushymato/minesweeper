module game #(
	parameter GRID_SIZE = 3,
	parameter STATE_SIZE = 4
)(
	input clock,
	input reset,
	
	input confirm,
	input restart,
	input [3:0] udlr,
	
	output move,
	output [1:0] dir,
	output [GRID_SIZE*GRID_SIZE-1:0] bombGrid,
	output [GRID_SIZE*GRID_SIZE-1:0] revealGrid,
	output [GRID_SIZE*GRID_SIZE-1:0] cursorGrid
);
	reg [3:0] c_state, n_state;
	reg [1:0]wl;
	localparam	S_INIT		= 4'b0000,
				S_GAME		= 4'b0001,
				S_MOVE		= 4'b0010,
				S_REVEAL	= 4'b0011,
				S_WIN		= 4'b0100,
				S_LOSE		= 4'b0101;

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
				end else if(|uldr) begin
					n_state = S_MOVE;
				end else begin
					n_state = S_GAME;
				end
			end
			S_MOVE: n_state = |uldr ? S_MOVE : S_GAME;
			S_REVEAL: n_state = confirm ? S_REVEAL : S_GAME;
			S_WIN: n_state = restart ? S_INIT : S_WIN;
			S_LOSE: n_state = restart ? S_INIT : S_WIN;
		endcase
	end
	
	always @(*)
	begin: signals
		move <= 1'b0;
		dir <= 1'b0;
		bombGrid <= 0;
		revealGrid <= 0;
		cursorGrid <= 0;
		
	end
	
	always@(posedge clock)
    begin: state_FFs
        if(!reset) begin
            c_state <= S_INIT;
        end else begin
            c_state <= n_state;
		end
    end
	
	
endmodule