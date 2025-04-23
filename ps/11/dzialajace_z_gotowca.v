module proc_1(
	input [8:0] DIN,
	input Resetn, Clock, Run,
	output reg Done,
	output reg [8:0] BusWires);

	parameter T0 = 2'b00, T1 = 2'b01, T2 = 2'b10, T3 = 2'b11;
	//stany FSM
	parameter mv = 3'b000, mvi = 3'b001, add = 3'b010, sub = 3'b011;
	//kody polecen
	wire [0 : 7] Xreg, Yreg;
	wire [2 : 0] I;
	wire [0 : 9] IR;
	wire [8 : 0] A, G;
	wire [8 : 0] R0, R1, R2, R3, R4, R5, R6, R7;
	wire [0 : 9] mux;
	reg G_in, G_out, DIN_out, AddSub, IR_in, A_in;
	reg [8 : 0] Sum;
	reg [1 : 0] Tstep_Q, Tstep_D;
	reg [0 : 7] R_in, R_out;
	assign I = IR[1 : 3];
	dec3to8 decX (IR[4 : 6], 1'b1, Xreg);
	dec3to8 decY (IR[7 : 9], 1'b1, Yreg);
	//zarzadzanie tabela stanow FSM 
	always @(Tstep_Q, Run, Done)
		case (Tstep_Q)
			T0:
				if (!Run) Tstep_D = T0;
				else Tstep_D = T1;
			T1:
				if (Done) Tstep_D = T0;
				else Tstep_D = T2;
				/* case (I)
					I0, I1: T_D = T0;
					I2, I3: T_D = T2;
				endcase */
			T2:
				Tstep_D = T3;
				/* case (I)
					I0, I1: T_D = T0; // podczas wykonywania instrukcji I0 i I1 FSM nie może mieć stanów T2 ani T3
					I2, I3: T_D = T3;
				endcase */
			T3:
				Tstep_D = T0;
		endcase
	
	//sterowanie wejsciami FSM
	always @(Tstep_Q or I or Xreg or Yreg) begin
		Done = 1'b0; 
		G_in = 1'b0; 
		G_out = 1'b0;
		A_in = 1'b0;
		AddSub = 1'b0;
		DIN_out = 1'b0;
		R_in = 8'b0;
		R_out = 8'b0;
		IR_in = 1'b0;
		case (Tstep_Q)
			T0: begin // zapamiętujemy DIN w IR w takcie 0
				IR_in = 1'b1;
			end
			T1: // wyjścia z FSM w takcie 1
				case (I)
					mv: begin
						R_out = Yreg;
						R_in = Xreg;
						Done = 1'b1;
					end
					mvi: begin
						DIN_out = 1'b1;
						R_in = Xreg;
						Done = 1'b1;
					end
					add, sub: begin
						R_out = Xreg;
						A_in = 1'b1;
					end
				endcase
			T2: // wyjścia z FSM w takcie 2
				// zamiast case (I)
				/* Rout = Yreg;
				Gin = 1'b1;
				if (I == I3)
					add_sub = 1'b1; */
				case (I)
					// I0, I1: ; // nie występują
					add: begin
						R_out = Yreg;
						G_in = 1'b1;
					end
					sub: begin
						R_out = Yreg;
						AddSub = 1'b1;
						G_in = 1'b1;
					end
				endcase
			T3: // wyjścia z FSM w takcie 3
				case (I)
					// I0, I1: ; // nie występują
					add, sub: begin
						G_out = 1'b1;
						R_in = Xreg;
						Done = 1'b1;
					end
				endcase
		endcase
	end
	//sterowanie przerzutnikami FSM
	always @(posedge Clock, negedge Resetn)
		if (!Resetn) Tstep_Q <= T0;
		else Tstep_Q <= Tstep_D;
	// rejestry
	regn #(9) reg_0(BusWires, R_in[0], Clock, R0);
	regn #(9) reg_1(BusWires, R_in[1], Clock, R1);
	regn #(9) reg_2(BusWires, R_in[2], Clock, R2);
	regn #(9) reg_3(BusWires, R_in[3], Clock, R3);
	regn #(9) reg_4(BusWires, R_in[4], Clock, R4);
	regn #(9) reg_5(BusWires, R_in[5], Clock, R5);
	regn #(9) reg_6(BusWires, R_in[6], Clock, R6);
	regn #(9) reg_7(BusWires, R_in[7], Clock, R7);
	
	regn #(9) reg_A(BusWires, A_in, Clock, A);
	regn #(9) reg_IR(DIN[8:0], IR_in, Clock, IR);
	regn #(9) reg_G(Sum, G_in, Clock, G);

	//modul dodawania/odejmowania
	always @(AddSub, A, BusWires)
		begin
			if (AddSub)
				Sum = A - BusWires;
			else
				Sum = A + BusWires;
		end
	assign mux = {DIN_out, R_out, G_out};
	//szyna 
	always@(*) begin
		if (mux == 10'b0100000000) BusWires = R0; 
		else if (mux == 10'b0010000000) BusWires = R1;
		else if (mux == 10'b0001000000) BusWires = R2;
		else if (mux == 10'b0000100000) BusWires = R3;
		else if (mux == 10'b0000010000) BusWires = R4; 
		else if (mux == 10'b0000001000) BusWires = R5;
		else if (mux == 10'b0000000100) BusWires = R6;
		else if (mux == 10'b0000000010) BusWires = R7;
		else if (mux == 10'b0000000001) BusWires = G;
		else BusWires = DIN;
	end

endmodule

module regn(R, Rin, Clock, Q);
parameter n = 9;
input [n-1:0] R;
input Rin, Clock;
output [n-1:0] Q;
reg [n-1:0] Q;
always @(posedge Clock)
if (Rin)
Q <= R;
endmodule

module dec3to8(W, En, Y);
input [2:0] W;
input En;
output [0:7] Y;
reg [0:7] Y;
always @(W or En)
begin
if (En == 1)
case (W)
3'b000: Y = 8'b10000000;
3'b001: Y = 8'b01000000;
3'b010: Y = 8'b00100000;
3'b011: Y = 8'b00010000;
3'b100: Y = 8'b00001000;
3'b101: Y = 8'b00000100;
3'b110: Y = 8'b00000010;
3'b111: Y = 8'b00000001;
endcase
else
Y = 8'b00000000;
end
endmodule
