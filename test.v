module test(
	input [9:0] SW, 
	input [3:0] KEY,
	input CLOCK_50,
	output [9:0] LEDR,
	output [6:0] HEX0,
	output [6:0] HEX1);

	wire [8:0] bombGrid;
	wire [8:0] revealGrid;
	wire [8:0] cursorGrid;
	wire [35:0] states;
	wire [1:0] wl;
	wire [3:0] cs;
	
	game g(
		.clock(CLOCK_50),
		.reset(KEY[0]),
		.confirm(~KEY[1]),
		.restart(~KEY[2]),
		.readkey(~KEY[3]),
		.udlr(SW[3:0]),
		.wl(wl),
		.bombGrid(bombGrid),
		.revealGrid(revealGrid),
		.cursorGrid(cursorGrid),
		.states(states),
		.cs(cs)
	);
	
	reg [3:0] cState;
	always @(*) begin
		case(cursorGrid)
			9'b100000000: cState <= states[35:32];
			9'b010000000: cState <= states[31:28];
			9'b001000000: cState <= states[27:24];
			9'b000100000: cState <= states[23:20];
			9'b000010000: cState <= states[19:16];
			9'b000001000: cState <= states[15:12];
			9'b000000100: cState <= states[11:8];
			9'b000000010: cState <= states[7:4];
			9'b000000001: cState <= states[3:0];
			default: cState <= 0;
		endcase
	end
		
	assign LEDR[8:0] = cursorGrid;
	assign LEDR[9] = |wl;
	
	hexDisplay h0(
		.X(cs),
		.Hex(HEX0)
	);

	hexDisplay h1(
		.X(cState),
		.Hex(HEX1)
	);
	
	
endmodule

module hexDisplay(X, Hex);
	input [3:0] X;
	output reg [6:0] Hex;
	
	always @(*)
	begin
		case (X[3:0])
			4'b0000: Hex[6:0] = 7'b1000000;
			4'b0001: Hex[6:0] = 7'b1111001;
			4'b0010: Hex[6:0] = 7'b0100100;
			4'b0011: Hex[6:0] = 7'b0110000;
			4'b0100: Hex[6:0] = 7'b0011001;
			4'b0101: Hex[6:0] = 7'b0010010;
			4'b0110: Hex[6:0] = 7'b0000010;
			4'b0111: Hex[6:0] = 7'b1111000;
			4'b1000: Hex[6:0] = 7'b0000000;
			4'b1001: Hex[6:0] = 7'b0010000;
			4'b1010: Hex[6:0] = 7'b0001000;
			4'b1011: Hex[6:0] = 7'b0000011;
			4'b1100: Hex[6:0] = 7'b1000110;
			4'b1101: Hex[6:0] = 7'b0100001;
			4'b1110: Hex[6:0] = 7'b0000110;
			4'b1111: Hex[6:0] = 7'b0001110;
			default: Hex[6:0] = 7'b1111111;
		endcase
	end

endmodule