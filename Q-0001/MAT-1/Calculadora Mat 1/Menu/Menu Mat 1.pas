const
	constante= 'constante';




var
	bApp,bCap: boolean;
	cTema: char;
	nombreUsuario: string;




// CONFIGURACIONES DEFAULTS
procedure configsDefaults();
	begin
		bApp:= true;
		bCap:= false;
	end;




// MODULOS COMUNES
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

procedure leerSiNo(var ok: boolean);
	var
		opc: char;
	begin
		writeln('    S -  Si');
		writeln('    N -  No');
		writeln;
		repeat
			write('  Opcion: '); readln(opc);
			ok:= (opc= 'S') or (opc= 's') or (opc= 'N') or (opc= 'n');
			if not ok then begin
				writeln('  Entrada invalida, presione Enter para volver a intentar');
				write('  '); readln;
			end;
		until ok;
		ok:= (opc= 'S') or (opc= 's');
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
procedure leerUsuario();
	var
		ok: boolean;
	begin
		repeat
			saltosLinea30();
			write('  Ingrese su nombre de usuario: '); readln(nombreUsuario);
			writeln;
			writeln('  Esta seguro que su nombre de usuario sea: ',nombreUsuario);
			leerSiNo(ok);
			if not ok then begin
				writeln('  De acuerdo, presione Enter para ingresar uno nuevo');
				write('  '); readln;
			end;
		until ok;
	end;




// CAPITULOS
procedure capGeometria();
	begin
		writeln('  Casi terminado, falta lectura ecuaciones');
		write('  '); readln;
	end;
procedure capConjuntos();
	begin
		writeln('  Justificado');
		write('  '); readln;
	end;
procedure capAlgebraBoole();
	begin
		writeln('  Sin hacer');
		write('  '); readln;
	end;
procedure capSucesiones();
	begin
		writeln('  Casi terminado');
		write('  '); readln;
	end;
procedure capCombinatoria();
	begin
		writeln('  Casi terminado');
		write('  '); readln;
	end;
procedure capMatrices();
	begin
		writeln('  Casi terminado');
		write('  '); readln;
	end;
procedure capSistEcuaciones();
	begin
		writeln('  Justificado estupidamente');
		write('  '); readln;
	end;




// MENU PRINCIPAL
procedure infoGeneral();
	begin
		saltosLinea30();
		writeln('  INFORMACION GENERAL');
		writeln;
		writeln('    Esta aplicacion fue creada con la intencion de poner a prueba conceptos aprendidos');
		writeln('    en la carrera y demostrar que todo lo que se aprende se puede utilizar con fines');
		writeln('    practicos y de utilidad');
		writeln;
		writeln('    En pocas palabras la aplicacion brinda la posibilidad de resolver un gran apartado');
		writeln('    de los ejercicios dados en la materia Matematica 1, Lic. informatica, UNLP; de modo');
		writeln('    que los estudiantes-companieros tengan una herramienta de autocorreccion aproximada');
		writeln;
		writeln('    El funcionamiento es sencillo, primero se elige el capitulo que se esta estudiando');
		writeln('    y luego se procede a elegir la herramienta especifica para determinado ejercicio,');
		writeln('    luego continua dentro del mismo capitulo, cambia a otro o simplemente cierra la app');
		writeln;
		enterContinuar();
	end;

procedure menuCapitulos();
	var
		opc: char;
	begin
		if bApp and bCap then begin
			saltosLinea30();
			writeln('  MENU CAPITULOS');
			writeln;
			writeln('  Ingrese la letra del apartado querido');
			writeln;
			writeln('    A -  Geometria');
			writeln('    B -  Demostraciones, Conjuntos y Funciones');
			writeln('    C -  Algebras de Boole');
			writeln('    D -  Sucesiones e Induccion');
			writeln('    E -  Combinatoria y Metodos de conteo');
			writeln('    F -  Matrices');
			writeln('    G -  Sist. de Ecuaciones y Determinantes');
			writeln;
			writeln('    H -  Volver al Menu Inicio');
			writeln('    I -  Cerrar Aplicacion');
			leerOpcion('A','I',opc);
			case opc of
				'A'..'G':	cTema:= opc;
				'H':	bCap:= false;
				'I':	bApp:= false;
			end;
		end;
	end;

procedure creditos();
	begin
		saltosLinea30();
		writeln('  CREDITOS');
		writeln;
		writeln('    Fecha: 08/2021');
		writeln('    Lenguaje: Pascal');
		writeln('    Creador: Josue S.A.');
		writeln('    Conocimientos adquiridos en Materia: CADP');
		writeln('                                Carrera: Lic. Informatica');
		writeln('                                Facultad: Informatica UNLP');
		writeln;
		enterContinuar();
	end;

procedure menuInicial();
	var
		opc: char;
	begin
		while bApp and (not bCap) do begin
			saltosLinea30();
			writeln('  MENU INICIAL');
			writeln;
			writeln('  Ingrese la letra del apartado querido');
			writeln;
			writeln('    A -  Informacion general de la aplicacion');
			writeln('    B -  Menu de los capitulos');
			writeln('    C -  Creditos');
			writeln;
			writeln('    D -  Cerrar aplicacion');
			leerOpcion('A','D',opc);
			case opc of
				'A':	infoGeneral();
				'B':	bCap:= true;
				'C':	creditos();
				'D':	bApp:= false;
			end;
		end;
	end;




// EXTRAS
procedure mensajeInicial();
	begin
		leerUsuario();
		saltosLinea30();
		writeln('  ADVERTENCIA:');
		writeln;
		writeln('    Usted usa la aplicacion bajo su eleccion, los resultados no estan');
		writeln('    verificados al 100% y en algunos casos solo son aproximaciones a de los');
		writeln('    resultados-resoluciones reales');
		writeln;
		writeln('    Es posible encontrar errores y crasheos de la aplicacion, en caso de');
		writeln('    experimentar error puede contactar al creador o intentar resolverlo');
		writeln('    dentro del codigo por usted mimso, si se cerro solo vuelva a abrirla');
		writeln;
		enterContinuar();
		saltosLinea30();
		writeln('  Bienvenida/o a Calculadora Mat 1');
		writeln;
		writeln('    Se espera que las herramientas brindadas le sean de utilidad');
		writeln('    y que tenga una buena jornada de estudio ',nombreUsuario);
		writeln;
		enterContinuar();
	end;

procedure mensajeCierre();
	begin
		saltosLinea30();
		writeln('  Que haya tenido una buena jornada de estudio y que la aplicacion le');
		writeln('  fuera de utilidad');
		writeln;
		writeln('    Adios ',nombreUsuario,', gracias por usar Calculadora Mat 1');
		writeln;
		writeln;
		writeln('  Presione Enter para cerrar la ventana ');
		write('  '); readln;
	end;




// PROGRAMA PRINCIPAL
begin
	configsDefaults();
	mensajeInicial;
	menuInicial();
	while bApp do begin
		menuCapitulos();
		while bApp and bCap do begin
			case cTema of
				'A':	capGeometria();
				'B':	capConjuntos();
				'C':	capAlgebraBoole();
				'D':	capSucesiones();
				'E':	capCombinatoria();
				'F':	capMatrices();
				'G':	capSistEcuaciones();
			end;
			menuCapitulos
		end;
		menuInicial();
	end;
	mensajeCierre();
end.
