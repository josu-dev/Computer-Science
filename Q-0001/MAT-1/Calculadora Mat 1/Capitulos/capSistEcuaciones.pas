const
	constante= 'constante';




var
	bApp: boolean;




// MODULOS COMUNES
procedure saltosLinea30();
	begin
		writeln;writeln;writeln;writeln;writeln; writeln;writeln;writeln;writeln;writeln;
		writeln;writeln;writeln;writeln;writeln; writeln;writeln;writeln;writeln;writeln;
		writeln;writeln;writeln;writeln;writeln; writeln;writeln;writeln;writeln;writeln;
	end;
procedure leerOpcion(min,max: char; var opc: char);
	var
		ok,mayus: boolean;
	begin
		mayus:= (min>= 'A') and (max<= 'Z');
		writeln;
		repeat
			write('  Opcion: '); readln(opc);
			if mayus and (opc>= 'a') and (opc<= 'z') then
				opc:= chr(ord(opc)-32);
			ok:= (opc>= min) and (opc<= max);
			if not ok then begin
				writeln('  Entrada invalida, presione Enter para volver a intentar');
				write('  '); readln;
			end;
		until ok;
	end;




procedure capSistEcuaciones();
	var
		opc: char;
	begin
		saltosLinea30();
		writeln('  MENU SISTEMAS DE ECUACIONES Y DETERMINANTES');
		writeln;
		writeln('    Sinceramente me quede sin ganas de seguir programando esta aplicacion, pero eso no');
		writeln('    quiere decir que tu no puedas hacerlo, asique te invito a intentar crear el codigo');
		writeln('    necesario para resolver los problemas planteados en este capitulo');
		writeln;
		writeln('    En resumen lo que falta es: leer las ecuaciones lineales e introducir los datos en el');
		writeln('    codigo de matrices con algunas reformas y se pueden resolver los sistemas. Para');
		writeln('    los determinantes hay que hacer los algoritmos practicamente de 0 pero no es imposible');
		writeln;
		writeln('  Ingrese la letra del apartado querido');
		writeln;
		writeln('    A -  Volver al Menu Capitulos');
		writeln('    B -  Cerrar Aplicacion');
		leerOpcion('A','B',opc);
		if opc= 'B' then
			bApp:= false;
	end;




// PROGRAMA PRINCIPAL
begin
	bApp:= true;
	while bApp do begin
		capSistEcuaciones();
		write('Se supone que ahora hirias al menu de capitulos pero f'); readln;
	end;
end.
