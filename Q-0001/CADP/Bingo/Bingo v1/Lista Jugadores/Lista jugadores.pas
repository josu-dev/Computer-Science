
type
	jugador= record
		nombre: string;
		puntos: integer;
		carton: integer;
	end;

	listaJugadores= ^nodoJ;

	nodoJ= record
		dato: jugador;
		sig: listaJugadores;
	end;
	
	vHacerMinuscula= array['A'..'Z'] of char;
	
var
	lJ: listaJugadores;
	vHacerMinus: vHacerMinuscula;

// Modulos generales
procedure leerSiNo(var opc: char);
	begin
		writeln('    S |  Si');
		writeln('    N |  No');
		repeat
			write(' Opcion: ');readln(opc);
			if opc= 's' then
				opc:= 'S'
			else if opc= 'n' then
				opc:= 'N'
			else if (opc<> 'S') and (opc<>'N') then
				writeln(' Opcion no valida, intente nuevamente');
			writeln;
		until (opc= 'S') or (opc= 'N');
	end;

procedure setearVHacerMinus();
	var
		i: char;
		n: integer;
	begin
		n:=0;
		for i:= 'a' to 'z' do begin
			n:= n+1;
			vHacerMinus[chr(64 +n)]:= i;
		end;
	end;

// Modulos Lista Jugadores
function cargarMasJugadores(): boolean;
	var
		opc: char;
	begin
		writeln(' Tiene que ingresar un jugador mas ?');
		leerSiNo(opc);
		cargarMasJugadores:= opc= 'S';
	end;
procedure leerJugador(var nombre: string);
	var
		opc: char;
	begin
		repeat
			writeln(' Ingrese el jugador');
			write(' Nombre: ');readln(nombre);
			writeln;
			writeln(' Confirme que el jugador se llama ',nombre);
			leerSiNo(opc);
			if opc= 'N' then
				writeln(' Proceda a ingresar nuevamente el jugador');
			writeln;
		until opc= 'S';
	end;
procedure asegurarMinuscula(var letra: char);
	begin
		if (letra>='A') and (letra<= 'Z') then
			letra:= vHacerMinus[letra];
	end;
function vaAqui(nombreExistente,nombreNuevo: string): boolean;
	var
		tamE,tamN,i,j: integer;
	begin
		tamE:= length(nombreExistente);
		tamN:= length(nombreNuevo);
		if tamE>tamN then
			tamE:= tamN;
		i:= 1;
		for j:= 1 to tamE do begin
			asegurarMinuscula(nombreExistente[i]);
			asegurarMinuscula(nombreNuevo[i]);
		end;
		while (i<= tamE) and (nombreExistente[i] = nombreNuevo[i]) do
			i:= i +1;
		vaAqui:= nombreExistente[i] > nombreNuevo[i];
	end;

procedure insertarAlfabeticamente(var pri: listaJugadores; nombre: string);
	var
		ant,act,nuevo: listaJugadores;
	begin
		new(nuevo);
		nuevo^.dato.nombre:= nombre;
		nuevo^.dato.puntos:= 0;
		ant:= pri;
		act:= pri;
		while (act<> nil) and (not vaAqui(act^.dato.nombre, nombre)) do begin
			ant:= act;
			act:= act^.sig;
		end;
		if ant=act then
			pri:= nuevo
		else
			ant^.sig:= nuevo;
		nuevo^.sig:= act;
	end;

procedure generarListaJugadores();
	var
		bConfirmacion: boolean;
		aux: listaJugadores;
		nombre: string;
		opc: char;
	begin
		bConfirmacion:= false;
		repeat
			lJ:= nil;
			writeln('Proceda a cargar los nombre de los jugadores');
			writeln('IMPORTANTE: TODOS TIENEN QUE CARGAR LOS MISMOS NOMBRE');
			writeln;
			while not bConfirmacion do begin
				leerJugador(nombre);
				insertarAlfabeticamente(lJ,nombre);
				bConfirmacion:= not cargarMasJugadores();
			end;
			bConfirmacion:= false;
			aux:= lJ;
			writeln(' Esta es la lista con todos los jugadores que ingreso:');
			while aux<> nil do begin
				writeln('  ',aux^.dato.nombre);
				aux:= aux^.sig;
			end;
			writeln;
			writeln(' Esta seguro que ingreso los mismos nombres que los otros jugadores ?');
			leerSiNo(opc);
			if opc= 'S' then
				bConfirmacion:= true
			else
				writeln(' Listado reseteado');
			writeln;
		until bConfirmacion;
	end;
begin
	setearVHacerMinus();
	generarListaJugadores();
end.
