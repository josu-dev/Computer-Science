
var
	codigo, cantidad: integer;
	aux: integer;
	totalizador: integer;
begin
	write('  Cod: ');readln(codigo);
	write('  Cantidad: ');readln(cantidad);
	while codigo<> 0 do begin
		aux:= codigo;
		totalizador:= 0;
		while (codigo<> 0) and (codigo= aux) do begin
			totalizador:= totalizador + cantidad;
			write('  Cod: ');readln(codigo);
			write('  Cantidad: ');readln(cantidad);
		end;
		writeln(totalizador);
	end;
end.
