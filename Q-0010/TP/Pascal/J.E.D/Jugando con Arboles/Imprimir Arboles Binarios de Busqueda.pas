const
	N_NODOS= 16;
	RANGO= 16;

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

// MODULOS COMUNES
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



// RECURSIVIDAD

function pot(x,n: integer): integer;
	begin
		if n> 0 then
			pot:= x* pot(x,n-1)
		else
			pot:= 1;
	end;

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

procedure generarArbol(var a: arbol);
	var
		i: integer;
		d: dato;
	begin
		new(a);
		a^.elem.nInt:= random(RANGO);
		a^.hi:= nil;
		a^.hd:= nil;
		for i:= 1 to N_NODOS -1 do begin
			d.nInt:= random(RANGO);
			insertarArbol(a,d);
		end;
	end;


procedure imprimirArbol(a: arbol);
	begin
		if a<> nil then begin
			imprimirArbol(a^.hi);
			writeln(a^.elem.nInt);
			imprimirArbol(a^.hd);
		end;
	end;


// INVENTOS
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


procedure espacios(n: integer);
	var
		i: integer;
	begin
		for i:= 1 to n do
			write(' ');
	end;

procedure imprimirNivel(a: arbol; max: integer; var lvl: integer; esp: integer);
	begin
		lvl:= lvl +1;
		if lvl<> max then begin
			if a<> nil then begin
				imprimirNivel(a^.hi,max,lvl,esp);
				lvl:= lvl -1;
				imprimirNivel(a^.hd,max,lvl,esp);
				lvl:= lvl -1;
			end
			else begin
				imprimirNivel(a,max,lvl,esp);
				lvl:= lvl -1;
				imprimirNivel(a,max,lvl,esp);
				lvl:= lvl -1;
			end;
		end
		else begin
			espacios(esp);
			if a<> nil then
				write(a^.elem.nInt)
			else
				write('  ');
			espacios(esp);
		end;
	end;

procedure imprimirArbolNiveles(a: arbol);
	var
		max,lvl,i,esp: integer;
	begin
		max:= mayorRama(a);
		esp:= pot(2,max-1)*2;
		lvl:= 0;
		for i:=1 to max do begin
			lvl:= 0;
			esp:= esp div 2;
			imprimirNivel(a,i,lvl,esp -1);
			writeln;
		end;
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
		writeln('  Ingrese los valores del arbol');
		repeat
			i:= i +1;
			repeat
				write('    Num ',i,': '); readln(rString);
				val(rString,d.nInt,code);
				ok:= (code= 0) or (rString[code]= 'n') or (rString[code]= 'N');
				if not ok then begin
					writeln('  Solo numeros enteros, intente nuevamente');
					write('  '); readln;
				end
			until ok;
			if code= 0 then
				insertarArbol(a,d);
		until code<> 0;
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




procedure imprimirNivelValor(a,n: arbol; max: integer; var lvl: integer; esp: integer);
	begin
		lvl:= lvl +1;
		if lvl<> max then begin
			if a<> nil then begin
				imprimirNivelValor(a^.hi,n,max,lvl,esp);
				lvl:= lvl -1;
				imprimirNivelValor(a^.hd,n,max,lvl,esp);
				lvl:= lvl -1;
			end
			else begin
				imprimirNivelValor(a,n,max,lvl,esp);
				lvl:= lvl -1;
				imprimirNivelValor(a,n,max,lvl,esp);
				lvl:= lvl -1;
			end;
		end
		else begin
			espacios(esp);
			if a<> nil then begin
				if a<> n then
					write('  ')
				else
					write(a^.elem.nInt);
			end
			else
				write('  ');
			espacios(esp);
		end;
	end;

procedure imprimirRamaValorNivel(a: arbol; max: integer; l: lista);
	var
		lvl,i,esp: integer;
	begin
		esp:= pot(2,max-1)*2;
		lvl:= 0;
		for i:=1 to max do begin
			lvl:= 0;
			esp:= esp div 2;
			imprimirNivelValor(a,l^.elem,i,lvl,esp -1);
			writeln;
			l:= l^.sig;
		end;
	end;
procedure buscarValor(a: arbol);
	var
		v,lvl: integer;
		l: lista;
	begin
		leerEntero('  Valor a buscar: ',v);
		lvl:= 0;
		l:= nil;
		buscarNodoValor(a,v,lvl,l);
		if l<> nil then
			imprimirRamaValorNivel(a,lvl,l)
		else
			writeln('  El valor no se encuentra en el arbol');
		
	end;


var
	a: arbol;
begin
	while true do begin
		//cargarArbolManual(a);
		generarArbol(A);
		//writeln(mayorRama(a));
		//imprimirArbol(a);
		imprimirArbolNiveles(a);
		buscarValor(a);
		buscarValor(a);
		readln;
	end;
end.
