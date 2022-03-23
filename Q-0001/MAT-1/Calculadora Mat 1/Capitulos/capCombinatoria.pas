const
	constante= 'constante';




type
	listaE= ^nodoE;
	nodoE= record
		elem: integer;
		sig: listaE;
	end;

	listaC= ^nodoC;
	nodoC= record
		elem: char;
		sig: listaC;
	end;




var
	bApp: boolean;



// FUNCIONES MATEMATICAS
function fact(x: word): qword;
	var
		n: integer;
	begin
		fact:= 1;
		if x<21 then
			for n:= x downto 2 do
				fact:= fact*n
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




// ENTEROS
procedure sumarEnteros(l: listaE; var total: word);
	begin
		total:= 0;
		while l<> nil do begin
			total:= total + l^.elem;
			l:= l^.sig;
		end;
	end;

procedure multiplicarEnteros(l: listaE; var total: word);
	begin
		total:= 1;
		while l<> nil do begin
			total:= total * l^.elem;
			l:= l^.sig;
		end;
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
					writeln('  Solo numeros enteros, intente nuevamente');
					write('  '); readln;
				end;
		until ok;
	end;

// CARACTERES
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

procedure eliminarCaracterString(var s: string; pos: word; var dl: word);
	var
		i: word;
	begin
		dl:= dl-1;
		for i:= pos to dl do
			s[i]:= s[i+1];
	end;

procedure leerSucecionCarac(frase: string; var l: listaC);
	var
		dl,i: word;
		rString: string;
		ult: listaC;
	begin
		l:= nil;
		write(frase);readln(rString);
		dl:= length(rString);
		i:= 1;
		while i<=dl do begin
			if rString[i]= ' ' then
				eliminarCaracterString(rString,i,dl)
			else begin
				agregarUltimoCaracter(l,ult,rString[i]);
				i:= i +1;
			end;
		end;
	end;

procedure procesarSucecionCarac(l: listaC; var cantCarac: word; var lCaracDist: listaC; var lCantCarac: listaE);
	var
		lCDU: listaC;
		lCCAux,lCCU: listaE;
		cantD,pos,i: word;
	begin
		cantCarac:= 0;
		cantD:= 0;
		lCaracDist:= nil;
		lCantCarac:= nil;
		while l<> nil do begin
			cantCarac:= cantCarac +1;
			buscarCaracter(lCaracDist,l^.elem,pos);
			if pos<> 0 then begin
				lCCAux:= lCantCarac;
				for i:= 2 to pos do
					lCCAux:= lCCAux^.sig;
				lCCAux^.elem:= lCCAux^.elem +1;
			end
			else begin
				cantD:= cantD +1;
				agregarUltimoCaracter(lCaracDist,lCDU,l^.elem);
				agregarUltimoEntero(lCantCarac,lCCU,1);
			end;
			l:= l^.sig;
		end;
	end;




// APARTADOS
procedure princMultiplicacion();
	var
		total: word;
		l: listaE;
	begin
		leerSucecionEnteros('  Varaciones por elemento: ',l);
		multiplicarEnteros(l,total);
		write('  Para los pasos: ');
		while l<> nil do begin
			write(l^.elem,' ');
			l:= l^.sig;
		end;
		writeln(' hay un total de ',total,' combinaciones');
		writeln;
		enterContinuar();
	end;

procedure princSuma();
	var
		ok: boolean;
		subTotal: word;
		l,lSubTotales,ult: listaE;
	begin
		lSubTotales:= nil;
		writeln('  Sumatoria de casos distintos');
		repeat
			leerSucecionEnteros('  Varaciones por elemento: ',l);
			multiplicarEnteros(l,subTotal);
			agregarUltimoEntero(lSubTotales,ult,subTotal);
			writeln('  Quiere ingresar otro caso distinto?');
			leerSiNo(ok);
		until not ok;
		sumarEnteros(lSubTotales,subTotal);
		write('  Para los casos distintos: ');
		while lSubTotales<> nil do begin
			write(lSubTotales^.elem,' ');
			if lSubTotales^.sig<> nil then
				write('+ ');
			lSubTotales:= lSubTotales^.sig;
		end;
		writeln(' hay un total de ',subTotal,' combinaciones');
		writeln;
		enterContinuar();
	end;

procedure perCantidades();
	var
		cantElem,cantIguales: word;
		lCantIguales: listaE;
		pIndistinguibles,divisor: qword;
	begin
		repeat
			saltosLinea30();
			leerNatural('  Cantidad total de elementos a permutar: ',cantElem);
			writeln;
			leerSucecionEnteros('  Cantidad elementos por tipo: ',lCantIguales);
			sumarEnteros(lCantIguales,cantIguales);
			if cantElem<> cantIguales then begin
				writeln('  Recuerde que la suma de los distintos elementos por tipo');
				writeln('  tiene que ser igual a la cantidad total de elementos');
				writeln('  Presione Enter para volver a intentar');
				readln;
			end;
		until cantElem= cantIguales;
		pIndistinguibles:= fact(cantElem);
		divisor:= 1;
		while lCantIguales <> nil do begin
			divisor:= divisor * fact(lCantIguales^.elem);
			lCantIguales:= lCantIguales^.sig;
		end;
		saltosLinea30();
		writeln;
		writeln('    Permutaciones indistinguibles: ',pIndistinguibles);
		writeln('    Permutaciones distinguibles: ',pIndistinguibles div divisor);
		writeln;
		enterContinuar();
	end;

procedure perCaracteres();
	var
		lCarac,lCaracDist: listaC;
		lCantCarac: listaE;
		pIndistinguibles,divisor: qword;
		cantCarac: word;
	begin
		leerSucecionCarac('  Caracteres a permutar: ',lCarac);
		procesarSucecionCarac(lCarac,cantCarac,lCaracDist,lCantCarac);
		pIndistinguibles:= fact(cantCarac);
		divisor:= 1;
		while lCantCarac <> nil do begin
			divisor:= divisor * fact(lCantCarac^.elem);
			lCantCarac:= lCantCarac^.sig;
		end;
		saltosLinea30();
		write('  Caracteres de entrada: ');
		while lCarac<> nil do begin
			write(lCarac^.elem);
			lCarac:= lCarac^.sig;
		end;
		writeln;
		writeln;
		writeln('    Permutaciones indistinguibles: ',pIndistinguibles);
		writeln('    Permutaciones distinguibles: ',pIndistinguibles div divisor);
		writeln;
		enterContinuar();
	end;

procedure perCaracSubcadena();
	var
		ordenados: boolean;
		lCarac,lCaracDist,lCaracGrupo,lCaracDistGrupo: listaC;
		lAux,lAuxGrupo,lCantCarac,lCantCaracGrupo: listaE;
		cantCarac,cantGrupo: word;
		pIndistinguibles, pIndisGrupo, divisor, divisorGrupo: qword;
	begin
		leerSucecionCarac('  Caracteres a permutar: ',lCarac);
		leerSucecionCarac('  Grupo de caracteres: ',lCaracGrupo);
		writeln('  Es importante el orden de los caracteres del grupo?');
		leerSiNo(ordenados);
		
		procesarSucecionCarac(lCarac,cantCarac,lCaracDist,lCantCarac);
		procesarSucecionCarac(lCaracGrupo,cantGrupo,lCaracDistGrupo,lCantCaracGrupo);
		
		pIndistinguibles:= fact(cantCarac);
		lAux:= lCantCarac;
		divisor:= 1;
		while lAux <> nil do begin
			divisor:= divisor * fact(lAux^.elem);
			lAux:= lAux^.sig;
		end;
		writeln;
		writeln('    Permutaciones indistinguibles totales: ',pIndistinguibles);
		writeln('    Permutaciones distinguibles totales : ',pIndistinguibles div divisor);
		
		lAux:= lCantCarac;
		lAuxGrupo:= lCantCaracGrupo;
		while (lCaracDist<> nil) and (lCaracDistGrupo<> nil) do begin
			if lCaracDist^.elem= lCaracDistGrupo^.elem then begin
				lCantCarac^.elem:= lCantCarac^.elem - lCantCaracGrupo^.elem;
				lCantCaracGrupo:= lCantCaracGrupo^.sig;
			end;
			lCaracDist:= lCaracDist^.sig;
			lCantCarac:= lCantCarac^.sig;
		end;
		divisor:= 1;
		while lAux <> nil do begin
			divisor:= divisor * fact(lAux^.elem);
			lAux:= lAux^.sig;
		end;
		divisorGrupo:= 1;
		while lAuxGrupo <> nil do begin
			divisorGrupo:= divisorGrupo * fact(lAuxGrupo^.elem);
			lAuxGrupo:= lAuxGrupo^.sig;
		end;
		pIndisGrupo:= fact(cantCarac-cantGrupo);
		writeln;
		if ordenados then begin
			writeln('    Permutaciones indistinguibles sin el grupo ordenado: ',pIndistinguibles div pIndisGrupo);
			writeln('    Permutaciones distinguibles sin el grupo ordenado: ',pIndistinguibles div (divisor * pIndisGrupo));
		end
		else begin
			writeln('    Permutaciones indistinguibles sin el grupo sin ordenar: ',pIndistinguibles div (divisor * pIndisGrupo));
			writeln('    Permutaciones distinguibles sin el grupo sin ordenar: ',pIndistinguibles div (divisor * pIndisGrupo * divisorGrupo));
		end;
		enterContinuar();
	end;

procedure permutaciones();
	var
		opc: char;
	begin
		writeln('  PERMUTACIONES');
		writeln;
		writeln('  Ingrese la letra del metodo de entrada requerido');
		writeln;
		writeln('    A -  Cantidades');
		writeln('    B -  Caracteres');
		writeln('    C -  Caracteres con grupo');
		leerOpcion('A','C',opc);
		saltosLinea30();
		case opc of
			'A':	perCantidades();
			'B':	perCaracteres();
			'C':	perCaracSubcadena();
		end;
	end;

procedure leerRN(var n,r: word);
	begin
		repeat
			writeln;
			leerNatural('  Cantidad de elementos totales: ',n);
			leerNatural('  Cantidad de elementos elegidos: ',r);
			if (r> n) or (r= 0) then begin
				writeln('  Recuerde que no puede elegir mas elementos que los totales');
				writeln('  Presione Enter para volver a cargar los valores');
				readln;
			end;
		until (r> 0) and (r<= n);
	end;

procedure rPermutaciones();
	var
		n,r: word;
	begin
		writeln('  R-PERMUTACIONES o VARIACIONES');
		writeln;
		writeln('     Es un ordenamiento de un subconjunto de r elementos');
		writeln('     a partir de un conjunto de n elementos distintos');
		writeln('     Si solo si 1 <= r <= n');
		writeln;
		writeln('  P(n,r)= n!/(n-r)!');
		writeln;
		writeln('    n: Elementos del conjunto');
		writeln('    r: Elementos del subconjunto');
		writeln;
		leerRN(n,r);
		writeln('  El resultado de P(',n,',',r,') es: ',fact(n) div fact(n-r));
		enterContinuar();
	end;

procedure combinaciones();
	var
		n,r: word;
	begin
		writeln('  COMBINACIONES');
		writeln;
		writeln('     Es una selección no ordenada de r elementos a partir de');
		writeln('     un conjunto de n elementos distintos');
		writeln('     Si solo si 1 <= r <= n');
		writeln;
		writeln('  C(n,r)= [P(n,r)]/r! = n!/[(n-r)!r!]');
		writeln;
		writeln('    n: Elementos del conjunto');
		writeln('    r: Elementos del subconjunto');
		writeln;
		leerRN(n,r);
		writeln('  El resultado de C(',n,',',r,') es: ',fact(n) div (fact(n-r) * fact(r)));
		enterContinuar();
	end;

procedure capCombinatoria();
	var
		bTema: boolean;
		opc: char;
	begin
		bTema:= true;
		while bApp and bTema do begin
			saltosLinea30();
			writeln('  MENU COMBINATORIA Y METODOS DE CONTEO');
			writeln;
			writeln('  Ingrese la letra del tema');
			writeln;
			writeln('    A -  Principio de multipliacion');
			writeln('    B -  Principio de suma');
			writeln('    C -  Permutaciones');
			writeln('    D -  R-Permutaciones o Variaciones');
			writeln('    E -  Combinaciones');
			writeln;
			writeln('    F -  Volver al Menu Capitulos');
			writeln('    G -  Cerrar Aplicacion');
			leerOpcion('A','G',opc);
			saltosLinea30();
			case opc of
				'A':	princMultiplicacion();
				'B':	princSuma();
				'C':	permutaciones();
				'D':	rPermutaciones();
				'E':	combinaciones();
				'F':	bTema:= false;
				'G':	bApp:= false;
			end;
		end;
	end;




// PROGRAMA PRINCIPAL
begin
	bApp:= true;
	while bApp do begin
		capCombinatoria();
		write('Se supone que ahora hirias al menu de capitulos pero f'); readln;
	end;
end.
