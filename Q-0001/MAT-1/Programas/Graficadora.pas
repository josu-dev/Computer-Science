program	graficadora;

var
i,i0,i1,i2,digito,vy: integer;
py,m2,b,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p110,p111,p112,p113,p114,p20,p21,p22,p23,p24,p25,p26,p27,p28,p29,p210,p211,p212,p213,p214,p30,p31,p32,p33,p34,p35,p36,p37,p38,p39,p310,p311,p312,p313,p314:real;
begin
	i:= 0;
	i1:= -7;
	i2:= -2;
	p114:= i; p113:= i; p112:= i; p111:= i; p110:= i; p19:= i; p18:= i; p17:= i; p16:= i; p15:= i; p14:= i; p13:= i; p12:= i; p11:= i; p10:= i;
	p214:= i; p213:= i; p212:= i; p211:= i; p210:= i; p29:= i; p28:= i; p27:= i; p26:= i; p25:= i; p24:= i; p23:= i; p22:= i; p21:= i; p20:= i;
	p314:= i; p313:= i; p312:= i; p311:= i; p310:= i; p39:= i; p38:= i; p37:= i; p36:= i; p35:= i; p34:= i; p33:= i; p32:= i; p31:= i; p30:= i;
	writeln('Ingrese el numero de la opcion deseada');
	writeln('0 | Para graficar recta con pendiente');
	writeln('1 | Para graficar linea recta vertical');
	readln(i0);
	if i0=0 then begin
		writeln('Ingrese m de su recta');
		readln(m2);
		writeln('Ingrese b de su recta');
		readln(b);
		for i0 :=1 to 3 do begin
			digito:=10000;
			repeat
				vy:=-8;
				py:= m2*i1+b;
				if (py>=-7.5) and (py<=-6.5) then
					vy:= -7
				else if (py>-6.5) and (py<=-5.5) then
					vy:= -6
				else if (py>-5.5) and (py<=-4.5) then
					vy:= -5
				else if (py>-4.5) and (py<=-3.5) then
					vy:= -4
				else if (py>-3.5) and (py<=-2.5) then
					vy:= -3
				else if (py>-2.5) and (py<=-1.5) then
					vy:= -2
				else if (py>-1.5) and (py<=-0.5) then
					vy:= -1
				else if (py>=-0.5) and (py<=0.5) then
					vy:= 0
				else if (py>=0.5) and (py<=1.5) then
					vy:= 1
				else if (py>1.5) and (py<=2.5) then
					vy:= 2
				else if (py>2.5) and (py<=3.5) then
					vy:= 3
				else if (py>3.5) and (py<=4.5) then
					vy:= 4
				else if (py>4.5) and (py<=5.5) then
					vy:= 5
				else if (py>5.5) and (py<=6.5) then
					vy:= 6
				else if (py>6.5) and (py<=7.5) then
					vy:= 7;
				if i1<-2 then
					case vy of
						7: p10:= 1*digito + p10;
						6: p11:= 1*digito + p11;
						5: p12:= 1*digito + p12;
						4: p13:= 1*digito + p13;
						3: p14:= 1*digito + p14;
						2: p15:= 1*digito + p15;
						1: p16:= 1*digito + p16;
						0: p17:= 1*digito + p17;
						-1: p18:= 1*digito + p18;
						-2: p19:= 1*digito + p19;
						-3: p110:= 1*digito + p110;
						-4: p111:= 1*digito + p111;
						-5: p112:= 1*digito + p112;
						-6: p113:= 1*digito + p113;
						-7: p114:= 1*digito + p114;
					end
				else if i1<3 then
					case vy of
						7: p20:= 1*digito + p20;
						6: p21:= 1*digito + p21;
						5: p22:= 1*digito + p22;
						4: p23:= 1*digito + p23;
						3: p24:= 1*digito + p24;
						2: p25:= 1*digito + p25;
						1: p26:= 1*digito + p26;
						0: p27:= 1*digito + p27;
						-1: p28:= 1*digito + p28;
						-2: p29:= 1*digito + p29;
						-3: p210:= 1*digito + p210;
						-4: p211:= 1*digito + p211;
						-5: p212:= 1*digito + p212;
						-6: p213:= 1*digito + p213;
						-7: p214:= 1*digito + p214;
					end
				else
					case vy of
						7: p30:= 1*digito + p30;
						6: p31:= 1*digito + p31;
						5: p32:= 1*digito + p32;
						4: p33:= 1*digito + p33;
						3: p34:= 1*digito + p34;
						2: p35:= 1*digito + p35;
						1: p36:= 1*digito + p36;
						0: p37:= 1*digito + p37;
						-1: p38:= 1*digito + p38;
						-2: p39:= 1*digito + p39;
						-3: p310:= 1*digito + p310;
						-4: p311:= 1*digito + p311;
						-5: p312:= 1*digito + p312;
						-6: p313:= 1*digito + p313;
						-7: p314:= 1*digito + p314;
					end;
				digito:= digito div 10;
				i1:= i1 +1;
			until i1= i2;
			i2:= i2+5;
		end;
	end else begin
		writeln('Ingrese el valor de la constante x');
		readln(py);
		if (py>=-7.5) and (py<=-6.5) then
			vy:= -7
		else if (py>-6.5) and (py<=-5.5) then
			vy:= -6
		else if (py>-5.5) and (py<=-4.5) then
			vy:= -5
		else if (py>-4.5) and (py<=-3.5) then
			vy:= -4
		else if (py>-3.5) and (py<=-2.5) then
			vy:= -3
		else if (py>-2.5) and (py<=-1.5) then
			vy:= -2
		else if (py>-1.5) and (py<=-0.5) then
			vy:= -1
		else if (py>=-0.5) and (py<=0.5) then
			vy:= 0
		else if (py>=0.5) and (py<=1.5) then
			vy:= 1
		else if (py>1.5) and (py<=2.5) then
			vy:= 2
		else if (py>2.5) and (py<=3.5) then
			vy:= 3
		else if (py>3.5) and (py<=4.5) then
			vy:= 4
		else if (py>4.5) and (py<=5.5) then
			vy:= 5
		else if (py>5.5) and (py<=6.5) then
			vy:= 6
		else if (py>6.5) and (py<=7.5) then
			vy:= 7;
		case vy of
			-7: begin b:= 10000; p114:= p114+b; p113:= p113+b; p112:= p112+b; p111:= p111 +b; p110:= p110+b; p19:= p19+b; p18:= p18+b; p17:= p17+b; p16:= p16 +b; p15:= p15 +b; p14:= p14 +b; p13:= p13 +b; p12:= p12 +b; p11:= p11 +b; p10:= p10 +b;end;
			-6: begin b:= 1000; p114:= p114+b; p113:= p113+b; p112:= p112+b; p111:= p111 +b; p110:= p110+b; p19:= p19+b; p18:= p18+b; p17:= p17+b; p16:= p16 +b; p15:= p15 +b; p14:= p14 +b; p13:= p13 +b; p12:= p12 +b; p11:= p11 +b; p10:= p10 +b;end;
			-5: begin b:= 100; p114:= p114+b; p113:= p113+b; p112:= p112+b; p111:= p111 +b; p110:= p110+b; p19:= p19+b; p18:= p18+b; p17:= p17+b; p16:= p16 +b; p15:= p15 +b; p14:= p14 +b; p13:= p13 +b; p12:= p12 +b; p11:= p11 +b; p10:= p10 +b;end;
			-4: begin b:= 10; p114:= p114+b; p113:= p113+b; p112:= p112+b; p111:= p111 +b; p110:= p110+b; p19:= p19+b; p18:= p18+b; p17:= p17+b; p16:= p16 +b; p15:= p15 +b; p14:= p14 +b; p13:= p13 +b; p12:= p12 +b; p11:= p11 +b; p10:= p10 +b;end;
			-3: begin b:= 1; p114:= p114+b; p113:= p113+b; p112:= p112+b; p111:= p111 +b; p110:= p110+b; p19:= p19+b; p18:= p18+b; p17:= p17+b; p16:= p16 +b; p15:= p15 +b; p14:= p14 +b; p13:= p13 +b; p12:= p12 +b; p11:= p11 +b; p10:= p10 +b;end;
			-2: begin b:= 10000; p214:= p214+10000; p213:= p213+10000; p212:= p212+10000; p211:= p211 +10000; p210:= p210+10000; p29:= p29+10000; p28:= p28+10000; p27:= p27+10000; p26:= p26 +10000; p25:= p25 +10000; p24:= p24 +10000; p23:= p23 +10000; p22:= p22 +10000; p21:= p21 +10000; p20:= p20 +10000;end;
			-1: begin b:= 1000; p214:= p214+1000; p213:= p213+1000; p212:= p212+1000; p211:= p211 +1000; p210:= p210+1000; p29:= p29+1000; p28:= p28+1000; p27:= p27+1000; p26:= p26 +1000; p25:= p25 +1000; p24:= p24 +1000; p23:= p23 +1000; p22:= p22 +1000; p21:= p21 +1000; p20:= p20 +1000;end;
			0: begin b:= 100; p214:= p214+100; p213:= p213+100; p212:= p212+100; p211:= p211 +100; p210:= p210+100; p29:= p29+100; p28:= p28+100; p27:= p27+100; p26:= p26 +100; p25:= p25 +100; p24:= p24 +100; p23:= p23 +100; p22:= p22 +100; p21:= p21 +100; p20:= p20 +100;end;
			1: begin b:= 10; p214:= p214+10; p213:= p213+10; p212:= p212+10; p211:= p211 +10; p210:= p210+10; p29:= p29+10; p28:= p28+10; p27:= p27+10; p26:= p26 +10; p25:= p25 +10; p24:= p24 +10; p23:= p23 +10; p22:= p22 +10; p21:= p21 +10; p20:= p20 +10;end;
			2: begin b:= 1; p214:= p214+1; p213:= p213+1; p212:= p212+1; p211:= p211 +1; p210:= p210+1; p29:= p29+1; p28:= p28+1; p27:= p27+1; p26:= p26 +1; p25:= p25 +1; p24:= p24 +1; p23:= p23 +1; p22:= p22 +1; p21:= p21 +1; p20:= p20 +1;end;
			3: begin b:= 10000; p314:= p314+b; p313:= p313+b; p312:= p312+b; p311:= p311 +b; p310:= p310+b; p39:= p39+b; p38:= p38+b; p37:= p37+b; p36:= p36 +b; p35:= p35 +b; p34:= p34 +b; p33:= p33 +b; p32:= p32 +b; p31:= p31 +b; p30:= p30 +b;end;
			4: begin b:= 1000; p314:= p314+b; p313:= p313+b; p312:= p312+b; p311:= p311 +b; p310:= p310+b; p39:= p39+b; p38:= p38+b; p37:= p37+b; p36:= p36 +b; p35:= p35 +b; p34:= p34 +b; p33:= p33 +b; p32:= p32 +b; p31:= p31 +b; p30:= p30 +b;end;
			5: begin b:= 100; p314:= p314+b; p313:= p313+b; p312:= p312+b; p311:= p311 +b; p310:= p310+b; p39:= p39+b; p38:= p38+b; p37:= p37+b; p36:= p36 +b; p35:= p35 +b; p34:= p34 +b; p33:= p33 +b; p32:= p32 +b; p31:= p31 +b; p30:= p30 +b;end;
			6: begin b:= 10; p314:= p314+b; p313:= p313+b; p312:= p312+b; p311:= p311 +b; p310:= p310+b; p39:= p39+b; p38:= p38+b; p37:= p37+b; p36:= p36 +b; p35:= p35 +b; p34:= p34 +b; p33:= p33 +b; p32:= p32 +b; p31:= p31 +b; p30:= p30 +b;end;
			7: begin b:= 1; p314:= p314+b; p313:= p313+b; p312:= p312+b; p311:= p311 +b; p310:= p310+b; p39:= p39+b; p38:= p38+b; p37:= p37+b; p36:= p36 +b; p35:= p35 +b; p34:= p34 +b; p33:= p33 +b; p32:= p32 +b; p31:= p31 +b; p30:= p30 +b;end;
		end;
		
	end;
	writeln(p10:5:0,p20:5:0,p30:5:0);
	writeln(p11:5:0,p21:5:0,p31:5:0);
	writeln(p12:5:0,p22:5:0,p32:5:0);
	writeln(p13:5:0,p23:5:0,p33:5:0);
	writeln(p14:5:0,p24:5:0,p34:5:0);
	writeln(p15:5:0,p25:5:0,p35:5:0);
	writeln(p16:5:0,p26:5:0,p36:5:0);
	writeln(p17:5:0,p27:5:0,p37:5:0);
	writeln(p18:5:0,p28:5:0,p38:5:0);
	writeln(p19:5:0,p29:5:0,p39:5:0);
	writeln(p110:5:0,p210:5:0,p310:5:0);
	writeln(p111:5:0,p211:5:0,p311:5:0);
	writeln(p112:5:0,p212:5:0,p312:5:0);
	writeln(p113:5:0,p213:5:0,p313:5:0);
	writeln(p114:5:0,p214:5:0,p314:5:0);
	

end.
