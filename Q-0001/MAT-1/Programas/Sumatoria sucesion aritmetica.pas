procedure menu(var op: char);
begin
	repeat
		writeln('Elija el modo a operar:');
		writeln('1 - Dando el primer termino, ultimo termino y la diferencia');
		writeln('2 - Dando el primer termino, cantidad de terminos y la diferencia');
		writeln('3 - Dando el ultimo termino, cantidad de terminos y la diferencia');
		writeln('4 - Dando dos terminos de la sucesion');
		readln(op);
		writeln();
	until (op>='1') or (op<='4');
end;

procedure datos1(var a1,an,n: integer);
var
	d: integer;
begin
	write('Ingrese valor primer termino: ');readln(a1);
	write('Ingrese valor ultimo termino: ');readln(an);
	write('Ingrese diferencia: ');readln(d);
	n:= ((an-a1) div d) +1;
end;

procedure datos2(var a1,an,n: integer);
var
	d: integer;
begin
	write('Ingrese valor del primer termino: ');readln(a1);
	write('Ingrese cantidad de terminos: ');readln(n);
	write('Ingrese diferencia: ');readln(d);
	an:= a1 + (n-1)*d;
end;

procedure datos3(var a1,an,n: integer);
var
	d: integer;
begin
	write('Ingrese valor del ultimo termino: ');readln(an);
	write('Ingrese cantidad de terminos: ');readln(n);
	write('Ingrese diferencia: ');readln(d);
	a1:= an - (n-1)*d;
end;

procedure datos4(var a1,an,n: integer);
var
	pos1,pos2: integer;
begin
	writeln('Ingrese dos terminos de la sucecion para sumar los terminos comprendidos entre ellos');
	write('Ingrese la posicion del termino: ');readln(pos1);
	write('Ingrese su valor: ');readln(a1);
	write('Ingrese la posicion del otro termino: ');readln(pos2);
	write('Ingrese su valor: ');readln(an);
	if pos1 > pos2 then
		n:= pos1 - pos2 +1
	else
		n:= pos2 - pos1 +1;
	//d:=(an - a1) div (pos1 + pos2 -2);
end;


var
op: char;
a1,an,n: integer;
total:real;
begin
	while true do begin
		menu(op);
		case op of
			'1' : datos1(a1,an,n);
			'2' : datos2(a1,an,n);
			'3' : datos3(a1,an,n);
			'4' : datos4(a1,an,n);
		end;
		total:= n*(a1 + an)/2;
		writeln('El resultado de la sumatoria es: ',total:0:0);
		writeln();
		writeln();
	end;
end.
