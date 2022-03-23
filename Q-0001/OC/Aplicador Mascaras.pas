program a_mascaras_v0;

var
elecc,opl: string;
sx7,sx6,sx5,sx4,sx3,sx2,sx1,sx0,x0,x1,x2,x3,x4,x5,x6,x7,m7,m6,m5,m4,m3,m2,m1,m0: char;

begin
	repeat
		repeat
			writeln('Ingrese el byte al que le quiere aplicar la mascara de la siguiente forma:');
			writeln('Por ejemplo si su byte es xx1xxx00, ingrese: x x 1 x x x 0 0 /deje 1 espacio antes del primer bit/');
			read(sx7);read(x7);read(sx6);read(x6);read(sx5);read(x5);read(sx4);read(x4);read(sx3);read(x3);read(sx2);read(x2);read(sx1);read(x1);read(sx0);readln(x0);
			writeln('Si su byte es: ',sx7,x7,sx6,x6,sx5,x5,sx4,x4,sx3,x3,sx2,x2,sx1,x1,sx0,x0, ' ingrese 1, sino ingrese 0');
			readln(elecc);
			if elecc<>'1' then
				writeln('Intentelo nuevamente');
			writeln();
		until elecc='1';
		repeat
			repeat
				writeln('Ingrese el numero de la operacion logica que quiere aplicar');
				writeln('0 || NOT');
				writeln('1 || OR');
				writeln('2 || AND');
				writeln('3 || NOR');
				writeln('4 || NAND');
				writeln('5 || XOR');
				writeln('6 || XNOR');
				readln(opl);
				if (opl<>'0') AND (opl<>'1') AND (opl<>'2') AND (opl<>'3') AND (opl<>'4') AND (opl<>'5') AND (opl<>'6') then
					writeln('Intentelo nuevamente');
				writeln();
			until (opl='0') or (opl='1') or (opl='2') or (opl='3') or (opl='4') or (opl='5') or (opl='6');
			if opl='0' then begin
				if x7='1' then
					x7:='0'
				else if x7='0'then
					x7:='1'
				else begin
					if sx7=' ' then
						sx7:='-'
					else 
						sx7:=' ';
					end;
				if x6='1' then
					x6:='0'
				else if x6='0'then
					x6:='1'
				else begin
					if sx6=' ' then
						sx6:='-'
					else 
						sx6:=' ';
					end;
				if x5='1' then
					x5:='0'
				else if x5='0'then
					x5:='1'
				else begin
					if sx5=' ' then
						sx5:='-'
					else 
						sx5:=' ';
					end;
				if x4='1' then
					x4:='0'
				else if x4='0'then
					x4:='1'
				else begin
					if sx4=' ' then
						sx4:='-'
					else 
						sx4:=' ';
					end;
				if x3='1' then
					x3:='0'
				else if x3='0'then
					x3:='1'
				else begin
					if sx3=' ' then
						sx3:='-'
					else 
						sx3:=' ';
					end;
				if x2='1' then
					x2:='0'
				else if x2='0'then
					x2:='1'
				else begin
					if sx2=' ' then
						sx2:='-'
					else 
						sx2:=' ';
					end;
				if x1='1' then
					x1:='0'
				else if x1='0'then
					x1:='1'
				else begin
					if sx1=' ' then
						sx1:='-'
					else 
						sx1:=' ';
					end;
				if x0='1' then
					x0:='0'
				else if x0='0'then
					x0:='1'
				else begin
					if sx0=' ' then
						sx0:='-'
					else 
						sx0:=' ';
					end;
			end
			else begin
				repeat
					writeln('Ingrese el byte mascara');
					writeln('Por ejemplo si su byte mascara es 11001100, ingrese:11001100');
					read(m7);read(m6);read(m5);read(m4);read(m3);read(m2);read(m1);readln(m0);
					writeln('Si su byte es: ',m7,m6,m5,m4,m3,m2,m1,m0, ' ingrese 1, sino ingrese 0');
					readln(elecc);
					if elecc<>'1' then
						writeln('Intentelo nuevamente');
					writeln();
				until elecc='1';
			end;
			case opl of
				'1' : begin
						if m7='1' then begin
							x7:='1';
							sx7:=' ';
						end;
						if m6='1' then begin
							x6:='1';
							sx6:=' ';
						end;
						if m5='1' then begin
							x5:='1';
							sx5:=' ';
						end;
						if m4='1' then begin
							x4:='1';
							sx4:=' ';
						end;
						if m3='1' then begin
							x3:='1';
							sx3:=' ';
						end;
						if m2='1' then begin
							x2:='1';
							sx2:=' ';
						end;
						if m1='1' then begin
							x1:='1';
							sx1:=' ';
						end;
						if m0='1' then begin
							x0:='1';
							sx0:=' ';
						end;
					end;
				'2' : begin
						if m7='0' then
							x7:='0';
						if m6='0' then
							x6:='0';
						if m5='0' then
							x5:='0';
						if m4='0' then
							x4:='0';
						if m3='0' then
							x3:='0';
						if m2='0' then
							x2:='0';
						if m1='0' then
							x1:='0';
						if m0='0' then
							x0:='0';
						end;
				'3' : begin
						if m7='1' then
							x7:='0'
						else if x7='x' then begin
							if sx7=' ' then
								sx7:='-'
							else 
								sx7:=' ';
							end
						else if x7='0' then
								x7:='1'
						else x7:='0';
						if m6='1' then
							x6:='0'
						else if x6='x' then begin
							if sx6=' ' then
								sx6:='-'
							else 
								sx6:=' ';
							end
						else if x6='0' then
								x6:='1'
						else x6:='0';
						if m5='1' then
							x5:='0'
						else if x5='x' then begin
							if sx5=' ' then
								sx5:='-'
							else 
								sx5:=' ';
							end
						else if x5='0' then
								x5:='1'
						else x5:='0';
						if m4='1' then
							x4:='0'
						else if x4='x' then begin
							if sx4=' ' then
								sx4:='-'
							else 
								sx4:=' ';
							end
						else if x4='0' then
								x4:='1'
						else x4:='0';
						if m3='1' then
							x3:='0'
						else if x3='x' then begin
							if sx3=' ' then
								sx3:='-'
							else 
								sx3:=' ';
							end
						else if x3='0' then
								x3:='1'
						else x3:='0';
						if m2='1' then
							x2:='0'
						else if x2='x' then begin
							if sx2=' ' then
								sx2:='-'
							else 
								sx2:=' ';
							end
						else if x2='0' then
								x2:='1'
						else x2:='0';
						if m1='1' then
							x1:='0'
						else if x1='x' then begin
							if sx1=' ' then
								sx1:='-'
							else 
								sx1:=' ';
							end
						else if x1='0' then
								x1:='1'
						else x1:='0';
						if m0='1' then
							x0:='0'
						else if x0='x' then begin
							if sx0=' ' then
								sx0:='-'
							else 
								sx0:=' ';
							end
						else if x0='0' then
								x0:='1'
						else x0:='0';
						end;
				'4' : begin
						if m7='0' then
							x7:='1'
						else if x7='x' then begin
								if sx7=' ' then
									sx7:='-'
								else 
									sx7:=' ';
								end
							else if x7='0' then
								x7:='1'
							else x7:='0';
						if m6='0' then
							x6:='1'
						else if x6='x' then begin
								if sx6=' ' then
									sx6:='-'
								else 
									sx6:=' ';
								end
							else if x6='0' then
								x6:='1'
							else x6:='0';
						if m5='0' then
							x5:='1'
						else if x5='x' then begin
								if sx5=' ' then
									sx5:='-'
								else 
									sx5:=' ';
								end
							else if x5='0' then
								x5:='1'
							else x5:='0';
						if m4='0' then
							x4:='1'
						else if x4='x' then begin
								if sx4=' ' then
									sx4:='-'
								else 
									sx4:=' ';
								end
							else if x4='0' then
								x4:='1'
							else x4:='0';
						if m3='0' then
							x3:='1'
						else if x3='x' then begin
								if sx3=' ' then
									sx3:='-'
								else 
									sx3:=' ';
								end
							else if x3='0' then
								x3:='1'
							else x3:='0';
						if m2='0' then
							x2:='1'
						else if x2='x' then begin
								if sx2=' ' then
									sx2:='-'
								else 
									sx2:=' ';
								end
							else if x2='0' then
								x2:='1'
							else x2:='0';
						if m1='0' then
							x1:='1'
						else if x1='x' then begin
								if sx1=' ' then
									sx1:='-'
								else 
									sx1:=' ';
								end
							else if x1='0' then
								x1:='1'
							else x1:='0';
						if m0='0' then
							x0:='1'
						else if x0='x' then begin
								if sx0=' ' then
									sx0:='-'
								else 
									sx0:=' ';
								end
							else if x0='0' then
								x0:='1'
							else x0:='0';
						end;
				'5' : begin
						if m7='1' then begin
							if x7='x' then begin
								if sx7=' ' then
									sx7:='-'
								else 
									sx7:=' ';
								end
							else if x7='0' then
								x7:='1'
							else x7:='0';
						end;
						if m6='1' then begin
							if x6='x' then begin
								if sx6=' ' then
									sx6:='-'
								else 
									sx6:=' ';
								end
							else if x6='0' then
								x6:='1'
							else x6:='0';
						end;
						if m5='1' then begin
							if x5='x' then begin
								if sx5=' ' then
									sx5:='-'
								else 
									sx5:=' ';
								end
							else if x5='0' then
								x5:='1'
							else x5:='0';
						end;
						if m4='1' then begin
							if x4='x' then begin
								if sx4=' ' then
									sx4:='-'
								else 
									sx4:=' ';
								end
							else if x4='0' then
								x4:='1'
							else x4:='0';
						end;
						if m3='1' then begin
							if x3='x' then begin
								if sx3=' ' then
									sx3:='-'
								else 
									sx3:=' ';
								end
							else if x3='0' then
								x3:='1'
							else x3:='0';
						end;
						if m2='1' then begin
							if x2='x' then begin
								if sx2=' ' then
									sx2:='-'
								else 
									sx2:=' ';
								end
							else if x2='0' then
								x2:='1'
							else x2:='0';
						end;
						if m1='1' then begin
							if x1='x' then begin
								if sx1=' ' then
									sx1:='-'
								else 
									sx1:=' ';
								end
							else if x1='0' then
								x1:='1'
							else x1:='0';
						end;
						if m0='1' then begin
							if x0='x' then begin
								if sx0=' ' then
									sx0:='-'
								else 
									sx0:=' ';
								end
							else if x0='0' then
								x0:='1'
							else x0:='0';
						end;
						end;
				'6' : begin
						if m7='0' then begin
							if x7='x' then begin
								if sx7=' ' then
									sx7:='-'
								else 
									sx7:=' ';
								end
							else if x7='0' then
								x7:='1'
							else x7:='0';
						end;
						if m6='0' then begin
							if x6='x' then begin
								if sx6=' ' then
									sx6:='-'
								else 
									sx6:=' ';
								end
							else if x6='0' then
								x6:='1'
							else x6:='0';
						end;
						if m5='0' then begin
							if x5='x' then begin
								if sx5=' ' then
									sx5:='-'
								else 
									sx5:=' ';
								end
							else if x5='0' then
								x5:='1'
							else x5:='0';
						end;
						if m4='0' then begin
							if x4='x' then begin
								if sx4=' ' then
									sx4:='-'
								else 
									sx4:=' ';
								end
							else if x4='0' then
								x4:='1'
							else x4:='0';
						end;
						if m3='0' then begin
							if x3='x' then begin
								if sx3=' ' then
									sx3:='-'
								else 
									sx3:=' ';
								end
							else if x3='0' then
								x3:='1'
							else x3:='0';
						end;
						if m2='0' then begin
							if x2='x' then begin
								if sx2=' ' then
									sx2:='-'
								else 
									sx2:=' ';
								end
							else if x2='0' then
								x2:='1'
							else x2:='0';
						end;
						if m1='0' then begin
							if x1='x' then begin
								if sx1=' ' then
									sx1:='-'
								else 
									sx1:=' ';
								end
							else if x1='0' then
								x1:='1'
							else x1:='0';
						end;
						if m0='0' then begin
							if x0='x' then begin
								if sx0=' ' then
									sx0:='-'
								else 
									sx0:=' ';
								end
							else if x0='0' then
								x0:='1'
							else x0:='0';
						end;
						end;
			end;
			writeln('El resultado de aplicar la mascara es:');
			writeln(sx7,x7,sx6,x6,sx5,x5,sx4,x4,sx3,x3,sx2,x2,sx1,x1,sx0,x0);
			writeln();
			repeat
				writeln('Ingrese el numero de la opcion que quiere');
				writeln('0 || Aplicar otra mascara');
				writeln('1 || Comenzar de 0');
				writeln('2 || Cerrar aplicacion');
				readln(elecc);
				writeln();
			until (elecc='0') or (elecc='1') or (elecc='2');
		until (elecc='1') or (elecc='2');
		if elecc='2' then
			elecc:='9';
	until elecc='9';
	readln();
end.
