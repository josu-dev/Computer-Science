const
	RESOLUCION_DEFAULT_ELEMENTO_MATRIZ= 1;
	ESPACIO_DEFAULT_ELEMENTO_MATRIZ= 6;

type
	listaC= ^nodoC;
	nodoC= record
		elem: char;
		sig: listaC;
	end;
	
	listaE= ^nodoE;
	nodoE= record
		elem: real;
		sigF: listaE;
		sigC: listaE;
	end;
	
	matriz= record
		nom: char;
		m: word;
		n: word;
		mxn: listaE;
	end;
	
	listaM= ^nodoM;
	nodoM= record
		elem: matriz;
		sig: listaM;
	end;

var
	bApp: boolean;
	mAux: matriz;
	lMatrices: listaM;
	resElem,espElem,cantVariables: word;




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




// CONFIGURACIONES DEFAULTS
procedure presetsCapMatrices();
	begin
		resElem:= RESOLUCION_DEFAULT_ELEMENTO_MATRIZ;
		espElem:= ESPACIO_DEFAULT_ELEMENTO_MATRIZ;
		lMatrices:= nil;
		cantVariables:= 0;
	end;




//	CREAR MATRIZ
procedure crearFila(var lE: listaE; n: word);
	var
		i: word;
		nue,ult: listaE;
	begin
		new(nue);
		nue^.elem:= 0;
		nue^.sigC:= nil;
		lE:= nue;
		ult:= nue;
		for i:= 2 to n do begin
			new(nue);
			nue^.elem:= 0;
			nue^.sigC:= nil;
			ult^.sigF:= nue;
			ult:= nue;
		end;
		ult^.sigF:= nil;
	end;

procedure conectarFila(ant,act: listaE; n: word);
	var
		i: word;
	begin
		for i:= 1 to n do begin
			ant^.sigC:= act;
			ant:= ant^.sigF;
			act:= act^.sigF;
		end;
	end;

procedure crearMatriz(var m: matriz);
	var
		i: word;
		nue,ult: listaE;
	begin
		crearFila(nue,m.n);
		m.mxn:= nue;
		ult:= nue;
		for i:= 2 to m.m do begin
			crearFila(nue,m.n);
			ult^.sigC:= nue;
			conectarFila(ult,nue,m.n);
			ult:= nue;
		end;
	end;

procedure crearVariable(m,n: word; var nom: char);
	var
		ant,act,nue: listaM;
	begin
		cantVariables:= cantVariables +1;
		new(nue);
		nue^.elem.m:= m;
		nue^.elem.n:= n;
		crearMatriz(nue^.elem);
		nue^.sig:= nil;
		act:= lMatrices;
		while act<> nil do begin
			ant:= act;
			act:= act^.sig;
		end;
		if lMatrices= act then begin
			lMatrices:= nue;
			lMatrices^.elem.nom:= 'A';
		end
		else begin
			ant^.sig:= nue;
			nue^.elem.nom:= chr(ord(ant^.elem.nom) +1);
		end;
		nom:= nue^.elem.nom;
	end;

procedure matrizCrearVariable();
	var
		m,n: word;
		nom: char;
	begin
		repeat
			writeln('  Ingrese las dimensiones de la Matriz');
			writeln;
			leerNatural('    Cantidad de Filas: ',m);
			leerNatural('    Cantidad de Columnas: ',n);
			if (m= 0) or (n= 0) then begin
				writeln('  Una matriz almenos debe tener 1 columna y 1 fila');
				writeln('  Presione Enter para voler a cargar las dimensiones ');
				write('  '); readln;
				saltosLinea30();
			end;
		until (m> 0) and (n> 0);
		crearVariable(m,n,nom);
		writeln;
		writeln('  Se creo con exito la variable ',nom);
		enterContinuar();
	end;



//	ELIMINAR MATRIZ
procedure eliminarMatriz(var l: listaE);
	var
		fila,aux: listaE;
	begin
		while l <> nil do begin
			fila:= l;
			l:= l^.sigC;
			while fila <> nil do begin
				aux:= fila;
				fila:= fila^.sigF;
				dispose(aux);
			end;
		end;
	end;

procedure eliminarTodasLasVariables();
	var
		aux: listaM;
	begin
		cantVariables:= 0;
		while lMatrices <> nil do begin
			eliminarMatriz(lMatrices^.elem.mxn);
			aux:= lMatrices;
			lMatrices:= lMatrices^.sig;
			dispose(aux);
		end;
	end;

procedure eliminarVariable(nom: char);
	var
		ant,act: listaM;
	begin
		act:= lMatrices;
		while (act<> nil) and (act^.elem.nom<> nom) do begin
			writeln(act^.elem.nom);
			ant:= act;
			act:= act^.sig;
		end;
		if act <> nil then begin
			cantVariables:= cantVariables -1;
			eliminarMatriz(act^.elem.mxn);
			if act=lMatrices then
				lMatrices:= lMatrices^.sig
			else
				ant^.sig:= act^.sig;
			dispose(act);
		end;
	end;



// IMPRIMIR MATRIZ
procedure imprimirMatriz(m: matriz);
	var
		x,y: integer;
		columna,fila: listaE;
	begin
		if m.mxn <> nil then begin
			writeln('  Matriz: ',m.nom);
			writeln;
			columna:= m.mxn;
			for y:= 1 to m.m do begin
				fila:= columna;
				write('    ');
				for x:= 1 to m.n do begin
					write(fila^.elem: espElem: resElem);
					fila:= fila^.sigF;
				end;
				writeln;
				writeln;
				columna:= columna^.sigC;
			end;
		end;
	end;



// ELEGIR MATRIZ
procedure buscarMatriz(nom: char; var m: matriz);
	var
		aux: listaM;
	begin
		aux:= lMatrices;
		while aux^.elem.nom<> nom do begin
			aux:= aux^.sig;
		end;
		m:= aux^.elem;
	end;

procedure elegirMatriz(frase:string; var nom: char);
	var
		aux: listaM;
		l,ult: listaC;
		pos: word;
	begin
		l:= nil;
		if cantVariables= 0 then begin
			writeln('  No hay variables creadas, comience con una ahora');
			writeln;
			writeln;
			matrizCrearVariable();
			saltosLinea30();
		end;
		repeat
			aux:= lMatrices;
			writeln('  Variables disponibles:');
			while aux<> nil do begin
				agregarUltimoCaracter(l,ult,aux^.elem.nom);
				writeln('    ',aux^.elem.nom);
				aux:= aux^.sig;
			end;
			writeln;
			write(frase); readln(nom);
			buscarCaracter(l,nom,pos);
			if pos= 0 then begin
				writeln('  Entrada invalida, presione Enter para volver a intentar');
				write('  '); readln;
			end;
		until pos<>0;
	end;



// CARGA MATRIZ
procedure cargaManual(m: matriz);
	var
		columna,fila: listaE;
		frase: string;
		y,x: word;
	begin
		columna:= m.mxn;
		writeln('  Proceda a ingresar los valores');
		for y:=1 to m.m do begin
			fila:= columna;
			writeln('  Fila ',y,':');
			for x:=1 to m.n do begin
				frase:= '    columna '+chr(48+(x div 10))+chr(48+(x mod 10))+': ';
				leerReal(frase,fila^.elem);
				fila:= fila^.sigF;
			end;
			writeln;
			columna:= columna^.sigC
		end;
		writeln;
		writeln('  Se cargo con exito la matriz');
		enterContinuar();
	end;

procedure cargaConstante(m: matriz);
	var
		columna,fila: listaE;
		n: real;
		y,x: word;
	begin
		columna:= m.mxn;
		leerReal('  Valor para toda la matriz: ',n);
		for y:=1 to m.m do begin
			fila:= columna;
			for x:=1 to m.n do begin
				fila^.elem:= n;
				fila:= fila^.sigF;
			end;
			columna:= columna^.sigC
		end;
		writeln;
		writeln;
		writeln('  Se cargo con exito la matriz con el valor ',n:0:0);
		enterContinuar();
	end;

procedure cargaAleatoria(m: matriz);
	var
		aux,fila: listaE;
		n1,n2: integer;
		y,x: word;
	begin
		aux:= m.mxn;
		repeat
			writeln('  Defina el rango de los numeros aleatorios a cargar');
			writeln('  Los extremos deben ser distintos y el superior mayor al inferior');
			writeln;
			leerEntero('  Extremo inferior incluido: ',n1);
			leerEntero('  Extremo superior incluido: ',n2);
		until n1<n2;
		n2:= n2 - n1;
		for y:=1 to m.m do begin
			fila:= aux;
			for x:=1 to m.n do begin
				fila^.elem:= n1 + random(n2 +1);
				fila:= fila^.sigF;
			end;
			aux:= aux^.sigC
		end;
		writeln;
		writeln;
		writeln('  Se cargo con exito la matriz con valores aleatorios');
		enterContinuar();
	end;

procedure copiarMatriz(mBase,mCopia: matriz);
	var
		colB,colC,filaB,filaC: listaE;
		y,x: word;
	begin
		colB:= mBase.mxn;
		colC:= mCopia.mxn;
		for y:=1 to mBase.m do begin
			filaB:= colB;
			filaC:= colC;
			for x:=1 to mBase.n do begin
				filaC^.elem:= filaB^.elem;
				filaB:= filaB^.sigF;
				filaC:= filaC^.sigF;
			end;
			colB:= colB^.sigC;
			colC:= colC^.sigC;
		end;
	end;
procedure cargaCopia(m: matriz);
	var
		mBase: matriz;
		nom: char;
	begin
		if cantVariables>1 then begin
			elegirMatriz('  Variable a copiar: ',nom);
			buscarMatriz(nom,mBase);
			if (mBase.m= m.m) and (mBase.n= m.n) then begin
				copiarMatriz(mBase,m);
				writeln;
				writeln;
				writeln('  Se copio con exito toda la matriz');
			end
			else
				writeln('  No se pueden copiar matrices de distintas dimensiones');
		end
		else
			writeln('  No hay variables a las que copiar, debe crear almenos 1 mas');
		enterContinuar();
	end;

procedure cargaCopiaDiagonal(m: matriz);
	var
		col,colBase,filaBase,fila: listaE;
		mBase: matriz;
		nom: char;
		y,x: word;
	begin
		if cantVariables>1 then begin
			elegirMatriz('  Variable a copiar su diagonal: ',nom);
			buscarMatriz(nom,mBase);
			if (m.m= mBase.m) and (m.n= mBase.n) then begin
				col:= m.mxn;
				colBase:= mBase.mxn;
				for y:=1 to m.m do begin
					fila:= col;
					filaBase:= colBase;
					for x:=1 to m.n do begin
						if x<> y then
							fila^.elem:= 0
						else
							fila^.elem:= filaBase^.elem;
						fila:= fila^.sigF;
						filaBase:= filaBase^.sigF;
					end;
					col:= col^.sigC;
					colBase:= colBase^.sigC;
				end;
				writeln;
				writeln;
				writeln('  Se copio con exito la diagonal de la matriz');
			end
			else
				writeln('  No se pueden copiar matrices de distintas dimensiones');
		end
		else
			writeln('  No hay variables a las que copiar, debe crear almenos 1 mas');
		enterContinuar();
	end;

procedure cargaTrianguloSuperior(m: matriz);
	var
		colBase,col,filaBase,fila: listaE;
		mBase: matriz;
		nom: char;
		y,x: word;
	begin
		if cantVariables>1 then begin
			elegirMatriz('  Variable a copiar su triangulo superior: ',nom);
			buscarMatriz(nom,mBase);
			if (m.m= mBase.m) and (m.n= mBase.n) then begin
				col:= m.mxn;
				colBase:= mBase.mxn;
				for y:=1 to m.m do begin
					fila:= col;
					filaBase:= colBase;
					for x:=1 to m.n do begin
						if x< y then
							fila^.elem:= 0
						else
							fila^.elem:= filaBase^.elem;
						fila:= fila^.sigF;
						filaBase:= filaBase^.sigF;
					end;
					col:= col^.sigC;
					colBase:= colBase^.sigC;
				end;
				writeln;
				writeln;
				writeln('  Se copio con exito el triangulo superior de la matriz');
			end
			else
				writeln('  No se pueden copiar matrices de distintas dimensiones');
		end
		else
			writeln('  No hay variables a las que copiar, debe crear almenos 1 mas');
		enterContinuar();
	end;

procedure cargaTrianguloInferior(m: matriz);
	var
		col,colBase,filaBase,fila: listaE;
		mBase: matriz;
		nom: char;
		y,x: word;
	begin
		if cantVariables>1 then begin
			elegirMatriz('  Variable a copiar su triangulo inferior: ',nom);
			buscarMatriz(nom,mBase);
			if (m.m= mBase.m) and (m.n= mBase.n) then begin
				col:= m.mxn;
				colBase:= mBase.mxn;
				for y:=1 to m.m do begin
					fila:= col;
					filaBase:= colBase;
					for x:=1 to m.n do begin
						if x> y then
							fila^.elem:= 0
						else
							fila^.elem:= filaBase^.elem;
						fila:= fila^.sigF;
						filaBase:= filaBase^.sigF;
					end;
					col:= col^.sigC;
					colBase:= colBase^.sigC;
				end;
				writeln;
				writeln;
				writeln('  Se copio con exito el triandulo inferior de la matriz');
			end
			else
				writeln('  No se pueden copiar matrices de distintas dimensiones');
		end
		else
			writeln('  No hay variables a las que copiar, debe crear almenos 1 mas');
		enterContinuar();
	end;

procedure matrizCarga();
	var
		modo,nom: char;
		m: matriz;
	begin
		writeln('  MENU CARGA');
		writeln;
		writeln('  Ingrese la letra de la herramienta requerida');
		writeln;
		writeln('    A -  Manual');
		writeln('    B -  Valor Constante');
		writeln('    C -  Valores aleatorios');
		writeln('    D -  Copiar otra matriz');
		writeln('    E -  Copiar diagonal de otra matriz');
		writeln('    F -  Copiar diagonal superior de otra matriz');
		writeln('    G -  Copiar diagonal inferior de otra matriz');
		writeln;
		writeln('    H -  Volver al Menu Matrices');
		leerOpcion('A','H',modo);
		if modo<> 'H' then begin
			saltosLinea30();
			elegirMatriz('  Variable a cargar: ',nom);
			writeln;
			buscarMatriz(nom,m);
			case modo of
				'A':	cargaManual(m);
				'B':	cargaConstante(m);
				'C':	cargaAleatoria(m);
				'D':	cargaCopia(m);
				'E':	cargaCopiaDiagonal(m);
				'F':	cargaTrianguloSuperior(m);
				'G':	cargaTrianguloInferior(m);
			end;
		end;
	end;

// VISUALIZAR
procedure matrizVer();
	var
		nom: char;
		m: matriz;
	begin
		elegirMatriz('  Variable a visualizar: ',nom);
		buscarMatriz(nom,m);
		writeln;
		writeln;
		writeln('  Seleccion');
		imprimirMatriz(m);
		enterContinuar();
	end;

// SUMAR
procedure matrizSuma();
	var
		c1,c2,c3,f1,f2,f3: listaE;
		mSum1,mSum2,mSum3: matriz;
		nom1,nom2,nom3: char;
		y,x: word;
	begin
		if cantVariables>0 then begin
			elegirMatriz('  Seleccione primer sumando: ',nom1);
			writeln;
			elegirMatriz('  Seleccione segundo sumando: ',nom2);
			writeln;
			buscarMatriz(nom1,mSum1);
			buscarMatriz(nom2,mSum2);
			if (mSum1.m= mSum2.m) and (mSum1.n= mSum2.n) then begin
				crearVariable(mSum1.m,mSum1.n,nom3);
				buscarMatriz(nom3,mSum3);
				c1:= mSum1.mxn;
				c2:= mSum2.mxn;
				c3:= mSum3.mxn;
				for y:=1 to mSum1.m do begin
					f1:= c1;
					f2:= c2;
					f3:= c3;
					for x:=1 to mSum1.n do begin
						f3^.elem:= f1^.elem + f2^.elem;
						f1:= f1^.sigF;
						f2:= f2^.sigF;
						f3:= f3^.sigF;
					end;
					c1:= c1^.sigC;
					c2:= c2^.sigC;
					c3:= c3^.sigC;
				end;
				writeln;
				writeln('  Se sumaron con exito las matrices');
				writeln('  Resultado guardado en la variable ',nom3);
			end
			else
				writeln('  No se pueden sumar matrices de distintas dimensiones');
		end
		else
			writeln('  No hay variables para sumar, debe crear almenos 1');
		enterContinuar();
	end;

// ESCALAR
procedure matrizEscalar();
	var
		columna,fila: listaE;
		m: matriz;
		nom: char;
		y,x: word;
		r: real;
	begin
		elegirMatriz('  Variable a escalar: ',nom);
		buscarMatriz(nom,m);
		repeat
			writeln;
			writeln;
			writeln('  Recuerde que aplicar un escalar es multiplicar cada elemento de la matrices');
			writeln('  con un valor distinto a 0');
			writeln;
			leerReal('  Escalar: ',r);
		until r<> 0;
		columna:= m.mxn;
		for y:=1 to m.m do begin
			fila:= columna;
			for x:=1 to m.n do begin
				fila^.elem:= fila^.elem * r;
				fila:= fila^.sigF;
			end;
			columna:= columna^.sigC;
		end;
		writeln;
		writeln;
		writeln('  Escalar aplicado con exito');
		enterContinuar();
	end;

// PRODUCTO
procedure matrizProducto();
	var
		c1,c2,cR,f1,f2,fR: listaE;
		mOp1,mOp2,mRes: matriz;
		nom1,nom2,nomR: char;
		y,x,z: word;
	begin
		if cantVariables>0 then begin
			elegirMatriz('  Seleccione primer factor: ',nom1);
			writeln;
			elegirMatriz('  Seleccione segundo factor: ',nom2);
			writeln;
			buscarMatriz(nom1,mOp1);
			buscarMatriz(nom2,mOp2);
			if mOp1.n= mOp2.m then begin
				crearVariable(mOp1.m,mOp2.n,nomR);
				buscarMatriz(nomR,mRes);
				c1:= mOp1.mxn;
				cR:= mRes.mxn;
				for y:=1 to mRes.m do begin
					f2:= mOp2.mxn;
					fR:= cR;
					for x:=1 to mRes.n do begin
						f1:= c1;
						c2:= f2;
						fR^.elem:= 0;
						for z:= 1 to mRes.n do begin
							fR^.elem:= fR^.elem + f1^.elem * c2^.elem;
							f1:= f1^.sigF;
							c2:= c2^.sigC;
						end;
						f2:= f2^.sigF;
						fR:= fR^.sigF;
					end;
					c1:= c1^.sigC;
					cR:= cR^.sigC;
				end;
				writeln;
				writeln('  Se multiplicaron con exito las matrices');
				writeln('  Resultado guardado en la variable ',nomR);
			end
			else begin
				writeln('  No se pueden multiplicar matrices si la cantidad de columnas del');
				writeln('  primer factor es distinta a la cantidad de filas del segundo factor');
			end;
		end
		else
			writeln('  No hay variables para multiplicar, debe crear almenos 1');
		enterContinuar();
	end;

// TRANSPOSICION
procedure matrizTransposicion();
	var
		cB,cT,fB,fT: listaE;
		mBase,mT: matriz;
		nomB,nomT: char;
		y,x: word;
	begin
		if cantVariables>0 then begin
			elegirMatriz('  Variable a transponer: ',nomB);
			writeln;
			buscarMatriz(nomB,mBase);
			crearVariable(mBase.n,mBase.m,nomT);
			buscarMatriz(nomT,mT);
			cB:= mBase.mxn;
			fT:= mT.mxn;
			for y:=1 to mBase.m do begin
				fB:= cB;
				cT:= fT;
				for x:=1 to mBase.n do begin
					cT^.elem:= fB^.elem;
					fB:= fB^.sigF;
					cT:= cT^.sigC;
				end;
				cB:= cB^.sigC;
				fT:= fT^.sigF;
			end;
			writeln;
			writeln('  Se tranposiciono con exito');
			writeln('  Resultado guardado en la variable ',nomT);
		end
		else
			writeln('  No hay variables para transponer, debe crear almenos 1');
		enterContinuar();
	end;

// INVERSA
procedure cargarIdentidad(m: matriz);
	var
		columna: listaE;
		y: word;
	begin
		columna:= m.mxn;
		for y:= 1 to (m.m -1) do begin
			columna^.elem:= 1;
			columna:= columna^.sigC;
			columna:= columna^.sigF;
		end;
		columna^.elem:= 1;
	end;
function esIdentidad(m: matriz): boolean;
	var
		columna,fila: listaE;
		y,x: word;
		ok: boolean;
	begin
		ok:= true;
		x:= 0;
		fila:= m.mxn;
		while (x< m.n) and ok do begin
			x:= x+1;
			columna:= fila;
			y:= 0;
			ok:= true;
			while (y< m.m) and ok do begin
				y:= y+1;
				if x<> y then
					ok:= columna^.elem= 0
				else
					ok:= columna^.elem= 1;
				columna:= columna^.sigC;
			end;
			fila:= fila^.sigF;
		end;
		esIdentidad:= ok;
	end;
function hayColumna0(m: matriz): boolean;
	var
		columna,fila: listaE;
		y,x: word;
		ok: boolean;
	begin
		ok:= false;
		x:= 0;
		fila:= m.mxn;
		while (x< m.n) and (not ok) do begin
			x:= x+1;
			columna:= fila;
			y:= 0;
			ok:= true;
			while (y< m.m) and ok do begin
				y:= y+1;
				ok:= columna^.elem= 0;
				columna:= columna^.sigC;
			end;
			fila:= fila^.sigF;
		end;
		hayColumna0:= ok;
	end;
procedure filaEscalar(fila: listaE; e: real);
	begin
		while fila<> nil do begin
			fila^.elem:= fila^.elem * e;
			fila:= fila^.sigF;
		end;
	end;
procedure filaSumar(fBase,fSum: listaE; e: real);
	begin
		while fBase<> nil do begin
			fBase^.elem:= fBase^.elem + fSum^.elem * e;
			fBase:= fBase^.sigF;
			fSum:= fSum^.sigF;
		end;
	end;
procedure filaPermutar(f1,f2: listaE);
	var
		aux: real;
	begin
		while f1<> nil do begin
			aux:= f1^.elem;
			f1^.elem:= f2^.elem;
			f2^.elem:= aux;
			f1:= f1^.sigF;
			f2:= f2^.sigF;
		end;
	end;
procedure hayUno(col: listaE; var uno: word);
	begin
		uno:= 1;
		while (col<> nil) and (col^.elem<> 1) do begin
			uno:= uno +1;
			col:= col^.sigC;
		end;
		if col = nil then
			uno:= 0;
	end;


procedure calcularInversa(mB: matriz; var mI: matriz; var ok: boolean);
	var
		colA,colI,filaA,rFilaA,filaI,rFilaI: listaE;
		e: real;
		x: word;
		nom: char;
	begin
		mAux.m:= mB.m;
		mAux.n:= mB.n;
		crearMatriz(mAux);
		copiarMatriz(mB,mAux);
		crearVariable(mB.m,mB.n,nom);
		buscarMatriz(nom,mI);
		cargarIdentidad(mI);
		
		colA:= mAux.mxn;
		colI:= mI.mxn;
		rFilaA:= colA;
		rfilaI:= colI;
		for x:= 1 to mAux.m do begin
			filaA:= rFilaA;
			filaI:= rFilaI;
			while (filaA^.sigC<> nil) and (filaA^.elem = 0) do begin
				filaA:= filaA^.sigC;
				filaI:= filaI^.sigC;
			end;
			if filaA<> rFilaA then begin
				filaPermutar(filaA,rFilaA);
				filaPermutar(filaI,rFilaI);
			end;
			if rFilaA^.elem<> 0 then begin
				if rFilaA^.elem<> 1 then begin
					filaEscalar(rFilaI, 1/rFilaA^.elem);
					filaEscalar(rFilaA, 1/rFilaA^.elem);
				end;
				filaA:= rFilaA^.sigC;
				filaI:= rFilaI^.sigC;
				while filaA<> nil do begin
					if filaA^.elem <> 0 then begin
						e:= -filaA^.elem;
						filaSumar(filaI,rFilaI,e);
						filaSumar(filaA,rFilaA,e);
					end;
					filaA:= filaA^.sigC;
					filaI:= filaI^.sigC;
				end;
				filaA:= colA;
				filaI:= colI;
				while filaA<> rFilaA do begin
					if filaA^.elem <> 0 then begin
						e:= -filaA^.elem;
						filaSumar(filaI,rFilaI,e);
						filaSumar(filaA,rFilaA,e);
					end;
					filaA:= filaA^.sigC;
					filaI:= filaI^.sigC;
				end;
			end;
			if colA^.sigF<> nil then begin
				colA:= colA^.sigF;
				rFilaA:= rFilaA^.sigC;
				rFilaA:= rFilaA^.sigF;
				rFilaI:= rFilaI^.sigC;
			end;
		end;
		ok:= esIdentidad(mAux);
		eliminarMatriz(mAux.mxn);
	end;


{
procedure calcularInversa(mB: matriz; var mI: matriz; var ok: boolean);
	var
		colA,colI,filaA,rFilaA,filaI,rFilaI: listaE;
		e: real;
		y,x,uno: word;
		nom: char;
	begin
		mAux.m:= mB.m;
		mAux.n:= mB.n;
		crearMatriz(mAux);
		copiarMatriz(mB,mAux);
		crearVariable(mB.m,mB.n,nom);
		buscarMatriz(nom,mI);
		cargarIdentidad(mI);
		
		colA:= mAux.mxn;
		colI:= mI.mxn;
		rFilaA:= colA;
		rfilaI:= colI;
		for x:= 1 to mAux.m do begin
			filaA:= rFilaA;
			filaI:= rFilaI;
			hayUno(colA,uno);
			if uno<> 0 then begin
				for y:= 2 to uno do begin
					filaA:= filaA^.sigC;
					filaI:= filaI^.sigC;
				end;
				filaPermutar(rFilaA,filaA);
				filaPermutar(rFilaI,filaI);
			end
			else begin
				filaEscalar(rFilaI, 1/rFilaA^.elem);
				filaEscalar(rFilaA, 1/rFilaA^.elem);
			end;
			filaA:= rFilaA^.sigC;
			filaI:= rFilaI^.sigC;
			while filaA<> nil do begin
				if filaA^.elem <> 0 then begin
					e:= -filaA^.elem;
					filaSumar(filaI,rFilaI,e);
					filaSumar(filaA,rFilaA,e);
				end;
				filaA:= filaA^.sigC;
				filaI:= filaI^.sigC;
			end;
			filaA:= colA;
			filaI:= colI;
			while filaA<> rFilaA do begin
				if filaA^.elem <> 0 then begin
					e:= -filaA^.elem;
					filaSumar(filaI,rFilaI,e);
					filaSumar(filaA,rFilaA,e);
				end;
				filaA:= filaA^.sigC;
				filaI:= filaI^.sigC;
			end;
			if x< mAux.m then begin
				colA:= colA^.sigF;
				rFilaA:= rFilaA^.sigC;
				rFilaA:= rFilaA^.sigF;
				rFilaI:= rFilaI^.sigC;
			end;
		end;
		ok:= esIdentidad(mAux);
		eliminarMatriz(mAux.mxn);
	end;
}


procedure matrizInversa();
	var
		mOp,mI: matriz;
		ok: boolean;
		nom: char;
	begin
		if cantVariables>0 then begin
			elegirMatriz('  Variable a calcular su inversa: ',nom);
			writeln;
			buscarMatriz(nom,mOp);
			if (mOp.m= mOp.n) then begin
				if not hayColumna0(mOp) then begin
					calcularInversa(mOp,mI,ok);
					if ok then begin
						writeln('  La inversa se pudo calcular con exito');
						writeln('  Resultado guardado en la variable ',mI.nom);
						writeln;
						writeln('  Se recomienda aumentar la resolucion en el apartado de');
						writeln('  visualizacion para ver con exactitud los valores');
					end
					else begin
						writeln('  La matriz cargada en la variable ',nom,' no tiene inversa');
						eliminarVariable(mI.nom);
					end;
				end
				else begin
					writeln('  Todos los valores de almenos una columna son 0, por lo tanto');
					writeln('  no puede tener inversa');
				end;
			end
			else begin
				writeln('  Es requisito excluyente que la matriz sea cuadrada ( nxn )');
				writeln('  para que pueda tener una inversa');
			end;
		end
		else
			writeln('  No hay variables para calcular su inversa, debe crear almenos 1');
		enterContinuar();
	end;

// ELIMINAR POR USUARIO
procedure matrizEliminar();
	var
		ok: boolean;
	begin
		writeln('  Estas seguro que quieres eliminar todas las variables');
		leerSiNo(ok);
		if ok then begin
			eliminarTodasLasVariables();
			writeln;
			writeln('  Todas las variables eliminadas con exito');
		end;
		enterContinuar();
	end;

// CONFIGURACIONES
procedure cambiarResolucion();
	begin
		repeat
			saltosLinea30();
			writeln('  Actualmente la resolucion es de ',resElem,' decimales');
			writeln('  Recuerde que entre mas decimales mas anchos son los numeros en pantalla');
			writeln;
			writeln('  Cuanta precision quiere, desde 0 a 4 decimales');
			leerNatural('  Decimales: ',resElem);
		until resElem< 5;
		if resElem> 0 then
			espElem:= 3 * (resElem + 1);
		writeln('  Resolucion actualizada con exito');
		enterContinuar;
		saltosLinea30();
	end;

procedure cambiarEspaciado();
	begin
		repeat
			saltosLinea30();
			writeln('  Actualmente el espaciado es de ',espElem,' caracteres');
			writeln('  Si va a trabajar con numeros grandes o con decimales, es recomendable que');
			writeln('  los espacios sean iguales a la cantidad de digitos de los numeros + 1');
			writeln;
			writeln('  Cuantos espacios quiere, desde 6 a 12');
			leerNatural('  Espacios: ',espElem);
		until (espElem> 5) and (espElem< 13);
		if resElem> 0 then
			espElem:= espElem + resElem +1;
		writeln('  Espacios actualizados con exito');
		enterContinuar;
		saltosLinea30();
	end;

procedure matrizConfig();
	var
		opc: char;
		bTema: boolean;
	begin
		bTema:= true;
		repeat
			writeln('  MENU CONFIGURACIONES');
			writeln;
			writeln('  Configuraciones disponibles');
			writeln;
			writeln('    A -  Cambiar resolucion');
			writeln('    B -  Cambiar espaciado entre elementos');
			writeln;
			writeln('    C -  Volver al Menu Matrices');
			leerOpcion('A','C',opc);
			case opc of
				'A':	cambiarResolucion();
				'B':	cambiarEspaciado();
				'C':	bTema:= false;
			end;
		until not bTema;
	end;




procedure capMatrices();
	var
		bTema: boolean;
		opc: char;
	begin
		bTema:= true;
		presetsCapMatrices();
		while bApp and bTema do begin
			saltosLinea30();
			writeln('  MENU MATRICES');
			writeln;
			writeln('  Ingrese la letra de la herramienta requerida');
			writeln;
			writeln('    A -  Crear Variable');
			writeln('    B -  Cargar Matriz');
			writeln('    C -  Visualizar Matriz');
			writeln('    D -  Suma');
			writeln('    E -  Escalar');
			writeln('    F -  Producto');
			writeln('    G -  Transposicion');
			writeln('    H -  Inversa');
			writeln;
			writeln('    I -  Eliminar las variables');
			writeln('    J -  Configurar visualizacion');
			writeln('    K -  Volver al Menu Capitulos');
			writeln('    L -  Cerrar Aplicacion');
			leerOpcion('A','L',opc);
			saltosLinea30();
			case opc of
				'A':	matrizCrearVariable();
				'B':	matrizCarga();
				'C':	matrizVer();
				'D':	matrizSuma();
				'E':	matrizEscalar();
				'F':	matrizProducto();
				'G':	matrizTransposicion();
				'H':	matrizInversa();
				'I':	matrizEliminar();
				'J':	matrizConfig();
				'K':	bTema:= false;
				'L':	bApp:= false;
			end;
		end;
		eliminarTodasLasVariables();
	end;



// PROGRAMA PRINCIPAL
begin
	bApp:= true;
	while bApp do begin
		capMatrices();
		write('Se supone que ahora hirias al menu de capitulos pero f'); readln;
	end;
end.
