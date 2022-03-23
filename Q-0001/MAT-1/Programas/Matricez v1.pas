type
	listaX= ^nodoX;
	nodoX= record
		v: real;
		sig: listaX;
	end;
	
	listaY= ^nodoY;
	nodoY= record
		elem: listaX;
		sig: listaY;
	end;
	
	matriz= record
		nom: string;
		m: integer;
		n: integer;
		mxn: listaY;
	end;




var
	Base,mN,mI,mImp,mAux: matriz;
	op1,op2,op3,mA,mB,mC,mD,mE: matriz;
	bApp,bConfig,bSimetrica,bSigno: boolean;
	nOperacion,valorRangoI,valorRangoF: integer;
	valorLeido: real;




//	INICIO
procedure presets();
	begin
		bApp:= true;
		randomize();
		mN.nom:= 'Nula';
		mI.nom:= 'Identidad';
		mA.nom:= 'A';
		mB.nom:= 'B';
		mC.nom:= 'C';
		mD.nom:= 'D';
		mE.nom:= 'E';
	end;





//	MODULOS COMUNES
procedure saltoLinea20();
	begin
		writeln;writeln;writeln;writeln;writeln; writeln;writeln;writeln;writeln;writeln;
		writeln;writeln;writeln;writeln;writeln; writeln;writeln;writeln;writeln;writeln;
	end;
	
procedure enterContinuar();
	begin
		write('  Presione Enter para continuar '); readln;
	end;
	
procedure leerSiNo(var opc: boolean);
	var
		resp: char;
	begin
		writeln('    S |  Si');
		writeln('    N |  No');
		repeat
			write('  Opcion: ');readln(resp);
			if resp= 's' then
				resp:= 'S'
			else if resp= 'n' then
				resp:= 'N'
			else if (resp<> 'S') and (resp<>'N') then
				writeln('  Opcion no valida, intente nuevamente');
			writeln;
		until (resp= 'S') or (resp= 'N');
		opc:= resp= 'S';
	end;

procedure leerReal(var r: real);
	var
		code: word;
		rString: string;
	begin
		repeat
			write('  Valor: ');readln(rString);
			val(rString,r,code);
			if code<> 0 then
				writeln('  Valor ingresado invalido, para decimales utilice el .');
			writeln;
		until code=0;
	end;

procedure leerEntero(var e: integer);
	var
		code: word;
		rString: string;
	begin
		repeat
			write('  Valor: ');readln(rString);
			val(rString,e,code);
			if code<> 0 then
				writeln('  Valor ingresado invalido, solo se toman numeros enteros');
			writeln;
		until code=0;
	end;

function buscarElemento(LY: listaY; y,x: integer): real;
	var
		i,j: integer;
		LX: listaX;
	begin
		for i:= 2 to y do
			LY:= LY^.sig;
		LX:= LY^.elem;
		for j:= 2 to x do
			LX:= LX^.sig;
		buscarElemento:= LX^.v;
	end;




//	ELIMINAR MATRIZ
procedure borrarMatriz(var A: matriz);
	var
		yA: listaY;
		xA: listaX;
	begin
		while A.mxn <> nil do begin
			while A.mxn^.elem <> nil do begin
				xA:= A.mxn^.elem;
				A.mxn^.elem:= A.mxn^.elem^.sig;
				dispose(xA);
			end;
			yA:= A.mxn;
			A.mxn:= A.mxn^.sig;
			dispose(yA);
		end;
	end;

procedure resetearMatrices();
	begin
		borrarMatriz(mN);
		borrarMatriz(mI);
		borrarMatriz(mAux);
		borrarMatriz(mA);
		borrarMatriz(mB);
		borrarMatriz(mC);
		borrarMatriz(mD);
		borrarMatriz(mE);
	end;




//	CREAR MATRIZ
procedure crearFila(var LX: listaX; n: integer);
	var
		j: integer;
		nue,ult: listaX;
	begin
		new(nue);
		nue^.sig:= nil;
		LX:= nue;
		ult:= nue;
		for j:= 2 to n do begin
			new(nue);
			ult^.sig:= nue;
			ult:= nue;
		end;
		ult^.sig:= nil;
	end;
	
procedure crearMatriz(var A: matriz);
	var
		i: integer;
		ult, nue: listaY;
	begin
		new(nue);
		crearFila(nue^.elem, A.n);
		A.mxn:= nue;
		ult:= nue;
		for i:= 2 to A.m do begin
			new(nue);
			crearFila(nue^.elem, A.n);
			ult^.sig:= nue;
			ult:= nue;
		end;
		ult^.sig:= nil;
	end;




// IMPRIMIR MATRIZ
procedure imprimirMatriz(A: matriz);
	var
		i,j: integer;
		y: listaY;
		x: listaX;
	begin
		if A.mxn <> nil then begin
			if bConfig then
				writeln('  Matriz: ',A.nom);
			y:= A.mxn;
			for i:= 1 to A.m do begin
				x:= y^.elem;
				for j:= 1 to A.n do begin
					write('  ',x^.v: 2: 0);
					x:= x^.sig;
				end;
				writeln;
				writeln;
				y:= y^.sig;
			end;
		end;
	end;


procedure copiarMatriz(A,B: matriz);
	var
		i,j: integer;
		yA,yB: listaY;
		xA,xB: listaX;
	begin
		yA:= A.mxn;
		yB:= B.mxn;
		for i:=1 to A.m do begin
			xA:= yA^.elem;
			xB:= yB^.elem;
			for j:=1 to A.n do begin
				xB^.v:= xA^.v;
				xA:= xA^.sig;
				xB:= xB^.sig;
			end;
			yA:= yA^.sig;
			yB:= yB^.sig;
		end;
	end;

procedure cargarMatrizManual(A: matriz);
	var
		i,j: integer;
		y: listaY;
		x: listaX;
	begin
		y:= A.mxn;
		writeln('  A continuacion cargue los valores');
		writeln;
		for i:=1 to A.m do begin
			x:= y^.elem;
			write('  Valores fila ',i,': ');
			for j:=1 to A.n do begin
				read(x^.v);
				x:= x^.sig;
			end;
			y:= y^.sig;
		end;
		writeln;
		writeln('  Matriz cargada correctamente, ingrese ok para continuar');
		readln;
		writeln;
	end;

procedure cargarMatrizValRandom(A: matriz);
	var
		i,j,n: integer;
		y: listaY;
		x: listaX;
	begin
		n:= valorRangoF - valorRangoI;
		y:= A.mxn;
		for i:=1 to A.m do begin
			x:= y^.elem;
			for j:=1 to A.n do begin
				x^.v:= valorRangoI + random(n +1);
				x:= x^.sig;
			end;
			y:= y^.sig;
		end;
	end;

procedure cargarMatrizValConst(A: matriz; v: real);
	var
		i,j: integer;
		y: listaY;
		x: listaX;
	begin
		y:= A.mxn;
		for i:=1 to A.m do begin
			x:= y^.elem;
			for j:=1 to A.n do begin
				x^.v:= v;
				x:= x^.sig;
			end;
			y:= y^.sig;
		end;
	end;


procedure crearMatrizNula();
	begin
		mN.m:= Base.m;
		mN.n:= Base.n;
		crearMatriz(mN);
		cargarMatrizValConst(mN,0);
	end;

procedure crearMatrizIdentidad();
	var
		i,j: integer;
		y: listaY;
		x: listaX;
	begin
		mI.m:= Base.m;
		mI.n:= Base.n;
		crearMatriz(mI);
		cargarMatrizValConst(mI,0);
		y:= mI.mxn;
		for i:=1 to mI.m do begin
			x:= y^.elem;
			for j:=2 to i do
				x:= x^.sig;
			x^.v:= 1;
			y:= y^.sig;
		end;
	end;




//	OPERACIONES
procedure sumarMatrizes(A,B,C: matriz);
	var
		i,j,s: integer;
		yA,yB,yC: listaY;
		xA,xB,xC: listaX;
	begin
		if bSigno then
			s:= 1
		else
			s:= -1;
		yA:= A.mxn;
		yB:= B.mxn;
		yC:= C.mxn;
		for i:=1 to A.m do begin
			xA:= yA^.elem;
			xB:= yB^.elem;
			xC:= yC^.elem;
			for j:=1 to A.n do begin
				xC^.v:= xA^.v + s*xB^.v;
				xA:= xA^.sig;
				xB:= xB^.sig;
				xC:= xC^.sig;
			end;
			yA:= yA^.sig;
			yB:= yB^.sig;
			yC:= yC^.sig;
		end;
	end;

procedure escalarMatriz(A: matriz; e: real);
	var
		i,j: integer;
		yA: listaY;
		xA: listaX;
	begin
		yA:= A.mxn;
		for i:=1 to A.m do begin
			xA:= yA^.elem;
			for j:=1 to A.n do begin
				xA^.v:= xA^.v * e;
				xA:= xA^.sig;
			end;
			yA:= yA^.sig;
		end;
	end;

procedure diagonalMatriz(A,B: matriz);
	var
		i,j: integer;
		yA,yB: listaY;
		xA,xB: listaX;
	begin
		yA:= A.mxn;
		yB:= B.mxn;
		for i:=1 to A.m do begin
			xA:= yA^.elem;
			xB:= yB^.elem;
			for j:=1 to A.n do begin
				if i<>j then
					xB^.v:= 0
				else
					xB^.v:= xA^.v;
				xA:= xA^.sig;
				xB:= xB^.sig;
			end;
			yA:= yA^.sig;
			yB:= yB^.sig;
		end;
	end;

procedure triangularSuperior(A,B: matriz);
	var
		i,j: integer;
		yA,yB: listaY;
		xA,xB: listaX;
	begin
		yA:= A.mxn;
		yB:= B.mxn;
		for i:=1 to A.m do begin
			xA:= yA^.elem;
			xB:= yB^.elem;
			for j:=1 to A.n do begin
				if i > j then
					xB^.v:= 0
				else
					xB^.v:= xA^.v;
				xA:= xA^.sig;
				xB:= xB^.sig;
			end;
			yA:= yA^.sig;
			yB:= yB^.sig;
		end;
	end;
	
procedure triangularInferior(A,B: matriz);
	var
		i,j: integer;
		yA,yB: listaY;
		xA,xB: listaX;
	begin
		yA:= A.mxn;
		yB:= B.mxn;
		for i:=1 to A.m do begin
			xA:= yA^.elem;
			xB:= yB^.elem;
			for j:=1 to A.n do begin
				if i < j then
					xB^.v:= 0
				else
					xB^.v:= xA^.v;
				xA:= xA^.sig;
				xB:= xB^.sig;
			end;
			yA:= yA^.sig;
			yB:= yB^.sig;
		end;
	end;

procedure transposicionMatriz(A,B: matriz);
	var
		i,j: integer;
		yA,yB: listaY;
		xB: listaX;
	begin
		yA:= A.mxn;
		yB:= B.mxn;
		for i:=1 to A.m do begin
			xB:= yB^.elem;
			for j:=1 to A.n do begin
				xB^.v:= buscarElemento(yA,j,i);
				xB:= xB^.sig;
			end;
			yB:= yB^.sig;
		end;
	end;

procedure productoMatricez(A,B,C: matriz);
	var
		i,j,k: integer;
		yA,yAux,yC: listaY;
		xA,xAux,xC: listaX;
	begin
		transposicionMatriz(B,mAux);
		yA:= A.mxn;
		yC:= C.mxn;
		for i:=1 to A.m do begin
			yAux:= mAux.mxn;
			xC:= yC^.elem;
			for j:=1 to A.n do begin
				xA:= yA^.elem;
				xAux:= yAux^.elem;
				xC^.v:= 0;
				for k:=1 to A.n do begin
					xC^.v:= xC^.v + xA^.v * xAux^.v;
					xA:= xA^.sig;
					xAux:= xAux^.sig;
				end;
				yAux:= yAux^.sig;
				xC:= xC^.sig;
			end;
			yA:= yA^.sig;
			yC:= yC^.sig;
		end;
	end;




//	OPERAR
procedure realizarOperacion();
	begin
		case nOperacion of
			1:	writeln('  Esta es la matriz seleccionada');
			10:	cargarMatrizManual(op1);
			11:	cargarMatrizValConst(op1,valorLeido);
			12: cargarMatrizValRandom(op1);
			13:	copiarMatriz(op2,op1);
			21:	sumarMatrizes(op1,op2,op3);
			31:	escalarMatriz(op1,valorLeido);
			41:	diagonalMatriz(op1,op2);
			51:	triangularSuperior(op1,op2);
			52:	triangularInferior(op1,op2);
			61: productoMatricez(op1,op2,op3);
			71: transposicionMatriz(op1,op2);
		end;
	end;




//	MENU OPERACIONES
procedure seleccionarMatrizCompleto(var A: matriz);
	var
		bConfirmacion: boolean;
		opc: char;
	begin
		if bSimetrica then
			writeln('    1 -  Identidad');
		writeln('    2 -  Nula');
		writeln('    3 -  A');
		writeln('    4 -  B');
		writeln('    5 -  C');
		writeln('    6 -  D');
		writeln('    7 -  E');
		repeat
			write('  Opcion: ');readln(opc);
			bConfirmacion:= (bSimetrica and (opc>= '1') and (opc<= '7')) or
				((not bSimetrica) and (opc>= '2') and (opc<= '7'));
			if bConfirmacion then begin
				case opc of
					'1' :	A:= mI;
					'2' :	A:= mN;
					'3' :	A:= mA;
					'4' :	A:= mB;
					'5' :	A:= mC;
					'6' :	A:= mD;
					'7' :	A:= mE;
				end;
			end
			else begin
				writeln('  Opcion no valida, intente nuevamente');
				writeln;
				enterContinuar();
			end;
		until bConfirmacion;
	end;

procedure seleccionarMatrizVariables(var A: matriz);
	var
		opc: char;
	begin
		writeln('    1 -  A');
		writeln('    2 -  B');
		writeln('    3 -  C');
		writeln('    4 -  D');
		writeln('    5 -  E');
		repeat
			write('  Opcion: ');readln(opc);
				case opc of
					'1' :	A:= mA;
					'2' :	A:= mB;
					'3' :	A:= mC;
					'4' :	A:= mD;
					'5' :	A:= mE;
					else begin
						writeln('  Opcion no valida, intente nuevamente');
						writeln;
						enterContinuar();
					end;
				end;
		until (opc>= '1') and (opc<= '5');
	end;

procedure elegirMostrar();
	begin
		writeln('  Que matriz quiere visualizar ?');
		seleccionarMatrizCompleto(mImp);
		nOperacion:= 1;
	end;

procedure elegirDiagonal();
	begin
		writeln('  Cual es la matriz a la que le copiara sus valores de la diagonal ?');
		seleccionarMatrizCompleto(op1);
		
		writeln;
		writeln('  Donde guardara la diagonal ?');
		seleccionarMatrizVariables(op2);
		
		mImp:= op2;
		nOperacion:= 41;
	end;

procedure elegirTriangulo();
	var
		opc: char;
	begin
		writeln('  Que triangulo quiere ?');
		writeln('    1 |  Superior');
		writeln('    2 |  Inferior');
		repeat
			write('  Opcion: ');readln(opc);
				case opc of
					'1' :	nOperacion:= 51;
					'2' :	nOperacion:= 52;
					else begin
						writeln('  Opcion no valida, intente nuevamente');
						writeln;
						enterContinuar();
					end;
				end;
				writeln;
		until (opc= '1') or (opc= '2');
		
		writeln('  Los valores del triangulo de cual matriz quiere ?');
		seleccionarMatrizCompleto(op1);
		
		writeln;
		writeln('  Donde guardara los valores del triangulo ?');
		seleccionarMatrizVariables(op2);
		
		mImp:= op2;
	end;

procedure elegirCargar();
	var
		opc: char;
	begin
		writeln('  Como quiere cargar la matriz ?');
		writeln('    1 |  Manual');
		writeln('    2 |  Con un valor constante');
		writeln('    3 |  Con valores random');
		writeln('    4 |  Copiar completa otra matriz');
		writeln('    5 |  Copiar diagonal de otra matriz');
		writeln('    6 |  Copiar triangulo de otra matriz');
		repeat
			write('  Opcion: ');readln(opc);
				case opc of
					'1' :	nOperacion:= 10;
					'2' :	nOperacion:= 11;
					'3' :	nOperacion:= 12;
					'4' :	nOperacion:= 13;
					'5' :	elegirDiagonal();
					'6' :	elegirTriangulo();
					else begin
						writeln('  Opcion no valida, intente nuevamente');
						writeln;
						enterContinuar();
					end;
				end;
				writeln;
		until (opc>= '1') and (opc<= '6');
		if opc< '5' then begin
			writeln('  Que matriz quiere cargar con valores ?');
			seleccionarMatrizVariables(op1);
			
			if nOperacion= 11 then begin
				writeln;
				writeln('  Cual es el valor constante a cargar ?');
				leerReal(valorLeido);
			end
			else if nOperacion= 12 then begin
				repeat
					writeln;
					writeln('  Cual es el rango de los valores randoms a cargar ?');
					writeln('  El rango solo puede ser de numeros enteros');
					writeln;
					writeln('  Minimo del rango, incluido');
					leerEntero(valorRangoI);
					writeln('  Maximo del rango, incluido');
					leerEntero(valorRangoF);
				until valorRangoI <> valorRangoF;
			end
			else if nOperacion= 13 then begin
				writeln;
				writeln('  A que matriz le quiere copiar los valores ?');
				seleccionarMatrizCompleto(op2);
			end;
			
			mImp:= op1;
		end;
	end;

procedure elegirSumarRestar();
	var
		opc: char;
	begin
		writeln('  Que quiere hacer ?');
		writeln('    1 |  Sumar');
		writeln('    2 |  Restar');
		repeat
			write('  Opcion: ');readln(opc);
				case opc of
					'1' :	bSigno:= true;
					'2' :	bSigno:= false;
					else begin
						writeln('  Opcion no valida, intente nuevamente');
						writeln;
						enterContinuar();
					end;
				end;
				writeln;
		until (opc= '1') or (opc= '2');
		writeln('  Cual es la primera matriz ?');
		seleccionarMatrizCompleto(op1);
		
		writeln;
		writeln('  Cual es la segunda matriz ?');
		seleccionarMatrizCompleto(op2);
		
		writeln;
		writeln('  Donde guardara el resultado ?');
		seleccionarMatrizVariables(op3);
		
		mImp:= op3;
		nOperacion:= 21;
	end;

procedure elegirEscalar();
	begin
		writeln('  A cual matriz quiere aplicar un escalar ?');
		seleccionarMatrizVariables(op1);
		
		writeln;
		writeln('  Cual es el valor del escalar ?');
		leerReal(valorLeido);
		
		mImp:= op1;
		nOperacion:= 31;
	end;

procedure elegirProducto();
	begin
		writeln('  Recuerde que el orden de las matrices en la operacion producto es MUY IMPORTANTE');
		writeln;
		writeln('  Cual es la primera matriz ?');
		seleccionarMatrizCompleto(op1);
		
		writeln;
		writeln('  Cual es la segunda matriz ?');
		seleccionarMatrizCompleto(op2);
		
		writeln;
		writeln('  Donde guardara el resultado ?');
		seleccionarMatrizVariables(op3);
		
		mImp:= op3;
		nOperacion:= 61;
	end;

procedure elegirTransposicion();
	begin
		writeln('  Cual matriz quiere transponer ?');
		seleccionarMatrizCompleto(op1);
		
		writeln;
		writeln('  Donde guardara el resultado ?');
		seleccionarMatrizVariables(op2);
		
		mImp:= op2;
		nOperacion:= 71;
	end;

procedure menuOperaciones();
	var
		opc: char;
		bConfirmacion: boolean;
	begin
		saltoLinea20(); saltoLinea20();
		writeln('  MENU Operaciones');
		writeln;
		writeln('  A continuacion elija lo que quiere hacer');
		writeln('    1 |  Ver Matriz');
		writeln('    2 |  Cargar Matriz');
		writeln('    3 |  Sumar - Restar  Matrices');
		writeln('    4 |  Aplicar Escalar a Matriz');
		if bSimetrica then begin
			writeln('    5 |  Producto de Matrices');
			writeln('    6 |  Transposicion de Matriz');
		end;
		writeln;
		writeln('    9 |  Volver al MENU Principal');
		writeln('    0 |  Cerrar Aplicacion');
		writeln;
		repeat
			write('  Opcion: ');readln(opc);
			bConfirmacion:= (bSimetrica and ((opc>= '0') and (opc<= '6')or (opc= '9'))) or
				((not bSimetrica) and ((opc>= '0') and (opc<= '4') or (opc= '9')));
			if bConfirmacion then begin
				saltoLinea20(); saltoLinea20();
				case opc of
					'1' :	elegirMostrar();
					'2' :	elegirCargar();
					'3' :	elegirSumarRestar();
					'4' :	elegirEscalar();
					'5' :	elegirProducto();
					'6' :	elegirTransposicion();
					'9' :	begin
								bConfig:= false;
								writeln;
								writeln('  Regresando al MENU Principal, presione Enter para continuar');
								readln;
							end;
					'0' :	bApp:= false;
				end;
			end
			else begin
				writeln('  Opcion no valida, intente nuevamente');
				writeln;
			end;
		until bConfirmacion;
	end;




//	CONFIGURACIONES MATRICES
procedure setearMatrices();
	begin
		if bSimetrica then
			crearMatrizIdentidad();
		//crearMatrizNula();
		mAux.m:= Base.m;
		mAux.n:= Base.n;
		crearMatriz(mAux);
		mA.m:= Base.m;
		mA.n:= Base.n;
		{mB.m:= Base.m;
		mB.n:= Base.n;
		mC.m:= Base.m;
		mC.n:= Base.n;
		mD.m:= Base.m;
		mD.n:= Base.n;
		mE.m:= Base.m;
		mE.n:= Base.n;}
		crearMatriz(mA);
		{crearMatriz(mB);
		crearMatriz(mC);
		crearMatriz(mD);
		crearMatriz(mE);}
	end;

procedure configurarMatriz();
	var
		bConfirmacion: boolean;
	begin
		bConfirmacion:= false;
		repeat
			saltoLinea20(); saltoLinea20();
			writeln('  TAMANO de matriz');
			writeln;
			writeln('  RECUERDE que la matriz mas pequena es de 1x1');
			writeln;
			writeln('  Cantidad de fila/s');
			leerEntero(Base.m);
			writeln('  Cantidad de columna/s');
			leerEntero(Base.n);
			if (Base.m> 0) and (Base.n> 0) then begin
				if Base.m<> Base.n then begin
					writeln('  La matriz no es cuadrada, por lo tanto no tendra Matriz diagonal,');
					writeln('  Identidad ni tampoco podra hacer producto de matrices')
				end;
				if Base.m * Base.n < 4000000 then
					writeln('  Esta seguro que quiere que su matriz sea de ',Base.m,' x ',Base.n,' ?')
				else begin
					writeln;
					writeln('  Con ',Base.m,' x ',Base.n,' dimension de matriz, va a exeder 1 GB de RAM');
					writeln('  Si continua con esas dimensiones acepta los posibles problemas asociados');
					writeln('  Confirme si quiere o no continuar con esas dimensiones');
				end;
				leerSiNo(bConfirmacion);
			end
			else
				writeln('  Las dimensiones tienen que ser mayores a 0');
			if not bConfirmacion then begin
				writeln('  Proceda a ingresar nuevamente los valores');
				enterContinuar();
			end;
		until bConfirmacion;
		bSimetrica:= Base.m = Base.n;
		Base.mxn:= nil;
		bConfig:= true;
	end;




//	MENU PRINCIPAL
procedure infoApp();
	begin
		saltoLinea20(); saltoLinea20();
		writeln('  Acerca de la Aplicacion');
		writeln;
		writeln('    El programa permite realizar operaciones en/entre matriz/ces.');
		writeln;
		writeln('    Para poder operar tendra que definir el tamano de las matrices');
		writeln('    con las que quiere trabajar, esto lo hara cuando comienze a');
		writeln('    operar. En caso de querer cambiar de tamano tendra que volver');
		writeln('    al Menu Principal y volver a comenzar con otras dimensiones');
		writeln;
		writeln('    Tiene la capacidad de cargar las matrices con las que opera,');
		writeln('    realizar operaciones con ellas o algunas preestablecidas y');
		writeln('    guardar los resultados en el caso de necesitarlos en el futuro');
		writeln;
		writeln('    Se puede operar con matrices cuadras y rectangulares.');
		writeln('    Si son cuadradas tendra todas las operaciones disponibles,');
		writeln('    en caso contrario estaran restringidas algunas de las');
		writeln('    operaciones para asegurar resultados correctos y confiables');
		writeln;
		writeln('  Para voler al MENU Ayuda, presione Enter');
		readln;
	end;

procedure infoConfigs();
	begin
		saltoLinea20(); saltoLinea20();
		writeln('  Configuraciones');
		writeln;
		writeln('    Tamano de Matriz/ces a trabajar:');
		writeln('      El tamano mas pequeno es de 1 x 1, el mas grande es cualquier');
		writeln('      dimension equivalente a 2800 x 2800');
		writeln('      Aclaracion:');
		writeln('        La progresion en cantidad de datos de una matriz de dos dimensiones como');
		writeln('        las que se disponen para trabajar, aumentan la cantidad de datos en forma');
		writeln('        cuadratica, por ente entre mas grande la matriz mas datos se tienen que');
		writeln('        procesar, esto puede ocasionar mayor consumo de recursos y tiempos mas ');
		writeln('        prolongados para el calculo de las operaciones y muestra de resultados');
		writeln;
		writeln('    Representacion numerica:');
		writeln('      Los valores de la matriz pueden pertenecer al campo de los');
		writeln('      reales, pero se mostraran como el entero mas cercano');
		writeln;
		writeln('    Datos:');
		writeln('      Dispone de un total de 5 variables para cargar matrices y/o');
		writeln('      guardar los resultados de las operaciones que realice');
		writeln('      Aclaraciones:');
		writeln('        Al aplicar un escalar sobre escribe la matriz');
		writeln('        En ciertas operaciones puede sobre escribir la matriz con el resultado');
		writeln;
		writeln('    Visualizacion:');
		writeln('      Puede visualizar las matrices del tamano que seleccione, por cuestiones de');
		writeln('      entendimiento claro de los datos no se recomienda superar las 25 filas y las');
		writeln('      25 columnas, de esta manera la disposicion entra en pantalla correctamente');
		writeln;
		writeln('  Para voler al MENU Ayuda, presione Enter');
		readln;
	end;

procedure infoOperaciones();
	begin
		saltoLinea20(); saltoLinea20();
		writeln('  Operaciones');
		writeln;
		writeln('    Visualizar');
		writeln('      Puede seleccionar cualquier matriz de la que dispone para ver los valores');
		writeln('      que contiene');
		writeln;
		writeln('    Cargar');
		writeln('      Puede elegir de que manera se cargan los valores de la matriz:');
		writeln('        Manual: se ingresan uno por uno los valores');
		writeln('        Valor constante: ingresa un unico valor para todos los valores');
		writeln('        Valores randoms: define un rango de enteros del cual se tomaran valores');
		writeln('        Copiar: elegi en que variable guardara los valores de otra matriz');
		writeln;
		writeln('    Suma - Resta');
		writeln('      Suma: elegi dos matrices para sumar sus valores y guardar el resultado');
		writeln('      Resta: elegi dos matrices para restar sus valores y guardar el resultado');
		writeln;
		writeln('    Escalar');
		writeln('      Dado un valor decimal, se multiplica cada valor de la matriz seleccionada');
		writeln('      por el valor ingresado,');
		writeln;
		writeln('    Diagonal');
		writeln('      Elegi una matriz para tomar los valores de la diagonal, el resto seran 0');
		writeln;
		writeln('    Triangulo');
		writeln('      Superior: elige una matriz para tomar los valores que esten en la diagonal y');
		writeln('      por encima de ella');
		writeln('      Inferior: elige una matriz para tomar los valores que esten en la diagonal y');
		writeln('      por debajo de ella');
		writeln;
		writeln('    Producto');
		writeln('      Se seleccionan dos matrices para realizar el producto entre ellas, la operacion');
		writeln('      no es conmutativa y en tamanos mayores a 500 x 500 puede demorar un poco');
		writeln;
		writeln('    Transposicion');
		writeln('      Se convierten las columnas de la matriz seleccionada en las filas de una matriz');
		writeln('      resultado');
		writeln;
		writeln('  Para voler al MENU Ayuda, presione Enter');
		readln;
	end;

procedure menuAyuda(var opc: char);
	begin
		repeat
			saltoLinea20(); saltoLinea20();
			writeln('  MENU Ayuda');
			writeln;
			writeln('  A continuacion elija sobre que informarse');
			writeln('    1 |  Acerca de la aplicacion');
			writeln('    2 |  Configuraciones');
			writeln('    3 |  Operaciones');
			writeln;
			writeln('    9 |  Volver al MENU Principal');
			writeln('    0 |  Cerrar Aplicacion');
			repeat
				writeln;
				write('  Opcion: ');readln(opc);
				case opc of
					'1' : 	infoApp();
					'2' : 	infoConfigs();
					'3' : 	infoOperaciones();
					'9' : 	begin
								writeln;
								writeln('  Regresando al MENU Principal, presione Enter para continuar');
								readln;
							end;
					'0' :  	bApp:= false;
					else
						writeln('  Opcion no valida, intente nuevamente');
				end;
			until (opc>= '0') and (opc<= '3') or (opc= '9');
		until (opc= '9') or (opc= '0');
	end;

procedure menuInicio();
	var
		opc: char;
	begin
		repeat
			resetearMatrices();
			saltoLinea20(); saltoLinea20();
			writeln;
			writeln('  MENU Principal');
			writeln;
			writeln('  A continuacion elija lo que quiera hacer');
			writeln('    1 |  Informacion');
			writeln('    2 |  Comenzar a operar con matrices');
			writeln('    0 |  Cerrar Aplicacion');
			repeat
				writeln;
				write('  Opcion: ');readln(opc);
				case opc of
					'1' : 	menuAyuda(opc);
					'2' : 	bApp:= true;
					'0' : 	bApp:= false;
					else
						writeln('  Opcion no valida, intente nuevamente');
				end;
			until (opc= '0') or (opc= '2') or (opc= '9');
		until (opc= '0') or (opc= '2');
	end;




//	MENSAJES
procedure msjInicio();
	begin
		writeln; writeln;
		writeln('  Operando con Matrices');
		writeln('                       en Pascal');
		writeln;
		writeln;
		enterContinuar();
	end;

procedure msjFinal();
	begin
		saltoLinea20(); saltoLinea20();
		writeln('                Gracias por usar la app');
		writeln;
		writeln('                                        Josue Suarez');
		writeln;
		writeln;
		writeln('  Presione Enter para cerrar la ventana');
		readln;
	end;



//	PROGRAMA PRINCIPAL
begin
	presets();
	msjInicio();
	menuInicio();
	while bApp do begin
		configurarMatriz();
		setearMatrices();
		menuOperaciones();
		while bApp and bConfig do begin
			saltoLinea20(); saltoLinea20();
			realizarOperacion();
			imprimirMatriz(mImp);
			enterContinuar();
			menuOperaciones();
		end;
		if bApp then
			menuInicio();
	end;
	msjFinal();
end.
