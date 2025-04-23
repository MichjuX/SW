module proc_1(
	input [8:0] DIN,
	input Resetn, Clock, Run,
	output reg Done,
	output [8:0] Bus);

	reg [7:0] Rin;
	reg Ain, Gin;
	wire [8:0] R_Q [7:0];
	regn #(9) reg_0(Bus, Rin[0], Clock, R_Q[0]);
	regn #(9) reg_1(Bus, Rin[1], Clock, R_Q[1]);
	regn #(9) reg_2(Bus, Rin[2], Clock, R_Q[2]);
	regn #(9) reg_3(Bus, Rin[3], Clock, R_Q[3]);
	regn #(9) reg_4(Bus, Rin[4], Clock, R_Q[4]);
	regn #(9) reg_5(Bus, Rin[5], Clock, R_Q[5]);
	regn #(9) reg_6(Bus, Rin[6], Clock, R_Q[6]);
	regn #(9) reg_7(Bus, Rin[7], Clock, R_Q[7]);
	
	wire [8:0] A_Q;
	regn #(9) reg_A(Bus, Ain, Clock, A_Q);
	
	reg add_sub;
	wire [8:0] G_D, G_Q;
	ripple_carry_adder_subtractor #(9) alu(A_Q, Bus, add_sub, G_D);
	regn #(9) reg_G(G_D, Gin, Clock, G_Q);
	
	reg IRin;
	wire [8:0] IR_Q;
	regn #(9) reg_IR(DIN, IRin, Clock, IR_Q);

	reg [7:0] Rout;
	reg Gout, DINout;
	one_hot_mux_10x1 #(9) mux({DINout, Rout [7:0], Gout},
		DIN, R_Q[7], R_Q[6], R_Q[5], R_Q[4], R_Q[3], R_Q[2], R_Q[1], R_Q[0], G_Q,
		Bus);

	wire [1:0] I = IR_Q[7:6];
	wire [7:0] Xreg, Yreg;
	dec3to8 decX(IR_Q[5:3], 1'b1, Xreg);
	dec3to8 decY(IR_Q[2:0], 1'b1, Yreg);

	// kody stanów FSM
	localparam [1:0] T0 = 2'b00, T1 = 2'b01, T2 = 2'b10, T3 = 2'b11;
	reg [1:0] T_D;
	reg [1:0] T_Q = T0;
	// sterowanie przerzutnikami FSM
	always @ (posedge Clock, negedge Resetn)
		if (~Resetn) T_Q <= T0;
		else T_Q <= T_D;

	// kody instrukcji
	localparam [1:0] I0 = 2'b00, I1 = 2'b01, I2 = 2'b10, I3 = 2'b11;
	// sterowanie przejściami między stanami FSM
	always @ (T_Q, Run, Done) begin
		case (T_Q)
			T0: // w tym takcie ładujemy kod instrukcji
				// case (I)
					// I0, I1, I2, I3: begin
						if (~Run) T_D = T0;
						else T_D = T1;
					// end
				// endcase
			T1:
				if (Done) T_D = T0;
				else T_D = T2;
				/* case (I)
					I0, I1: T_D = T0;
					I2, I3: T_D = T2;
				endcase */
			T2:
				T_D = T3;
				/* case (I)
					I0, I1: T_D = T0; // podczas wykonywania instrukcji I0 i I1 FSM nie może mieć stanów T2 ani T3
					I2, I3: T_D = T3;
				endcase */
			T3:
				T_D = T0;
		endcase
	end

	// sterowanie wyjściami FSM
	always @ (T_Q or I or Xreg or Yreg) begin
		// domyślne wartości
		IRin = 1'b0;
		Rout = 8'b00000000;
		Gout = 1'b0;
		DINout = 1'b0;
		Rin = 8'b00000000;
		Ain = 1'b0;
		Gin = 1'b0;
		add_sub = 1'b0;
		Done = 1'b0;
		case (T_Q)
			T0: // zapamiętujemy DIN w IR w takcie 0
				IRin = 1'b1;
			T1: // wyjścia z FSM w takcie 1
				case (I)
					I0: begin
						Rout = Yreg;
						Rin = Xreg;
						Done = 1'b1;
					end
					I1: begin
						DINout = 1'b1;
						Rin = Xreg;
						Done = 1'b1;
					end
					I2, I3: begin
						Rout = Xreg;
						Ain = 1'b1;
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
					I2: begin
						Rout = Yreg;
						Gin = 1'b1;
					end
					I3: begin
						Rout = Yreg;
						Gin = 1'b1;
						add_sub = 1'b1;
					end
				endcase
			T3: // wyjścia z FSM w takcie 3
				case (I)
					// I0, I1: ; // nie występują
					I2, I3: begin
						Gout = 1'b1;
						Rin = Xreg;
						Done = 1'b1;
					end
				endcase
		endcase
	end

endmodule

module regn
	#(parameter N = 9)(
	input [N-1:0] R,
	input Rin, Clock,
	output reg [N-1:0] Q);

	always @ (posedge Clock)
		if (Rin) Q <= R;
		else Q <= Q;

endmodule

module one_hot_mux_10x1
	#(parameter BITS = 9)(
	input [9:0] s,
	input [BITS-1:0] i0_, i1_, i2_, i3_, i4_, i5_, i6_, i7_, i8_, i9_,
	output reg [BITS-1:0] out);

	/* wire [BITS-1:0] i_and_s [9:0];
	assign i_and_s[0] = i0_ & {BITS{s[0]}};
	assign i_and_s[1] = i1_ & {BITS{s[1]}};
	assign i_and_s[2] = i2_ & {BITS{s[2]}};
	assign i_and_s[3] = i3_ & {BITS{s[3]}};
	assign i_and_s[4] = i4_ & {BITS{s[4]}};
	assign i_and_s[5] = i5_ & {BITS{s[5]}};
	assign i_and_s[6] = i6_ & {BITS{s[6]}};
	assign i_and_s[7] = i7_ & {BITS{s[7]}};
	assign i_and_s[8] = i8_ & {BITS{s[8]}};
	assign i_and_s[9] = i9_ & {BITS{s[9]}};
	generate
		genvar bit_index;
		for (bit_index = 0; bit_index <= BITS-1; bit_index = bit_index + 1) begin: forb
			assign out[bit_index] =
				i_and_s[0][bit_index] |
				i_and_s[1][bit_index] |
				i_and_s[2][bit_index] |
				i_and_s[3][bit_index] |
				i_and_s[4][bit_index] |
				i_and_s[5][bit_index] |
				i_and_s[6][bit_index] |
				i_and_s[7][bit_index] |
				i_and_s[8][bit_index] |
				i_and_s[9][bit_index];
		end
	endgenerate */

	always @ (*)
		case (s)
			10'b0000000001: out = i0_;
			10'b0000000010: out = i1_;
			10'b0000000100: out = i2_;
			10'b0000001000: out = i3_;
			10'b0000010000: out = i4_;
			10'b0000100000: out = i5_;
			10'b0001000000: out = i6_;
			10'b0010000000: out = i7_;
			10'b0100000000: out = i8_;
			10'b1000000000: out = i9_;
			default: out = {BITS{1'b0}};
		endcase

endmodule

module dec3to8(
	input [2:0] W,
	input En,
	output reg [7:0] Y);

	always @ (W, En)
		if (En)
			case (W)
				3'b000: Y = 8'b00000001;
				3'b001: Y = 8'b00000010;
				3'b010: Y = 8'b00000100;
				3'b011: Y = 8'b00001000;
				3'b100: Y = 8'b00010000;
				3'b101: Y = 8'b00100000;
				3'b110: Y = 8'b01000000;
				3'b111: Y = 8'b10000000;
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
