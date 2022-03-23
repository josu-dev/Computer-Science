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




procedure capConjuntos();
	var
		opc: char;
	begin
		saltosLinea30();
		writeln('  MENU DEMOSTRACIONES, CONJUNTOS Y FUNCIONES');
		writeln;
		writeln('    En este capitulo se trabaja de una manera mas teorica, con ejercitacion enfocada');
		writeln('    en el analizis, justificacion y desarrollo de conceptos, metodos y definiciones');
		writeln;
		writeln('    Por este echo es dificil la creacion de herramientas para resolver los diferentes');
		writeln('    ejercicios planteados durante el capitulo, ya que tienen mas areas que solo aplicar');
		writeln('    formulas, reglas de operacion y resultados finitos');
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
		capConjuntos();
		write('Se supone que ahora hirias al menu de capitulos pero f'); readln;
	end;
end.
