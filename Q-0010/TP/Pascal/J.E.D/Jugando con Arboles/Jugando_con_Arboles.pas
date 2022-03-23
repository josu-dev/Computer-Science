const
	N_NODOS= 16;


type
	dato= record
		nInt: integer;
	end;
	arbol= ^nodo;
	nodo= record
		elem: dato;
		hi: arbol;
		hd: arbol;
	end;
	
	lista= ^nodoL;
	nodoL= record
		elem: arbol;
		sig: lista;
	end;


var
	B_App,B_Ope,B_Arbol,B_Orientacion: boolean;
	C_Tema: char;

	Rango_Min,Rango_Max: integer;

	A_Imp: arbol;




// CONFIGURACIONES DEFAULTS
procedure configsDefaultArbol();
	begin
		B_App:= true;
		B_Ope:= false;
		B_Arbol:= false;
		B_Orientacion:= true;
		A_Imp:= nil;
		Rango_Min:= 0;
		Rango_Max:= 99;
	end;




// MODULOS GENERICOS
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




//  ARBOLES
//    MODULOS COMUNES
function randomCarga(): integer;
	begin
		randomCarga:= Rango_Min + random(Rango_Max - Rango_Min +1);
	end;
function pot(x,n: integer): integer;
	begin
		if n> 0 then
			pot:= x* pot(x,n-1)
		else
			pot:= 1;
	end;
procedure recorrerRamas(a: arbol; var n,max: integer);
	begin
		if a<> nil then begin
			n:= n +1;
			recorrerRamas(a^.hi,n,max);
			recorrerRamas(a^.hd,n,max);
			n:= n-1;
		end
		else
			if n> max then
				max:= n;
	end;
function mayorRama(a: arbol): integer;
	var
		n: integer;
	begin
		mayorRama:= -1;
		n:= 0;
		recorrerRamas(a,n,mayorRama);
	end;

{   Esta es una mejor implementacion para calcular la mayor rama, pero no la hice yo

function max (a,b : integer) : integer; 
	begin
		if (a >= b) then
			max := a
		else
			max := b;
	end;
function altura(A : arbol) : integer;
	begin
		if (a <> nil) then
			altura := 1 + max( altura(a^.hi), altura(a^.hd) )
		else
			altura := 0;
	end;
}

procedure espacios(n: integer);
	var
		i: integer;
	begin
		for i:= 1 to n do
			write(' ');
	end;
procedure agregarUltimo(var l: lista; a: arbol);
	var
		nue,act: lista;
	begin
		new(nue);
		nue^.elem:= a;
		nue^.sig:= nil;
		if l<> nil then begin
			act:= l;
			while act^.sig <> nil do
				act:= act^.sig;
			act^.sig:= nue;
		end
		else
			l:= nue;
	end;
procedure invertirLista(l: lista; var lNue: lista);
	begin
		if l<> nil then begin
			invertirLista(l^.sig,lNue);
			agregarUltimo(lNue,l^.elem);
		end
		else
			lNue:= nil;
	end;
procedure buscarNodoValor(a: arbol; v: integer; var lvl: integer; var l: lista);
	begin
		if a<> nil then begin
			lvl:= lvl +1;
			if a^.elem.nInt< v then begin
				agregarUltimo(l,a);
				buscarNodoValor(a^.hd,v,lvl,l)
			end
			else if a^.elem.nInt> v then begin
				agregarUltimo(l,a);
				buscarNodoValor(a^.hi,v,lvl,l)
			end
			else
				agregarUltimo(l,a);
		end
		else begin
			l:= nil;
			lvl:= 0;
		end;
	end;



//    IMPRIMIR
procedure imprimirNivel(a: arbol; max: integer; lvl: integer; esp: integer);
	begin
		lvl:= lvl +1;
		if lvl<> max then begin
			if a<> nil then begin
				imprimirNivel(a^.hi,max,lvl,esp);
				imprimirNivel(a^.hd,max,lvl,esp);
			end
			else begin
				imprimirNivel(a,max,lvl,esp);
				imprimirNivel(a,max,lvl,esp);
			end;
		end
		else begin
			espacios(esp);
			if a<> nil then begin
				if (a^.elem.nInt< 10) and (a^.elem.nInt> -1) then
					write(' ');
				write(a^.elem.nInt)
			end
			else
				write('  ');
			espacios(esp);
		end;
	end;
procedure imprimirArbolNiveles(a: arbol);
	var
		max,lvl,i,esp,n: integer;
	begin
		max:= mayorRama(a);
		if B_Orientacion then begin
			esp:= pot(2,max-1)*2;
			for i:=1 to max do begin
				lvl:= 0;
				esp:= esp div 2;
				imprimirNivel(a,i,lvl,esp -1);
				writeln;
			end;
		end
		else begin
			esp:= 1;
			n:= 0;
			for i:=max downto 1 do begin
				lvl:= 0;
				if i<> max then begin
					n:= n +1;
					esp:= pot(2,n);
				end;
				imprimirNivel(a,i,lvl,esp -1);
				writeln;
			end;
		end;
	end;

procedure imprimirNivelValor(a,n: arbol; max: integer; lvl: integer; esp: integer);
	begin
		lvl:= lvl +1;
		if lvl<> max then begin
			if a<> nil then begin
				imprimirNivelValor(a^.hi,n,max,lvl,esp);
				imprimirNivelValor(a^.hd,n,max,lvl,esp);
			end
			else begin
				imprimirNivelValor(a,n,max,lvl,esp);
				imprimirNivelValor(a,n,max,lvl,esp);
			end;
		end
		else begin
			espacios(esp);
			if a<> nil then begin
				if a<> n then
					write('  ')
				else begin
					if (a^.elem.nInt< 10) and (a^.elem.nInt> -1) then
						write(' ');
					write(a^.elem.nInt);
				end;
			end
			else
				write('  ');
			espacios(esp);
		end;
	end;
procedure imprimirRamaValorNivel(a: arbol; max: integer; l: lista);
	var
		lvl,i,esp,n: integer;
		lInv: lista;
	begin
		if B_Orientacion then begin
			esp:= pot(2,max-1)*2;
			for i:=1 to max do begin
				lvl:= 0;
				esp:= esp div 2;
				imprimirNivelValor(a,l^.elem,i,lvl,esp -1);
				writeln;
				l:= l^.sig;
			end;
		end
		else begin
			invertirLista(l,lInv);
			esp:= 1;
			n:= 0;
			for i:=max downto 1 do begin
				lvl:= 0;
				if i<> max then begin
					n:= n +1;
					esp:= pot(2,n);
				end;
				imprimirNivelValor(a,lInv^.elem,i,lvl,esp -1);
				writeln;
				lInv:= lInv^.sig;
			end;
		end;
	end;



//    CREAR
procedure insertarArbol(var a: arbol; d: dato);
	begin
		if a= nil then begin
			new(a);
			a^.elem:= d;
			a^.hi:= nil;
			a^.hd:= nil;
		end
		else begin
			if a^.elem.nInt< d.nInt then
				insertarArbol(a^.hd,d)
			else
				insertarArbol(a^.hi,d)
		end;
	end;
procedure recomendacionCarga();
	begin
		writeln('  RECOMENDACION');
		writeln;
		writeln('    Se recomienda cargar un rango de valores de 0 a 99');
		writeln('    con un maximo de ',N_NODOS,' nodos para una buena visualizacion');
		writeln;
		writeln;
	end;
procedure cargarArbolManual(var a: arbol);
	var
		ok: boolean;
		code: word;
		i: integer;
		rString: string;
		d: dato;
	begin
		a:= nil;
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
			if code= 0 then
				insertarArbol(a,d)
			else
				if i= 1 then begin
					writeln('  Un arbol al menos tiene un nodo, intente nuevamente');
					write('  '); readln;
					i:= i -1;
					code:= 0;
				end;
		until code<> 0;
	end;
procedure cargarArbolAleatorio(var a: arbol);
	var
		nNodos,i: integer;
		d: dato;
	begin
		writeln('  Carga Aleatoria');
		writeln;
		leerRangoEntero('    Valor Minimo incluido: ','    Valor Maximo incluido: ',Rango_Min,Rango_Max);
		writeln;
		repeat
			leerEntero('    Cantidad de nodos del arbol: ',nNodos);
			if nNodos< 1 then begin
				writeln('    Un arbol al menos tiene un nodo, intente nuevamente');
				write('  '); readln;
			end;
		until nNodos> 0;
		new(a);
		a^.elem.nInt:= randomCarga();
		a^.hi:= nil;
		a^.hd:= nil;
		for i:= 1 to nNodos -1 do begin
			d.nInt:= randomCarga();
			insertarArbol(a,d);
		end;
	end;
procedure crearArbol();
	var
		opc: char;
	begin
		saltosLinea30(); saltosLinea30();
		writeln('  MENU CREAR ARBOL');
		writeln;
		writeln('  Ingrese la letra del apartado requerido');
		writeln;
		writeln('    A -  Cargar Manual');
		writeln('    B -  Cargar Aleatorio');
		leerOpcion('A','B',opc);
		saltosLinea30(); saltosLinea30();
		recomendacionCarga();
		if opc= 'A' then
			cargarArbolManual(A_Imp)
		else
			cargarArbolAleatorio(A_Imp);
		writeln;
		writeln;
		writeln('  Arbol cargado:');
		imprimirArbolNiveles(A_Imp);
		writeln;
		enterContinuar();
		B_Arbol:= true;
	end;



//    VISUALIZAR
procedure imprimirArbolListaDescendente(a: arbol; var i: integer);
	begin
		if a<> nil then begin
			imprimirArbolListaDescendente(a^.hd,i);
			i:= i +1;
			write('  ',a^.elem.nInt);
			if i= 16 then begin
				writeln;
				write('  ');
				i:= 0;
			end;
			imprimirArbolListaDescendente(a^.hi,i);
		end;
	end;
procedure imprimirArbolListaAscendente(a: arbol; var i: integer);
	begin
		if a<> nil then begin
			imprimirArbolListaAscendente(a^.hi,i);
			i:= i +1;
			write('  ',a^.elem.nInt);
			if i= 16 then begin
				writeln;
				write('  ');
				i:= 0;
			end;
			imprimirArbolListaAscendente(a^.hd,i);
		end;
	end;
procedure arbolVisualizar();
	var
		i: integer;
		opc: char;
	begin
		saltosLinea30(); saltosLinea30();
		if A_Imp<> nil then begin
			writeln('  MENU VISUALIZACION');
			writeln;
			writeln('  Ingrese la letra del apartado requerido');
			writeln;
			writeln('    A -  Ver arbol entero');
			writeln('    B -  Lista valores ascendente');
			writeln('    C -  Lista valores descendente');
			leerOpcion('A','C',opc);
			writeln;
			writeln;
			writeln('  Arbol:');
			write('  ');
			i:= 0;
			case opc of
				'A' :	imprimirArbolNiveles(A_Imp);
				'B'	:	imprimirArbolListaAscendente(A_Imp,i);
				'C'	:	imprimirArbolListaDescendente(A_Imp,i);
			end;
		end
		else
			writeln('  No hay arbol para visualizar');
		writeln;
		enterContinuar();
	end;

//    BUSCAR
procedure arbolBuscarValor();
	var
		v,lvl: integer;
		l: lista;
		a: arbol;
	begin
		saltosLinea30(); saltosLinea30();
		leerEntero('  Valor a buscar: ',v);
		a:= A_Imp;
		lvl:= 0;
		l:= nil;
		buscarNodoValor(a,v,lvl,l);
		writeln;
		if l<> nil then begin
			writeln('  El valor buscado se encuentra en el nivel: ',lvl);
			writeln;
			writeln('  Rama mas directa:');
			imprimirRamaValorNivel(a,lvl,l)
		end
		else
			writeln('  El valor no se encuentra en el arbol');
		writeln;
		enterContinuar();
	end;

//    SUMAR
function sumarNodosArbol(a: arbol): real;
	begin
		if a<> nil then
			sumarNodosArbol:= a^.elem.nInt + sumarNodosArbol(a^.hi) + sumarNodosArbol(a^.hd)
		else
			sumarNodosArbol:= 0;
	end;
procedure arbolSumarValores();
	var
		sum: real;
	begin
		saltosLinea30(); saltosLinea30();
		if A_Imp<> nil then begin
			sum:= sumarNodosArbol(A_Imp);
			writeln('  Arbol a sumar valores:');
			imprimirArbolNiveles(A_Imp);
			writeln;
			writeln('  La sumatoria es: ',sum:0:0);
		end
		else
			writeln('  No hay valores en el arbol para sumar');
		writeln;
		enterContinuar();
	end;

//    ESCALAR
procedure escalarNodosArbol(a: arbol; esc: integer);
	begin
		if a<> nil then begin
			a^.elem.nInt:= a^.elem.nInt* esc;
			escalarNodosArbol(a^.hi, esc);
			escalarNodosArbol(a^.hd, esc);
		end;
	end;
procedure arbolEscalarValores();
	var
		esc: integer;
	begin
		saltosLinea30(); saltosLinea30();
		if A_Imp<> nil then begin
			leerEntero('  Valor del escalar: ',esc);
			writeln;
			writeln('  Arbol base:');
			imprimirArbolNiveles(A_Imp);
			escalarNodosArbol(A_Imp,esc);
			writeln;
			writeln('  Arbol escalado:');
			imprimirArbolNiveles(A_Imp);
		end
		else
			writeln('  No hay valores en el arbol para escalar');
		writeln;
		enterContinuar();
	end;

//    MINIMO MAXIMO
procedure buscarMinimoArbolLista(a: arbol; var v: integer; var lvl: integer; var l: lista);
	begin
		if a<> nil then begin
			if a^.elem.nInt<= v then begin
				lvl:= lvl +1;
				v:= a^.elem.nInt;
				agregarUltimo(l,a);
				buscarMinimoArbolLista(a^.hi,v,lvl,l)
			end
		end;
	end;
procedure buscarMaximoArbolLista(a: arbol; var v: integer; var lvl: integer; var l: lista);
	begin
		if a<> nil then begin
			if a^.elem.nInt>= v then begin
				lvl:= lvl +1;
				v:= a^.elem.nInt;
				agregarUltimo(l,a);
				buscarMaximoArbolLista(a^.hd,v,lvl,l)
			end
		end;
	end;
procedure arbolBuscarMinMax();
	var
		opc: char;
		l: lista;
		v,lvl: integer;
	begin
		saltosLinea30(); saltosLinea30();
		if A_Imp<> nil then begin
			writeln('  MENU MINIMO/MAXIMO');
			writeln;
			writeln('  Ingrese la letra del apartado requerido');
			writeln;
			writeln('    A -  Buscar Minimo');
			writeln('    B -  Buscar Maximo');
			leerOpcion('A','B',opc);
			saltosLinea30(); saltosLinea30();
			writeln('  Arbol:');
			imprimirArbolNiveles(A_Imp);
			l:= nil;
			lvl:= 0;
			writeln;
			if opc= 'A' then begin
				v:= 32000;
				buscarMinimoArbolLista(A_Imp,v,lvl,l);
				write('  El minimo es: ',v);
			end
			else begin
				v:= -32000;
				buscarMaximoArbolLista(A_Imp,v,lvl,l);
				write('  El maximo es: ',v);
			end;
			writeln(' en el nivel: ',lvl);
			writeln;
			writeln('  Rama mas directa es:');
			imprimirRamaValorNivel(A_Imp,lvl,l);
		end
		else
			writeln('  No hay arbol para buscar minimo o maximo');
		writeln;
		enterContinuar();
	end;

//    NIVELES
procedure arbolNumeroNiveles();
	begin
		saltosLinea30(); saltosLinea30();
		if A_Imp<> nil then begin
			writeln('  Arbol:');
			imprimirArbolNiveles(A_Imp);
			writeln;
			writeln('  El arbol tiene ',mayorRama(A_Imp),' niveles');
		end
		else
			writeln('  El arbol no tiene niveles');
		writeln;
		enterContinuar();
	end;

//    ELIMINAR VALOR
procedure buscarMinimoArbolNodo(a: arbol; var n: arbol);
	begin
		if a<> nil then begin
			if a^.elem.nInt<= n^.elem.nInt then begin
				n:= a;
				buscarMinimoArbolNodo(a^.hi,n)
			end
		end;
	end;
procedure buscarMaximoArbolNodo(a: arbol; var n: arbol);
	begin
		if a<> nil then begin
			if a^.elem.nInt>= n^.elem.nInt then begin
				n:= a;
				buscarMaximoArbolNodo(a^.hd,n)
			end
		end;
	end;
procedure eliminarNodoArbol(aAnt,aElim: arbol);
	var
		fin: arbol;
	begin
		new(fin);
		fin^.elem.nInt:= 9999;
		if (aAnt<> aElim) then begin
			if aElim^.hd<> nil then begin
				if aElim^.hi<> nil then begin
					buscarMinimoArbolNodo(aElim^.hd,fin);
					fin^.hi:= aElim^.hi;
				end;
				if aAnt^.hi= aElim then
					aAnt^.hi:= aElim^.hd
				else
					aAnt^.hd:= aElim^.hd;
			end
			else if aElim^.hi<> nil then begin
				if aAnt^.hi= aElim then
					aAnt^.hi:= aElim^.hi
				else
					aAnt^.hd:= aElim^.hi;
			end
			else begin
				if aAnt^.hi= aElim then
					aAnt^.hi:= nil
				else
					aAnt^.hd:= nil;
			end;
		end
		else if aElim^.hd<> nil then begin
			if aElim^.hi<> nil then begin
				buscarMinimoArbolNodo(aElim^.hd,fin);
				fin^.hi:= aElim^.hi;
			end;
			A_Imp:= aElim^.hd;
		end
		else if aElim^.hi<> nil then
			A_Imp:= aElim^.hi
		else
			A_Imp:= nil;
		dispose(aElim);
	end;
procedure arbolEliminarValor();
	var
		v,lvl: integer;
		l,lAnt: lista;
	begin
		saltosLinea30(); saltosLinea30();
		if A_Imp<> nil then begin
			leerEntero('  Valor a eliminar: ',v);
			lvl:= 0;
			l:= nil;
			buscarNodoValor(A_Imp,v,lvl,l);
			writeln;
			if l<> nil then begin
				writeln('  Arbol Base');
				imprimirArbolNiveles(A_Imp);
				lAnt:= l;
				while l^.sig<> nil do begin
					lAnt:= l;
					l:= l^.sig
				end;
				eliminarNodoArbol(lAnt^.elem,l^.elem);
				writeln;
				writeln('  Arbol con el valor eliminado');
				imprimirArbolNiveles(A_Imp);
			end
			else
				writeln('  El valor no se encuentra en el arbol, por lo tanto no se puede eliminar');
		end
		else
			writeln('  No hay valores en el arbol para eliminar');
		writeln;
		enterContinuar();
	end;

//    ELIMINAR RAMA
procedure eliminarRamaArbol(aAnt,aElim: arbol);
	begin
		if aElim<> nil then begin
			eliminarRamaArbol(aElim,aElim^.hi);
			eliminarRamaArbol(aElim,aElim^.hd);
			if aAnt^.hi= aElim then
					aAnt^.hi:= nil
				else
					aAnt^.hd:= nil;
			if aAnt= aElim then
				A_Imp:= nil;
			dispose(aElim);
		end;
	end;
procedure arbolEliminarRama();
	var
		v,lvl: integer;
		l,lAnt: lista;
	begin
		saltosLinea30(); saltosLinea30();
		if A_Imp<> nil then begin
			leerEntero('  Valor de rama a eliminar incluido: ',v);
			lvl:= 0;
			l:= nil;
			buscarNodoValor(A_Imp,v,lvl,l);
			writeln;
			if l<> nil then begin
				writeln('  Arbol Base');
				imprimirArbolNiveles(A_Imp);
				lAnt:= l;
				while l^.sig<> nil do begin
					lAnt:= l;
					l:= l^.sig
				end;
				eliminarRamaArbol(lAnt^.elem,l^.elem);
				writeln;
				writeln('  Arbol con rama eliminada');
				imprimirArbolNiveles(A_Imp);
			end
			else
				writeln('  El valor no se encuentra en el arbol, por lo tanto no se puede eliminar');
		end
		else
			writeln('  No hay valores en el arbol para eliminar');
		writeln;
		enterContinuar();
	end;




//    MENU OPERACIONES
procedure cambiarImpresion();
	var
		opc: char;
	begin
		saltosLinea30(); saltosLinea30();
		write('  Actualmente el arbol entero se imprime con la ');
		if B_Orientacion then
			writeln('raiz arriba y las hojas abajo')
		else
			writeln('las hojas arriba y la raiz abajo');
		writeln;
		writeln;
		writeln('  Como quiere ver el arbol');
		writeln;
		writeln('    A -  Raiz arriba y hojas abajo');
		writeln('    B -  Hojas arriba y raiz abajo');
		leerOpcion('A','B',opc);
		B_Orientacion:= opc= 'A';
		writeln;
		writeln;
		write('  Ahora el arbol se imprimira con la ');
		if B_Orientacion then
			writeln('raiz arriba y las hojas abajo')
		else
			writeln('las hojas arriba y la raiz abajo');
		enterContinuar;
	end;

procedure menuOperacionesArbol();
	var
		opc: char;
	begin
		C_Tema:= ' ';
		while B_App and B_Ope and B_Arbol and (C_Tema=' ') do begin
			saltosLinea30(); saltosLinea30();
			writeln('  MENU OPERACIONES');
			writeln;
			writeln('  Ingrese la letra del apartado requerido');
			writeln;
			writeln('    A -  Visualizar');
			writeln('    B -  Buscar Valor');
			writeln('    C -  Sumar Valores');
			writeln('    D -  Escalar Valores');
			writeln('    E -  Buscar Minimo/Maximo');
			writeln('    F -  Cantidad Niveles');
			writeln('    G -  Eliminar Valor');
			writeln('    H -  Eliminar Rama');
			writeln;
			writeln('    I -  Nuevo Arbol');
			writeln('    J -  Cambiar Impresion Arbol');
			writeln;
			writeln('    K -  Menu Arboles');
			writeln('    L -  Cerrar Aplicacion');
			leerOpcion('A','L',opc);
			case opc of
				'A'..'H':	C_Tema:= opc;
				'I':	B_Arbol:= false;
				'J':	cambiarImpresion();
				'K':	B_Ope:= false;
				'L':	B_App:= false;
			end;
		end;
	end;




//    MENU INICIAL
procedure infoArboles();
	begin
		saltosLinea30(); saltosLinea30();
		writeln('  INFORMACION:');
		writeln;
		writeln('    Esta es una pequenia aplicacion con el fin de ayudar a entender la');
		writeln('    estructura de datos Arboles Binarios de Busqueda, a la vez de ser una');
		writeln('    manera de poner en practica los conocimientos sobre estos mismos');
		writeln;
		writeln('    Usted podra crear un arbol y realizar algunas operaciones sobre el');
		writeln('    viendo como se almacenan logicamente los datos. En particular los');
		writeln('    datos son valores enteros, pero es posible modificarlo de asi requerirlo');
		writeln('    mediante el codigo de la aplicacion');
		writeln;
		enterContinuar();
	end;

procedure menuArbol();
	var
		opc: char;
	begin
		while B_App and not B_Ope do begin
			saltosLinea30(); saltosLinea30();
			writeln('  MENU ARBOLES');
			writeln;
			writeln('  Ingrese la letra del apartado requerido');
			writeln;
			writeln('    A -  Crear ARBOL');
			writeln('    B -  Informacion Arboles');
			writeln;
			writeln('    C -  Cerrar Aplicacion');
			leerOpcion('A','C',opc);
			case opc of
				'A':	B_Ope:= true;
				'B':	infoArboles();
				'C':	B_App:= false;
			end;
		end;
	end;

procedure mensajeCierre();
	begin
		saltosLinea30(); saltosLinea30();
		writeln('  Se espera que la aplicacion le haya ayudado a entender un poco mas');
		writeln('  el funcionamiento de los Arboles Binarios de Busqueda');
		writeln;
		writeln('    Que disfrute de Taller de Programacion :D');
		writeln;
		writeln;
		writeln('  Presione Enter para cerrar la ventana ');
		write('  '); readln;
	end;




// PROGRAMA PRINCIPAL
begin
	configsDefaultArbol();
	menuArbol();
	while B_App do begin
		repeat
			crearArbol();
			menuOperacionesArbol();
			while B_App and B_Ope and B_Arbol do begin
				case C_Tema of
					'A':	arbolVisualizar();
					'B':	arbolBuscarValor();
					'C':	arbolSumarValores();
					'D':	arbolEscalarValores();
					'E':	arbolBuscarMinMax();
					'F':	arbolNumeroNiveles();
					'G':	arbolEliminarValor();
					'H':	arbolEliminarRama();
				end;
				menuOperacionesArbol();
			end;
		until not B_App or not B_Ope;
		menuArbol();
	end;
	mensajeCierre();
end.
