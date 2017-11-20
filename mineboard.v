// Board relationships:
// Bombs
module samplegen(
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
	// example 3x3 board with 2 mines at 0 and 1
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

	genvar i;
	integer x;
	parameter GRID_SIZE = 3;
	parameter STATE_SIZE = 4;
	generate
		for (i=0 i < GRID_SIZE; i=i+1) begin
			for(j=0 j < GRID_SIZE; j=j+1) begin
				x = i*GRID_SIZE + j;
				if(x == 0) begin
					square s_inst(
						.setbomb(bombGrid[x]),
						.setreveal(revealGrid[x]),
						.setcursor(cursorGrid[x]),
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
							bombGrid[x+1]}),
						.adjcursor({
							cursorGrid[(i+1)*GRID_SIZE+j], 
							1'b0, 
							1'b0, 
							cursorGrid[x+1]}),
						.cursor(nextCursorGrid[x]),
						.state(states[(x+1)*STATE_SIZE-1:x*STATE_SIZE])
					);
				end else if(x == GRID_SIZE-1) begin
					square s_inst(
						.setbomb(bombGrid[x]),
						.setreveal(revealGrid[x]),
						.setcursor(cursorGrid[x]),
						.move(move),
						.dir(dir),
						.adjbomb({
							1'b0, 
							bombGrid[(i+1)*GRID_SIZE+j], 
							bombGrid[(i+1)*GRID_SIZE+j-1], 
							bombGrid[x-1], 
							1'b0,
							1'b0, 
							1'b0, 
							1'b0}),
						.adjcursor({
							cursorGrid[(i+1)*GRID_SIZE+j], 
							cursorGrid[x-1], 
							1'b0,
							1'b0}),
						.cursor(nextCursorGrid[x]),
						.state(states[(x+1)*STATE_SIZE-1:x*STATE_SIZE])
					);

				end else if(x == (GRID_SIZE-1)*GRID_SIZE) begin
					square s_inst(
						.setbomb(bombGrid[x]),
						.setreveal(revealGrid[x]),
						.setcursor(cursorGrid[x]),
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
							bombGrid[x+1]}),
						.adjcursor({
							1'b0, 
							1'b0, 
							cursorGrid[(i-1)*GRID_SIZE+j], 
							cursorGrid[x+1]}),
						.cursor(nextCursorGrid[x]),
						.state(states[(x+1)*STATE_SIZE-1:x*STATE_SIZE])
					);
				end else if(x == (GRID_SIZE*GRID_SIZE - 1)) begin
					square s_inst(
						.setbomb(bombGrid[x]),
						.setreveal(revealGrid[x]),
						.setcursor(cursorGrid[x]),
						.move(move),
						.dir(dir),
						.adjbomb({
							1'b0, 
							1'b0, 
							1'b0, 
							bombGrid[x-1], 
							bombGrid[(i-1)*GRID_SIZE+j-1],
							bombGrid[(i-1)*GRID_SIZE+j], 
							1'b0, 
							1'b0}),
						.adjcursor({
							1'b0, 
							cursorGrid[x-1], 
							cursorGrid[(i-1)*GRID_SIZE+j], 
							1'b0}),
						.cursor(nextCursorGrid[x]),
						.state(states[(x+1)*STATE_SIZE-1:x*STATE_SIZE])
					);
				end else if(i == 0) begin
					square s_inst(
						.setbomb(bombGrid[x]),
						.setreveal(revealGrid[x]),
						.setcursor(cursorGrid[x]),
						.move(move),
						.dir(dir),
						.adjbomb({
							bombGrid[(i+1)*GRID_SIZE+j+1], 
							bombGrid[(i+1)*GRID_SIZE+j], 
							bombGrid[(i+1)*GRID_SIZE+j-1], 
							bombGrid[x-1], 
							1'b0,
							1'b0, 
							1'b0, 
							bombGrid[x+1]}),
						.adjcursor({
							cursorGrid[(i+1)*GRID_SIZE+j], 
							cursorGrid[x-1], 
							1'b0, 
							cursorGrid[x+1]}),
						.cursor(nextCursorGrid[x]),
						.state(states[(x+1)*STATE_SIZE-1:x*STATE_SIZE])
					);
				end else if(j == 0) begin
					square s_inst(
						.setbomb(bombGrid[x]),
						.setreveal(revealGrid[x]),
						.setcursor(cursorGrid[x]),
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
							bombGrid[x+1]}),
						.adjcursor({
							cursorGrid[(i+1)*GRID_SIZE+j], 
							1'b0, 
							cursorGrid[(i-1)*GRID_SIZE+j], 
							cursorGrid[x+1]}),
						.cursor(nextCursorGrid[x]),
						.state(states[(x+1)*STATE_SIZE-1:x*STATE_SIZE])
					);
				end else if(j == GRID_SIZE-1) begin
					square s_inst(
						.setbomb(bombGrid[x]),
						.setreveal(revealGrid[x]),
						.setcursor(cursorGrid[x]),
						.move(move),
						.dir(dir),
						.adjbomb({
							1'b0, 
							bombGrid[(i+1)*GRID_SIZE+j], 
							bombGrid[(i+1)*GRID_SIZE+j-1], 
							bombGrid[x-1], 
							bombGrid[(i-1)*GRID_SIZE+j-1],
							bombGrid[(i-1)*GRID_SIZE+j], 
							1'b0, 
							1'b0}),
						.adjcursor({
							cursorGrid[(i+1)*GRID_SIZE+j], 
							cursorGrid[x-1], 
							cursorGrid[(i-1)*GRID_SIZE+j], 
							1'b0}),
						.cursor(nextCursorGrid[x]),
						.state(states[(x+1)*STATE_SIZE-1:x*STATE_SIZE])
					);
				end else if(i == GRID_SIZE-1) begin
					square s_inst(
						.setbomb(bombGrid[x]),
						.setreveal(revealGrid[x]),
						.setcursor(cursorGrid[x]),
						.move(move),
						.dir(dir),
						.adjbomb({
							1'b0, 
							1'b0, 
							1'b0, 
							bombGrid[x-1], 
							bombGrid[(i-1)*GRID_SIZE+j-1],
							bombGrid[(i-1)*GRID_SIZE+j], 
							bombGrid[(i-1)*GRID_SIZE+j+1], 
							bombGrid[x+1]}),
						.adjcursor({
							1'b0, 
							cursorGrid[x-1], 
							cursorGrid[(i-1)*GRID_SIZE+j], 
							cursorGrid[x+1]}),
						.cursor(nextCursorGrid[x]),
						.state(states[(x+1)*STATE_SIZE-1:x*STATE_SIZE])
					);
				end else begin
					square s_inst(
						.setbomb(bombGrid[x]),
						.setreveal(revealGrid[x]),
						.setcursor(cursorGrid[x]),
						.move(move),
						.dir(dir),
						.adjbomb({
							bombGrid[(i+1)*GRID_SIZE+j+1], 
							bombGrid[(i+1)*GRID_SIZE+j], 
							bombGrid[(i+1)*GRID_SIZE+j-1], 
							bombGrid[x-1], 
							bombGrid[(i-1)*GRID_SIZE+j-1],
							bombGrid[(i-1)*GRID_SIZE+j], 
							bombGrid[(i-1)*GRID_SIZE+j+1], 
							bombGrid[x+1]}),
						.adjcursor({
							cursorGrid[(i+1)*GRID_SIZE+j], 
							cursorGrid[x-1], 
							cursorGrid[(i-1)*GRID_SIZE+j], 
							cursorGrid[x+1]}),
						.cursor(nextCursorGrid[x]),
						.state(states[(x+1)*STATE_SIZE-1:x*STATE_SIZE])
					);
				end
			end
		end
	endgenerate
endmodule

module sampleboard(
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
	// example 3x3 board with 2 mines at 0 and 1
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
	
	square s8(
		.setbomb(bombGrid[8]),
		.setreveal(revealGrid[8]),
		.setcursor(cursorGrid[8]),
		.move(move),
		.dir(dir),
		.adjbomb({1'b0, 1'b0, 1'b0, bombGrid[7], bombGrid[4], bombGrid[6], 1'b0, 1'b0}),
		.adjcursor({1'b0, cursorGrid[7], cursorGrid[5], 1'b0}),
		.cursor(nextCursorGrid[8]),
		.state(states[35:32])
	);
	
	square s7(
		.setbomb(bombGrid[7]),
		.setreveal(revealGrid[7]),
		.setcursor(cursorGrid[7]),
		.move(move),
		.dir(dir),
		.adjbomb({1'b0, 1'b0, 1'b0, bombGrid[6], bombGrid[3], bombGrid[4], bombGrid[5], bombGrid[8]}),
		.adjcursor({1'b0, cursorGrid[6], cursorGrid[4], cursorGrid[8]}),
		.cursor(nextCursorGrid[7]),
		.state(states[31:28])
	);

	square s6(
		.setbomb(bombGrid[6]),
		.setreveal(revealGrid[6]),
		.setcursor(cursorGrid[6]),
		.move(move),
		.dir(dir),
		.adjbomb({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, bombGrid[3], bombGrid[4], bombGrid[7]}),
		.adjcursor({1'b0, 1'b0, cursorGrid[3], cursorGrid[7]}),
		.cursor(nextCursorGrid[6]),
		.state(states[27:24])
	);

	square s5(
		.setbomb(bombGrid[5]),
		.setreveal(revealGrid[5]),
		.setcursor(cursorGrid[5]),
		.move(move),
		.dir(dir),
		.adjbomb({1'b0, bombGrid[8], bombGrid[7], bombGrid[4], bombGrid[1], bombGrid[2], 1'b0, 1'b0}),
		.adjcursor({cursorGrid[8], cursorGrid[4], cursorGrid[2], 1'b0}),
		.cursor(nextCursorGrid[5]),
		.state(states[23:20])
	);
	square s4(
		.setbomb(bombGrid[4]),
		.setreveal(revealGrid[4]),
		.setcursor(cursorGrid[4]),
		.move(move),
		.dir(dir),
		.adjbomb({bombGrid[8], bombGrid[7], bombGrid[6], bombGrid[3], bombGrid[0], bombGrid[1], bombGrid[2], bombGrid[5]}),
		.adjcursor({cursorGrid[7], cursorGrid[3], cursorGrid[1], cursorGrid[5]}),
		.cursor(nextCursorGrid[4]),
		.state(states[19:16])
	);
	square s3(
		.setbomb(bombGrid[3]),
		.setreveal(revealGrid[3]),
		.setcursor(cursorGrid[3]),
		.move(move),
		.dir(dir),
		.adjbomb({bombGrid[7], bombGrid[6], 1'b0, 1'b0, 1'b0, bombGrid[0], bombGrid[1], bombGrid[4]}),
		.adjcursor({cursorGrid[6], 1'b0, cursorGrid[0], cursorGrid[4]}),
		.cursor(nextCursorGrid[3]),
		.state(states[15:12])
	);
	square s2(
		.setbomb(bombGrid[2]),
		.setreveal(revealGrid[2]),
		.setcursor(cursorGrid[2]),
		.move(move),
		.dir(dir),
		.adjbomb({1'b0, bombGrid[5], bombGrid[4], bombGrid[1], 1'b0, 1'b0, 1'b0, 1'b0}),
		.adjcursor({cursorGrid[5], cursorGrid[1], 1'b0, 1'b0}),
		.cursor(nextCursorGrid[2]),
		.state(states[11:8])
	);
	square s1(
		.setbomb(bombGrid[1]),
		.setreveal(revealGrid[1]),
		.setcursor(cursorGrid[1]),
		.move(move),
		.dir(dir),
		.adjbomb({bombGrid[5], bombGrid[4], bombGrid[3], bombGrid[0], 1'b0, 1'b0, 1'b0, bombGrid[2]}),
		.adjcursor({cursorGrid[4], cursorGrid[0], 1'b0, cursorGrid[2]}),
		.cursor(nextCursorGrid[1]),
		.state(states[7:4])
	);
	square s0(
		.setbomb(bombGrid[0]),
		.setreveal(revealGrid[0]),
		.setcursor(cursorGrid[0]),
		.move(move),
		.dir(dir),
		.adjbomb({bombGrid[4], bombGrid[3], 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, bombGrid[1]}),
		.adjcursor({cursorGrid[3], 1'b0, 1'b0, cursorGrid[1]}),
		.cursor(nextCursorGrid[0]),
		.state(states[3:0])
	);

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
	reg bomb;
	reg reveal;

	always @(*) begin
		state = setbomb ? 4'd9 : adjbomb[7] + adjbomb[6] + adjbomb[5] + adjbomb[4] + adjbomb[3] + adjbomb[2] + adjbomb[1] + adjbomb[0];
		bomb = setbomb;
		reveal = setreveal;
		cursor = setcursor;
		if (move) begin
			cursor = adjcursor[dir];
			// 00 copy from left (move right)
			// 01 copy from bottom (move up)
			// 10 copy from right (move left)
			// 11 copy from top (move down)
		end
	end
endmodule