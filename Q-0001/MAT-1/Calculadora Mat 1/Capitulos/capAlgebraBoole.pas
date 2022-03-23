type
	listaC= ^nodoC;
	nodoC= record
		elem: char;
		sig: listaC;
	end;
	
	terminoB= record
		tipo: word;
		car: char;
		neg: boolean;
	end;
	listaB= ^nodoB;
	nodoB= record
		elem: terminoB;
		sig: listaB;
	end;


// MANEJO CARACTERES
procedure eliminarCaracterString(var s: string; pos: word; var dl: word);
	var
		i: word;
	begin
		dl:= dl-1;
		for i:= pos to dl do
			s[i]:= s[i+1];
	end;

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
procedure insertarCaracter(var l: listaC; c: char);
	var
		nue: listaC;
	begin
		new(nue);
		nue^.elem:= c;
		nue^.sig:= nil;
		if l= nil then
			l:= nue
		else begin
			nue^.sig:= l^.sig;
			l^.sig:= nue;
		end;
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
procedure eliminarCaracterLista(var l: listaC);
	var
		aux: listaC;
	begin
		if l<> nil then begin
			aux:= l;
			l:= l^.sig;
			dispose(aux);
		end;
	end;



function esSupremoInfimo(c: char): boolean;
	begin
		esSupremoInfimo:= (c= '0') or (c= '1');
	end;
function esOperacion(c: char): boolean;
	begin
		esOperacion:= (c= '+') or (c= '.') or (c= chr(39));
	end;
function esOrden(c: char): boolean;
	begin
		esOrden:= (c= '(') or (c= ')');
	end;
function esVariable(c: char): boolean;
	begin
		esVariable:= (c>= 'A') and (c<= 'Z') or (c>= 'a') and (c<= 'z');
	end;
function esFuncion(funcion: string): boolean;
	var
		i: word;
	begin
		i:=1;
		esFuncion:= true;
		while (i<= length(funcion)) and esFuncion do begin
			esFuncion:=  esVariable(funcion[i]) or (funcion[i]= ' ') or esOperacion(funcion[i]) or esOrden(funcion[i]) or esSupremoInfimo(funcion[i]);
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
procedure leerFuncionString(frase: string; var sLeida: string);
	var
		ok: boolean;
	begin
		repeat
			write(frase);readln(sLeida);
			ok:= esFuncion(sLeida);
			if ok then
				ok:= esAritmetica(sLeida);
			if not ok then begin
				writeln('  Verifique que la ecuacion esta escrita correctamente, intente nuevamente');
				write('  '); readln;
			end;
		until ok;
	end;

procedure stringALista(sLeida: string; var lFun: listaC);
	var
		dl,i: word;
		lUltF: listaC;
	begin
		lFun:= nil;
		dl:= length(sLeida);
		i:= 1;
		while i<= dl do begin
			if sLeida[i]= ' ' then
				eliminarCaracterString(sLeida,i,dl)
			else begin
				agregarUltimoCaracter(lFun,lUltF,sLeida[i]);
				i:= i +1;
			end;
		end;
	end;

procedure corregirFuncion(var lFun: listaC);
	var
		lA: listaC;
	begin
		lA:= lFun;
		while lA<> nil do begin
			if (lA^.elem>= 'a') and (lA^.elem<= 'z') then
				lA^.elem:= chr(ord(lA^.elem)-32);
			if (lA^.sig<> nil) then begin
				if esVariable(lA^.elem) and (esVariable(lA^.sig^.elem) or (lA^.sig^.elem= '(')) then
						insertarCaracter(lA,'.')
				else if (lA^.elem= chr(39)) and (esVariable(lA^.sig^.elem) or (lA^.sig^.elem= '(')) then
						insertarCaracter(lA,'.')
				else if (lA^.elem= ')') and ((lA^.sig^.elem= '(') or esVariable(lA^.sig^.elem)) then
						insertarCaracter(lA,'.');
			end;
			lA:= lA^.sig;
		end;
	end;

procedure leerFuncionLista(frase: string; var lFun: listaC);
	var
		sLeida: string;
	begin
		leerFuncionString(frase,sLeida);
		stringALista(sLeida,lFun);
		corregirFuncion(lFun);
	end;


procedure agregarUltTermB(var l,ult: listaB; t: terminoB);
	var
		nue: listaB;
	begin
		new(nue);
		nue^.elem:= t;
		nue^.sig:= nil;
		if l= nil then
			l:= nue
		else
			ult^.sig:= nue;
		ult:= nue;
	end;
procedure agregarUltTermBManual(var l,ult: listaB; tipo: word; car: char; neg: boolean);
	var
		nue: listaB;
	begin
		new(nue);
		nue^.elem.tipo:= tipo;
		nue^.elem.car:= car;
		nue^.elem.neg:= neg;
		nue^.sig:= nil;
		if l= nil then
			l:= nue
		else
			ult^.sig:= nue;
		ult:= nue;
	end;

procedure ordenarFuncionLista(lB: listaB);
	var
		c: terminoB;
		lA: listaB;
	begin
		while lB<> nil do begin
			if lB^.elem.tipo= 1 then begin
				lA:= lB;
				while (lA<> nil) and (lA^.elem.car<> '+') do begin
					if (lA^.elem.tipo= 1) and (lA^.elem.car< lB^.elem.car) then begin
						c:= lB^.elem;
						lB^.elem:= lA^.elem;
						lA^.elem:= c;
					end;
					lA:= lA^.sig;
				end;
				lB:= lB^.sig;
			end;
			if lB<> nil then
				lB:= lB^.sig;
		end;
	end;
	
procedure procesarFuncionLista(lC: listaC; var lB: listaB);
	var
		ult: listaB;
		neg: boolean;
	begin
		lB:= nil;
		while lC<> nil do begin
			if esVariable(lC^.elem) then begin
				neg:= (lC^.sig<> nil) and (lC^.sig^.elem= chr(39));
				agregarUltTermBManual(lB,ult,1,lC^.elem,neg);
				if neg then
					lC:= lC^.sig;
			end
			else
				agregarUltTermBManual(lB,ult,0,lC^.elem,false);
			lC:= lC^.sig;
		end;
		ordenarFuncionLista(lB);
	end;



var
	lCarB: listaC;
	lTermB: listaB;
	
begin
	while true do begin
		leerFuncionLista('  DALE PAI: ', lCarB);
		procesarFuncionLista(lCarB,lTermB);
		while lCarB<> nil do begin
			write(lCarB^.elem);
			lCarB:= lCarB^.sig;
		end;
		writeln;
		while lTermB<> nil do begin
			write(lTermB^.elem.car);
			if lTermB^.elem.neg then
				write(chr(39));
			lTermB:= lTermB^.sig;
		end;
		writeln;
		write('  '); readln;
	end;
end.
