program bcdconverter;

var
cambiar,cerrar: boolean;
opcion,numero,i,digito,divisor: integer;
num,d3c,d2c,d1c,d3,d2,d1,d0,ds,respuesta: string;

begin
	cerrar:= false;
	while cerrar=false do begin
		cambiar:= false;
		writeln('Escriba el numero de la herramienta que quiere utilizar:');
		writeln('	0 - Para pasar de DEC a BCD desempaquetado con signo');
		writeln('	1 - Para pasar de DEC a BCD empaquetado');
		readln(opcion);
		while (cambiar=false) and (cerrar=false) do begin
			divisor:= 1000;
			d3c:=' 1111';
			d2c:=d3c;
			d1c:=d3c;
			writeln('Ingrese su numero entero de 4 cifras como maximo');
			readln(numero);
			if (numero div 1000 >= 10) or (numero div 1000 <= -10) then
				writeln('Numero ingresado invalido')
			else begin
				if numero>=0 then
					ds:='1100'
				else begin
					ds:='1101';
					numero:= -numero;
				end;
				for i:=1 to 4 do begin
					digito:= numero div divisor;
					numero:= numero - digito*divisor;
					case digito of
						0: num:= '0000';
						1: num:= '0001';
						2: num:= '0010';
						3: num:= '0011';
						4: num:= '0100';
						5: num:= '0101';
						6: num:= '0110';
						7: num:= '0111';
						8: num:= '1000';
						9: num:= '1001';
					end;
					if i=1 then
						d3:= num
					else if i=2 then
						d2:= num
					else if i=3 then
						d1:= num
					else if i=4 then
						d0:= num;
					divisor:= divisor div 10;
				end;
				if d3='0000' then begin
					d3:='';
					d3c:='';
					if d2='0000' then begin
						d2:='';
						d2c:='';
						if d1='0000' then begin
							d1:='';
							d1c:='';
						end;
					end;
				end;
				if opcion=0 then
					writeln('Su numero en BCD desempaquetado con signo es:',d3c,d3,d2c,d2,d1c,d1,' ',ds,d0)
				else begin
					if d3<>'' then
						d3c:='0000'
					else if d2<>'' then
						d2c:='0000'
					else if d1<>'' then
						d2:='0000'
					else
						d2:='';
					writeln('Su numero en BCD empaquetado es: ',d3c,d3,' ',d2,d1,' ',d0,ds);
				end;
			end;
			writeln();
			writeln('Opciones:');
			writeln('"pepetir" - Volver a utilizar herramienta');
			writeln('"cambiar - Cambia de herramienta');
			writeln('"cerrar" - Cierra la aplicacion');
			readln(respuesta);
			writeln();
			case respuesta of
				'repetir' : cambiar:=false;
				'cambiar' : cambiar:=true;
				'cerrar' : cerrar:=true;
				
			end;
		end;
	end;
	writeln('Finalizado con exito');
	readln();
end.
