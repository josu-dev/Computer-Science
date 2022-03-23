{graficadora v2}
{
program graficadora_v2;

var
i,vx,espi:integer;
m1,b1,px: real;
cari,cari7,cari6,cari5,cari4,cari3,cari2,cari1,cari0,carim1,carim2,carim3,carim4,carim5,carim6,carim7,card,card7,card6,card5,card4,card3,card2,card1,card0,cardm1,cardm2,cardm3,cardm4,cardm5,cardm6,cardm7,carp,carm7,carm6,carm5,carm4,carm3,carm2,carm1,carm0,carmm1,carmm2,carmm3,carmm4,carmm5,carmm6,carmm7:string;
begin
	writeln('Ingrese la pendiente:');
	readln(m1);
	writeln('Ingrese la ordenada al origen:');
	readln(b1);
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
				else if (px>-7.5) and (px<=-6.5) then
					vx:= -7
				else if (px>-6.5) and (px<=-5.5) then
					vx:= -6
				else if (px>-5.5) and (px<=-4.5) then
					vx:= -5
				else if (px>-4.5) and (px<=-3.5) then
					vx:= -4
				else if (px>-3.5) and (px<=-2.5) then
					vx:= -3
				else if (px>-2.5) and (px<=-1.5) then
					vx:= -2
				else if (px>-1.5) and (px<=-0.5) then
					vx:= -1
				else if (px>=-0.5) and (px<=0.5) then
					vx:= 0
				else if (px>=0.5) and (px<=1.5) then
					vx:= 1
				else if (px>1.5) and (px<=2.5) then
					vx:= 2
				else if (px>2.5) and (px<=3.5) then
					vx:= 3
				else if (px>3.5) and (px<=4.5) then
					vx:= 4
				else if (px>4.5) and (px<=5.5) then
					vx:= 5
				else if (px>5.5) and (px<=6.5) then
					vx:= 6
				else if (px>6.5) and (px<=7.5) then
					vx:= 7
				else if (px>7.5) then
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
	writeln('==============');
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
	writeln('==============');
end.}

program graficadora_v2;

var
i,vx,espi:integer;
m1,b1,px: real;
cari,cari7,cari6,cari5,cari4,cari3,cari2,cari1,cari0,carim1,carim2,carim3,carim4,carim5,carim6,carim7,card,card7,card6,card5,card4,card3,card2,card1,card0,cardm1,cardm2,cardm3,cardm4,cardm5,cardm6,cardm7,carp,carm7,carm6,carm5,carm4,carm3,carm2,carm1,carm0,carmm1,carmm2,carmm3,carmm4,carmm5,carmm6,carmm7:string;
begin
	writeln('Ingrese la pendiente:');
	readln(m1);
	writeln('Ingrese la ordenada al origen:');
	readln(b1);
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
end.
