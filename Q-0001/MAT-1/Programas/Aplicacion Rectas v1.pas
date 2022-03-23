
program calculadora_de_rectas;

var
elecc,confirmacion,
cari,cari7,cari6,cari5,cari4,cari3,cari2,cari1,cari0,carim1,carim2,carim3,carim4,carim5,carim6,carim7,
card,card7,card6,card5,card4,card3,card2,card1,card0,cardm1,cardm2,cardm3,cardm4,cardm5,cardm6,cardm7,
carp,carm7,carm6,carm5,carm4,carm3,carm2,carm1,carm0,carmm1,carmm2,carmm3,carmm4,carmm5,carmm6,carmm7:string;
px,x1p,x2p,y1p,y2p,m1,m2,b1,b2,a,b,c,n1c,n2c,n3c: real;
i,vx,espi:integer;
begin
	repeat
		writeln('Elija la herramienta a utilizar:');
		writeln('0 || Recta a base de 2 puntos');
		writeln('1 || Recta paralela a 1 existente');
		writeln('2 || Recta perpendicular a 1 existente');
		readln(elecc);
		writeln();
	until (elecc='0') or (elecc='1') or (elecc='2');
	if elecc='0' then begin
		confirmacion:='no';
		while (confirmacion='no') or (confirmacion='No') or (confirmacion='NO') do begin
			writeln('Ingrese el primer punto perteneciente a la recta');
			writeln('-Cordenada x del punto');
			readln(x1p);
			writeln('-Cordenada y del punto');
			readln(y1p);
			writeln('Si su punto es (',x1p:4:2,', ',y1p:4:2,') ingrese "si", de no ser asi, ingrese "no"');
			readln(confirmacion);
			if (confirmacion='no') or (confirmacion='No') or (confirmacion='NO') then
				writeln('Intentelo de nuevo');
		end;
		writeln();
		confirmacion:='no';
		while (confirmacion='no') or (confirmacion='No') or (confirmacion='NO') do begin
			writeln('Ingrese el segundo punto perteneciente a la recta');
			writeln('-Cordenada x del punto');
			readln(x2p);
			writeln('-Cordenada y del punto');
			readln(y2p);
			writeln('Si su punto es (',x2p:4:2,', ',y2p:4:2,') ingrese "si", de no ser asi, ingrese "no"');
			readln(confirmacion);
			if (confirmacion='no') or (confirmacion='No') or (confirmacion='NO') then
				writeln('Intentelo de nuevo');
		end;
		writeln();
		m1:= (y2p-y1p)/(x2p-x1p);
		b1:= y1p - (m1*x1p);
		writeln('La ecuacion de la recta que pasa por (',x1p:4:2,', ',y1p:4:2,') y (',x2p:4:2,', ',y2p:4:2,') es: y= ',m1:4:2,'x ',b1:3:1);	
		writeln('La grafica de y= ',m1:4:2,'x ',b1:3:1,' es:');
		writeln();
		for i:=7 downto -7 do begin
			if m1<-5 then
				carp:='|'
			else if m1<-0.5 then
				carp:='\'
			else if m1<0.5 then
				carp:='-'
			else if m1<5 then
				carp:='/'
			else 
				carp:='|';
			if m1<>0 then begin
				px:= (i-b1)/m1;
				if px<=-7.5 then
					vx:= -8
				else if px<=-6.5 then
					vx:= -7
				else if px<=-5.5 then
					vx:= -6
				else if px<=-4.5 then
					vx:= -5
				else if px<=-3.5 then
					vx:= -4
				else if px<=-2.5 then
					vx:= -3
				else if px<=-1.5 then
					vx:= -2
				else if px<=-0.5 then
					vx:= -1
				else if px<=0.5 then
					vx:= 0
				else if px<=1.5 then
					vx:= 1
				else if px<=2.5 then
					vx:= 2
				else if px<=3.5 then
					vx:= 3
				else if px<=4.5 then
					vx:= 4
				else if px<=5.5 then
					vx:= 5
				else if px<=6.5 then
					vx:= 6
				else if px<=7.5 then
					vx:= 7
				else if px>7.5 then
					vx:= 8;
					espi:= 7+vx;
				case espi of
					15 : begin cari:='               '; carp:=''; card:='';end;
					14 : begin cari:='              '; card:=' ';end;
					13 : begin cari:='             '; card:='  ';end;
					12 : begin cari:='            '; card:='   ';end;
					11 : begin cari:='           '; card:='    ';end;
					10 : begin cari:='          '; card:='     ';end;
					9 : begin cari:='         '; card:='      ';end;
					8 : begin cari:='        '; card:='       ';end;
					7 : begin cari:='       '; card:='        ';end;
					6 : begin cari:='      '; card:='         ';end;
					5 : begin cari:='     '; card:='          ';end;
					4 : begin cari:='    '; card:='           ';end;
					3 : begin cari:='   '; card:='            ';end;
					2 : begin cari:='  '; card:='             ';end;
					1 : begin cari:=' '; card:='              ';end;
					0 : begin cari:=''; card:='               ';end;
					-1 : begin cari:=''; carp:=''; card1:='                ';end;
				end;
			end else if i=b1 then begin
				cari:='_______';
				carp:='_';
				card:='_______';
			end else begin
				cari:='';
				carp:='';
				card:='';
			end;
			if i=7 then begin
				cari7:=cari;
				carm7:=carp;
				card7:=card;
			end else if i=6 then begin
				cari6:=cari;
				carm6:=carp;
				card6:=card;
			end else if i=5 then begin
				cari5:=cari;
				carm5:=carp;
				card5:=card;
			end else if i=4 then begin
				cari4:=cari;
				carm4:=carp;
				card4:=card;
			end else if i=3 then begin
				cari3:=cari;
				carm3:=carp;
				card3:=card;
			end else if i=2 then begin
				cari2:=cari;
				carm2:=carp;
				card2:=card;
			end else if i=1 then begin
				cari1:=cari;
				carm1:=carp;
				card1:=card;
			end else if i=0 then begin
				cari0:=cari;
				carm0:=carp;
				card0:=card;
			end else if i=-1 then begin
				carim1:=cari;
				carmm1:=carp;
				cardm1:=card;
			end else if i=-2 then begin
				carim2:=cari;
				carmm2:=carp;
				cardm2:=card;
			end else if i=-3 then begin
				carim3:=cari;
				carmm3:=carp;
				cardm3:=card;
			end else if i=-4 then begin
				carim4:=cari;
				carmm4:=carp;
				cardm4:=card;
			end else if i=-5 then begin
				carim5:=cari;
				carmm5:=carp;
				cardm5:=card;
			end else if i=-6 then begin
				carim6:=cari;
				carmm6:=carp;
				cardm6:=card;
			end else if i=-7 then begin
				carim7:=cari;
				carmm7:=carp;
				cardm7:=card;
			end;
		end;
		writeln();
		writeln();
		writeln('===============');
		writeln(cari7,carm7,card7);
		writeln(cari6,carm6,card6);
		writeln(cari5,carm5,card5);
		writeln(cari4,carm4,card4);
		writeln(cari3,carm3,card3);
		writeln(cari2,carm2,card2);
		writeln(cari1,carm1,card1);
		writeln(cari0,carm0,card0);
		writeln(carim1,carmm1,cardm1);
		writeln(carim2,carmm2,cardm2);
		writeln(carim3,carmm3,cardm3);
		writeln(carim4,carmm4,cardm4);
		writeln(carim5,carmm5,cardm5);
		writeln(carim6,carmm6,cardm6);
		writeln(carim7,carmm7,cardm7);
		writeln('===============');
	end
	else if elecc='1' then begin
		repeat
			writeln('Cual es la forma de la ecuacion de la recta base:');
			writeln('0 || ax + by + c=0');
			writeln('1 || y - y1 = m(x - x1)');
			writeln('2 || y - y1 = y2 - y1(x - x1)');
			writeln('              -------');
			writeln('              x2 - x1');
			readln(elecc);
			writeln();
		until (elecc='0') or (elecc='1') or (elecc='2');
		case elecc of
			'0' : begin
					confirmacion:='no';
					while (confirmacion='no') or (confirmacion='No') or (confirmacion='NO') do begin
						writeln('A continuacion ingrese los datos');
						writeln('-Coeficiente de x');
						readln(a);
						writeln('-Coeficiente de y');
						readln(b);
						writeln('-Termino independiente');
						readln(c);
						writeln('Si su ecuacion es ',a:4:2,'x ',b:4:2,'y ',c:4:2,' = 0 ingrese "si", de no ser asi, ingrese "no"');
						readln(confirmacion);
						if (confirmacion='no') or (confirmacion='No') or (confirmacion='NO') then
							writeln('Intentelo de nuevo');
					end;
					writeln();
					
					n1c:= -a;
					n3c:= -c;
					if b>0 then
						n2c:= b
					else begin
						n2c:= -b;
						n1c:= -n1c;
						n3c:= -n3c;
					end;
					n1c:= n1c/n2c;
					b1:= n3c/n2c;
					n2c:= 1;
					m1:=n1c;
					writeln('La ecuacion ingresada en forma explicita es: y= ',m1:3:2,'x ',b1:3:2);
				end;
			'1' : begin
					confirmacion:='no';
					while (confirmacion='no') or (confirmacion='No') or (confirmacion='NO') do begin
						writeln('A continuacion ingrese los datos');
						writeln('-Valor de y1');
						readln(y1p);
						writeln('-Valor de m');
						readln(m1);
						writeln('-Valor de x1');
						readln(x1p);
						writeln('Si su ecuacion es y - ',y1p:4:2,' = ',m1:4:2,'(x - ',x1p:4:2,') ingrese "si", de no ser asi, ingrese "no"');
						readln(confirmacion);
						if (confirmacion='no') or (confirmacion='No') or (confirmacion='NO') then
							writeln('Intentelo de nuevo');
					end;
					writeln();
					b1:= m1*x1p + y1p;
					writeln('La ecuacion ingresada en forma explicita es: y= ',m1:3:2,'x ',b1:3:2);
				end;
			'2' : begin
					confirmacion:='no';
					while (confirmacion='no') or (confirmacion='No') or (confirmacion='NO') do begin
						writeln('Ingrese los datos solicitados');
						writeln('-Valor de y1');
						readln(y1p);
						writeln('-Valor de y2');
						readln(y2p);
						writeln('-Valor de x1');
						readln(x1p);
						writeln('-Valor de x2');
						readln(x2p);
						writeln('Si su ecuacion es y ',-y1p:4:2,' = ',y2p:4:2,' ',-y1p:4:2,'(x ',-x1p:4:2,') ingrese "si", de no ser asi, ingrese "no"');
						writeln('                           -----------');
						writeln('                            ',x2p:4:2,' ',-x1p:4:2);
						readln(confirmacion);
						if (confirmacion='no') or (confirmacion='No') or (confirmacion='NO') then
							writeln('Intentelo de nuevo');
					end;
					writeln();
					m1:= (y2p-y1p)/(x2p-x1p);
					b1:= y1p - (m1*x1p);
					writeln('La ecuacion ingresada en forma explicita es: y= ',m1:3:2,'x ',b1:3:2);
				end;
		end;
		writeln();
		confirmacion:='no';
		while (confirmacion='no') or (confirmacion='No') or (confirmacion='NO') do begin
			writeln('Ingrese 1 punto perteneciente a la recta paralela que busca');
			writeln('-Cordenada x del punto');
			readln(x1p);
			writeln('-Cordenada y del punto');
			readln(y1p);
			writeln('Si su punto es (',x1p:4:2,', ',y1p:4:2,') ingrese "si", de no ser asi, ingrese "no"');
			readln(confirmacion);
			if (confirmacion='no') or (confirmacion='No') or (confirmacion='NO') then
				writeln('Intentelo de nuevo');
		end;
		writeln();
		b2:= y1p - (m1*x1p);
		writeln('La ecuacion de la recta paralela a  y= ',m1:3:1,'x ',b1:3:1,' que pasa por(',x1p:4:2,', ',y1p:4:2,') es: y= ',m1:4:2,'x ',b2:3:1);
		writeln('La grafica de y= ',m1:4:2,'x ',b2:3:1,' es:');
		writeln();
		for i:=7 downto -7 do begin
			if m1<-5 then
				carp:='|'
			else if m1<-0.5 then
				carp:='\'
			else if m1<0.5 then
				carp:='-'
			else if m1<5 then
				carp:='/'
			else 
				carp:='|';
			if m1<>0 then begin
				px:= (i-b2)/m1;
				if px<=-7.5 then
					vx:= -8
				else if px<=-6.5 then
					vx:= -7
				else if px<=-5.5 then
					vx:= -6
				else if px<=-4.5 then
					vx:= -5
				else if px<=-3.5 then
					vx:= -4
				else if px<=-2.5 then
					vx:= -3
				else if px<=-1.5 then
					vx:= -2
				else if px<=-0.5 then
					vx:= -1
				else if px<=0.5 then
					vx:= 0
				else if px<=1.5 then
					vx:= 1
				else if px<=2.5 then
					vx:= 2
				else if px<=3.5 then
					vx:= 3
				else if px<=4.5 then
					vx:= 4
				else if px<=5.5 then
					vx:= 5
				else if px<=6.5 then
					vx:= 6
				else if px<=7.5 then
					vx:= 7
				else if px>7.5 then
					vx:= 8;
					espi:= 7+vx;
				case espi of
					15 : begin cari:='               '; carp:=''; card:='';end;
					14 : begin cari:='              '; card:=' ';end;
					13 : begin cari:='             '; card:='  ';end;
					12 : begin cari:='            '; card:='   ';end;
					11 : begin cari:='           '; card:='    ';end;
					10 : begin cari:='          '; card:='     ';end;
					9 : begin cari:='         '; card:='      ';end;
					8 : begin cari:='        '; card:='       ';end;
					7 : begin cari:='       '; card:='        ';end;
					6 : begin cari:='      '; card:='         ';end;
					5 : begin cari:='     '; card:='          ';end;
					4 : begin cari:='    '; card:='           ';end;
					3 : begin cari:='   '; card:='            ';end;
					2 : begin cari:='  '; card:='             ';end;
					1 : begin cari:=' '; card:='              ';end;
					0 : begin cari:=''; card:='               ';end;
					-1 : begin cari:=''; carp:=''; card1:='                ';end;
				end;
			end else if i=b2 then begin
				cari:='_______';
				carp:='_';
				card:='_______';
			end else begin
				cari:='';
				carp:='';
				card:='';
			end;
			if i=7 then begin
				cari7:=cari;
				carm7:=carp;
				card7:=card;
			end else if i=6 then begin
				cari6:=cari;
				carm6:=carp;
				card6:=card;
			end else if i=5 then begin
				cari5:=cari;
				carm5:=carp;
				card5:=card;
			end else if i=4 then begin
				cari4:=cari;
				carm4:=carp;
				card4:=card;
			end else if i=3 then begin
				cari3:=cari;
				carm3:=carp;
				card3:=card;
			end else if i=2 then begin
				cari2:=cari;
				carm2:=carp;
				card2:=card;
			end else if i=1 then begin
				cari1:=cari;
				carm1:=carp;
				card1:=card;
			end else if i=0 then begin
				cari0:=cari;
				carm0:=carp;
				card0:=card;
			end else if i=-1 then begin
				carim1:=cari;
				carmm1:=carp;
				cardm1:=card;
			end else if i=-2 then begin
				carim2:=cari;
				carmm2:=carp;
				cardm2:=card;
			end else if i=-3 then begin
				carim3:=cari;
				carmm3:=carp;
				cardm3:=card;
			end else if i=-4 then begin
				carim4:=cari;
				carmm4:=carp;
				cardm4:=card;
			end else if i=-5 then begin
				carim5:=cari;
				carmm5:=carp;
				cardm5:=card;
			end else if i=-6 then begin
				carim6:=cari;
				carmm6:=carp;
				cardm6:=card;
			end else if i=-7 then begin
				carim7:=cari;
				carmm7:=carp;
				cardm7:=card;
			end;
		end;
		writeln();
		writeln();
		writeln('===============');
		writeln(cari7,carm7,card7);
		writeln(cari6,carm6,card6);
		writeln(cari5,carm5,card5);
		writeln(cari4,carm4,card4);
		writeln(cari3,carm3,card3);
		writeln(cari2,carm2,card2);
		writeln(cari1,carm1,card1);
		writeln(cari0,carm0,card0);
		writeln(carim1,carmm1,cardm1);
		writeln(carim2,carmm2,cardm2);
		writeln(carim3,carmm3,cardm3);
		writeln(carim4,carmm4,cardm4);
		writeln(carim5,carmm5,cardm5);
		writeln(carim6,carmm6,cardm6);
		writeln(carim7,carmm7,cardm7);
		writeln('===============');
	end
	else begin
		repeat
			writeln('Cual es la forma de la ecuacion de la recta base:');
			writeln('0 || ax + by + c=0');
			writeln('1 || y - y1 = m(x - x1)');
			writeln('2 || y - y1 = y2 - y1(x - x1)');
			writeln('              -------');
			writeln('              x2 - x1');
			readln(elecc);
			writeln();
		until (elecc='0') or (elecc='1') or (elecc='2');
		case elecc of
			'0' : begin
					confirmacion:='no';
					while (confirmacion='no') or (confirmacion='No') or (confirmacion='NO') do begin
						writeln('A continuacion ingrese los datos');
						writeln('-Coeficiente de x');
						readln(a);
						writeln('-Coeficiente de y');
						readln(b);
						writeln('-Termino independiente');
						readln(c);
						writeln('Si su ecuacion es ',a:4:2,'x ',b:4:2,'y ',c:4:2,' = 0 ingrese "si", de no ser asi, ingrese "no"');
						readln(confirmacion);
						if (confirmacion='no') or (confirmacion='No') or (confirmacion='NO') then
							writeln('Intentelo de nuevo');
					end;
					writeln();
					
					n1c:= -a;
					n3c:= -c;
					if b>0 then
						n2c:= b
					else begin
						n2c:= -b;
						n1c:= -n1c;
						n3c:= -n3c;
					end;
					n1c:= n1c/n2c;
					b1:= n3c/n2c;
					n2c:= 1;
					m1:=n1c;
					writeln('La ecuacion ingresada en forma explicita es: y= ',m1:3:1,'x ',b1:3:1);
				end;
			'1' : begin
					confirmacion:='no';
					while (confirmacion='no') or (confirmacion='No') or (confirmacion='NO') do begin
						writeln('A continuacion ingrese los datos');
						writeln('-Valor de y1');
						readln(y1p);
						writeln('-Valor de m');
						readln(m1);
						writeln('-Valor de x1');
						readln(x1p);
						writeln('Si su ecuacion es y - ',y1p:4:2,' = ',m1:4:2,'(x - ',x1p:4:2,') ingrese "si", de no ser asi, ingrese "no"');
						readln(confirmacion);
						if (confirmacion='no') or (confirmacion='No') or (confirmacion='NO') then
							writeln('Intentelo de nuevo');
					end;
					writeln();
					b1:= m1*x1p + y1p;
					writeln('La ecuacion ingresada en forma explicita es: y= ',m1:3:2,'x ',b1:3:2);
				end;
			'2' : begin
					confirmacion:='no';
					while (confirmacion='no') or (confirmacion='No') or (confirmacion='NO') do begin
						writeln('Ingrese los datos solicitados');
						writeln('-Valor de y1');
						readln(y1p);
						writeln('-Valor de y2');
						readln(y2p);
						writeln('-Valor de x1');
						readln(x1p);
						writeln('-Valor de x2');
						readln(x2p);
						writeln('Si su ecuacion es y ',-y1p:4:2,' = ',y2p:4:2,' ',-y1p:4:2,'(x ',-x1p:4:2,') ingrese "si", de no ser asi, ingrese "no"');
						writeln('                           -----------');
						writeln('                            ',x2p:4:2,' ',-x1p:4:2);
						readln(confirmacion);
						if (confirmacion='no') or (confirmacion='No') or (confirmacion='NO') then
							writeln('Intentelo de nuevo');
					end;
					writeln();
					m1:= (y2p-y1p)/(x2p-x1p);
					b1:= y1p - (m1*x1p);
					writeln('La ecuacion ingresada en forma explicita es: y= ',m1:3:2,'x ',b1:3:2);
				end;
		end;
		confirmacion:='no';
		while (confirmacion='no') or (confirmacion='No') or (confirmacion='NO') do begin
			writeln('Ahora ingrese un punto perteneciente a la recta perpendicular que quiere obtener');
			writeln('-Cordenada x del punto');
			readln(x1p);
			writeln('-Cordenada y del punto');
			readln(y1p);
			writeln('Si su punto es (',x1p:4:2,', ',y1p:4:2,') ingrese "si", de no ser asi, ingrese "no"');
			readln(confirmacion);
			if (confirmacion='no') or (confirmacion='No') or (confirmacion='NO') then
				writeln('Intentelo de nuevo');
		end;
		writeln();
		m2:= -(1/m1);
		b2:= y1p - (m2*x1p);
		writeln('La ecuacion de la recta paralela a  y= ',m1:3:1,'x ',b1:3:1,' que pasa por(',x1p:4:2,', ',y1p:4:2,') es: y= ',m2:3:2,'x ',b2:3:1);
		writeln('La grafica de y= ',m2:4:2,'x ',b2:3:1,' es:');
		writeln();
		for i:=7 downto -7 do begin
			if m2<-5 then
				carp:='|'
			else if m2<-0.5 then
				carp:='\'
			else if m2<0.5 then
				carp:='-'
			else if m2<5 then
				carp:='/'
			else 
				carp:='|';
			if m2<>0 then begin
				px:= (i-b2)/m2;
				if px<=-7.5 then
					vx:= -8
				else if px<=-6.5 then
					vx:= -7
				else if px<=-5.5 then
					vx:= -6
				else if px<=-4.5 then
					vx:= -5
				else if px<=-3.5 then
					vx:= -4
				else if px<=-2.5 then
					vx:= -3
				else if px<=-1.5 then
					vx:= -2
				else if px<=-0.5 then
					vx:= -1
				else if px<=0.5 then
					vx:= 0
				else if px<=1.5 then
					vx:= 1
				else if px<=2.5 then
					vx:= 2
				else if px<=3.5 then
					vx:= 3
				else if px<=4.5 then
					vx:= 4
				else if px<=5.5 then
					vx:= 5
				else if px<=6.5 then
					vx:= 6
				else if px<=7.5 then
					vx:= 7
				else if px>7.5 then
					vx:= 8;
					espi:= 7+vx;
				case espi of
					15 : begin cari:='               '; carp:=''; card:='';end;
					14 : begin cari:='              '; card:=' ';end;
					13 : begin cari:='             '; card:='  ';end;
					12 : begin cari:='            '; card:='   ';end;
					11 : begin cari:='           '; card:='    ';end;
					10 : begin cari:='          '; card:='     ';end;
					9 : begin cari:='         '; card:='      ';end;
					8 : begin cari:='        '; card:='       ';end;
					7 : begin cari:='       '; card:='        ';end;
					6 : begin cari:='      '; card:='         ';end;
					5 : begin cari:='     '; card:='          ';end;
					4 : begin cari:='    '; card:='           ';end;
					3 : begin cari:='   '; card:='            ';end;
					2 : begin cari:='  '; card:='             ';end;
					1 : begin cari:=' '; card:='              ';end;
					0 : begin cari:=''; card:='               ';end;
					-1 : begin cari:=''; carp:=''; card1:='                ';end;
				end;
			end else if i=b2 then begin
				cari:='_______';
				carp:='_';
				card:='_______';
			end else begin
				cari:='';
				carp:='';
				card:='';
			end;
			if i=7 then begin
				cari7:=cari;
				carm7:=carp;
				card7:=card;
			end else if i=6 then begin
				cari6:=cari;
				carm6:=carp;
				card6:=card;
			end else if i=5 then begin
				cari5:=cari;
				carm5:=carp;
				card5:=card;
			end else if i=4 then begin
				cari4:=cari;
				carm4:=carp;
				card4:=card;
			end else if i=3 then begin
				cari3:=cari;
				carm3:=carp;
				card3:=card;
			end else if i=2 then begin
				cari2:=cari;
				carm2:=carp;
				card2:=card;
			end else if i=1 then begin
				cari1:=cari;
				carm1:=carp;
				card1:=card;
			end else if i=0 then begin
				cari0:=cari;
				carm0:=carp;
				card0:=card;
			end else if i=-1 then begin
				carim1:=cari;
				carmm1:=carp;
				cardm1:=card;
			end else if i=-2 then begin
				carim2:=cari;
				carmm2:=carp;
				cardm2:=card;
			end else if i=-3 then begin
				carim3:=cari;
				carmm3:=carp;
				cardm3:=card;
			end else if i=-4 then begin
				carim4:=cari;
				carmm4:=carp;
				cardm4:=card;
			end else if i=-5 then begin
				carim5:=cari;
				carmm5:=carp;
				cardm5:=card;
			end else if i=-6 then begin
				carim6:=cari;
				carmm6:=carp;
				cardm6:=card;
			end else if i=-7 then begin
				carim7:=cari;
				carmm7:=carp;
				cardm7:=card;
			end;
		end;
		writeln('===============');
		writeln(cari7,carm7,card7);
		writeln(cari6,carm6,card6);
		writeln(cari5,carm5,card5);
		writeln(cari4,carm4,card4);
		writeln(cari3,carm3,card3);
		writeln(cari2,carm2,card2);
		writeln(cari1,carm1,card1);
		writeln(cari0,carm0,card0);
		writeln(carim1,carmm1,cardm1);
		writeln(carim2,carmm2,cardm2);
		writeln(carim3,carmm3,cardm3);
		writeln(carim4,carmm4,cardm4);
		writeln(carim5,carmm5,cardm5);
		writeln(carim6,carmm6,cardm6);
		writeln(carim7,carmm7,cardm7);
		writeln('===============');
		end;
	readln();
end.
