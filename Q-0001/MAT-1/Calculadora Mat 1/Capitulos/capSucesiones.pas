const
	CANT_VARIABLES_ECUACION= 1;




type
	// SUCECIONES
	listaE= ^nodoE;
	nodoE= record
		elem: integer;
		sig: listaE;
	end;

	listaR= ^nodoR;
	nodoR= record
		elem: real;
		sig: listaR;
	end;

	sucesion= record
		tIni: real;
		dif: real;
		raz: real;
		tipo: char;
	end;
	
	// ECUACIONES
	termino= record
		tipo: word;
		op: char;
		valE: integer;
		valR: real;
	end;
	listaT= ^nodoT;
	nodoT= record
		elem: termino;
		ant: listaT;
		sig: listaT;
	end;

	listaC= ^nodoC;
	nodoC= record
		elem: char;
		sig: listaC;
	end;




var
	bApp: boolean;
	numVar: word;




// CONFIGURACIONES DEFAULTS
procedure presetsEcuaciones();
	begin
		numVar:= CANT_VARIABLES_ECUACION;
	end;
procedure normasCargarEcuacion();
	begin
		writeln; writeln;
		writeln('  Como ingresar ecuaciones:');
		writeln;
		writeln('  -  Numeros negativos usar (-n) siendo n el modulo del numero.');
		writeln('  -  Numeros decimales usar el . para indicar la parte decimal');
		writeln('  -  Numeros fraccionarios usar (a/b) siendo a el numerador y b el denominador');
		writeln('  -  Producto con el * , previo al simbolo un factor y luego el otro');
		writeln('  -  Division con el / , previo al simbolo el dividendo y luego el divisor');
		writeln('  -  Potencia con el ^ , previo al simbolo la base y luego el exponente');
		writeln('  -  Raiz con r , previo al simbolo el indice y luego el radicando');
		writeln('  -  Variables solo con letras');
		writeln('  -  Es muy importante utilizar PARENTESIS () para el orden operacional');
		writeln('  -  No colocar simbolos de operacion juntos, ejemplo +/');
	end;



// FUNCIONES MATEMATICAS
function pot(x: real; n: integer): real;
	var
		i: integer;
	begin
		pot:= x;
		if n>0 then
			for i:= 2 to n do
				pot:= pot*x
		else if n= 0 then
			pot:= 1
		else begin
			for i:=-2 downto n do
				pot:= pot*x;
			pot:= 1/pot;
		end;
	end;
function ln(z: real):real;
	var
		k: integer;
		aux: real;
	begin
		ln:= 0;
		aux:= (z-1)/(z+1);
		for k:=0 to 1000 do begin
			ln:= ln + 1/(2*k+1)*pot(aux,(2*k+1));
		end;
		ln:= 2*ln;
	end;
function exp(x: real): real;
	var
		n: integer;
		f: longword;
	begin
		exp:= 1;
		f:=1;
		for n:=1 to 12 do begin
			f:= f*n;
			exp:= exp+ pot(x,n)/f;
		end;
	end;
function raiz(n: real; x: real): real;
	begin
		if x> 0 then
			raiz:= exp(ln(x)/n)
		else if x= 0 then
			raiz:= 0
		else raiz:= -1;
	end;
function fact(x: word): qword;
	var
		n: integer;
	begin
		fact:= 1;
		if x<21 then
			for n:= x downto 2 do
				fact:= fact*n
	end;




// ECUACIONES
// MANEJO CARACTERES
procedure agregarUltimoCaracter(var l,ult: listaC; c: char);
	var
		nue: listaC;
	begin
		new(nue);
		nue^.elem:= c;
		nue^.sig:= nil;
		if l= nil then
			l:= nue
		else
			ult^.sig:= nue;
		ult:= nue;
	end;
procedure buscarCaracter(l: listaC; c: char; var pos: word);
	var
		i: word;
	begin
		i:= 0;
		pos:= 0;
		while (l<>nil) and (pos=0) do begin
			i:= i +1;
			if l^.elem= c then
				pos:= i;
			l:= l^.sig;
		end;
	end;
procedure eliminarListaCaracteres(var l: listaC);
	var
		aux: listaC;
	begin
		while l<>nil do begin
			aux:= l;
			l:= l^.sig;
			dispose(aux);
		end;
	end;

procedure eliminarCaracterString(var s: string; pos: word; var dl: word);
	var
		i: word;
	begin
		dl:= dl-1;
		for i:= pos to dl do
			s[i]:= s[i+1];
	end;


function esNumero(c: char): boolean;
	begin
		esNumero:= (c>= '0') and (c<= '9') or (c= '.') or (c= ',');
	end;
function esOperacion(c: char): boolean;
	begin
		esOperacion:= (c= '+') or (c= '-') or (c= '*') or (c= '/') or (c= '=') or (c= '^') or (c= 'r');
	end;
function esOrden(c: char): boolean;
	begin
		esOrden:= (c= '(') or (c= ')');
	end;
function esVariable(c: char): boolean;
	begin
		esVariable:= (c>= 'A') and (c<= 'Z') or (c>= 'a') and (c<= 'z');
	end;

function esEcuacion(ecuacion: string): boolean;
	var
		i: word;
	begin
		i:=1;
		esEcuacion:= true;
		while (i<= length(ecuacion)) and esEcuacion do begin
			esEcuacion:=  esNumero(ecuacion[i]) or (ecuacion[i]= ' ') or esOperacion(ecuacion[i]) or esVariable(ecuacion[i]) or  esOrden(ecuacion[i]);
			i:= i +1;
		end;
	end;

function esAritmetica(ecuacion: string): boolean;
	var
		nParA,nParC,nIgua: integer;
		i: word;
	begin
		i:=1;
		nParA:= 0;
		nParC:= 0;
		nIgua:= 0;
		while i<= length(ecuacion) do begin
			case ecuacion[i] of
				'(': nParA:= nParA +1;
				')': nParC:= nParC +1;
				'=': nIgua:= nIgua +1;
			end;
			i:= i +1;
		end;
		esAritmetica:= (nParA= nParC) and (nIgua<=1);
	end;

procedure leerEcuacionString(frase: string; var sLeida: string);
	var
		ok: boolean;
	begin
		repeat
			normasCargarEcuacion();
			writeln;
			write(frase);readln(sLeida);
			ok:= esEcuacion(sLeida);
			if ok then
				ok:= esAritmetica(sLeida);
			if not ok then begin
				writeln('  Verifique que la ecuacion esta escrita correctamente, intente nuevamente');
				write('  '); readln;
			end;
		until ok;
	end;
procedure ecuacionStringALista(sLeida: string; var lEcu,lVar: listaC; var ok: boolean);
	var
		dl,i,pos,cVar: word;
		lUltE,lUltV: listaC;
	begin
		lEcu:= nil;
		lVar:= nil;
		cVar:= 0;
		dl:= length(sLeida);
		i:= 1;
		ok:= true;
		while (i<=dl) and ok do begin
			if sLeida[i]= ' ' then
				eliminarCaracterString(sLeida,i,dl)
			else begin
				if sLeida[i]= ',' then
					sLeida[i]:= '.'
				else if (sLeida[i]>= 'A') and (sLeida[i]<= 'Z') then
					sLeida[i]:= chr(ord(sLeida[i])+32);
				if (sLeida[i]>= 'a') and (sLeida[i]<= 'z') then begin
					buscarCaracter(lVar,sLeida[i],pos);
					if pos= 0 then begin
						agregarUltimoCaracter(lVar,lUltV,sLeida[i]);
						cVar:= cVar +1;
					end;
					ok:= cVar<= numVar;
				end;
				if ok then
					agregarUltimoCaracter(lEcu,lUltE,sLeida[i]);
				i:= i +1;
			end;
		end;
	end;

procedure leerEcuacionLista(frase: string; var lEcu,lVar: listaC);
	var
		ok: boolean;
		sLeida: string;
	begin
		repeat
			leerEcuacionString(frase,sLeida);
			ecuacionStringALista(sLeida,lEcu,lVar,ok);
			if not ok then begin
				writeln('  No utilice mas variables de las que corresponden, intente nuevamente');
				write('  '); readln;
				eliminarListaCaracteres(lEcu);
				eliminarListaCaracteres(lVar);
			end;
		until ok;
	end;

// TERMINOS
procedure agregarUltimoTermino(var l,ult: listaT; t: termino);
	var
		nue: listaT;
	begin
		new(nue);
		nue^.elem:= t;
		nue^.sig:= nil;
		if l= nil then begin
			l:= nue;
			l^.ant:= nil;
		end
		else begin
			ult^.sig:= nue;
			nue^.ant:= ult;
		end;
		ult:= nue;
	end;
procedure agregarUltimoTerminoManual(var l,ult: listaT; tipo,valE: integer; valR: real; op: char);
	var
		nue: listaT;
	begin
		new(nue);
		nue^.elem.tipo:= tipo;
		nue^.elem.valE:= valE;
		nue^.elem.valR:= valR;
		nue^.elem.op:= op;
		nue^.sig:= nil;
		if l= nil then begin
			l:= nue;
			l^.ant:= nil;
		end
		else begin
			ult^.sig:= nue;
			nue^.ant:= ult;
		end;
		ult:= nue;
	end;

procedure copiarEcuacion(l: listaT; var lCop: listaT);
	var
		ult: listaT;
	begin
		lCop:= nil;
		while l<> nil do begin
			agregarUltimoTermino(lCop,ult,l^.elem);
			l:= l^.sig;
		end;
	end;

procedure eliminarTermino(var term: listaT);
	begin
		if term<> nil then begin
			if term^.ant<> nil then
				term^.ant^.sig:= nil;
			if term^.sig<> nil then
				term^.sig^.ant:= nil;
			dispose(term);
		end;
	end;
procedure eliminarListaTerminos(var l: listaT);
	var
		aux: listaT;
	begin
		while l<> nil do begin
			aux:= l;
			l:= l^.sig;
			dispose(aux);
		end;
	end;
procedure eliminarTerminosOperacion(var term1,term2: listaT);
	var
		aux: listaT;
	begin
		aux:= term1^.sig;
		term1^.sig:= term2^.sig;
		if term2^.sig<> nil then
			term2^.sig^.ant:= term1;
		dispose(aux);
		dispose(term2);
	end;
	
procedure hacerNumero(sNum: string; var int: boolean; var numE: integer; var numR: real);
	var
		code: word;
	begin
		val(sNum,numE,code);
		int:= code=0;
		if not int then
			val(sNum,numR,code);
	end;

procedure procesarEcuacionLista(lC: listaC; var lT: listaT);
	var
		sNum: string;
		ult: listaT;
		int: boolean;
		numE: integer;
		numR: real;
	begin
		lT:= nil;
		while lc<> nil do begin
			sNum:= '';
			while (lC<> nil) and esNumero(lC^.elem) do begin
				sNum:= sNum + lC^.elem;
				lC:= lC^.sig;
			end;
			if sNum<> '' then begin
				hacerNumero(sNum,int,numE,numR);
				if int then
					agregarUltimoTerminoManual(lt,ult,1,numE,0,' ')
				else
					agregarUltimoTerminoManual(lt,ult,2,0,numR,' ');
			end
			else
				if lC<> nil then begin
					agregarUltimoTerminoManual(lt,ult,0,0,0,lC^.elem);
					lC:= lC^.sig;
				end;
		end;
	end;

// OPERACIONES ARITMETICAS
procedure resolverMedioTermino(var term1,term2: listaT);
	begin
		if term1^.elem.op = '-' then begin
			if term2^.elem.tipo= 1 then
				term2^.elem.valE:= - term2^.elem.valE
			else
				term2^.elem.valR:= - term2^.elem.valR;
		end;
		term1^.elem:= term2^.elem;
		term1^.sig:= term2^.sig;
		if term1^.sig<> nil then
			term1^.sig^.ant:= term1;
		dispose(term2);
	end;

procedure sumarTerminos(var term1,term2: listaT);
	begin
		if (term1^.elem.tipo= 1) and (term2^.elem.tipo= 1) then
			term1^.elem.valE:= term1^.elem.valE + term2^.elem.valE
		else begin
			term1^.elem.tipo:= 2;
			term1^.elem.valR:= term1^.elem.valE + term2^.elem.valE + term1^.elem.valR + term2^.elem.valR;
			term1^.elem.valE:= 0;
		end;
		eliminarTerminosOperacion(term1,term2);
	end;
procedure restarTerminos(var term1,term2: listaT);
	begin
		if (term1^.elem.tipo= 1) and (term2^.elem.tipo= 1) then
			term1^.elem.valE:= term1^.elem.valE - term2^.elem.valE
		else begin
			term1^.elem.tipo:= 2;
			term1^.elem.valR:= term1^.elem.valE - term2^.elem.valE + term1^.elem.valR - term2^.elem.valR;
			term1^.elem.valE:= 0;
		end;
		eliminarTerminosOperacion(term1,term2);
	end;
procedure productoTerminos(var term1,term2: listaT);
	begin
		if (term1^.elem.tipo= 1) then begin
			if (term2^.elem.tipo= 1) then
				term1^.elem.valE:= term1^.elem.valE * term2^.elem.valE
			else begin
				term1^.elem.tipo:= 2;
				term1^.elem.valR:= term1^.elem.valE * term2^.elem.valR;
				term1^.elem.valE:= 0;
			end
		end
		else if (term2^.elem.tipo= 1) then
				term1^.elem.valR:= term1^.elem.valR * term2^.elem.valE
			else
				term1^.elem.valR:= term1^.elem.valR * term2^.elem.valR;
		eliminarTerminosOperacion(term1,term2);
	end;
procedure divisionTerminos(var term1,term2: listaT);
	begin
		if (term1^.elem.tipo= 1) then begin
			term1^.elem.tipo:= 2;
			if (term2^.elem.tipo= 1) then
				term1^.elem.valR:= term1^.elem.valE / term2^.elem.valE
			else
				term1^.elem.valR:= term1^.elem.valE / term2^.elem.valR;
			term1^.elem.valE:= 0;
		end
		else if (term2^.elem.tipo= 1) then
				term1^.elem.valR:= term1^.elem.valR / term2^.elem.valE
			else
				term1^.elem.valR:= term1^.elem.valR / term2^.elem.valR;
		eliminarTerminosOperacion(term1,term2);
	end;
procedure potenciaTerminos(var term1,term2: listaT);
	begin
		if (term1^.elem.tipo= 1) then begin
			term1^.elem.tipo:= 2;
			term1^.elem.valR:= pot(term1^.elem.valE,term2^.elem.valE);
			term1^.elem.valE:= 0;
		end
		else
			term1^.elem.valR:= pot(term1^.elem.valR,term2^.elem.valE);
		eliminarTerminosOperacion(term1,term2);
	end;
procedure raizTerminos(var term1,term2: listaT);
	begin
		if (term1^.elem.tipo= 1) then begin
			term1^.elem.tipo:= 2;
			term1^.elem.valR:= raiz(term1^.elem.valE,term2^.elem.valE + term2^.elem.valR);
			term1^.elem.valE:= 0;
		end
		else
			term1^.elem.valR:= raiz(term1^.elem.valR,term2^.elem.valE + term2^.elem.valR);
		eliminarTerminosOperacion(term1,term2);
	end;

procedure resolverOperacion(op: char; var term1,term2: listaT);
	begin
		case op of
			'+':	sumarTerminos(term1,term2);
			'-':	restarTerminos(term1,term2);
			'*':	productoTerminos(term1,term2);
			'/':	divisionTerminos(term1,term2);
			'^':	potenciaTerminos(term1,term2);
			'r':	raizTerminos(term1,term2);
		end;
	end;


procedure resolverEcuacion(lT: listaT);
	var
		aux: listaT;
		nOp1,nOp2,nOp3: integer;
	begin
		aux:= lT;
		nOp1:= 0;
		nOp2:= 0;
		nOp3:= 0;
		while aux<> nil do begin
			if aux^.elem.tipo= 0 then
				case aux^.elem.op of
					'^':	nOp3:= nOp3 +1;
					'r':	nOp3:= nOp3 +1;
					'*':	nOp2:= nOp2 +1;
					'/':	nOp2:= nOp2 +1;
					else
						nOp1:= nOp1 +1;
				end;
			aux:= aux^.sig;
		end;
		while nOp3> 0 do begin
			aux:= lT;
			while (aux<> nil) and (aux^.elem.op<> '^') and (aux^.elem.op<> 'r') do
				aux:= aux^.sig;
			if (aux^.elem.op= '^') or (aux^.elem.op= 'r') then begin
				nOp3:= nOp3 -1;
				resolverOperacion(aux^.elem.op,aux^.ant,aux^.sig);
			end;
		end;
		while nOp2> 0 do begin
			aux:= lT;
			while (aux<> nil) and (aux^.elem.op<> '*') and (aux^.elem.op<> '/') do
				aux:= aux^.sig;
			if (aux^.elem.op= '*') or (aux^.elem.op= '/') then begin
				nOp2:= nOp2 -1;
				resolverOperacion(aux^.elem.op,aux^.ant,aux^.sig);
			end;
		end;
		while nOp1> 0 do begin
			aux:= lT;
			while (aux<> nil) and (aux^.elem.op<> '+') and (aux^.elem.op<> '-') do begin
				aux:= aux^.sig;
			end;
			if (aux^.ant<> nil) and (aux^.ant^.elem.tipo>0) then begin
				if (aux^.elem.op= '+') or (aux^.elem.op= '-') then begin
					resolverOperacion(aux^.elem.op,aux^.ant,aux^.sig);
				end;
			end
			else
				resolverMedioTermino(aux,aux^.sig);
			nOp1:= nOp1 -1;
		end;
	end;


procedure resolverParentesis(var lT: listaT);
	var
		lA,lPar,lParUlt,lAnt: listaT;
		nP,i: integer;
	begin
		nP:= 0;
		lA:=lT;
		while lA<> nil do begin
			if lA^.elem.op= '(' then
				nP:= nP +1;
			lA:= lA^.sig;
		end;
		while nP> 0 do begin
			lA:= lT;
			i:= 0;
			if lA^.elem.op= '(' then
				i:= 1;
			while i<nP do begin
				lA:= lA^.sig;
				if lA^.elem.op= '(' then
					i:= i +1;
			end;
			lAnt:= lA^.ant;
			lPar:= nil;
			lA:= lA^.sig;
			eliminarTermino(lA^.ant);
			while lA^.elem.op<> ')' do begin
				agregarUltimoTermino(lPar,lParUlt,lA^.elem);
				lA:= lA^.sig;
				eliminarTermino(lA^.ant);
			end;
			resolverEcuacion(lPar);
			lPar^.sig:= lA^.sig;
			eliminarTermino(lA);
			if lPar^.sig<> nil then
				lPar^.sig^.ant:= lPar;
			if lAnt<> nil then begin
				lAnt^.sig:= lPar;
			end
			else
				lT:= lPar;
			lPar^.ant:= lAnt;
			nP:= nP -1;
		end;
		resolverEcuacion(lT);
	end;


procedure copiarYReemplazarEcuacion(l: listaT; tipo: word; op: char; valE: integer; valR: real; var lCop: listaT);
	var
		lUlt: listaT;
	begin
		lCop:= nil;
		while l<> nil do begin
			if l^.elem.op= op then
				agregarUltimoTerminoManual(lCop,lUlt,tipo,valE,valR,' ')
			else
				agregarUltimoTermino(lCop,lUlt,l^.elem);
			l:= l^.sig;
		end;
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

procedure leerNatural(frase: string; var n: word);
	var
		code: word;
		rString: string;
	begin
		repeat
			write(frase); readln(rString);
			val(rString,n,code);
			if code<> 0 then begin
				writeln('  Solo numeros naturales, intente nuevamente');
				write('  '); readln;
			end;
		until code=0;
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
procedure leerReal(frase: string; var r: real);
	var
		code: word;
		rString: string;
	begin
		repeat
			write(frase); readln(rString);
			val(rString,r,code);
			if code<> 0 then begin
				writeln('  Solo numeros reales, utilice el . en vez de ,');
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
procedure leerRangoSumatoria(var ini,fin: integer);
	begin
		writeln('  Ingrese el rango de la sumatoria a calcular');
		repeat
			writeln;
			leerRangoEntero('    Sumatoria inicia en: ','    Sumatoria termina en: ',ini,fin);
		until ini> 0;
	end;


procedure agregarUltimoEntero(var l,ult: listaE; e: word);
	var
		nue: listaE;
	begin
		new(nue);
		nue^.elem:= e;
		nue^.sig:= nil;
		if l= nil then
			l:= nue
		else
			ult^.sig:= nue;
		ult:= nue;
	end;
procedure agregarUltimoReal(var l,ult: listaR; r: real);
	var
		nue: listaR;
	begin
		new(nue);
		nue^.elem:= r;
		nue^.sig:= nil;
		if l= nil then
			l:= nue
		else
			ult^.sig:= nue;
		ult:= nue;
	end;

procedure leerSucecionEnteros(frase: string; var l: listaE);
	var
		ok: boolean;
		e,code: word;
		rString: string;
		ult: listaE;
	begin
		l:= nil;
		ok:= false;
		writeln('  N para dejar de ingresar datos');
		writeln;
		repeat
			write(frase);readln(rString);
			val(rString,e,code);
			if code= 0 then
				agregarUltimoEntero(l,ult,e)
			else
				if (rString[code]= 'N') or (rString[code]= 'n') then
					ok:= true
				else begin
					writeln('  Solo numeros naturales, intente nuevamente');
					write('  '); readln;
				end;
		until ok;
	end;




procedure elegirTipoSucesion(var tipo: char);
	begin
		writeln('  A continuacion con que tipo de sucesion quiere trabajar');
		writeln;
		writeln('    A -  Aritmetica');
		writeln('    B -  Geometrica');
		leerOpcion('A','B',tipo);
	end;
procedure leerAritmetica(var s: sucesion);
	var
		ok: boolean;
		modo: char;
		aux,t1,t2: real;
		i,pos1,pos2: word;
	begin
		writeln;
		writeln('  Recuerde: el primer termino de una sucesion se encuentra en la posicion 1');
		writeln('  de alli en adelante');
		writeln('  Cuales son los datos de entrada');
		writeln;
		writeln('    A -  Valor termino inicial y diferencia');
		writeln('    B -  Valor termino cualquiera,su posicion en la sucesion y diferencia');
		writeln('    C -  Valor de dos terminos de la sucesion y su posicion en la sucesion');
		leerOpcion('A','C',modo);
		writeln;
		case modo of
			'A':	begin
						leerReal('  Valor termino incial: ',s.tIni);
						leerReal('  Diferencia: ',s.dif);
					end;
			'B':	begin
						leerReal('  Valor termino cualquiera: ',t1);
						leerNatural('  Posicion: ',pos1);
						leerReal('  Diferencia: ',s.dif);
						for i:= pos1 downto 2 do begin
							t1:= t1 - s.dif;
						end;
						s.tIni:= t1;
					end;
			'C':	begin
						repeat
							leerReal('  Valor termino 1: ',t1);
							leerNatural('  Posicion: ',pos1);
							leerReal('  Valor termino 2: ',t2);
							leerNatural('  Posicion: ',pos2);
							ok := (pos1<> pos2) and (t1<> t2);
							if not ok then begin
								writeln('  Verifique que los terminos son distintos');
								write('  ');readln;
							end;
						until ok;
						if pos1> pos2 then begin
							i:= pos2;
							pos2:= pos1;
							pos1:= i;
							aux:= t2;
							t2:= t1;
							t1:= aux;
						end;
						s.dif:= (t1- t2)/(-pos2 + pos1);
						s.tIni:= t2 - (pos2-1)*s.dif;
					end;
		end;
	end;
procedure leerGeometrica(var s: sucesion);
	var
		ok: boolean;
		modo: char;
		aux,t1,t2: real;
		i,pos1,pos2: word;
	begin
		writeln;
		writeln('  Recuerde: el primer termino de una sucesion se encuentra en la posicion 1');
		writeln('  de alli en adelante');
		writeln('  Cuales son los datos de entrada');
		writeln;
		writeln('    A -  Valor termino inicial y razon de cambio');
		writeln('    B -  Valor termino cualquiera,su posicion en la sucesion y razon de cambio');
		writeln('    C -  Valor de dos terminos de la sucesion y su posicion en la sucesion');
		leerOpcion('A','C',modo);
		writeln;
		case modo of
			'A':	begin
						leerReal('  Valor termino incial: ',s.tIni);
						leerReal('  Razon de cambio: ',s.raz);
					end;
			'B':	begin
						leerReal('  Valor termino cualquiera: ',t1);
						leerNatural('  Posicion: ',pos1);
						leerReal('  Razon de cambio: ',s.raz);
						for i:= pos1 downto 2 do begin
							t1:= t1/s.raz;
						end;
						s.tIni:= t1;
					end;
			'C':	begin
						repeat
							leerReal('  Valor termino 1: ',t1);
							leerNatural('  Posicion: ',pos1);
							leerReal('  Valor termino 2: ',t2);
							leerNatural('  Posicion: ',pos2);
							ok := (pos1<> pos2) and (t1<> t2);
							if not ok then begin
								writeln('  Verifique que los terminos son distintos');
								write('  ');readln;
							end;
						until ok;
						if pos1> pos2 then begin
							i:= pos2;
							pos2:= pos1;
							pos1:= i;
							aux:= t2;
							t2:= t1;
							t1:= aux;
						end;
						s.raz:= raiz((pos2-pos1),t2/t1);
						s.tIni:= t1/pot(s.raz,(pos1-1));
					end;
		end;
	end;

procedure imprimirFormulasSucesion(s: sucesion);
	begin
		writeln('  Las formulas son: ');
		if s.tipo= 'A' then begin
			writeln('    Recursiva: a_1 = ',s.tIni:0:2);
			writeln('               a_n = a_(n - 1) + ',s.dif:0:2,'  si n>= 2');
			writeln;
			writeln('    Explicita: a_n = ',s.tIni:0:2,' + (n - 1)',s.dif:0:2,'  si n>= 1');
		end
		else begin
			writeln('    Recursiva: a_1 = ',s.tIni:0:2);
			writeln('               a_n = a_(n - 1)*',s.raz:0:2,'  si n>= 2');
			writeln;
			writeln('    Explicita: a_n = ',s.tIni:0:2,'*',s.raz:0:2,'^(n - 1)  si n>= 1');
		end;
	end;

procedure menuSucesion();
	var
		opc: char;
		s: sucesion;
		lPos: listaE;
		rInf,rSup: integer;
	begin
		saltosLinea30();
		elegirTipoSucesion(s.tipo);
		saltosLinea30();
		if s.tipo= 'A' then
			writeln('  MENU SUCESION ARITMETICA')
		else
			writeln('  MENU SUCESION GEOMETRICA');
		writeln;
		writeln('  Ingrese la letra de la herramienta requerida');
		writeln;
		writeln('    A -  Hayar formulas');
		writeln('    B -  Calcular termino/s');
		writeln;
		writeln('    C -  Volver al Menu Sucesiones e Induccion');
		leerOpcion('A','C',opc);
		if opc<> 'C' then begin
			if s.tipo= 'A' then
				leerAritmetica(s)
			else
				leerGeometrica(s);
			writeln;
			if opc= 'A' then
				imprimirFormulasSucesion(s)
			else begin
				writeln('  A -  Posicion/es especifica/s a calcular');
				writeln('  B -  Rango de posiciones a calcular');
				leerOpcion('A','B',opc);
				if opc= 'A' then begin
					writeln;
					leerSucecionEnteros('  Calcular posicion: ',lPos);
					writeln;
					writeln('  Los terminos son:');
					if s.tipo= 'A' then
						while lPos<> nil do begin
							writeln('    a_',lPos^.elem,': ', (s.tIni + (lPos^.elem -1)*s.dif):0:2);
							lPos:= lPos^.sig;
						end
					else
						while lPos<> nil do begin
							writeln('    a_',lPos^.elem,': ', (s.tIni*pot(s.raz,lPos^.elem-1)):0:2);
							lPos:= lPos^.sig;
						end
				end
				else begin
					repeat
						writeln;
						writeln('  Ingrese el rango de posiciones a calcular');
						writeln;
						leerRangoEntero('    Extremo inferior incluido: ','    Extremo inferior incluido: ',rInf,rSup);
						if rInf< 1 then
							writeln('  Recuerde que las sucesiones empiezan al menos en la posicon 1');
					until rInf> 0;
					writeln;
					writeln('  Valores del rango dado');
					if rInf= 1 then begin
						writeln('    a_1 = ',s.tIni:0:2);
						rInf:= 2;
					end;
					if s.tipo= 'A' then
						for rInf:= rInf to rSup do
							writeln('    a_',rInf,' = ', (s.tIni + (rInf -1)*s.dif):0:2)
					else
						for rInf:= rInf to rSup do
							writeln('    a_',rInf,' = ', (s.tIni*pot(s.raz,rInf-1)):0:2);
				end;
			end;
			writeln;
			enterContinuar();
		end;
	end;

procedure sumarSucesion(modo: char; s: sucesion; var total: real);
	var
		n,k: integer;
		ope: integer;
		opc: char;
	begin
		total:= 0;
		if modo= 'A' then begin
			leerRangoSumatoria(n,k);
			if s.tipo= 'A' then
				total:= ((k-n+1)*((s.tIni+(n-1)*s.dif)+(s.tIni+(k-1)*s.dif)))/2
			else
				total:= ((s.tIni*pot(s.raz,n-1))*(1-pot(s.raz,k)))/(1-s.raz);
		end
		else
			repeat
				ope:= 1;
				writeln;
				leerRangoSumatoria(n,k);
				if s.tipo= 'A' then
					total:= total + ope*((k-n+1)*((s.tIni+(n-1)*s.dif)+(s.tIni+(k-1)*s.dif)))/2
				else
					total:= total + ope*((s.tIni*pot(s.raz,n-1))*(1-pot(s.raz,k)))/(1-s.raz);
				writeln;
				writeln('  Ingrese como proseguir');
				writeln;
				writeln('    A -  Sumar otra sumatoria');
				writeln('    B -  Restar otra sumatoria');
				writeln('    C -  Finalizar la suma de sumatorias;');
				leerOpcion('A','C',opc);
				if (opc= 'A') or (opc= 'B') then begin
					if opc= 'A' then
						ope:= 1
					else
						ope:= -1;
					writeln;
					writeln('  Eleccion de sucesion');
					writeln;
					writeln('    A -  Mantener sucesion actual');
					writeln('    B -  Nueva sucesion');
					leerOpcion('A','B',opc);
					if opc= 'B' then begin
						elegirTipoSucesion(opc);
						if opc= 'A' then
							leerAritmetica(s)
						else
							leerGeometrica(s);
					end;
				end;  
			until opc= 'C';
	end;


procedure sumarEcuacion(modo: char; lT: listaT; lVar: listaC; var total: real);
	var
		n,k: integer;
		ope: integer;
		opc: char;
		lEcu: listaC;
		lCop: listaT;
	begin
		total:= 0;
		if modo= 'A' then begin
			leerRangoSumatoria(n,k);
			for n:= n to k do begin
				copiarYReemplazarEcuacion(lT,1,lVar^.elem,n,0,lCop);
				resolverParentesis(lCop);
				total:= total + lCop^.elem.valE + lCop^.elem.valR;
				dispose(lCop);
			end;
		end
		else
			repeat
				ope:= 1;
				writeln;
				leerRangoSumatoria(n,k);
				for n:= n to k do begin
					copiarYReemplazarEcuacion(lT,1,lVar^.elem,n,0,lCop);
					resolverParentesis(lCop);
					total:= total + ope*(lCop^.elem.valE + lCop^.elem.valR);
					dispose(lCop);
				end;
				writeln;
				writeln('  Ingrese como proseguir');
				writeln;
				writeln('    A -  Sumar otra sumatoria');
				writeln('    B -  Restar otra sumatoria');
				writeln('    C -  Finalizar la suma de sumatorias;');
				leerOpcion('A','C',opc);
				if (opc= 'A') or (opc= 'B') then begin
					if opc= 'A' then
						ope:= 1
					else
						ope:= -1;
					writeln;
					writeln('  Eleccion de ecuacion');
					writeln;
					writeln('    A -  Mantener ecuacion actual');
					writeln('    B -  Nueva ecuacion');
					leerOpcion('A','B',opc);
					if opc= 'B' then begin
						eliminarListaTerminos(lT);
						dispose(lVar);
						leerEcuacionLista('  Ecuacion a sumar: ',lEcu,lVar);
						procesarEcuacionLista(lEcu,lT);
					end;
				end;
			until opc= 'C';
		eliminarListaTerminos(lT);
		dispose(lVar);
	end;
procedure menuSumatoria();
	var
		modo,opc: char;
		s: sucesion;
		lEcu,lVar: listaC;
		lT: listaT;
		sTotal: real;
	begin
		saltosLinea30();
		writeln('  MENU SUMATORIA');
		writeln;
		writeln('  Ingrese la letra de la herramienta requerida');
		writeln;
		writeln('    A -  Sumatoria unica');
		writeln('    B -  Suma de Sumatorias');
		writeln;
		writeln('    C -  Volver al Menu Sucesiones e Induccion');
		leerOpcion('A','C',modo);
		if modo<> 'C' then begin
			writeln;
			writeln('  Que quiere sumar');
			writeln;
			writeln('    A -  Ecuacion');
			writeln('    B -  Sucecion aritmetica - geometrica');
			leerOpcion('A','B',opc);
			if opc= 'A' then begin
				writeln;
				leerEcuacionLista('  Ecuacion a sumar: ',lEcu,lVar);
				procesarEcuacionLista(lEcu,lT);
				sumarEcuacion(modo,lT,lVar,sTotal);
			end
			else begin
				elegirTipoSucesion(s.tipo);
				if s.tipo= 'A' then
					leerAritmetica(s)
				else
					leerGeometrica(s);
				sumarSucesion(modo,s,sTotal);
			end;
			writeln;
			writeln('  El resultado de la sumatoria es: ',sTotal:0:2);
			enterContinuar();
		end;
	end;

procedure capSucesiones();
	var
		bTema: boolean;
		opc: char;
	begin
		presetsEcuaciones();
		bTema:= true;
		while bApp and bTema do begin
			saltosLinea30();
			writeln('  MENU SUCESIONES E INDUCCION');
			writeln;
			writeln('  Para efectos del programa sucesion y progresion significan lo mismo');
			writeln('  Ingrese la letra del tema');
			writeln;
			writeln('    A -  Sucesion');
			writeln('    B -  Sumatoria');
			writeln;
			writeln('    C -  Volver al Menu Capitulos');
			writeln('    D -  Cerrar Aplicacion');
			leerOpcion('A','D',opc);
			case opc of
				'A':	menuSucesion();
				'B':	menuSumatoria();
				'C':	bTema:= false;
				'D':	bApp:= false;
			end;
		end;
	end;




// PROGRAMA PRINCIPAL
begin
	bApp:= true;
	while bApp do begin
		capSucesiones();
		write('Se supone que ahora irias al menu de capitulos pero f'); readln;
	end;
end.
