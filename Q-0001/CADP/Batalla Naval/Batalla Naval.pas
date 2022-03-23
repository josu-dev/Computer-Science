program Batalla_Naval_version_Pascal;

// CONSTANTES DEL PROGRAMA
const
	ANCHOT=10;
	ALTOT= 10;




// TIPOS DE DATOS
type
	integerToInteger= array['0'..'9'] of integer;
	letterToInteger= array['A'..'J'] of integer;
	pixel= array[0..4] of string[4];
	linea= array[1..ANCHOT] of integer;
	matriz= array[1..ALTOT] of linea;
	celda= record
		x: integer;
		y: integer;
		est: integer;
	end;
	barco= ^nodo;
	nodo= record
		dato: celda;
		sig: barco;
	end;
	barcos= array[1..10] of barco;
	cantidadesBarcos= array[1..4] of integer;




// VARIABLES GLOBALES
var
	vITI: integerToInteger;
	vLTI: letterToInteger;
	p: pixel;
	mTP,mTO,mTPreview: matriz;
	vBarcos,vBarcosPreview: barcos;
	nJugador: char;
	sLinea: string;
	nBarcos,nBarcosCargados,nTurno,nAciertos,nAciertosP,nAciertosO,nUndidosP,nUndidosO: integer;
	bJugar,bPartida,bCarga: boolean;




// MODULOS
// Setear configuraciones Defaults
procedure iniciarVITI();
	var
		i: char;
		n: integer;
	begin
		n:=0;
		for i:='0' to '9' do begin
			n:= n +1;
			vITI[i]:= n;
		end;
	end;

procedure iniciarVLTI();
	var
		i: char;
		n: integer;
	begin
		n:=0;
		for i:='A' to 'J' do begin
			n:= n +1;
			vLTI[i]:= n;
		end;
	end;

procedure iniciarPixeles();
	begin
		p[0]:= '    ';
		p[1]:= chr(176)+chr(176)+chr(176)+chr(176);
		p[2]:= '||||';
		p[3]:= chr(219)+chr(219)+chr(219)+chr(219);
		p[4]:= 'XXXX';
	end;

procedure iniciarSLinea();
	var
		i: integer;
	begin
		sLinea:='';
		for i:=1 to 16 do
			sLinea:= sLinea + chr(196);
	end;

procedure iniciarDefault();
	begin
		bJugar:= true;
		nBarcos:= 6;
		nAciertos:= 15;
		iniciarVITI();
		iniciarVLTI();
		iniciarPixeles();
		iniciarSLinea();
	end;




// Modulos comunes
procedure saltosLinea10();
	begin
		writeln; writeln; writeln; writeln; writeln; writeln; writeln; writeln; writeln; writeln;
	end;

procedure confirmarContinuar();
	begin
		writeln(' Presione ENTER para continuar');
		readln;
	end;

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

procedure imprimirTFila(y: integer; fila: linea);
	var
		x: integer;
	begin
		write(chr(64 + y),' ');
		for x:=1 to ANCHOT do
			write(p[fila[x]]);
		writeln;
		write('  ');
		for x:=1 to ANCHOT do
			write(p[fila[x]]);
		writeln;
	end;

procedure imprimirTablero(mTI: matriz; tipo: char);
	var
		y: integer;
	begin
		if bCarga then begin
			writeln(' Ronda: ',nTurno,' | Aciertos: ',nAciertosP,'/',nAciertos,' | Barcos Undidos: ',nUndidosP,'/',nBarcos);
			writeln;
		end;
		case tipo of
			'P': writeln(' Tablero propio');
			'O': writeln(' Tablero oponente');
			'V': begin
					writeln(' Posicionar barco ',nBarcosCargados,'/',nBarcos);
					writeln(' Tablero previsualizador');
				end;
		end;
		writeln('   0   1   2   3   4   5   6   7   8   9');
		for y:=1 to ALTOT do
			imprimirTFila(y,mTI[y]);
		writeln;
	end;

function hacerMayuscula(yChar: char): char;
	begin
		if (yChar>='A') and (yChar<='J') then
			hacerMayuscula:= yChar
		else case yChar of
			'a' : hacerMayuscula:= 'A';
			'b' : hacerMayuscula:= 'B';
			'c' : hacerMayuscula:= 'C';
			'd' : hacerMayuscula:= 'D';
			'e' : hacerMayuscula:= 'E';
			'f' : hacerMayuscula:= 'F';
			'g' : hacerMayuscula:= 'G';
			'h' : hacerMayuscula:= 'H';
			'i' : hacerMayuscula:= 'I';
			'j' : hacerMayuscula:= 'J';
		end;
	end;

function validarX(xChar: char):boolean;
	begin
		validarX:= ((xChar>='0') and (xChar<='9'));
	end;

function validarY(yChar: char):boolean;
	begin
		validarY:= ((yChar>='A') and (yChar<='J')) or ((yChar>='a') and (yChar<='j'));
	end;

function validarXY(xChar,yChar: char; mTE: matriz):boolean;
	begin
		validarXY:= validarX(xChar) and validarY(yChar) and ((mTE[vLTI[hacerMayuscula(yChar)]][vITI[xChar]] <> 4) and (mTE[vLTI[hacerMayuscula(yChar)]][vITI[xChar]] <> 2));
	end;




// Autor del Programa
procedure derechosAutor();
	begin
		writeln(sLinea + sLinea + sLinea);
		writeln('           Batalla Naval version Pascal');
		writeln('                Por: Josue Suarez');
		writeln(sLinea + sLinea + sLinea);
		writeln();
	end;




// Menu Principal
procedure volverMenuAyuda();
	begin
		writeln(' Para regresar al MENU Ayuda');
		confirmarContinuar();
	end;

procedure infoObjetivoJuego();
	begin
		saltosLinea10(); saltosLinea10();
		writeln(' OBJETIVO del juego');
		writeln;
		writeln('  El objetivo del juego es destruir todos los barcos enemigos, a travez');
		writeln('  de una serie de turnos donde cada jugador disparara al enemigo.');
		writeln;
		writeln('  Para ello la partida consta de:');
		writeln('      3 etapas:');
		writeln('          La Carga de los barcos');
		writeln('          Los turnos para atacar y recibir ataques');
		writeln('          El resultado de la partida');
		writeln('      2 tableros:');
		writeln('          Tablero Propio: donde estaran las naves propias, y los disparos recibidos');
		writeln('          Tablero Oponente: donde se marcaran los disparos al oponente, y las naves golpeadas');
		writeln;
		volverMenuAyuda();
	end;

procedure infoEtapasPartida();
	begin
		saltosLinea10(); saltosLinea10();
		writeln(' ETAPAS del juego');
		writeln;
		writeln('  Carga de barco/s');
		writeln('      Al comenzar, cada jugador posiciona sus barcos en el tablero propio, de forma secreta, segun sus');
		writeln('      preferencias respetando la cantidad de naves de cada tamano de a cuerdo a las configuraciones por');
		writeln('      defecto o a las configuraciones personalizadas seleccionadas.');
		writeln('      Los podra colocar en direccion HORIZONTAL o VERTICAL, indicando la posicion de el extremo');
		writeln('      supeior izquierdo del barco.');
		writeln('      No se podran colocar barcos pegados entre si en la misma direccion. ');
		writeln;
		writeln('  Dar y Recibir disparos');
		writeln('      El jugador 1 dispara primero indicandole al jugador 2 a que posicion lo hara.');
		writeln('      El jugador 2 recibira el disparo informandole al jugador 1 si su disparo impacto en un barco,');
		writeln('      en el caso que haya impactado informara si el disparo undio el barco o no.');
		writeln('      Ahora se invierten los roles, y se vuelve a hacer el mismo proceso.');
		writeln('      Esto se repetira las veces necesarias hasta que se undan todos los Barcos de uno de los Jugadores.');
		writeln;
		writeln('  Resultado');
		writeln('      Existen 2 posibles escenarios:');
		writeln('          Ganar: uno de los jugadores consigue destruir todos los barcos de su rival.');
		writeln('          Empate: ambos jugadores destruyen los barcos de su rival en la misma cantidad de turnos.');
		writeln;
		volverMenuAyuda();
	end;

procedure infoConfigsDefault();
	begin
		saltosLinea10(); saltosLinea10();
		writeln(' CONFIGURACIONES DEFAULTS');
		writeln;
		writeln('  Por defecto el juego tiene las siguientes configuraciones:');
		writeln('      Ancho de tablero: 10 casillas, del 0 al 9.');
		writeln('      Alto de tablero: 10 casillas, de la A a la J.');
		writeln('      Cantidad de barcos total: 5.');
		writeln('      Cantidad de barcos por tamano:');
		writeln('          1 x 1= 1 barco.');
		writeln('          2 x 1= 2 barcos.');
		writeln('          3 x 1= 2 barcos.');
		writeln('          4 x 1= 1 barco.');
		writeln('      ( El tamano de barco esta dado por casillas, puede ser en sentido vertical u horizontal )');
		writeln;
		volverMenuAyuda();
	end;

procedure infoConfiguraciones();
	begin
		saltosLinea10(); saltosLinea10();
		writeln(' CONFIGURACIONES PERSONALIZABLES');
		writeln;
		writeln('  Como usuario en el apartado "Configurar Partida" del Menu principal, podra configurar los ');
		writeln('  siguientes apartados: ');
		writeln('      Cantidad de barcos total.');
		writeln('      Cantidad de barco/s por tamano:');
		writeln('          1 x 1.');
		writeln('          2 x 1.');
		writeln('          3 x 1.');
		writeln('          4 x 1.');
		writeln('  ( El tamano de barco esta dado por casillas, puede ser en sentido vertical u horizontal )');
		writeln('  ( El total de barcos tiene que ser igual a la suma de las cantidades de barcos por cada tamano )');
		writeln;
		volverMenuAyuda();
	end;

procedure comoJugar(var opc: char);
	begin
		repeat
			saltosLinea10(); saltosLinea10();
			writeln('     MENU Ayuda');
			writeln;
			writeln(' A continuacion elija lo que quiere saber');
			writeln('    1 |  Objetivo del juego');
			writeln('    2 |  Etapas de la Partida');
			writeln('    3 |  Configuraciones por defecto');
			writeln('    4 |  Que se puede configurar');
			writeln('    5 |  Volver al MENU Principal');
			writeln('    6 |  Cerrar el juego');
			repeat
				write(' Opcion: ');readln(opc);
				case opc of
					'1' : infoObjetivoJuego();
					'2' : infoEtapasPartida();
					'3' : infoConfigsDefault();
					'4' : infoConfiguraciones();
					'5' : begin
							writeln;
							writeln(' Regresando al MENU Principal');
							confirmarContinuar();
							saltosLinea10();
						end;
					'6' : begin
							bPartida:= false;
							bJugar:= false;
						end;
					else writeln(' Opcion no valida, intente nuevamente');
				end;
				writeln;
			until (opc>= '1') and (opc<= '6');
		until (opc= '5') or (opc= '6');
	end;

procedure setearTotalBarcos();
	var
		cantidad,opc: char;
	begin
		repeat
			writeln(' Ingrese la cantidad de barcos total, minimo 1 - maximo 9');
			repeat
				write(' Cantidad: ');readln(cantidad);
				if not((cantidad>= '1') and (cantidad<= '9')) then
					writeln(' Cantidad invalida, intente nuevamente');
				writeln;
			until (cantidad>= '1') and (cantidad<= '9');
			writeln(' Esta seguro que la cantidad de barcos total sea: ',cantidad,' ?');
			leerSiNo(opc);
			if opc= 'N' then begin
				writeln(' Proceda a cargar nuevamente la cantidad');
				writeln;
			end;
		until opc= 'S';
		nBarcos:= vITI[cantidad] - 1;
	end;

procedure leerCantidadBarco(var cant: integer; tam: integer);
	var
		cantidad,opc: char;
	begin
		repeat
			writeln(' Ingrese la cantidad de barcos tamano ',tam,' x 1');
			repeat
				write(' Cantidad: ');readln(cantidad);
				if not((cantidad>= '0') and ((vITI[cantidad] - 1)<= nBarcos)) then
					writeln(' Cantidad invalida, intente nuevamente');
				writeln;
			until (cantidad>= '0') and ((vITI[cantidad] - 1)<= nBarcos);
			writeln(' Esta seguro que la cantidad de barcos tamano ',tam,' x 1 sea: ',cantidad,' ?');
			leerSiNo(opc);
			if opc= 'N' then begin
				writeln(' Proceda a cargar nuevamente la cantidad');
				writeln;
			end;
		until opc= 'S';
		cant:= vITI[cantidad] - 1;
	end;

function sumarBarcos(cantBarcos: cantidadesBarcos): integer;
	var
		i: integer;
		cant: integer;
	begin
		cant:= 0;
		for i:= 1 to 4 do
			cant:= cant +cantBarcos[i];
		sumarBarcos:= cant;
	end;

function sumarCeldas(cantBarcos: cantidadesBarcos): integer;
	var
		i: integer;
		cant: integer;
	begin
		cant:= 0;
		for i:= 1 to 4 do
			cant:= cant +cantBarcos[i]*i;
		sumarCeldas:= cant;
	end;

procedure setearBarcosPorTamano();
	var
		i,n: integer;
		cantBarcos: cantidadesBarcos;
	begin
		repeat
			for i:= 1 to 4 do
				leerCantidadBarco(cantBarcos[i],i);
			n:= sumarBarcos(cantBarcos);
			if not(n= nBarcos) then begin
				writeln(' La suma de las cantidades de barcos de cada tamano no corresponde');
				writeln(' con la cantidad de barcos total ingresada: ',nBarcos);
				writeln(' Vuelva a ingresar las cantidades de barcos');
				confirmarContinuar();
			end;
			writeln;
		until n= nBarcos;
		nAciertos:= sumarCeldas(cantBarcos);
	end;

procedure configurarPartida();
	begin
		saltosLinea10();
		writeln('     MENU Configuraciones');
		writeln;
		writeln(' A continuacion podra editar los siguientes parametros');
		writeln;
		writeln('     Cantidad de barcos total');
		writeln('     Cantidad de barcos por tamano:');
		writeln('         Cantidad de barcos 1 x 1');
		writeln('         Cantidad de barcos 2 x 1');
		writeln('         Cantidad de barcos 3 x 1');
		writeln('         Cantidad de barcos 4 x 1');
		writeln;
		writeln(' IMPORTANTE: RECUERDE QUE AMBOS JUGADORES TIENEN QUE TENER');
		writeln(' LAS MISMAS CONFIGURACIONES DE PARTIDA.');
		writeln;
		confirmarContinuar();
		setearTotalBarcos();
		setearBarcosPorTamano();
		writeln(' Configuraciones cargadas correctamente');
		writeln(' Regresando al MENU Principal');
		confirmarContinuar();
		saltosLinea10();
	end;

procedure inicioJuego();
	var
		opc: char;
	begin
		bPartida:= true;
		writeln(' Bienvenido al juego');
		writeln;
		writeln;
		repeat
			writeln('     MENU Principal');
			writeln;
			writeln(' A continuacion elija lo que desea hacer');
			writeln('    1 |  Como jugar');
			writeln('    2 |  Configurar Partida');
			writeln('    3 |  Empezar a jugar');
			writeln('    4 |  Cerrar juego');
			repeat
				write(' Opcion: ');readln(opc);
				case opc of
					'1' : comoJugar(opc);
					'2' : configurarPartida();
					'3' : begin
							writeln;
							writeln(' Preparando partida');
							writeln(' Presione Enter para colocar los barcos');
							readln;
						end;
					'4' : begin
							opc:= '6';
							bPartida:= false;
							bJugar:= false;
						end
					else writeln(' Opcion no valida, intente nuevamente');
				end;
				writeln;
			until ((opc>= '1') and (opc<= '3')) or (opc= '5') or (opc= '6');
			saltosLinea10();
			saltosLinea10();
		until (opc= '3') or (opc= '6');
	end;




// Resetear configuraciones de la Partida
procedure iniciarVBarcos();
	var
		i: integer;
	begin
		for i:=1 to nBarcos do
			vBarcos[i]:= nil;
	end;

procedure resetearTablero();
	var
		x: integer;
		y: integer;
	begin
		for y:=1 to ALTOT do
			for x:=1 to ANCHOT do
				mTP[y][x]:=0;
	end;

procedure resetearPartida();
	begin
		bCarga:= false;
		nBarcosCargados:= 0;
		nTurno:= 0;
		nAciertosP:= 0;
		nAciertosO:= 0;
		nUndidosP:= 0;
		nUndidosO:= 0;
		iniciarVBarcos();
		resetearTablero();
		mTO:= mTP;
	end;
	



// Cargar barcos en tablero
procedure colocarEnTablero(x,y: integer);
	begin
		mTPreview[y][x]:=3;
	end;

procedure tipoBarco( var opc: char);
	begin
		repeat
			writeln(' Que tamano de barco quiere');
			writeln('     1 |  1 x 1');
			writeln('     2 |  2 x 1');
			writeln('     3 |  3 x 1');
			writeln('     4 |  4 x 1');
			write(' Opcion: ');readln(opc);
			if not((opc>= '1') and (opc<= '4')) then
				writeln(' Opcion no valida, intente nuevamente');
			writeln;
		until (opc>= '1') and (opc<= '4');
	end;

procedure direccionBarco( var opc: char);
	begin
		repeat
			writeln(' Que orientacion de barco quiere');
			writeln('     H |  Orientacion horizontal');
			writeln('     V |  Orientacion vertical');
			write(' Opcion: ');readln(opc);
			if not((opc= 'H') or (opc= 'h') or (opc= 'V') or (opc= 'v')) then
				writeln(' Opcion no valida, intente nuevamente');
			if opc= 'h' then
				opc:= 'H'
			else if opc= 'v' then
				opc:= 'V';
			writeln;
		until (opc= 'H') or (opc= 'V');
	end;

procedure posicionBarco( tipo: integer; direccion: char; var x,y: integer);
	var
		estado: boolean;
		xChar,yChar: char;
	begin
		estado:= false;
		repeat
			imprimirTablero(mTPreview,'V');
			write(' Tamano: ',tipo);
			if tipo> 1 then 
				writeln(', Orientacion: ',direccion)
			else
				writeln;
			writeln;
			writeln(' Ingrese posicion superior izquierda de donde desea colocar el barco');
			write(' Valor horizonal: ');readln(xChar);
			write(' Valor vertical: ');readln(yChar);
			if validarX(xChar) and validarY(yChar) then begin
				x:= vITI[xChar];
				y:= vLTI[hacerMayuscula(yChar)];
				if direccion= 'H' then begin
					if ((x + tipo -1) < ANCHOT +1) and (y < (ALTOT +1))then
						estado:= true
					else
						writeln(' Opcion no valida, exede limite del tablero');
				end
				else begin
					if ((y + tipo -1) < ALTOT +1) and (x < (ANCHOT +1))then
						estado:= true
					else
						writeln(' Opcion no valida, exede limite del tablero');
				end;
			end
			else
				writeln(' Valores no validos, intente nuevamente');
			writeln;	
		until estado;
	end;

procedure agregarCelda(var L: barco; x,y: integer);
	var
		nuevo: barco;
	begin
		colocarEnTablero(x,y);
		new(nuevo);
		nuevo^.dato.x:= x;
		nuevo^.dato.y:= y;
		nuevo^.dato.est:= 3;
		nuevo^.sig:=L;
		L:= nuevo;
	end;

procedure generarBarco(var nuevo: barco; tipo: integer; direccion: char; x,y: integer);
	var
		i: integer;
	begin
		if direccion= 'H' then
			for i:=1 to tipo do
				agregarCelda(nuevo,x +i -1,y)
		else
			for i:=1 to tipo do
				agregarCelda(nuevo,x,y +i -1);
	end;

function validarBarco(L: barco): boolean;
	var
		bMatch: boolean;
	begin
		bMatch:= false;
		while (L<> nil) and (not bMatch) do begin
			bMatch:= mTP[L^.dato.y][L^.dato.x] = 3;
			L:= L^.sig;
		end;
		validarBarco:= bMatch;
	end;

procedure leerBarco(i: integer);
	var
		opc: char;
		bConfirmacion: boolean;
		tipo,x,y: integer;
		direccion: char;
	begin
		bConfirmacion:= false;
		repeat
			mTPreview:= mTP;
			vBarcosPreview:= vBarcos;
			
			imprimirTablero(mTPreview,'V');
			tipoBarco(opc);
			case opc of
				'1': tipo:= 1;
				'2': tipo:= 2;
				'3': tipo:= 3;
				'4': tipo:= 4;
			end;
			writeln;
			if tipo<> 1 then begin
				imprimirTablero(mTPreview,'V');
				writeln(' Tamano: ',tipo);
				writeln;
				direccionBarco(opc);
				direccion:= opc;
				writeln;
				writeln;
			end;
			posicionBarco(tipo,opc,x,y);
			generarBarco(vBarcosPreview[i],tipo,direccion,x,y);
			if not validarBarco(vBarcosPreview[i]) then begin
				imprimirTablero(mTPreview,'V');
				writeln(' Esa es la posicion deseada?');
				leerSiNo(opc);
				if opc='S' then
					bConfirmacion:= True
				else
					writeln(' Reiniciando posicionamiento de nuevo barco');
			end
			else
				writeln(' Barco ingresado se suporpone con uno previo, intentelo nuevamente');
			writeln;
		until bConfirmacion;
	end;

procedure cargarBarcos();
	begin
		for nBarcosCargados:=1 to nBarcos do begin
			leerBarco(nBarcosCargados);
			mTP:= mTPreview;
			vBarcos:= vBarcosPreview;
			writeln;
		end;
		bCarga:= true;
		writeln(' Presione Enter para elegir Jugador');
		readln;
	end;




// Elegir quien abre la Partida
procedure elegirJugador();
	begin
		imprimirTablero(mTP,'P');
		writeln(' Sos el jugador 1 o 2 ?');
		writeln(' IMPORTANTE: tu rival tiene que ser el jugador opuesto al que elijas.');
		writeln;
		repeat
			write(' Opcion: ');readln(nJugador);
			if not((nJugador= '1') or (nJugador= '2')) then begin
				writeln(' Opcion no valida, intente nuevamente');
			end;
			writeln;
		until (nJugador= '1') or (nJugador= '2');
		writeln(' Presione Enter para comenzar las rondas');
		readln;
	end;




// Desarrollo de la Partida
procedure seUndioBarco(var nUndidos: integer);
	var
		opc: char;
	begin
		writeln(' Con el disparo, se undio un barco ?');
		leerSiNo(opc);
		if opc= 'S' then
			nUndidos:= nUndidos +1;
	end;

procedure hacerDisparo();
	var
		bConfirmacion: boolean;
		x,y: integer;
		opc,xChar,yChar: char;
	begin
		bConfirmacion:= false;
		repeat
			imprimirTablero(mTO,'O');
			writeln(' A que punto va a disparar');
			write(' Valor horizonal: ');readln(xChar);
			write(' Valor vertical: ');readln(yChar);
			if validarXY(xChar,yChar,mTO) then begin
				writeln(' El punto a disparar ingresado es ',xChar,' ',yChar,' ?');
				leerSiNo(opc);
				if opc= 'S' then begin
					bConfirmacion:= true;
					x:= vITI[xChar];
					y:= vLTI[hacerMayuscula(yChar)];
					writeln(' Su disparo impacto en un barco enemigo ?');
					leerSiNo(opc);
					if opc= 'S' then begin
						mTO[y][x]:= 4;
						nAciertosP:= nAciertosP +1;
						imprimirTablero(mTO,'O');
						writeln(' Mapa actualizado, buen disparo');
						seUndioBarco(nUndidosP);
					end
					else begin
						mTO[y][x]:=1;
						imprimirTablero(mTO,'O');
						writeln(' Mapa actualizado, mal disparo');
					end;
				end
				else 
					writeln(' Ingrese nuevamente las coordenadas');
			end
			else
				writeln(' Valores no validos, intente nuevamente');
			confirmarContinuar();
			writeln;	
		until bConfirmacion;
	end;

function impactoBarco(x,y: integer):boolean;
	begin
		impactoBarco:= mTP[y][x] = 3;
	end;

procedure recibirDisparo();
	var
		bConfirmacion: boolean;
		x,y: integer;
		opc,xChar,yChar: char;
	begin
		bConfirmacion:= false;
		repeat
			imprimirTablero(mTP,'P');
			writeln(' Donde cae el disparo ?');
			write(' Valor horizonal: ');readln(xChar);
			write(' Valor vertical: ');readln(yChar);
			if validarXY(xChar,yChar,mTP) then begin
				writeln(' El punto disparado ingresado es ',xChar,' ',yChar,' ?');
				leerSiNo(opc);
				if opc= 'S' then begin
					bConfirmacion:= true;
					x:= vITI[xChar];
					y:= vLTI[hacerMayuscula(yChar)];
					if impactoBarco(x,y) then begin
						mTP[y][x]:= 2;
						nAciertosO:= nAciertosO +1;
						imprimirTablero(mTP,'P');
						writeln(' Mapa actualizado, buen disparo enemigo');
						seUndioBarco(nUndidosO);
					end
					else begin
						mTP[y][x]:=1;
						imprimirTablero(mTP,'P');
						writeln(' Mapa actualizado, mal disparo enemigo');
					end;
				end
				else 
					writeln(' Ingrese nuevamente las coordenadas');
			end
			else
				writeln(' Valores no validos, intente nuevamente');
			confirmarContinuar();
			writeln;	
		until bConfirmacion;
	end;

procedure desarrollarPartida();
	begin
		if nJugador= '1' then begin
			repeat
				nTurno:= nTurno +1;
				hacerDisparo();
				recibirDisparo();
			until (nUndidosP= nBarcos) or (nUndidosO= nBarcos);
		end
		else 
			repeat
				nTurno:= nTurno +1;
				recibirDisparo();
				hacerDisparo();
			until (nUndidosP= nBarcos) or (nUndidosO= nBarcos);
	end;




// Resultados de la Partida
function jugadorOpuesto(nJugador: char):char;
	begin
		if nJugador= '1' then
			jugadorOpuesto:= '2'
		else
			jugadorOpuesto:= '1';
	end;

procedure resultadoPartida();
	var
		espacios: string;
	begin
		if nTurno< 10 then
			espacios:= '             '
		else if nTurno< 100 then
			espacios:= '            '
		else
			espacios:= '           ';
		writeln(chr(218) + sLinea + sLinea + sLinea + chr(191));
		if nUndidosP<>nUndidosO then begin
			if (nUndidosP= nBarcos) and (nUndidosO< nBarcos) then
				writeln(chr(179)+ '  El jugador ',nJugador,' es el ganador' + '                    ' + chr(179))
			else
				writeln(chr(179)+ '  El jugador ',jugadorOpuesto(nJugador),' es el ganador' + '                    ' + chr(179));
			writeln(chr(179) + '                                                ' + chr(179));
			writeln(chr(179) + '  Consiguio la victoria en ', nTurno,' turnos' + espacios + chr(179));
		end
		else begin
			writeln(chr(179)+ '  Empate                                        ' + chr(179));
			writeln(chr(179)+ '  Ambos Jugadores son muy buenos o muy malos    ' + chr(179));
		end;
		writeln(chr(192) + sLinea + sLinea + sLinea + chr(217));
		writeln;
		writeln;
		confirmarContinuar();
	end;




// Terminar Partida
procedure finPartida();
	var
		opc: char;
	begin
		writeln(' Quieres seguir jugando ?');
		leerSiNo(opc);
		if opc='S' then begin
			writeln;
			writeln(' Preparando para nueva partida');
			confirmarContinuar();
		end
		else begin
			bPartida:= false;
			writeln(' Regresando al MENU Principal');
			confirmarContinuar();
		end;
		saltosLinea10(); saltosLinea10();
	end;



// Mensaje de Cierre
procedure cierreAplicacion();
	begin
		saltosLinea10(); saltosLinea10(); saltosLinea10();
		writeln(' Gracias por jugar a Batalla Naval version Pascal <3');
		writeln(' Presione enter para cerrar la aplicacion');
		writeln;
		readln;
	end;



// CUERPO PRINCIPAL
begin
	iniciarDefault();
	derechosAutor();
	while bJugar do begin
		inicioJuego();
		while bPartida do begin
			resetearPartida();
			cargarBarcos;
			elegirJugador();
			desarrollarPartida();
			resultadoPartida();
			finPartida();
		end;
	end;
	cierreAplicacion();
end.
