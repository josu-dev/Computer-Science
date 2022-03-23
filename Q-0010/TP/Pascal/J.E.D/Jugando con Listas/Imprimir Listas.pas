const
	CARGA_RANGO_MIN= -9;
	CARGA_RANGO_MAX= 99;
	CARGA_CANT_NODOS= 10;
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

function randomCarga(): integer;
	begin
		randomCarga:= CARGA_RANGO_MIN + random(CARGA_RANGO_MAX - CARGA_RANGO_MIN +1);
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
procedure generarListaDerecha(var l: lista);
	var
		n: integer;
		nue,ult: lista;
	begin
		n:= -1;
		l:= nil;
		while n< CARGA_CANT_NODOS -1 do begin
			crearNodo(nue,n,randomCarga);
			agregarDerecha(l,ult,nue);
		end;
	end;


procedure agregarIzquierda(var l: lista; nue: lista);
	begin
		nue^.sig:= l;
		if l<> nil then
			nue^.elem.nomSig:= l^.elem.nomAct;
		l:= nue;
	end;
procedure generarListaIzquierda(var l: lista);
	var
		n: integer;
		nue: lista;
	begin
		n:= -1;
		l:= nil;
		while n< CARGA_CANT_NODOS -1 do begin
			crearNodo(nue,n,randomCarga);
			agregarIzquierda(l,nue);
		end;
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
procedure generarListaOrdenada(var l: lista);
	var
		n: integer;
		nue: lista;
	begin
		n:= -1;
		l:= nil;
		while n< CARGA_CANT_NODOS -1 do begin
			crearNodo(nue,n,randomCarga);
			insertarCreciente(l,nue);
		end;
	end;



procedure imprimirListaVertical(l: lista);
	begin
		while l<> nil do begin
			writeln;
			writeln('  Nodo: ',l^.elem.nomAct);
			writeln('    Valor: ',l^.elem.nInt);
			writeln('    Sig: ',l^.elem.nomSig);
			l:= l^.sig;
		end;
	end;
procedure imprimirListaLinea(l: lista);
	var
		lA: lista;
		i: integer;
	begin
		lA:= l;
		writeln;
		writeln;
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
procedure imprimirListaVertFinIni(l: lista);
	begin
		writeln;
		if l<> nil then begin
			imprimirListaVertFinIni(l^.sig);
			writeln;
			writeln('  ',l^.elem.nomAct);
			writeln('    Valor: ',l^.elem.nInt);
			writeln('    Sig: ',l^.elem.nomSig);
		end;
	end;
procedure imprimirNodoLista(l: lista);
	begin
		if l<> nil then begin
			writeln('  Nodo: ',l^.elem.nomAct);
			writeln('    Valor: ',l^.elem.nInt);
			writeln('    Sig: ',l^.elem.nomSig);
		end;
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

function buscarListaDesorden(l: lista; n: integer): lista;
	begin
		while (l<> nil) and (l^.elem.nInt<> n) do
			l:= l^.sig;
		buscarListaDesorden:= l;
	end;

function buscarListaCreciente(l: lista; n: integer): lista;
	begin
		while (l<> nil) and (l^.elem.nInt <> n) do
			l:= l^.sig;
		buscarListaCreciente:= l;
	end;

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
			else
				ant^.sig:= act^.sig;
			dispose(act);
		end;
	end;
procedure eliminarNodosIgualesLista(var l: lista; n: integer);
	var
		ant,act,aux: lista;
	begin
		act:= l;
		while (act<> nil) and (act^.elem.nInt<> n) do begin
			ant:= act;
			act:= act^.sig;
		end;
		while (act<> nil) and (act^.elem.nInt= n) do begin
			if act= l then
				l:= l^.sig
			else
				ant^.sig:= act^.sig;
			aux:= act;
			act:= act^.sig;
			dispose(aux);
		end;
	end;
procedure eliminarNodosRangoLista(var l: lista; min,max: integer);
	var
		ant,act,aux: lista;
	begin
		act:= l;
		while (act<> nil) and (act^.elem.nInt< min) do begin
			ant:= act;
			act:= act^.sig;
		end;
		while (act<> nil) and (act^.elem.nInt<= max) do begin
			if act= l then
				l:= l^.sig
			else
				ant^.sig:= act^.sig;
			aux:= act;
			act:= act^.sig;
			dispose(aux);
		end;
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

function cantidadNodosLista(l: lista): integer;
	begin
		if l<> nil then
			cantidadNodosLista:= 1 + cantidadNodosLista(l^.sig)
		else
			cantidadNodosLista:= 0;
	end;

function sumarValoresLista(l: lista): integer;
	begin
		if l<> nil then
			sumarValoresLista:= l^.elem.nInt + sumarValoresLista(l^.sig)
		else
			sumarValoresLista:= 0;
	end;

procedure escalarValoresLista(l: lista; esc: integer);
	begin
		while l<> nil do begin
			l^.elem.nInt:= l^.elem.nInt * esc;
			l:= l^.sig;
		end;
	end;



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


{
no recursivo
procedure invertirLista(l: lista; var lNue: lista);
	var
		n: integer;
		aux: lista;
	begin
		n:= -1;
		lNue:= nil;
		while l<> nil do begin
			crearNodo(aux,n,l^.elem.nInt);
			agregarIzquierda(lNue,aux);
			l:= l^.sig;
		end;
	end;
}
var
	l1,l2,l3: lista;
	n,m: integer;
	bc,bd: boolean;
begin
	writeln();
	while true do begin
		generarListaDerecha(l1);
		invertirLista(l1,n,l2,l3);
		imprimirListaDiagonal(l1);
		//generarListaOrdenada(l2);
		//mergeListaOrdenado(l1,l2,l3);
		imprimirListaLinea(l1);
		imprimirListaLinea(l2);
		//imprimirListaLinea(l3);
		readln(m);
		imprimirNodoLista(buscarListaDesorden(l1,m));
		writeln('termino');
		tieneOrden(l1,bc,bd);
		writeln('creciente: ',bc,'  decreciente: ',bd);
		writeln('  cantidad nodos: ',cantidadNodosLista(l1));
		ordenarListaCreciente(l1);
		imprimirListaLinea(l1);
		tieneOrden(l1,bc,bd);
		writeln('creciente: ',bc,'  decreciente: ',bd);
		//ordenarListaDecreciente(l1);
		imprimirListaLinea(l1);
		tieneOrden(l1,bc,bd);
		writeln('creciente: ',bc,'  decreciente: ',bd);
		readln(n);
		readln(m);
		//imprimirNodoLista(buscarListaDesorden(l1,n));
		eliminarNodosRangoLista(l1,n,m);
		imprimirListaLinea(l1);
		//imprimirListaLinea(l3);
		imprimirListaDiagonal(l1);
		//imprimirListaVertical(l1);
		//imprimirListaDiagonal(l2);
		//imprimirListaInverso(l1);
		readln;
	end;
end.
