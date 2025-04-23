module processor_2(
	input [8:0] DIN,
	input Resetn, Clock, Run,
	output reg Done,
	output reg [8:0] BusWires,
	output [8:0] ADDR, DOUT,
	output W);

	// stany FSM
	localparam [2:0] T0 = 3'b000, T1 = 3'b001, T2 = 3'b010, T3 = 3'b011,
		T4 = 3'b100, T5 = 3'b101;
	// kody instrukcji
	localparam [2:0] mv = 3'b000, mvi = 3'b001, add = 3'b010, sub = 3'b011,
	ld = 3'b100, st = 3'b101, mvnz = 3'b110;
	wire [0:7] Xreg, Yreg;
	wire [2:0] I;
	wire [9:1] IR;
	wire [8:0] A, G;
	wire [8:0] R0, R1, R2, R3, R4, R5, R6, PC;
	reg G_in, G_out, DIN_out, AddSub, IR_in, A_in;
	wire [8:0] Sum;
	reg [2:0] Tstep_Q /* synthesis keep */;
	reg [2:0] Tstep_D;
	reg [0:7] R_in, R_out;
	reg incr_PC;
	wire zero_G = (G == 9'b000000000) /* synthesis keep */;
	reg ADDR_in, DOUT_in;
	reg W_D;

	assign I = IR[9:7];
	dec3to8 decX(IR[6:4], 1'b1, Xreg);
	dec3to8 decY(IR[3:1], 1'b1, Yreg);

	// sterowanie przejściami między stanami FSM
	always @ (Tstep_Q, Run, Done)
		case (Tstep_Q)
			T0:
				if (~Run) Tstep_D = T0;
				else Tstep_D = T1;
			T1:
				if (Done) Tstep_D = T0;
				else Tstep_D = T2;
			T2:
				if (Done) Tstep_D = T0;
				else Tstep_D = T3;
			T3:
				if (Done) Tstep_D = T0;
				else Tstep_D = T4;
			T4:
				if (Done) Tstep_D = T0;
				else Tstep_D = T5;
			default: // T5
				Tstep_D = T0;
		endcase
	
	// sterowanie wyjściami FSM
	always @ (Tstep_Q, I, Xreg, Yreg, zero_G) begin
		Done = 1'b0;
		G_in = 1'b0;
		G_out = 1'b0;
		A_in = 1'b0;
		AddSub = 1'b0;
		DIN_out = 1'b0;
		R_in = 8'b0000_0000;
		R_out = 8'b0000_0000;
		IR_in = 1'b0;
		incr_PC = 1'b0;
		ADDR_in = 1'b0;
		DOUT_in = 1'b0;
		W_D = 1'b0;
		case (Tstep_Q)
			T0: begin // wyjścia z FSM w takcie 0
				R_out[7] = 1'b1;
				ADDR_in = 1'b1;
			end
			// na zboczu T0 -> T1 zegara zlecamy RAMowi wystawienie kodu instrukcji
			T1: begin // wyjścia z FSM w takcie 1
				// RAM dopiero na zboczu T1 -> T2 będzie miał gotowe odczytane słowo
				incr_PC = 1'b1;
			end
			// na zboczu T1 -> T2 RAM inicjuje podanie odczytanego słowa na DIN
			T2: begin // wyjścia z FSM w takcie 2
				// w wyniku opóźnień chwilę po zboczu T1 -> T2 (ale przed T2 -> T3) na DIN trafia słowo
				IR_in = 1'b1;
			end
			// na zboczu T2 -> T3 procesor inicjuje zapisanie w IR słowa z DIN
			T3: // wyjścia z FSM w takcie 3
				// w wyniku opóźnień chwilę po zboczu T2 -> T3 (ale przed T3 -> T4) do IR trafia kod instrukcji
				case (I)
					mv: begin
						R_out = Yreg;
						R_in = Xreg;
						Done = 1'b1;
					end
					mvi: begin
						R_out[7] = 1'b1;
						ADDR_in = 1'b1;
						incr_PC = 1'b1;
					end
					add, sub: begin
						R_out = Xreg;
						A_in = 1'b1;
					end
					ld, st: begin
						R_out = Yreg;
						ADDR_in = 1'b1;
					end
					mvnz: begin
						Done = 1'b1;
						if (~zero_G) begin
							R_out = Yreg;
							R_in = Xreg;
						end
					end
				endcase
			// w instrukcjach mvi i ld na zboczu T3 -> T4 zlecamy RAMowi wystawienie słowa danych
			T4: // wyjścia z FSM w takcie 4
				case (I)
					// mvi, ld: RAM dopiero na zboczu T4 -> T5 będzie miał gotowe odczytane słowo
					add: begin
						R_out = Yreg;
						G_in = 1'b1;
					end
					sub: begin
						R_out = Yreg;
						G_in = 1'b1;
						AddSub = 1'b1;
					end
					st: begin
						R_out = Xreg;
						DOUT_in = 1'b1;
						W_D = 1'b1;
						Done = 1'b1;
					end
				endcase
			// w instrukcjach mvi i ld na zboczu T4 -> T5 RAM inicjuje podanie odczytanego słowa na DIN
			T5: // wyjścia z FSM w takcie 5
				case (I)
					mvi, ld: begin
						// w wyniku opóźnień chwilę po zboczu T4 -> T5 (ale przed T5 -> T0) na DIN trafia słowo
						DIN_out = 1'b1;
						R_in = Xreg;
						Done = 1'b1;
					end
					add, sub: begin
						G_out = 1'b1;
						R_in = Xreg;
						Done = 1'b1;
					end
				endcase
		endcase
	end

	// sterowanie przerzutnikami FSM
	always @ (posedge Clock, negedge Resetn)
		if (~Resetn) Tstep_Q <= T0;
		else Tstep_Q <= Tstep_D;

	// rejestry
	regn #(9) reg_0(BusWires, R_in[0], Clock, R0);
	regn #(9) reg_1(BusWires, R_in[1], Clock, R1);
	regn #(9) reg_2(BusWires, R_in[2], Clock, R2);
	regn #(9) reg_3(BusWires, R_in[3], Clock, R3);
	regn #(9) reg_4(BusWires, R_in[4], Clock, R4);
	regn #(9) reg_5(BusWires, R_in[5], Clock, R5);
	regn #(9) reg_6(BusWires, R_in[6], Clock, R6);
	counter #(9) cnt_pc(Resetn, incr_PC, R_in[7], Clock, BusWires, PC);
	regn #(9) reg_A(BusWires, A_in, Clock, A);
	regn #(9) reg_G(Sum, G_in, Clock, G);
	regn #(9) reg_IR(DIN, IR_in, Clock, IR);
	regn #(9) reg_ADDR(BusWires, ADDR_in, Clock, ADDR);
	regn #(9) reg_DOUT(BusWires, DOUT_in, Clock, DOUT);
	regn #(1) reg_W(W_D, 1'b1, Clock, W);

	// alu
	ripple_carry_adder_subtractor #(9) alu(A, BusWires, AddSub, Sum);

	// multiplekser
	wire [0:9] mux_s;
	assign mux_s = {DIN_out, R_out, G_out};
	always @ (*)
		case (mux_s)
			default: BusWires = DIN;
			10'b0100000000: BusWires = R0; 
			10'b0010000000: BusWires = R1;
			10'b0001000000: BusWires = R2;
			10'b0000100000: BusWires = R3;
			10'b0000010000: BusWires = R4; 
			10'b0000001000: BusWires = R5;
			10'b0000000100: BusWires = R6;
			10'b0000000010: BusWires = PC;
			10'b0000000001: BusWires = G;
		endcase

endmodule

module regn
	#(parameter N = 9)(
	input [N-1:0] R,
	input Rin, Clock,
	output reg [N-1:0] Q);

	initial Q = {N{1'b0}};
	always @ (posedge Clock)
		if (Rin) Q <= R;
		else Q <= Q;

endmodule

module dec3to8(
	input [2:0] W,
	input En,
	output reg [0:7] Y);

	always @ (W, En)
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

endmodule

module ripple_carry_adder_subtractor
	#(parameter N = 4)(
	input [N-1:0] A, B,
	input sub,
	output [N-1:0] S);
	// output cout,
	// output overflow);

	wire [N-2:0] c;
	// assign overflow = c[N-2] ^ cout;
	generate
		genvar i;
		for (i = 0; i < N; i = i + 1)
		begin: ad
			case (i)
				0: full_adder fa(A[i], sub ^ B[i], sub, S[i], c[i]);
				N-1: full_adder fa(A[i], sub ^ B[i], c[i-1], S[i],/*cout*/);
				default: full_adder fa(A[i], sub ^ B[i], c[i-1], S[i], c[i]);
			endcase
		end
	endgenerate

endmodule

module full_adder(
	input a, b, cin,
	output s, cout);

	assign s = cin ^ (a ^ b);
	assign cout = a & b | (a ^ b) & cin;

endmodule

module counter
	#(parameter N = 4)(
	input areset, enable, sload, clock,
	input [N-1:0] data,
	output reg [N-1:0] state);

	initial state = {N{1'b0}};
	always @ (posedge clock, negedge areset)
		if (~areset) state = {N{1'b0}};
		else if (sload) state <= data;
		else if (enable) state <= state + 1'b1;
		else state <= state;

endmodule
