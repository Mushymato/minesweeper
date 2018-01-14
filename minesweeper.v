module minesweeper(
	input CLOCK_50,
	input [9:0] SW,
	input [3:0] KEY,
	
	output [9:0] LEDR
	
	/*output VGA_CLK,   						//	VGA Clock
	output VGA_HS,							//	VGA H_SYNC
	output VGA_VS,							//	VGA V_SYNC
	output VGA_BLANK_N,						//	VGA BLANK
	output VGA_SYNC_N,						//	VGA SYNC
	output [9:0] VGA_R,   						//	VGA Red[9:0]
	output [9:0] VGA_G,	 						//	VGA Green[9:0]
	output [9:0] VGA_B   						//	VGA Blue[9:0]*/
);
	localparam GRID_SIZE = 9;
	
	wire reset, confirm, restart, readkey;
	assign reset = KEY[0];
	assign restart = ~KEY[1];
	
	assign confirm = ~KEY[2];
	assign readkey = ~KEY[3];
	
	wire [3:0] udlr;
	assign udlr = SW[3:0];
		
	wire [GRID_SIZE*GRID_SIZE-1:0] bombGrid, revealGrid, cursorGrid;
	wire [4*(GRID_SIZE*GRID_SIZE)-1:0] states;
	wire d_enable;
	wire [1:0] wl;
	
	assign LEDR[9:8] = wl;
	
	wire [GRID_SIZE*GRID_SIZE-1:0] initGrid;
	
	rand9x9 r99(
		.clock(CLOCK_50),
		.reset(reset),
		.restart(restart),
		.initGrid(initGrid)
	);
	assign LEDR = initGrid[8:0];
	
	wire gameClk;
	rateDiv rd(
		.clock(CLOCK_50),
		.reset(reset),
		.pulse(gameClk)
	);

	game #(
		.GRID_SIZE(GRID_SIZE)
	)g(
		.clock(gameClk),
		.reset(reset),
		.confirm(confirm),
		.restart(restart),
		.readkey(readkey),
		.udlr(udlr),
		.initGrid(initGrid),
		
		.wl(wl),
		.bombGrid(bombGrid),
		.revealGrid(revealGrid),
		.cursorGrid(cursorGrid),
		.states(states),
		
		.d_enable(d_enable)
	);
	
	wire [7:0] x_b;
	wire [6:0] y_b;
	wire [2:0] colour_b;
	wire plotEn_b;
	
	drawBoard #(
		.GRID_SIZE(GRID_SIZE)
	)db(
		.clock(CLOCK_50),
		.reset(reset),
		.d_enable(d_enable),
		
		.bombGrid(bombGrid),
		.revealGrid(revealGrid),
		.cursorGrid(cursorGrid),
		.states(states),
		
		.x_out(x_b),
		.y_out(y_b),
		.colour(colour_b),
		.plotEn(plotEn_b)
	);

	wire [7:0] x_wl;
	wire [6:0] y_wl;
	wire [2:0] colour_wl;
	wire plotEn_wl;

	drawWinLose #(
		.GRID_SIZE(GRID_SIZE)
	)dwl(
		.clock(CLOCK_50),
		.reset(reset),
		
		.wl(wl),
		
		.x_out(x_wl),
		.y_out(y_wl),
		.colour(colour_wl),
		.plotEn(plotEn_wl)
	);
	
	reg [7:0] x;
	reg [6:0] y;
	reg [2:0] colour;
	reg plotEn;
	
	always @(*) begin
		case(wl)
			2'b00: begin
				x <= x_b + 1;
				y <= y_b + 1;
				colour <= colour_b;
				plotEn <= plotEn_b;
			end
			default: begin
				x <= x_wl + 1;
				y <= y_wl + 1;
				colour <= colour_wl;
				plotEn <= plotEn_wl;
			end
		endcase
	end
	
	/* vga_adapter VGA(
			.resetn(reset),
			.clock(CLOCK_50),
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
		defparam VGA.BACKGROUND_IMAGE = "black.mif";*/
		
endmodule

module rateDiv(
	input clock,
	input reset,
	output reg pulse
);
	reg [12:0] div;
	always @(posedge clock) begin
		if(!reset) begin
			//div <= 13'b1111111111111;
			div <= 8'b11111111;
			pulse <= 0;
		end else begin
			if(div == 0) begin
				pulse <= ~pulse;
				//div <= 13'b1111111111111;
				div <= 8'b11111111;
			end else begin
				div <= div - 1;
			end
		end
	end
endmodule