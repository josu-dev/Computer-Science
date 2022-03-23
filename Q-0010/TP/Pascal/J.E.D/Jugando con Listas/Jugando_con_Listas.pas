const
	CARGA_RANGO_MIN= -9;
	CARGA_RANGO_MAX= 99;
	CARGA_CANT_NODOS= 9;
	MAX_CANT_NODOS= 100;
	NODOS_LINEA= 10;



type
	dato= record
		nInt: integer;
		nomAct: string;
		nomSig: string;
	end;

	lista= ^nodo;
	nodo= record
		elem: dato;
		sig: lista;
	end;



var
	B_App,B_Ope,B_Lista: boolean;
	C_Tema: char;
	L_Imp,L_Aux: lista;
	Rango_Min,Rango_Max,Cant_Nodos: integer;



//  CONFIGURACIONES DEFAULTS
procedure configsDefaultLista();
	begin
		B_App:= true;
		B_Ope:= false;
		B_Lista:= false;
		L_Imp:= nil;
		L_Aux:= nil;
		Rango_Min:= CARGA_RANGO_MIN;
		Rango_Max:= CARGA_RANGO_MAX;
		Cant_Nodos:= CARGA_CANT_NODOS;
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
procedure leerEntero(frase: string; var e: integer);
	var
		code: word;
		rString: string;
	begin
		repeat
			write(frase); readln(rString);
			val(rString,e,code);
			if code<> 0 then begin
				writeln('  Solo numeros enteros, intente nuevamente');
				write('  '); readln;
			end;
		until code=0;
	end;
procedure leerRangoEntero(fraseInf,fraseSup: string; var inf,sup: integer);
	begin
		repeat
			leerEntero(fraseInf,inf);
			leerEntero(fraseSup,sup);
			if inf= sup then begin
				writeln('  Un rango consta de mas de un valor, intente nuevamente');
				write('  '); readln;
			end
			else if inf> sup then begin
				writeln('  Primero el valor mas chico luego el mas grande, intente nuevamente');
				write('  '); readln;
			end;
		until inf< sup;
	end;




//  LISTAS
//    MODULOS COMUNES
function randomCarga(): integer;
	begin
		randomCarga:= Rango_Min + random(Rango_Max - Rango_Min +1);
	end;
function intToStr(n: integer): string;
	begin
		if n>9 then
			intToStr:= intToStr(n div 10) + chr(48 + n mod 10) 
		else
			intToStr:= chr(48 + n);
	end;
function intToLttToStr(n: integer): string;
	begin
		if n>25 then
			intToLttToStr:=  intToLttToStr(n div 26) + chr(65 + (n mod 26))
		else
			intToLttToStr:= chr(65 + n);
	end;


procedure crearNodo(var nue: lista; var n: integer; val: integer);
	begin
		n:= n +1;
		new(nue);
		nue^.elem.nInt:= val;
		nue^.elem.nomAct:= intToLttToStr(n);
		nue^.elem.nomSig:= 'NIL';
		if n< 10 then
			nue^.elem.nomAct:= nue^.elem.nomAct +' ';
		nue^.sig:= nil;
	end;
procedure crearNodoDefault(var nue: lista;val: integer);
	begin
		new(nue);
		nue^.elem.nInt:= val;
		nue^.elem.nomAct:= 'DEFAULT';
		nue^.elem.nomSig:= 'NIL';
		nue^.sig:= nil;
	end;

procedure agregarDerecha(var l,ult: lista; nue: lista);
	begin
		if l= nil then
			l:= nue
		else begin
			ult^.elem.nomSig:= nue^.elem.nomAct;
			ult^.sig:= nue;
		end;
		ult:= nue;
	end;
procedure agregarDerechaRecorrido(var l: lista; nue: lista);
	var
		act: lista;
	begin
		if l<> nil then begin
			act:= l;
			while act^.sig <> nil do
				act:= act^.sig;
			act^.elem.nomSig:= nue^.elem.nomAct;
			act^.sig:= nue;
		end
		else
			l:= nue;
	end;
procedure agregarIzquierda(var l: lista; nue: lista);
	begin
		nue^.sig:= l;
		if l<> nil then
			nue^.elem.nomSig:= l^.elem.nomAct;
		l:= nue;
	end;
procedure insertarCreciente(var l: lista; nue: lista);
	var
		ant,act: lista;
	begin
		act:= l;
		while (act<> nil) and (act^.elem.nInt< nue^.elem.nInt) do begin
			ant:= act;
			act:= act^.sig;
		end;
		if act<> nil then
			nue^.elem.nomSig:= act^.elem.nomAct;
		if act= l then
			l:= nue
		else begin
			ant^.elem.nomSig:= nue^.elem.nomAct;
			ant^.sig:= nue;
		end;
		nue^.sig:= act;
	end;
procedure eliminarLista(var l: lista);
	var
		act: lista;
	begin
		while l<> nil do begin
			act:= l;
			l:= l^.sig;
			dispose(act);
		end;
	end;
function buscarListaDesorden(l: lista; n: integer): lista;
	begin
		while (l<> nil) and (l^.elem.nInt<> n) do
			l:= l^.sig;
		buscarListaDesorden:= l;
	end;
procedure actualizarNomSig(l: lista);
	begin
		while l<> nil do begin
			if l^.sig<> nil then
				l^.elem.nomSig:= l^.sig^.elem.nomAct
			else
				l^.elem.nomSig:= 'NIL';
			l:= l^.sig;
		end;
	end;



//    IMPRIMIR
procedure imprimirNodoLista(l: lista);
	begin
		if l<> nil then begin
			writeln('    Nodo: ',l^.elem.nomAct);
			writeln('      Valor: ',l^.elem.nInt);
			writeln('      Sig: ',l^.elem.nomSig);
		end
		else
			writeln('  No existe nodo');
	end;
procedure imprimirListaLinea(l: lista);
	var
		lA: lista;
		i: integer;
	begin
		lA:= l;
		i:= 0;
		while (lA<> nil) and (i< NODOS_LINEA) do begin
			i:= i +1;
			write('  Nodo: ',lA^.elem.nomAct,'   ');
			if length(lA^.elem.nomAct)=1 then
				write(' ');
			lA:= lA^.sig;
		end;
		lA:= l;
		writeln;
		i:= 0;
		while (lA<> nil) and (i< NODOS_LINEA) do begin
			i:= i +1;
			write('    Val: ');
			write(lA^.elem.nInt,'  ');
			if (lA^.elem.nInt< 10) and (lA^.elem.nInt> -1) then
				write(' ');
			lA:= lA^.sig;
		end;
		writeln;
		i:= 0;
		while (l<> nil) and (i< NODOS_LINEA) do begin
			i:= i +1;
			write('    Sig: ',l^.elem.nomSig,'  ');
			if length(l^.elem.nomSig)=1 then
				write(' ');
			l:= l^.sig;
		end;
		writeln;
		writeln;
		if l<> nil then
			imprimirListaLinea(l);
	end;



//    CREAR
procedure recomendacionCarga();
	begin
		writeln('  RECOMENDACION');
		writeln;
		writeln('    Cargar un rango de valores de 0 a 99, con una cantidad ');
		writeln('    maxima de ',NODOS_LINEA -2,' valores para una buena visualizacion');
		writeln;
		writeln;
	end;
procedure cargarListaManual(var l: lista; modo: char);
	var
		ok: boolean;
		code: word;
		i,n: integer;
		rString: string;
		d: dato;
		nue,ult: lista;
	begin
		eliminarLista(l);
		n:= -1;
		i:= 0;
		writeln('  Carga Manual');
		writeln;
		writeln('  Ingrese n o N para dejar de ingresar valores');
		writeln;
		writeln;
		repeat
			i:= i +1;
			repeat
				write('    Valor ',i,': '); readln(rString);
				val(rString,d.nInt,code);
				ok:= (code= 0) or (rString[code]= 'n') or (rString[code]= 'N');
				if not ok then begin
					writeln('  Solo numeros enteros, intente nuevamente');
					write('  '); readln;
				end
			until ok;
			if code= 0 then begin
				crearNodo(nue,n,d.nInt);
				case modo of
					'A': 	agregarDerecha(l,ult,nue);
					'B':	agregarIzquierda(l,nue);
					'C':	insertarCreciente(l,nue);
				end;
			end
			else
				if i= 1 then begin
					writeln('  Una lista al menos tiene un nodo, intente nuevamente');
					write('  '); readln;
					i:= i -1;
					code:= 0;
				end;
		until (code<> 0) or (n= MAX_CANT_NODOS);
		if n= MAX_CANT_NODOS then
			writeln('  Ya se ingreso la maxima cantidad representable correctamente');
		Cant_Nodos:= n;
	end;
procedure cargarListaAleatorio(var l: lista; modo: char);
	var
		i,n: integer;
		ult,nue: lista;
	begin
		eliminarLista(l);
		n:= -1;
		writeln('  Carga Aleatoria');
		writeln;
		leerRangoEntero('    Valor Minimo incluido: ','    Valor Maximo incluido: ',Rango_Min,Rango_Max);
		writeln;
		repeat
			leerEntero('    Cantidad de valores de la lista: ',Cant_Nodos);
			if Cant_Nodos< 1 then begin
				writeln('    Una lista al menos tiene un valor, intente nuevamente');
				write('  '); readln;
			end
			else if Cant_Nodos> MAX_CANT_NODOS then begin
				writeln('    No se puede mostrar correctamente, ingrese una cantidad menor');
				write('  '); readln;
			end;
		until (Cant_Nodos> 0) and (Cant_Nodos< MAX_CANT_NODOS +1);
		for i:= 1 to Cant_Nodos do begin
			crearNodo(nue,n,randomCarga());
			case modo of
				'A': 	agregarDerecha(l,ult,nue);
				'B':	agregarIzquierda(l,nue);
				'C':	insertarCreciente(l,nue);
			end;
		end;
	end;
procedure crearLista(var l: lista);
	var
		carga,modo: char;
	begin
		saltosLinea30(); saltosLinea30();
		writeln('  MENU CREAR LISTA');
		writeln;
		writeln('  Ingrese la letra del apartado requerido');
		writeln;
		writeln('    A -  Cargar Manual');
		writeln('    B -  Cargar Aleatorio');
		leerOpcion('A','B',carga);
		writeln;
		writeln('  Bajo que criterio se creara');
		writeln;
		writeln('    A -  Agregar Ultimo');
		writeln('    B -  Agregar Primero');
		writeln('    C -  Insertar Creciente');
		leerOpcion('A','C',modo);
		saltosLinea30(); saltosLinea30();
		recomendacionCarga();
		if carga= 'A' then
			cargarListaManual(l,modo)
		else
			cargarListaAleatorio(l,modo);
		writeln;
		writeln;
		writeln('  Lista cargada:');
		imprimirListaLinea(l);
		writeln;
		enterContinuar();
		B_Lista:= true;
	end;



//    VISUALIZAR
procedure imprimirListaDiagonal(l: lista);
	var
		esp: string;
	begin
		esp:= '';
		writeln;
		while l<> nil do begin
			writeln('  Nodo: ',l^.elem.nomAct);
			writeln(esp,'    Valor: ',l^.elem.nInt);
			write(esp,'    Sig: ',l^.elem.nomSig,'  ');
			l:= l^.sig;
			esp:= esp + '             ';
		end;
	end;
procedure imprimirListaVertIniFin(l: lista);
	begin
		while l<> nil do begin
			writeln;
			writeln('    Nodo: ',l^.elem.nomAct);
			writeln('      Valor: ',l^.elem.nInt);
			writeln('      Sig: ',l^.elem.nomSig);
			l:= l^.sig;
		end;
	end;
procedure imprimirListaVertFinIni(l: lista);
	begin
		writeln;
		if l<> nil then begin
			imprimirListaVertFinIni(l^.sig);
			writeln;
			writeln('    Nodo: ',l^.elem.nomAct);
			writeln('      Valor: ',l^.elem.nInt);
			writeln('      Sig: ',l^.elem.nomSig);
		end;
	end;

procedure listaVisualizar();
	var
		opc: char;
	begin
		saltosLinea30(); saltosLinea30();
		if L_Imp<> nil then begin
			writeln('  MENU VISUALIZACION');
			writeln;
			writeln('  Ingrese la letra del apartado requerido');
			writeln;
			writeln('    A -  Ver en sucesion');
			writeln('    B -  Ver en diagonal');
			writeln('    C -  Ver en vertical inicio - final');
			writeln('    D -  Ver en vertical final - inicio');
			leerOpcion('A','D',opc);
			writeln;
			writeln;
			writeln('  Lista:');
			case opc of
				'A' :	imprimirListaLinea(L_Imp);
				'B'	:	imprimirListaDiagonal(L_Imp);
				'C'	:	imprimirListaVertIniFin(L_Imp);
				'D'	:	imprimirListaVertFinIni(L_Imp);
			end;
		end
		else
			writeln('  No hay lista para visualizar');
		writeln;
		enterContinuar();
	end;



//    AGREGAR
procedure listaAgregarValor();
	var
		carga,modo: char;
		n: integer;
		nue: lista;
	begin
		saltosLinea30(); saltosLinea30();
		writeln('  MENU AGREGAR');
		writeln;
		writeln('  Ingrese la letra del apartado requerido');
		writeln;
		writeln('    A -  Valor Manual');
		writeln('    B -  Valor Aleatorio');
		leerOpcion('A','B',carga);
		writeln;
		writeln('  Bajo que criterio se agregara');
		writeln;
		writeln('    A -  Agregar Ultimo');
		writeln('    B -  Agregar Primero');
		writeln('    C -  Insertar Creciente');
		leerOpcion('A','C',modo);
		saltosLinea30(); saltosLinea30();
		if carga= 'A' then begin
			recomendacionCarga();
			leerEntero('  Valor a cargar: ',n);
		end
		else begin
			writeln('  Valor random creado');
			n:= randomCarga();
		end;
		crearNodo(nue,Cant_Nodos,n);
		writeln;
		writeln;
		writeln('  Lista base:');
		imprimirListaLinea(L_Imp);
		writeln;
		writeln('  Valor a cargar:');
		imprimirNodoLista(nue);
		
		case modo of
			'A': 	agregarDerechaRecorrido(L_Imp,nue);
			'B':	agregarIzquierda(L_Imp,nue);
			'C':	insertarCreciente(L_Imp,nue);
		end;
		writeln;
		writeln('  Lista cargada:');
		imprimirListaLinea(L_Imp);
		writeln;
		enterContinuar();
	end;



//    ESTADISTICAS
function cantidadNodosLista(l: lista): integer;
	begin
		if l<> nil then
			cantidadNodosLista:= 1 + cantidadNodosLista(l^.sig)
		else
			cantidadNodosLista:= 0;
	end;
procedure tieneOrden(l: lista; var creciente,decreciente: boolean);
	var
		ant: lista;
	begin
		ant:= l;
		creciente:= true;
		decreciente:= true;
		while (l<> nil) and (creciente or decreciente) do begin
			if ant^.elem.nInt< l^.elem.nInt then
				decreciente:= false
			else if ant^.elem.nInt> l^.elem.nInt then
				creciente:= false;
			ant:= l;
			l:= l^.sig;
		end;
	end;
procedure minimoLista(l: lista; var min: lista);
	begin
		if l<> nil then begin
			minimoLista(l^.sig,min);
			if l^.elem.nInt< min^.elem.nInt then
				min:= l;
		end
		else
			crearNodoDefault(min,9999);
	end;
procedure maximoLista(l: lista; var max: lista);
	begin
		if l<> nil then begin
			maximoLista(l^.sig,max);
			if l^.elem.nInt> max^.elem.nInt then
				max:= l;
		end
		else
			crearNodoDefault(max,-9999);
	end;
procedure listaEstadisticas();
	var
		cant: integer;
		min,max: lista;
		creciente,decreciente: boolean;
	begin
		saltosLinea30(); saltosLinea30();
		if L_Imp<> nil then begin
			cant:= cantidadNodosLista(L_Imp);
			tieneOrden(L_Imp,creciente,decreciente);
			minimoLista(L_Imp,min);
			maximoLista(L_Imp,max);
			writeln('  ESTADISTICAS');
			writeln;
			writeln;
			writeln('  Lista:');
			imprimirListaLinea(L_Imp);
			writeln;
			writeln('    Cantidad de nodos: ',cant);
			writeln;
			writeln('    Orden');
			writeln('          Creciente: ',creciente,'   Decreciente: ',decreciente,'   Desordenada: ',not(creciente or decreciente));
			writeln;
			writeln('    Minimo:');
			imprimirNodoLista(min);
			writeln;
			writeln('    Maximo:');
			imprimirNodoLista(max);
		end
		else
			writeln('  No hay lista para ver estadisticas');
		writeln;
		enterContinuar();
	end;



//    BUSCAR
procedure listaBuscarValor();
	var
		v: integer;
		lAux: lista;
	begin
		saltosLinea30(); saltosLinea30();
		if L_Imp<> nil then begin
			leerEntero('  Valor a buscar: ',v);
			lAux:= buscarListaDesorden(L_Imp,v);
			writeln;
			writeln;
			writeln('  Lista:');
			imprimirListaLinea(L_Imp);
			if lAux<> nil then begin
				writeln;
				writeln('  El valor buscado se encuentra en el nodo:');
				imprimirNodoLista(lAux);
			end
			else
				writeln('  El valor no se encuentra en la lista');
		end
		else
			writeln('  No hay lista para buscar algun valor');
		writeln;
		enterContinuar();
	end;



//    SUMA
function sumarValoresLista(l: lista): integer;
	begin
		if l<> nil then
			sumarValoresLista:= l^.elem.nInt + sumarValoresLista(l^.sig)
		else
			sumarValoresLista:= 0;
	end;
procedure listaSumarValores();
	begin
		saltosLinea30(); saltosLinea30();
		if L_Imp<> nil then begin
			writeln('  Lista a sumar valores:');
			imprimirListaLinea(L_Imp);
			writeln;
			writeln('  La sumatoria es: ',sumarValoresLista(L_Imp));
		end
		else
			writeln('  No hay lista para sumar');
		writeln;
		enterContinuar();
	end;



//    ESCALAR
procedure escalarValoresLista(l: lista; esc: integer);
	begin
		while l<> nil do begin
			l^.elem.nInt:= l^.elem.nInt * esc;
			l:= l^.sig;
		end;
	end;
procedure listaEscalarValores();
	var
		esc: integer;
	begin
		saltosLinea30(); saltosLinea30();
		if L_Imp<> nil then begin
			leerEntero('  Valor del escalar: ',esc);
			writeln;
			writeln('  Lista base:');
			imprimirListaLinea(L_Imp);
			escalarValoresLista(L_Imp,esc);
			writeln;
			writeln('  Lista escalada:');
			imprimirListaLinea(L_Imp);
		end
		else
			writeln('  No hay lista para escalar');
		writeln;
		enterContinuar();
	end;



//    ELIMINAR
procedure eliminarNodoLista(var l: lista; n: integer);
	var
		ant,act: lista;
	begin
		act:= l;
		while (act<> nil) and (act^.elem.nInt<> n) do begin
			ant:= act;
			act:= act^.sig;
		end;
		if act<> nil then begin
			if act= l then
				l:= l^.sig
			else begin
				if act^.sig<> nil then
					ant^.elem.nomSig:= act^.sig^.elem.nomAct
				else
					ant^.elem.nomSig:= 'NIL';
				ant^.sig:= act^.sig;
			end;
			dispose(act);
		end;
	end;
procedure eliminarNodosIgualesLista(var l: lista; n: integer);
	var
		ant,act,aux: lista;
	begin
		act:= l;
		while act<> nil do begin
			if act^.elem.nInt<> n then begin
				ant:= act;
				act:= act^.sig;
			end
			else begin
				if act= l then
					l:= l^.sig
				else
					ant^.sig:= act^.sig;
				aux:= act;
				act:= act^.sig;
				dispose(aux);
			end;
		end;
		actualizarNomSig(l);
	end;
procedure eliminarNodosRangoLista(var l: lista; min,max: integer);
	var
		ant,act,aux: lista;
	begin
		act:= l;
		while act<> nil do begin
			if (act^.elem.nInt< min) or (act^.elem.nInt> max) then begin
				ant:= act;
				act:= act^.sig;
			end
			else begin
				if act= l then
					l:= l^.sig
				else
					ant^.sig:= act^.sig;
				aux:= act;
				act:= act^.sig;
				dispose(aux);
			end;
		end;
		actualizarNomSig(l);
	end;
procedure listaEliminar();
	var
		opc: char;
		val,min,max: integer;
	begin
		saltosLinea30(); saltosLinea30();
		if L_Imp<> nil then begin
			writeln('  MENU ELIMINAR');
			writeln;
			writeln('  Ingrese la letra del apartado requerido');
			writeln;
			writeln('    A -  Eliminar un valor');
			writeln('    B -  Eliminar un valor y sus repeticiones');
			writeln('    C -  Eliminar rango');
			writeln('    D -  Eliminar lista');
			leerOpcion('A','D',opc);
			writeln;
			writeln;
			case opc of
				'A'..'B':	leerEntero('  Valor a eliminar: ',val);
				'C'	:	leerRangoEntero('  Valor minimo a eliminar: ','  Valor maximo a eliminar: ',min,max);
			end;
			if opc<> 'D' then begin
				writeln;
				writeln;
			end;
			writeln('  Lista base:');
			imprimirListaLinea(L_Imp);
			case opc of
				'A' :	eliminarNodoLista(L_Imp,val);
				'B'	:	eliminarNodosIgualesLista(L_Imp,val);
				'C'	:	eliminarNodosRangoLista(L_Imp,min,max);
				'D'	:	eliminarLista(L_Imp);
			end;
			writeln;
			writeln('  Lista despues de eliminar:');
			if L_Imp<> nil then
				imprimirListaLinea(L_Imp)
			else begin
				writeln;
				writeln('  Vacia');
			end;
		end
		else
			writeln('  No hay lista para eliminar');
		writeln;
		enterContinuar();
	end;



//    INVERTIR
procedure invertirLista(l: lista; var n: integer; var lNue,ult: lista);
	var
		aux: lista;
	begin
		if l<> nil then begin
			invertirLista(l^.sig,n,lNue,ult);
			crearNodo(aux,n,l^.elem.nInt);
			agregarDerecha(lNue,ult,aux);
		end
		else begin
			lNue:= nil;
			n:= -1;
		end;
	end;
procedure listaInvertir();
	var
		n: integer;
		lUlt: lista;
	begin
		saltosLinea30(); saltosLinea30();
		if L_Imp<> nil then begin
			writeln('  Lista base:');
			imprimirListaLinea(L_Imp);
			invertirLista(L_Imp,n,L_Aux,lUlt);
			writeln;
			writeln('  Lista invertida:');
			imprimirListaLinea(L_Aux);
			eliminarLista(L_Imp);
			L_Imp:= L_Aux;
			L_Aux:= nil;
		end
		else
			writeln('  No hay lista para invertir');
		writeln;
		enterContinuar();
	end;



//    ORDENAR
procedure ordenarListaCreciente(l: lista);
	var
		lA,lAct,lMax: lista;
		aux: dato;
	begin
		lA:= l;
		while l<> nil do begin
			lMax:= l;
			lAct:= l^.sig;
			while lAct<> nil do begin
				if lAct^.elem.nInt< lMax^.elem.nInt then
					lMax:= lAct;
				lAct:= lAct^.sig;
			end;
			if l<> lMax then begin
				aux:= l^.elem;
				l^.elem:= lMax^.elem;
				lMax^.elem:= aux;
			end;
			l:= l^.sig;
		end;
		actualizarNomSig(lA);
	end;
procedure ordenarListaDecreciente(l: lista);
	var
		lA,lAct,lMax: lista;
		aux: dato;
	begin
		lA:= l;
		while l<> nil do begin
			lMax:= l;
			lAct:= l^.sig;
			while lAct<> nil do begin
				if lAct^.elem.nInt> lMax^.elem.nInt then
					lMax:= lAct;
				lAct:= lAct^.sig;
			end;
			if l<> lMax then begin
				aux:= l^.elem;
				l^.elem:= lMax^.elem;
				lMax^.elem:= aux;
			end;
			l:= l^.sig;
		end;
		actualizarNomSig(lA);
	end;
procedure listaOrdenar();
	var
		opc: char;
	begin
		saltosLinea30(); saltosLinea30();
		if L_Imp<> nil then begin
			writeln('  MENU ORDENAR');
			writeln;
			writeln('  Ingrese la letra del apartado requerido');
			writeln;
			writeln('    A -  Ordenar Creciente');
			writeln('    B -  Ordenar Decreciente');
			leerOpcion('A','B',opc);
			writeln;
			writeln;
			writeln('  Lista base:');
			imprimirListaLinea(L_Imp);
			if opc= 'A' then
				ordenarListaCreciente(L_Imp)
			else
				ordenarListaDecreciente(L_Imp);
			writeln;
			write('  Lista ordenada de forma');
			if opc= 'A' then
				writeln('creciente:')
			else
				writeln('decreciente:');
			imprimirListaLinea(L_Imp);
		end
		else
			writeln('  No hay lista para ordenar');
		writeln;
		enterContinuar();
	end;



//    MERGE
procedure minimoEntreListas(var lPri,lSeg: lista; var elem: dato);
	begin
		if lPri<> nil then begin
			if lSeg<> nil then begin
				if lPri^.elem.nInt<= lSeg^.elem.nInt then begin
					elem:= lPri^.elem;
					lPri:= lPri^.sig;
				end
				else begin
					elem:= lSeg^.elem;
					lSeg:= lSeg^.sig;
				end;
			end
			else begin
				elem:= lPri^.elem;
				lPri:= lPri^.sig;
			end
		end
		else if lSeg<> nil then begin
			elem:= lSeg^.elem;
			lSeg:= lSeg^.sig;
		end;
	end;
procedure mergeListaOrdenado(lPri,lSeg: lista; var lNue: lista);
	var
		d: dato;
		n: integer;
		nue,ult: lista;
	begin
		n:= -1;
		lNue:= nil;
		while (lPri<> nil) or (lSeg<> nil) do begin
			minimoEntreListas(lPri,lSeg,d);
			crearNodo(nue,n,d.nInt);
			agregarDerecha(lNue,ult,nue);
		end;
	end;
procedure listaMerge();
	var
		creciente,decreciente: boolean;
		lNue: lista;
	begin
		saltosLinea30(); saltosLinea30();
		if L_Imp<> nil then begin
			tieneOrden(L_Imp,creciente,decreciente);
			writeln('  MENU MERGE');
			writeln;
			if creciente then begin
				writeln('  Para hacer merge se necesita una segunda lista ordenada');
				writeln('  de forma creciente, creela ahora');
				writeln;
				enterContinuar();
				crearLista(L_Aux);
				tieneOrden(L_Aux,creciente,decreciente);
				if not creciente then
					ordenarListaCreciente(L_Aux);
				mergeListaOrdenado(L_Imp,L_Aux,lNue);
				saltosLinea30(); saltosLinea30();
				writeln('  Merge');
				writeln;
				writeln;
				writeln('  Lista 1:');
				imprimirListaLinea(L_Imp);
				writeln;
				writeln('  Lista 2:');
				imprimirListaLinea(L_Aux);
				writeln;
				writeln;
				writeln('  Lista Resultante:');
				imprimirListaLinea(lNue);
				eliminarLista(L_Imp);
				eliminarLista(L_Aux);
				L_Imp:= lNue;
			end
			else if decreciente then begin
				writeln('  La lista inicial tiene orden decreciente, cambielo');
				writeln('  a creciente para poder proseguir');
			end
			else begin
				writeln('  La lista inicial esta desordenada, ordendela de forma');
				writeln('  creciente para poder proseguir');
			end;
		end
		else
			writeln('  No hay lista inicial para combinar');
		writeln;
		enterContinuar();
	end;



//    MENU OPERACIONES
procedure menuOperacionesLista();
	var
		opc: char;
	begin
		C_Tema:= ' ';
		if B_App and B_Ope then begin
			saltosLinea30(); saltosLinea30();
			writeln('  MENU OPERACIONES');
			writeln;
			writeln('  Ingrese la letra del apartado requerido');
			writeln;
			writeln('    A -  Visualizar');
			writeln('    B -  Agregar Valor');
			writeln('    C -  Estadisticas');
			writeln('    D -  Buscar Valor');
			writeln('    E -  Sumar Valores');
			writeln('    F -  Escalar Valores');
			writeln('    G -  Eliminar');
			writeln('    H -  Invertir');
			writeln('    I -  Ordenar');
			writeln('    J -  Merge');
			writeln;
			writeln('    K -  Nueva Lista');
			writeln;
			writeln('    L -  Menu Inicio');
			writeln('    M -  Cerrar Aplicacion');
			leerOpcion('A','M',opc);
			case opc of
				'A'..'J':	C_Tema:= opc;
				'K':	B_Lista:= false;
				'L':	B_Ope:= false;
				'M':	B_App:= false;
			end;
		end;
	end;



//    MENU INICIAL 
procedure infoListas();
	begin
		saltosLinea30(); saltosLinea30();
		writeln('  INFORMACION:');
		writeln;
		writeln('    Esta es una pequenia aplicacion con el fin de ayudar a entender la');
		writeln('    estructura de datos listas simples, a la vez de ser una manera de poner');
		writeln('    en practica los conocimientos sobre estos mismos');
		writeln;
		writeln('    Usted podra crear una lista y realizar algunas operaciones sobre ella');
		writeln('    viendo como se almacenan logicamente los datos. En particular los');
		writeln('    datos son valores enteros, pero es posible modificarlo de asi requerirlo');
		writeln('    mediante el codigo de la aplicacion');
		writeln;
		enterContinuar();
	end;

procedure menuLista();
	var
		opc: char;
	begin
		while B_App and not B_Ope do begin
			saltosLinea30(); saltosLinea30();
			writeln('  MENU LISTAS');
			writeln;
			writeln('  Ingrese la letra del apartado requerido');
			writeln;
			writeln('    A -  Crear LISTA');
			writeln('    B -  Informacion Listas');
			writeln;
			writeln('    C -  Cerrar aplicacion');
			leerOpcion('A','C',opc);
			case opc of
				'A':	B_Ope:= true;
				'B':	infoListas();
				'C':	B_App:= false;
			end;
		end;
	end;

procedure mensajeCierre();
	begin
		saltosLinea30(); saltosLinea30();
		writeln('  Se espera que la aplicacion le haya ayudado a entender un poco mas');
		writeln('  el funcionamiento de listas Simples');
		writeln;
		writeln('    Que disfrute de Conceptos de CADP y TP :D');
		writeln;
		writeln;
		writeln('  Presione Enter para cerrar la ventana ');
		write('  '); readln;
	end;




//  PROGRAMA PRINCIPAL
begin
	configsDefaultLista();
	menuLista();
	while B_App do begin
		repeat
			crearLista(L_Imp);
			menuOperacionesLista();
			while B_App and B_Ope and B_Lista do begin
				case C_Tema of
					'A':	listaVisualizar();
					'B':	listaAgregarValor();
					'C':	listaEstadisticas();
					'D':	listaBuscarValor();
					'E':	listaSumarValores();
					'F':	listaEscalarValores();
					'G':	listaEliminar();
					'H':	listaInvertir();
					'I':	listaOrdenar();
					'J':	listaMerge();
				end;
				menuOperacionesLista();
			end;
		until not B_App or not B_Ope;
		menuLista();
	end;
	eliminarLista(L_Imp);
	mensajeCierre();
end.
