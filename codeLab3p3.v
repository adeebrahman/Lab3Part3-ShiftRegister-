`timescale 1ns / 1ns

module rotatingReg (input [9:0]SW, [3:0]KEY, output [9:0]LEDR);

	wire DATA[7:0];   //right syntax?
	wire LSRight, loadn, RotateRight, clk, reset;
	
	assign DATA[3:0] = SW[3:0];
	assign reset = SW[9];
	assign KEY[0] = clk;
	assign KEY[1] = loadn;
	assign KEY[2] = RotateRight;
	assign KEY[3] = LSRight;
	
	wire rr[3:0]; //goes into T[3:0]
	wire d[3:0];  //goes into 1 of "data enable mux" 
	wire r[4:0]; 
	//wire l[3:0];
	
	
	//LSRight mux
	mux2to1 lsRight(.x(d[3]), .y(1'b0), .enable(LSRight), .m(r[4]));	//en 1 = y,  	x connects to D of the last DFF
	
	
	//each module has 2 muxes (a rotREG [output wire: rr] and a dataDecide [output wire: d) and 1 DFF module
	
	
	//mod0
	mux2to1 rotREG0(.x(r[4]), .y(r[3]), .enable(RotateRight), .m(rr[0]));
	mux2to1 dataDecide0(.x(DATA[0]), .y(rr[0]), .enable(loadn), .m(d[0]));
	
	DFF FF0 (.D(d[0]), .clk(clk), reset.(reset), .Q(r[0]));  //DONT FORGET TO CONNECT ALL THE r's TO LEDR
	
	//mod1
	mux2to1 rotREG1(.x(r[0]), .y(r[2]), .enable(RotateRight), .m(rr[1]));
	mux2to1 dataDecide1(.x(DATA[1]), .y(rr[1]), .enable(loadn), .m(d[1]));
	
	DFF FF1 (.D(d[1]), .clk(clk), reset.(reset), .Q(r[1));
	
	//mod2
	mux2to1 rotREG2(.x(r[1]), .y(r[3]), .enable(RotateRight), .m(rr[2]));
	mux2to1 dataDecide2(.x(DATA[2]), .y(rr[2]), .enable(loadn), .m(d[2]));
	
	DFF FF2 (.D(d[2]), .clk(clk), reset.(reset), .Q(r[2]));
	
	//mod3
	mux2to1 rotREG2(.x(r[2]), .y(r[0]), .enable(RotateRight), .m(rr[3]));  //r0?
	mux2to1 dataDecide2(.x(DATA[3]), .y(rr[3]), .enable(loadn), .m(d[3]));
	
	DFF FF2 (.D(d[3]), .clk(clk), reset.(reset), .Q(r[3]));
	
	
	
	//Display LEDR
	
	assign LEDR[3:0] = r[3:0];
	
endmodule




module DFF(input D, clk, reset, output Q);
		
	always (@ posedge clk)
		begin
			if (reset == 1'b0)
				Q = 0;
			
			else 
				Q <= D;
		
		end
		
endmodule



module mux2to1(input x, y, enable,output m);

    assign m = enable ? y : x;

endmodule




