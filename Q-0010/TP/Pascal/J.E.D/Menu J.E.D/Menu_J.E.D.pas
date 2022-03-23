program JED;
var
	B_1Vez,B_App,B_Est: boolean;
	C_Tipo: char;




//  CONFIGURACIONES DEFAULTS
procedure configsDefaultAplicacion();
	begin
		B_1Vez:= true;
		B_App:= true;
		B_Est:= false;
		C_Tipo:= ' ';
	end;




//  MODULOS GENERICOS
procedure saltosLinea30();
	begin
		writeln;writeln;writeln;writeln;writeln; writeln;writeln;writeln;writeln;writeln;
		writeln;writeln;writeln;writeln;writeln; writeln;writeln;writeln;writeln;writeln;
		writeln;writeln;writeln;writeln;writeln; writeln;writeln;writeln;writeln;writeln;
	end;
procedure enterContinuar();
	begin
		writeln;
		writeln('  Presione Enter para continuar ');
		write('  '); readln;
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




//  ESTRUCTURAS
//    VECTOR
procedure estVector();
	begin
		writeln('  Que buscabas pa');
		write('  '); readln;
	end;

//    LISTA
procedure estLista();
	begin
		writeln('  Que buscabas pa');
		write('  '); readln;
	end;

//    ARBOL
procedure estArbol();
	begin
		writeln('  Que buscabas pa');
		write('  '); readln;
	end;




//  MENU PRINCIPAL
procedure mensajeBienvenida();
	begin
		if B_1Vez then begin
			B_1Vez:= false;
			writeln('  Bienvenida/o a');
			writeln('                 Jugando con Estructuras de Datos  ( J.E.D. )');
			writeln;
			writeln('    Se espera que las herramientas brindadas le sean de utilidad');
			writeln('    y que pase un buen rato jugando');
			writeln;
			writeln;
		end;
	end;

procedure infoAplicacion();
	begin
		saltosLinea30(); saltosLinea30();
		writeln('  INFORMACION GENERAL');
		writeln;
		writeln('    Esta aplicacion fue creada con la intencion de poner a prueba conceptos aprendidos');
		writeln('    en la carrera y demostrar que todo lo que se aprende se puede utilizar con fines');
		writeln('    practicos, utiles y entretenimiento aunque sean basicos - antiguos');
		writeln;
		writeln('    En pocas palabras la aplicacion brinda la posibilidad de operar y ver los cambios');
		writeln('    efectuados en las Estructuras de Datos disponibles para entender mejor que sucede');
		writeln('    con la informacion que procesan y guardan los algoritmos que las utilizan');
		writeln;
		writeln('    El funcionamiento es sencillo, primero se elige el tipo de estructura a jugar, luego');
		writeln('    se procede a cargarla inicialmente y por ultimo se pueden efectuar procesos para ver');
		writeln('    que sucede con la informacion. En cualquier momento se puede generar nuevamente la');
		writeln('    estructua, cambiar el tipo o cerrar la aplicacion');
		writeln;
		enterContinuar();
	end;

procedure menuEstructuras();
	var
		opc: char;
	begin
		if B_App and B_Est then begin
			saltosLinea30(); saltosLinea30();
			writeln('  MENU ESTRUCTURAS');
			writeln;
			writeln('  Ingrese la letra del apartado requerido');
			writeln;
			writeln('    A -  Vector');
			writeln('    B -  Lista');
			writeln('    C -  Arbol Binario de Busqueda');
			writeln;
			writeln('    D -  Menu Inicio');
			writeln('    E -  Cerrar Aplicacion');
			leerOpcion('A','E',opc);
			case opc of
				'A'..'C':	C_Tipo:= opc;
				'D':	B_Est:= false;
				'E':	B_App:= false;
			end;
		end;
	end;

procedure creditos();
	begin
		saltosLinea30(); saltosLinea30();
		writeln('  CREDITOS');
		writeln;
		writeln('    Fecha: 09/2021');
		writeln('    Lenguaje: Pascal');
		writeln('    Creador: Josue S.A.');
		writeln('    Conocimientos adquiridos en Materias: CADP y Taller de Programacion');
		writeln('                                Carrera: Lic. Informatica');
		writeln('                                Facultad: Informatica UNLP');
		writeln('    Agradecimiento:');
		writeln('                   Los companieros de cursada por hacer apoyo');
		writeln('                   y ser los Beta Testers del programa');
		writeln;
		enterContinuar();
	end;

procedure menuInicio();
	var
		opc: char;
	begin
		while B_App and (not B_Est) do begin
			saltosLinea30(); saltosLinea30();
			mensajeBienvenida();
			writeln('  MENU INICIO');
			writeln;
			writeln('  Ingrese la letra del apartado requerido');
			writeln;
			writeln('    A -  Menu Estructuras');
			writeln;
			writeln('    B -  Informacion Aplicacion');
			writeln('    C -  Creditos');
			writeln;
			writeln('    D -  Cerrar aplicacion');
			leerOpcion('A','D',opc);
			case opc of
				'A':	B_Est:= true;
				'B':	infoAplicacion();
				'C':	creditos();
				'D':	B_App:= false;
			end;
		end;
	end;




//  EXTRAS
procedure mensajeInicial();
	begin
		saltosLinea30(); saltosLinea30();
		writeln('  ADVERTENCIA:');
		writeln;
		writeln('    Usted debe usar la aplicacion con fines de entrenimiento y como guia');
		writeln('    para entender desde otro punto algunas de las estructuras de datos');
		writeln('    basicas. Los algoritmos utilizados pueden no ser los mas optimos, solo');
		writeln('    cumplen el trabajo para el fin de la aplicacion');
		writeln;
		writeln('    Es posible encontrar errores de representacion o que la aplicacion se');
		writeln('    cierre por un error, dado el primer problema trate de trabajar segun');
		writeln('    los parametros recomendados, dado el segundo problema contacte al creador');
		writeln('    o intente arreglarlo por su cuenta dentro del codigo');
		writeln;
		enterContinuar();
	end;

procedure mensajeCierre();
	begin
		saltosLinea30(); saltosLinea30();
		writeln('  Se espera que J.E.D. le haya ayudado a entender un poco mas');
		writeln('  el funcionamiento de las Estructuras de Datos disponibles');
		writeln;
		writeln('    Que tenga un lindo dia :)');
		writeln;
		writeln;
		writeln('  Presione Enter para cerrar la ventana ');
		write('  '); readln;
	end;




//  PROGRAMA PRINCIPAL
begin
	configsDefaultAplicacion();
	mensajeInicial();
	menuInicio();
	while B_App do begin
		menuEstructuras();
		while B_App and B_Est do begin
			case C_Tipo of
				'A':	estVector();
				'B':	estLista();
				'C':	estArbol();
			end;
			menuEstructuras();
		end;
		menuInicio();
	end;
	mensajeCierre();
end.
