procedure potencia(var n: extended; exp: integer);
	var
		i: integer;
		base: extended;
	begin
		base:=n;
		if exp=0 then
			n:=1
		else if exp >0 then
			for i:=2 to exp do
				n:= n*base
		else begin
			for i:=-2 downto exp do
				n:= n*base;
			n:= 1/n;
		end;
	end;

procedure menu(var op: char);
begin
	repeat
		writeln('Elija el modo a operar:');
		writeln('1 - Sumatoria comienza en 1, termina en z, primer termino y razon de cambio');
		writeln('2 - Sumatoria comienza en x, termina en z, primer termino y razon de cambio');
		readln(op);
		writeln();
	until (op>='1') or (op<='2');
end;

procedure datos1(var n: extended);
var
	t1,r,iU: integer;
	pot: extended;
begin
	write('Sumatoria termina en: : ');readln(iU);
	write('Valor del primer termino: : ');readln(t1);
	write('Razon de cambio: ');readln(r);
	pot:= r;
	potencia(pot,iU);
	n:= (1-pot)/(1-r);
	n:= n*t1;
end;

procedure datos2(var n: extended);
var
	t1,iI,iU,r: integer;
	potI,potU: extended;
begin
	write('Sumatoria comienza en: ');readln(iI);
	write('Sumatoria termina en: ');readln(iU);
	write('Valor del primer termino: ');readln(t1);
	write('Razon de cambio: ');readln(r);
	potI:= r;
	potU:= r;
	potencia(potI,iI-1);
	potencia(potU,iU);
	n:= (1-potU)/(1-r) - (1-potI)/(1-r);
	n:= n*t1;
end;


var
op: char;
n:extended;
begin
	while true do begin
		menu(op);
		case op of
			'1' : datos1(n);
			'2' : datos2(n);
		end;
		writeln('El resultado de la sumatoria es: ',n:0:0);
		writeln();
		writeln();
	end;
end.

