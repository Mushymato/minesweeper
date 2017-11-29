module testboard(	
	input [8:0] bombGrid,
	input [8:0] revealGrid,
	input [8:0] cursorGrid,
	input move,
	input [1:0] dir,
	
	output [35:0] states,
	output [8:0] nextCursorGrid,
	
	output [3:0] state0, 
	output [3:0] state1,
	output [3:0] state2,
	output [3:0] state3,
	output [3:0] state4,
	output [3:0] state5,
	output [3:0] state6,
	output [3:0] state7,
	output [3:0] state8,
	
	output [2:0] row1,
	output [2:0] row2,
	output [2:0] row3
);
	assign state0 = states[3:0];
	assign state1 = states[7:4];
	assign state2 = states[11:8];
	assign state3 = states[15:12];
	assign state4 = states[19:16];
	assign state5 = states[23:20];
	assign state6 = states[27:24];
	assign state7 = states[31:28];
	assign state8 = states[35:32];
	// gird:
	//	8	7	6
	//	5	4	3
	//	2	1	0
	assign row1 = nextCursorGrid[8:6];
	assign row2 = nextCursorGrid[5:3];
	assign row3 = nextCursorGrid[2:0];
	
	localparam GRID_SIZE = 3;
	localparam STATE_SIZE = 4;
	
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

endmodule

module board #(
	parameter GRID_SIZE = 3,
	parameter STATE_SIZE = 4
)(
	input [GRID_SIZE*GRID_SIZE-1:0] bombGrid,
	input [GRID_SIZE*GRID_SIZE-1:0] revealGrid,
	input [GRID_SIZE*GRID_SIZE-1:0] cursorGrid,
	input move,
	input [1:0] dir,
	
	output [STATE_SIZE*(GRID_SIZE*GRID_SIZE)-1:0] states,
	output [GRID_SIZE*GRID_SIZE-1:0] nextCursorGrid
);
	genvar i;
	genvar j;
	generate
		for (i=0; i < GRID_SIZE; i=i+1) begin: x_pos
			for(j=0; j < GRID_SIZE; j=j+1) begin: y_pos
				if((i*GRID_SIZE + j) == 0) begin
					// bottom-right
					square s_inst(
						.setbomb(bombGrid[(i*GRID_SIZE + j)]),
						.setreveal(revealGrid[(i*GRID_SIZE + j)]),
						.setcursor(cursorGrid[(i*GRID_SIZE + j)]),
						.move(move),
						.dir(dir),
						.adjbomb({
							bombGrid[(i+1)*GRID_SIZE+j+1], 
							bombGrid[(i+1)*GRID_SIZE+j], 
							1'b0, 
							1'b0, 
							1'b0,
							1'b0, 
							1'b0, 
							bombGrid[(i*GRID_SIZE + j)+1]}),
						.adjcursor({
							cursorGrid[(i+1)*GRID_SIZE+j], 
							1'b0, 
							1'b0, 
							cursorGrid[(i*GRID_SIZE + j)+1]}),
						.adjwall({1'b0, 1'b1, 1'b1, 1'b0}),
						.cursor(nextCursorGrid[(i*GRID_SIZE + j)]),
						.state(states[((i*GRID_SIZE + j)+1)*STATE_SIZE-1:(i*GRID_SIZE + j)*STATE_SIZE])
					);
				end else if((i*GRID_SIZE + j) == GRID_SIZE-1) begin
					// bottom-left 
					square s_inst(
						.setbomb(bombGrid[(i*GRID_SIZE + j)]),
						.setreveal(revealGrid[(i*GRID_SIZE + j)]),
						.setcursor(cursorGrid[(i*GRID_SIZE + j)]),
						.move(move),
						.dir(dir),
						.adjbomb({
							1'b0, 
							bombGrid[(i+1)*GRID_SIZE+j], 
							bombGrid[(i+1)*GRID_SIZE+j-1], 
							bombGrid[(i*GRID_SIZE + j)-1], 
							1'b0,
							1'b0, 
							1'b0, 
							1'b0}),
						.adjcursor({
							cursorGrid[(i+1)*GRID_SIZE+j], 
							cursorGrid[(i*GRID_SIZE + j)-1], 
							1'b0,
							1'b0}),
						.adjwall({1'b0, 1'b0, 1'b1, 1'b1}),
						.cursor(nextCursorGrid[(i*GRID_SIZE + j)]),
						.state(states[((i*GRID_SIZE + j)+1)*STATE_SIZE-1:(i*GRID_SIZE + j)*STATE_SIZE])
					);

				end else if((i*GRID_SIZE + j) == (GRID_SIZE-1)*GRID_SIZE) begin
					// top-right
					square s_inst(
						.setbomb(bombGrid[(i*GRID_SIZE + j)]),
						.setreveal(revealGrid[(i*GRID_SIZE + j)]),
						.setcursor(cursorGrid[(i*GRID_SIZE + j)]),
						.move(move),
						.dir(dir),
						.adjbomb({
							1'b0, 
							1'b0, 
							1'b0, 
							1'b0, 
							1'b0,
							bombGrid[(i-1)*GRID_SIZE+j], 
							bombGrid[(i-1)*GRID_SIZE+j+1], 
							bombGrid[(i*GRID_SIZE + j)+1]}),
						.adjcursor({
							1'b0, 
							1'b0, 
							cursorGrid[(i-1)*GRID_SIZE+j], 
							cursorGrid[(i*GRID_SIZE + j)+1]}),
						.adjwall({1'b1, 1'b1, 1'b0, 1'b0}),
						.cursor(nextCursorGrid[(i*GRID_SIZE + j)]),
						.state(states[((i*GRID_SIZE + j)+1)*STATE_SIZE-1:(i*GRID_SIZE + j)*STATE_SIZE])
					);
				end else if((i*GRID_SIZE + j) == (GRID_SIZE*GRID_SIZE - 1)) begin
					// top-left
					square s_inst(
						.setbomb(bombGrid[(i*GRID_SIZE + j)]),
						.setreveal(revealGrid[(i*GRID_SIZE + j)]),
						.setcursor(cursorGrid[(i*GRID_SIZE + j)]),
						.move(move),
						.dir(dir),
						.adjbomb({
							1'b0, 
							1'b0, 
							1'b0, 
							bombGrid[(i*GRID_SIZE + j)-1], 
							bombGrid[(i-1)*GRID_SIZE+j-1],
							bombGrid[(i-1)*GRID_SIZE+j], 
							1'b0, 
							1'b0}),
						.adjcursor({
							1'b0, 
							cursorGrid[(i*GRID_SIZE + j)-1], 
							cursorGrid[(i-1)*GRID_SIZE+j], 
							1'b0}),
						.adjwall({1'b1, 1'b0, 1'b0, 1'b1}),
						.cursor(nextCursorGrid[(i*GRID_SIZE + j)]),
						.state(states[((i*GRID_SIZE + j)+1)*STATE_SIZE-1:(i*GRID_SIZE + j)*STATE_SIZE])
					);
				end else if(i == 0) begin
					// bottom row
					square s_inst(
						.setbomb(bombGrid[(i*GRID_SIZE + j)]),
						.setreveal(revealGrid[(i*GRID_SIZE + j)]),
						.setcursor(cursorGrid[(i*GRID_SIZE + j)]),
						.move(move),
						.dir(dir),
						.adjbomb({
							bombGrid[(i+1)*GRID_SIZE+j+1], 
							bombGrid[(i+1)*GRID_SIZE+j], 
							bombGrid[(i+1)*GRID_SIZE+j-1], 
							bombGrid[(i*GRID_SIZE + j)-1], 
							1'b0,
							1'b0, 
							1'b0, 
							bombGrid[(i*GRID_SIZE + j)+1]}),
						.adjcursor({
							cursorGrid[(i+1)*GRID_SIZE+j], 
							cursorGrid[(i*GRID_SIZE + j)-1], 
							1'b1, 
							cursorGrid[(i*GRID_SIZE + j)+1]}),
						.adjwall({1'b0, 1'b0, 1'b1, 1'b0}),
						.cursor(nextCursorGrid[(i*GRID_SIZE + j)]),
						.state(states[((i*GRID_SIZE + j)+1)*STATE_SIZE-1:(i*GRID_SIZE + j)*STATE_SIZE])
					);
				end else if(j == 0) begin
					// right column
					square s_inst(
						.setbomb(bombGrid[(i*GRID_SIZE + j)]),
						.setreveal(revealGrid[(i*GRID_SIZE + j)]),
						.setcursor(cursorGrid[(i*GRID_SIZE + j)]),
						.move(move),
						.dir(dir),
						.adjbomb({
							bombGrid[(i+1)*GRID_SIZE+j+1], 
							bombGrid[(i+1)*GRID_SIZE+j], 
							1'b0, 
							1'b0, 
							1'b0,
							bombGrid[(i-1)*GRID_SIZE+j], 
							bombGrid[(i-1)*GRID_SIZE+j+1], 
							bombGrid[(i*GRID_SIZE + j)+1]}),
						.adjcursor({
							cursorGrid[(i+1)*GRID_SIZE+j], 
							1'b0, 
							cursorGrid[(i-1)*GRID_SIZE+j], 
							cursorGrid[(i*GRID_SIZE + j)+1]}),
						.adjwall({1'b0, 1'b1, 1'b0, 1'b0}),
						.cursor(nextCursorGrid[(i*GRID_SIZE + j)]),
						.state(states[((i*GRID_SIZE + j)+1)*STATE_SIZE-1:(i*GRID_SIZE + j)*STATE_SIZE])
					);
				end else if(j == GRID_SIZE-1) begin
					// left column
					square s_inst(
						.setbomb(bombGrid[(i*GRID_SIZE + j)]),
						.setreveal(revealGrid[(i*GRID_SIZE + j)]),
						.setcursor(cursorGrid[(i*GRID_SIZE + j)]),
						.move(move),
						.dir(dir),
						.adjbomb({
							1'b0, 
							bombGrid[(i+1)*GRID_SIZE+j], 
							bombGrid[(i+1)*GRID_SIZE+j-1], 
							bombGrid[(i*GRID_SIZE + j)-1], 
							bombGrid[(i-1)*GRID_SIZE+j-1],
							bombGrid[(i-1)*GRID_SIZE+j], 
							1'b0, 
							1'b0}),
						.adjcursor({
							cursorGrid[(i+1)*GRID_SIZE+j], 
							cursorGrid[(i*GRID_SIZE + j)-1], 
							cursorGrid[(i-1)*GRID_SIZE+j], 
							1'b0}),
						.adjwall({1'b0, 1'b0, 1'b0, 1'b1}),
						.cursor(nextCursorGrid[(i*GRID_SIZE + j)]),
						.state(states[((i*GRID_SIZE + j)+1)*STATE_SIZE-1:(i*GRID_SIZE + j)*STATE_SIZE])
					);
				end else if(i == GRID_SIZE-1) begin
					// top row
					square s_inst(
						.setbomb(bombGrid[(i*GRID_SIZE + j)]),
						.setreveal(revealGrid[(i*GRID_SIZE + j)]),
						.setcursor(cursorGrid[(i*GRID_SIZE + j)]),
						.move(move),
						.dir(dir),
						.adjbomb({
							1'b0, 
							1'b0, 
							1'b0, 
							bombGrid[(i*GRID_SIZE + j)-1], 
							bombGrid[(i-1)*GRID_SIZE+j-1],
							bombGrid[(i-1)*GRID_SIZE+j], 
							bombGrid[(i-1)*GRID_SIZE+j+1], 
							bombGrid[(i*GRID_SIZE + j)+1]}),
						.adjcursor({
							1'b0, 
							cursorGrid[(i*GRID_SIZE + j)-1], 
							cursorGrid[(i-1)*GRID_SIZE+j], 
							cursorGrid[(i*GRID_SIZE + j)+1]}),
						.adjwall({1'b1, 1'b0, 1'b0, 1'b0}),
						.cursor(nextCursorGrid[(i*GRID_SIZE + j)]),
						.state(states[((i*GRID_SIZE + j)+1)*STATE_SIZE-1:(i*GRID_SIZE + j)*STATE_SIZE])
					);
				end else begin
					// middle
					square s_inst(
						.setbomb(bombGrid[(i*GRID_SIZE + j)]),
						.setreveal(revealGrid[(i*GRID_SIZE + j)]),
						.setcursor(cursorGrid[(i*GRID_SIZE + j)]),
						.move(move),
						.dir(dir),
						.adjbomb({
							bombGrid[(i+1)*GRID_SIZE+j+1], 
							bombGrid[(i+1)*GRID_SIZE+j], 
							bombGrid[(i+1)*GRID_SIZE+j-1], 
							bombGrid[(i*GRID_SIZE + j)-1], 
							bombGrid[(i-1)*GRID_SIZE+j-1],
							bombGrid[(i-1)*GRID_SIZE+j], 
							bombGrid[(i-1)*GRID_SIZE+j+1], 
							bombGrid[(i*GRID_SIZE + j)+1]}),
						.adjcursor({
							cursorGrid[(i+1)*GRID_SIZE+j], 
							cursorGrid[(i*GRID_SIZE + j)-1], 
							cursorGrid[(i-1)*GRID_SIZE+j], 
							cursorGrid[(i*GRID_SIZE + j)+1]}),
						.adjwall({1'b0, 1'b0, 1'b0, 1'b0}),
						.cursor(nextCursorGrid[(i*GRID_SIZE + j)]),
						.state(states[((i*GRID_SIZE + j)+1)*STATE_SIZE-1:(i*GRID_SIZE + j)*STATE_SIZE])
					);
				end
			end
		end
	endgenerate
endmodule

module square(
	input setbomb, // this square is a bomb
	input setreveal, // this square should be revealGrids
	input setcursor, // this square should be the location of the cursor
	input move, // move cursor from adjacent squares
	input [1:0] dir, // direction of movement, ~URDL so DLUR
	//input [3:0] ec, // edge/corner flags
	
	input [7:0] adjbomb, // bomb/not bomb for 8 adjacent squares
	input [3:0] adjcursor, // is cursor/is not cursor for 4 adjacent squares
	input [3:0] adjwall, // is adjacent squares walls?
	
	output reg cursor, // next state of cursor
	output reg [3:0] state // state of this square, 0-9 where 9 is bomb
);
	// bombGrid:
	//	7	6	5
	//	0	*	4
	//	1	2	3
	// reveal/cursorGrid:
	//	-	3	-
	//	0	*	2
	//	-	1	-
	reg [1:0] op;
	always @(*) begin
		case(dir)
			2'b00: op = 2'b10;
			2'b01: op = 2'b11;
			2'b10: op = 2'b00;
			2'b11: op = 2'b01;
			default: op = 2'b00;
		endcase
	end
	always @(*) begin
		state = setbomb ? 4'd9 : adjbomb[7] + adjbomb[6] + adjbomb[5] + adjbomb[4] + adjbomb[3] + adjbomb[2] + adjbomb[1] + adjbomb[0];
		cursor = setcursor;
		if (move) begin
			if (~(adjwall[op] && cursor)) begin
				cursor = adjcursor[dir];
			end
			// 00 copy from left (move right)
			// 01 copy from bottom (move up)
			// 10 copy from right (move left)
			// 11 copy from top (move down)
		end
	end
endmodule