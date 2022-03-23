const
	TAM_R2= 20;
	PIXEL_DEFAULT_PLANO= '*';
	DECIMALES_DEFAULT_NUMEROS= 0;



type
	plano= array[-TAM_R2..TAM_R2,-TAM_R2..TAM_R2] of char;




var
	bApp: boolean;
	pVacio,pImp: plano;
	pixel: char;
	resNum: word;




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
		else if x=0 then
			raiz:=0
		else raiz:= -1;
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




// CONFIGURACIONES DEFAULTS
procedure iniPlanoDefault();
	var
		x,y: integer;
	begin
		for y:= TAM_R2 downto -TAM_R2 do
			for x:= -TAM_R2 to TAM_R2 do
				pVacio[y][x]:= ' ';
		for y:= TAM_R2 downto -TAM_R2 do
			if (y mod 5) = 0 then
				pVacio[y][0]:= '-';
		for x:= -TAM_R2 to TAM_R2 do
			if (x mod 5) = 0 then
				pVacio[0][x]:= '|';
		pVacio[0][0]:= '+';
	end;

procedure presetsGeometria();
	begin
		pixel:= PIXEL_DEFAULT_PLANO;
		resNum:= DECIMALES_DEFAULT_NUMEROS;
		iniPlanoDefault();
	end;




// PLANO
procedure imprimirPlano();
	var
		x,y: integer;
	begin
		writeln('  RECUERDE ESTO ES UNA REPRESENTACION GRAFICA APROXIMADA');
		writeln('  +                                         Y                                         +');
		for y:= TAM_R2 downto 1 do begin
			write('    ');
			for x:= -TAM_R2 to TAM_R2 do
				write(pImp[y][x],' ');
			writeln;
		end;
		write(' -X ');
		for x:= -TAM_R2 to TAM_R2 do
			write(pImp[0][x],' ');
		writeln('X');
		for y:= -1 downto -TAM_R2 do begin
			write('    ');
			for x:= -TAM_R2 to TAM_R2 do
				write(pImp[y][x],' ');
			writeln;
		end;
		writeln('  +                                        -Y                                         +');
	end;

function quePixel(m: real): char;
	begin
		if m> 5 then 
			quePixel:= '|'
		else if m> 0.5 then
			quePixel:= '/'
		else if m> -0.5 then
			quePixel:= '-'
		else if m> -5 then
			quePixel:= '\'
		else
			quePixel:= '|';
	end;

procedure actPlanoPunto(ax,ay: real);
	var
		x,y: integer;
	begin
		x:= -TAM_R2;
		while ((x+0.5)<= ax) and (x<= TAM_R2) do
			x:= x +1;
		y:= TAM_R2;
		while ((y-0.5)>= ay) and (y>= -TAM_R2) do
			y:= y -1;
		if ((x-0.5)<= ax) and ((x+0.5)> ax) and ((y-0.5)<= ay) and ((y+0.5)> ay) and (x<= TAM_R2) and (y>= -TAM_R2) then
			pImp[y][x]:= 'O';
	end;

procedure actPlanoRecta(funcion: boolean; m,b: real);
	var
		x,y: integer;
		aux: real;
	begin
		if funcion then begin
			if (m> 1) or (m<-1) then
				for y:= TAM_R2 downto -TAM_R2 do begin
					aux:= (y-b)/m;
					for x:= -TAM_R2 to TAM_R2 do
						if ((x-0.5)<= aux) and ((x+0.5)> aux) then
							pImp[y][x]:= pixel;
				end
			else
				for x:= -TAM_R2 to TAM_R2 do begin
					aux:= m*x + b;
					for y:= TAM_R2 downto -TAM_R2 do
						if ((y-0.5)<= aux) and ((y+0.5)> aux) then
							pImp[y][x]:= pixel;
				end;
		end
		else begin
			x:= -TAM_R2;
			while ((x+0.5)<= b) and (x<= TAM_R2) do
				x:= x +1;
			if ((x-0.5)<= b) and ((x+0.5)> b) and (x<= TAM_R2) then
				for y:= TAM_R2 downto -TAM_R2 do
					pImp[y][x]:= pixel;
		end;
	end;

procedure actPlanoParabola(vertical: boolean; c: real; xv,yv: integer);
	var
		x,y: integer;
		aux: real;
	begin
		if vertical then begin
			for y:= TAM_R2 downto -TAM_R2 do begin
				aux:= raiz(2,4*c*(y-yv));
				if aux>-1 then begin
					aux:= -aux + xv;
					for x:= -TAM_R2 to xv do
						if ((x-0.5)<= aux) and ((x+0.5)> aux) then
							pImp[y][x]:= pixel;
				end;
			end;
			for y:= TAM_R2 downto -TAM_R2 do begin
				aux:= raiz(2,4*c*(y-yv));
				if aux>-1 then begin
					aux:= aux + xv;
					for x:= xv to TAM_R2 do
						if ((x-0.5)<= aux) and ((x+0.5)> aux) then
							pImp[y][x]:= pixel;
				end;
			end;
		end
		else begin
			for x:= -TAM_R2 to TAM_R2 do begin
				aux:= raiz(2,4*c*(x-xv));
				if aux>-1 then begin
					aux:= aux + yv;
					for y:= TAM_R2 downto yv do
						if ((y-0.5)<= aux) and ((y+0.5)> aux) then
							pImp[y][x]:= pixel;
				end;
			end;
			for x:= -TAM_R2 to TAM_R2 do begin
				aux:= raiz(2,4*c*(x-xv));
				if aux>-1 then begin
					aux:= -aux + yv;
					for y:= yv downto -TAM_R2 do
						if ((y-0.5)<= aux) and ((y+0.5)> aux) then
							pImp[y][x]:= pixel;
				end;
			end;
		end;
	end;

procedure actPlanoCircunferencia(r: real; a,b: integer);
	var
		x,y: integer;
		r2,aux: real;
	begin
		r2:= r*r;
		for x:= -TAM_R2 to TAM_R2 do begin
			aux:= raiz(2,r2- (x-a)*(x-a));
			if aux>-1 then begin
				aux:= aux + b;
				for y:= TAM_R2 downto b do
					if ((y-0.5)<= aux) and ((y+0.5)> aux) then
						pImp[y][x]:= pixel;
			end;
		end;
		for y:= TAM_R2 downto b do begin
			aux:= raiz(2,r2- (y-b)*(y-b));
			if aux>-1 then begin
				aux:= -aux + a;
				for x:= -TAM_R2 to a do
					if ((x-0.5)<= aux) and ((x+0.5)> aux) then
						pImp[y][x]:= pixel;
				aux:= -aux+ 2*a;
				for x:= a to TAM_R2 do
					if ((x-0.5)<= aux) and ((x+0.5)> aux) then
						pImp[y][x]:= pixel;
			end;
		end;
		for x:= -TAM_R2 to TAM_R2 do begin
			aux:= raiz(2,r2- (x-a)*(x-a));
			if aux>-1 then begin
				aux:= -aux + b;
				for y:= b downto -TAM_R2 do
					if ((y-0.5)<= aux) and ((y+0.5)> aux) then
						pImp[y][x]:= pixel;
			end;
		end;
		for y:= b downto -TAM_R2 do begin
			aux:= raiz(2,r2- (y-b)*(y-b));
			if aux>-1 then begin
				aux:= -aux + a;
				for x:= -TAM_R2 to a do
					if ((x-0.5)<= aux) and ((x+0.5)> aux) then
						pImp[y][x]:= pixel;
				aux:= -aux+ 2*a;
				for x:= a to TAM_R2 do
					if ((x-0.5)<= aux) and ((x+0.5)> aux) then
						pImp[y][x]:= pixel;
			end;
		end;
	end;




// HERRAMIENTAS
procedure vaciarPlano();
	begin
		saltosLinea30();
		pImp:= pVacio;
		writeln('  Plano vaciado con exito');
		enterContinuar();
	end;
procedure leerPuntoReal(frase: string; var x,y: real);
	begin
		writeln(frase);
		leerReal('    Coordena en eje x: ',x);
		leerReal('    Coordena en eje y: ',y);
	end;
procedure leerPuntoEntero(frase: string; var x,y: integer);
	begin
		writeln(frase);
		leerEntero('    Coordena en eje x: ',x);
		leerEntero('    Coordena en eje y: ',y);
	end;
procedure leerRectaVH(frase: string; var vertical: boolean; var v: integer);
	var
		opc: char;
	begin
		writeln(frase);
		writeln;
		writeln('  Cual es su direccion');
		writeln('    H -  Horizontal');
		writeln('    V -  Vertical');
		writeln;
		repeat
			write('  Opcion: '); readln(opc);
			vertical:= (opc= 'V') or (opc= 'H');
			if not vertical then begin
				writeln('  Entrada invalida, presione Enter para volver a intentar');
				write('  '); readln;
			end;
		until vertical;
		vertical:= opc= 'V';
		writeln;
		writeln('  En que valor esta la recta');
		if vertical then
			leerEntero('    X= ',v)
		else
			leerEntero('    Y= ',v)
	end;




// PUNTO
procedure colocarPunto();
	var
		ok: boolean;
		x,y: real;
	begin
		repeat
			saltosLinea30();
			leerPuntoReal('  Ingrese el punto a colocar',x,y);
			ok:= (x>= -TAM_R2) and (x<= TAM_R2) and (y<= TAM_R2) and (y>= -TAM_R2);
			if not ok then begin
				writeln('  Recuerde que el punto tiene que tener cordenadas dentro del rango [',-TAM_R2,',',TAM_R2,']');
				write('  '); readln;
			end
		until ok;
		actPlanoPunto(x,y);
		writeln;
		writeln('  Se coloco el punto (',x:0:resNum,',',y:0:resNum,') en el plano con exito');
		imprimirPlano();
		enterContinuar();
	end;

procedure distanciaPuntos();
	var
		x1,x2,y1,y2,d: real;
	begin
		saltosLinea30();
		leerPuntoReal('  Ingrese el punto 1',x1,y1);
		writeln;
		leerPuntoReal('  Ingrese el punto 2',x2,y2);
		d:= raiz(2,pot(x2-x1,2)+pot(y2-y1,2));
		writeln;
		writeln('  La distancia entre (',x1:0:resNum,',',y1:0:resNum,') y (',x2:0:resNum,',',y2:0:resNum,') es de: ',d:0:2);
		enterContinuar();
	end;

procedure puntoMedio();
	var
		x1,x2,xM,y1,y2,yM: real;
	begin
		saltosLinea30();
		leerPuntoReal('  Ingrese el punto 1',x1,y1);
		writeln;
		leerPuntoReal('  Ingrese el punto 2',x2,y2);
		xM:= (x1 + x2)/2;
		yM:= (y1 + y2)/2;
		writeln;
		writeln('  El punto medio entre (',x1:0:resNum,',',y1:0:resNum,') y (',x2:0:resNum,',',y2:0:resNum,')');
		writeln('  se encuentra en: (',xM:0:resNum,',',yM:0:resNum,')');
		enterContinuar();
	end;

procedure geometriaPunto();
	var
		bTema: boolean;
		opc: char;
	begin
		bTema:= true;
		pImp:= pVacio;
		repeat
			saltosLinea30();
			writeln('  MENU PUNTOS');
			writeln;
			writeln('  Ingrese la letra de la herramienta');
			writeln;
			writeln('    A -  Graficar');
			writeln('    B -  Calcular distancia entre puntos');
			writeln('    C -  Calcular punto medio');
			writeln;
			writeln('    D -  Vaciar Plano');
			writeln('    E -  Volver al Menu Geometria');
			leerOpcion('A','E',opc);
			case opc of
				'A':	colocarPunto();
				'B':	distanciaPuntos();
				'C':	puntoMedio();
				'D':	vaciarPlano();
				'E':	bTema:= false;
			end;
		until not bTema;
	end;




// RECTA
procedure pendienteOrdenada(var funcion: boolean; var m,b: real);
	begin
		leerReal('  Pendiente: ',m);
		leerReal('  Ordenada: ',b);
		funcion:= true;
	end;
procedure pendientePunto(var funcion: boolean; var m,b: real);
	var
		x,y: real;
	begin
		leerReal('  Pendiente: ',m);
		leerPuntoReal('  Punto perteneciente a la recta',x,y);
		b:= y - m*x;
		funcion:= true;
	end;
procedure dosPuntos(var funcion: boolean; var m,b: real);
	var
		x1,x2,y1,y2: real;
	begin
		leerPuntoReal('  Punto 1 perteneciente a la recta',x1,y1);
		writeln;
		leerPuntoReal('  Punto 2 perteneciente a la recta',x2,y2);
		if x1<> x2 then begin
			m:= (y2 - y1)/(x2 - x1);
			b:= y1 - m*x1;
			funcion:= true;
		end
		else begin
			m:= 0;
			b:= x1;
			funcion:= false;
		end;
	end;
procedure ecuacionRecta(var funcion: boolean; var m,b: real);
	begin
		funcion:= true;
		m:= 1;
		b:= 0;
		writeln('  Sin hacer');
		write('  '); readln;
	end;
procedure leerRecta(frase: string; var funcion: boolean; var m,b: real);
	var
		opc: char;
	begin
		writeln(frase);
		writeln;
		writeln('  Que datos tiene de la recta');
		writeln;
		writeln('    A -  Pendiente y ordenada');
		writeln('    B -  Pendiente y punto');
		writeln('    C -  Dos puntos');
		writeln('    D -  Ecuacion');
		leerOpcion('A','D',opc);
		writeln;
		writeln;
		case opc of
			'A':	pendienteOrdenada(funcion,m,b);
			'B':	pendientePunto(funcion,m,b);
			'C':	dosPuntos(funcion,m,b);
			'D':	ecuacionRecta(funcion,m,b);
		end;
	end;


procedure formulasRecta();
	var
		funcion: boolean;
		m,b: real;
		y2: real;
	begin
		saltosLinea30();
		leerRecta('  Ingrese la recta a calcular algunas de sus formulas',funcion,m,b);
		y2:= m*3 + b;
		writeln;
		writeln;
		writeln('  Las formulas para la recta dada son');
		writeln;
		writeln('    Ecuacion punto pendiente:');
		writeln('                             Punto: (',3.:0:resNum,',',y2:0:resNum,')');
		writeln('                             y - (',y2:0:resNum,') = ',m:0:resNum,'(X - ',3.:0:resNum,')');
		writeln;
		writeln('    Ecuacion general:');
		writeln('                     Y + (',-m:0:resNum,'X) + (',-b:0:resNum,') = 0');
		writeln;
		writeln('    Ecuacion explicita:');
		writeln('                       Y = ',m:0:resNum,'X + (',b:0:resNum,')');
		enterContinuar();
	end;

procedure colocarRecta();
	var
		funcion: boolean;
		m,b: real;
	begin
		saltosLinea30();
		leerRecta('  Ingrese la recta a graficar',funcion,m,b);
		actPlanoRecta(funcion,m,b);
		writeln;
		writeln;
		imprimirPlano();
		enterContinuar();
	end;

procedure calcularParalela();
	var
		funcion: boolean;
		m1,b1,b2,x,y: real;
	begin
		pImp:= pVacio;
		saltosLinea30();
		leerRecta('  Ingrese la recta base',funcion,m1,b1);
		actPlanoRecta(funcion,m1,b1);
		writeln;
		writeln;
		leerPuntoReal('  Ingrese 1 punto para calcular la paralela a la recta base',x,y);
		if funcion then
			b2:= y - m1*x
		else
			b2:= x;
		actPlanoRecta(funcion,m1,b2);
		writeln;
		writeln;
		imprimirPlano();
		writeln;
		if funcion then begin
			writeln('  Recta base: Y = ',m1:0:resNum,'X + (',b1:0:resNum,')');
			writeln('  Recta paralela: Y = ',m1:0:resNum,'X + (',b2:0:resNum,')');
		end
		else begin
			writeln('  Recta base: X = ',b1:0:resNum);
			writeln('  Recta paralela: X = ',b2:0:resNum);
		end;
		enterContinuar();
	end;

procedure calcularPerpendicular();
	var
		funcion1, funcion2: boolean;
		m1,m2,b1,b2,x,y: real;
	begin
		pImp:= pVacio;
		saltosLinea30();
		leerRecta('  Ingrese la recta base',funcion1,m1,b1);
		actPlanoRecta(funcion1,m1,b1);
		writeln;
		writeln;
		leerPuntoReal('  Ingrese 1 punto para calcular la perpendicular a la recta base',x,y);
		if funcion1 then begin
			if m1<> 0 then begin
				funcion2:= true;
				m2:= -1/m1;
				b2:= y - m2*x
			end
			else begin
				funcion2:= false;
				m2:= 0;
				b2:= x;
			end;
		end
		else begin
			funcion2:= true;
			m2:= 0;
			b2:= y;
		end;
		actPlanoRecta(funcion2,m2,b2);
		writeln;
		writeln;
		imprimirPlano();
		writeln;
		if funcion1 then begin
			writeln('  Recta base: Y = ',m1:0:resNum,'X + (',b1:0:resNum,')');
			if funcion2 then
				writeln('  Recta perpendicular: Y = ',m2:0:resNum,'X + (',b2:0:resNum,')')
			else
				writeln('  Recta perpendicular: X = ',b2:0:resNum);
		end
		else begin
			writeln('  Recta base: X = ',b1:0:resNum);
			writeln('  Recta perpendicular: Y = ',b2:0:resNum);
		end;
		enterContinuar();
	end;

procedure interseccionRectas();
	var
		funcion1, funcion2: boolean;
		m1,m2,b1,b2,x,y: real;
	begin
		pImp:= pVacio;
		saltosLinea30();
		leerRecta('  Ingrese la primera recta',funcion1,m1,b1);
		actPlanoRecta(funcion1,m1,b1);
		writeln;
		writeln;
		leerRecta('  Ingrese la segunda recta',funcion2,m2,b2);
		actPlanoRecta(funcion2,m2,b2);
		writeln;
		writeln;
		imprimirPlano();
		writeln;
		if (funcion1= funcion2) and (m1= m2) then begin
			if b1= b2 then
				writeln('  Las rectas son coincidentes, intersectan en todos sus puntos')
			else
				writeln('  Las rectas son paralelas, no intersectan nunca')
		end
		else begin
			if funcion1 then begin
				if m1<> 0 then begin
					x:= (b2-b1)/(m1-m2);
					y:= m1*x + b1;
				end
				else begin
					x:= b2;
					y:= b1;
				end
			end
			else begin
				x:= b1;
				y:= b2;
			end;
			writeln('  Las rectas son transversales ya que se intersectan unicamente');
			writeln('  en el punto (',x:0:resNum,',',y:0:resNum,')');
		end;
		enterContinuar();
	end;


procedure geometriaRecta();
	var
		bTema: boolean;
		opc: char;
	begin
		bTema:= true;
		pImp:= pVacio;
		repeat
			saltosLinea30();
			writeln('  MENU RECTAS');
			writeln;
			writeln('  Ingrese la letra de la herramienta');
			writeln;
			writeln('    A -  Calcular formulas');
			writeln('    B -  Graficar');
			writeln('    C -  Calcular paralela');
			writeln('    D -  Calcular perpendicular');
			writeln('    E -  Calcular interseccion');
			writeln;
			writeln('    F -  Vaciar Plano');
			writeln('    G -  Volver al Menu Geometria');
			leerOpcion('A','G',opc);
			case opc of
				'A':	formulasRecta();
				'B':	colocarRecta();
				'C':	calcularParalela();
				'D':	calcularPerpendicular();
				'E':	interseccionRectas();
				'F':	vaciarPlano();
				'G':	bTema:= false;
			end;
		until not bTema;
	end;




// CIRCUNFERENCIA
procedure radioCentro(var r: real; var a,b: integer);
	begin
		writeln('  A fines de simplificacion, los centros solo pueden ser de valores enteros');
		writeln;
		leerReal('  Radio: ',r);
		leerPuntoEntero('  Ingrese el centro para la circunferencia',a,b);
	end;
procedure diametroCentro(var r: real; var a,b: integer);
	begin
		writeln('  A fines de simplificacion, los centros solo pueden ser de valores enteros');
		writeln;
		leerReal('  Diametro: ',r);
		r:= r/2;
		leerPuntoEntero('  Ingrese el centro para la circunferencia',a,b);
	end;
procedure ecuacionCircunferencia(var r: real; var a,b: integer);
	begin
		r:= 1;
		a:= 0;
		b:= 0;
		writeln('  Sin hacer');
		write('  '); readln;
	end;
procedure leerCircunferencia(frase: string; var r: real; var a,b: integer);
	var
		opc: char;
	begin
		writeln(frase);
		writeln;
		writeln('    A -  Radio y centro');
		writeln('    B -  Diametro y centro');
		writeln('    C -  Ecuacion');
		leerOpcion('A','C',opc);
		writeln;
		writeln;
		case opc of
			'A':	radioCentro(r,a,b);
			'B':	diametroCentro(r,a,b);
			'C':	ecuacionCircunferencia(r,a,b);
		end;
	end;


procedure formulaCircunferencia();
	var
		r: real;
		a,b: integer;
	begin
		saltosLinea30();
		leerCircunferencia('  Ingrese los datos para la formula',r,a,b);
		writeln;
		writeln;
		writeln('  La ecuacion estandar es:');
		writeln('                          (X - (',a,'))^2 + (Y - (',b,'))^2 = ',r:0:resNum,'^2');
		enterContinuar();
	end;

procedure colocarCircunferencia();
	var
		r: real;
		a,b: integer;
	begin
		saltosLinea30();
		leerCircunferencia('  Ingrese la circunferencia a graficar',r,a,b);
		actPlanoCircunferencia(r,a,b);
		writeln;
		writeln;
		imprimirPlano();
		enterContinuar();
	end;

procedure interseccionCircunferencia();
	var
		funcion: boolean;
		r,m,o,c1,c2,c3,dsc,x1,x2,y1,y2: real;
		a,b: integer;
	begin
		pImp:= pVacio;
		saltosLinea30();
		leerCircunferencia('  Ingrese la circunferencia',r,a,b);
		actPlanoCircunferencia(r,a,b);
		writeln;
		writeln;
		leerRecta('  Ingrese la recta',funcion,m,o);
		actPlanoRecta(funcion,m,o);
		writeln;
		writeln;
		c1:= 1 + m*m;
		c2:= -2*a + 2*(o-b)*m;
		c3:= a*a + (o-b)*(o-b) - r*r;
		dsc:= c2*c2 - 4*c1*c3;
		if dsc>=0 then begin
			dsc:= raiz(2,dsc);
			x1:= (-c2 + dsc)/(2*c1);
			y1:= m*x1 + o;
			actPlanoPunto(x1,y1);
			if dsc<>0 then begin
				x2:= (-c2 - dsc)/(2*c1);
				y2:= m*x2 + o;
				actPlanoPunto(x2,y2);
				imprimirPlano();
				writeln;
				writeln('  La circunferencia y la recta se intersectan en los puntos');
				writeln('    A: (',x1:0:resNum,',',y1:0:resNum,')');
				writeln('    B: (',x2:0:resNum,',',y2:0:resNum,')');
			end
			else begin
				imprimirPlano();
				writeln;
				writeln('  La circunferencia y la recta se intersectan en el punto');
				writeln('    A: (',x1:0:resNum,',',y1:0:resNum,')');
			end;	
		end
		else begin
			imprimirPlano();
			writeln;
			writeln('  La circunferencia y la recta no se intersectan en ningun punto');
		end;
		enterContinuar();
	end;


procedure geometriaCircunferencia();
	var
		bTema: boolean;
		opc: char;
	begin
		bTema:= true;
		pImp:= pVacio;
		repeat
			saltosLinea30();
			writeln('  MENU CIRCUNFERENCIAS');
			writeln;
			writeln('  Ingrese la letra de la herramienta');
			writeln;
			writeln('    A -  Calcular formula');
			writeln('    B -  Graficar');
			writeln('    C -  Calcular interseccion con recta');
			writeln;
			writeln('    D -  Vaciar Plano');
			writeln('    E -  Volver al Menu Geometria');
			leerOpcion('A','E',opc);
			case opc of
				'A':	formulaCircunferencia();
				'B':	colocarCircunferencia();
				'C':	interseccionCircunferencia();
				'D':	vaciarPlano();
				'E':	bTema:= false;
			end;
		until not bTema;
	end;




// PARABOLA
procedure ejeDistFocalVertice(var vertical: boolean; var c: real; var xv,yv: integer);
	var
		vEnt: integer;
	begin
		writeln('  A fines de simplificacion, los puntos solo pueden ser de valores enteros');
		writeln;
		leerRectaVH('  Ingrese la recta del eje focal',vertical,vEnt);
		writeln;
		writeln;
		leerReal('  Distancia focal: ',c);
		writeln;
		writeln;
		leerPuntoEntero('  Vertice',xv,yv);
	end;
procedure ejeDistFocalFoco(var vertical: boolean; var c: real; var xv,yv: integer);
	var
		cEnt: integer;
	begin
		writeln('  A fines de simplificacion, los puntos solo pueden ser de valores enteros');
		writeln;
		leerRectaVH('  Ingrese la recta del eje focal',vertical,cEnt);
		writeln;
		writeln;
		leerEntero('  Distancia focal: ',cEnt);
		writeln;
		writeln;
		leerPuntoEntero('  Foco',xv,yv);
		if vertical then
			yv:= yv - cEnt
		else
			xv:= xv - cEnt;
		c:= cEnt;
	end;
procedure directrizVertice(var vertical: boolean; var c: real; var xv,yv: integer);
	var
		vEnt: integer;
	begin
		writeln('  A fines de simplificacion, los puntos solo pueden ser de valores enteros');
		writeln;
		leerRectaVH('  Ingrese la recta directriz',vertical,vEnt);
		writeln;
		writeln;
		leerPuntoEntero('  Vertice',xv,yv);
		if vertical then begin
			c:= vEnt - xv;
			if c<0 then
				c:= -c;
			if vEnt> xv then
				c:= -c;
		end
		else begin
			c:= vEnt - yv;
			if c<0 then
				c:= -c;
			if vEnt> yv then
				c:= -c;
		end;
		vertical:= not vertical;
	end;
procedure directrizFoco(var vertical: boolean; var c: real; var xv,yv: integer);
	var
		vEnt: integer;
	begin
		writeln('  A fines de simplificacion, los puntos solo pueden ser de valores enteros');
		writeln;
		leerRectaVH('  Ingrese la recta directriz',vertical,vEnt);
		writeln;
		writeln;
		leerPuntoEntero('  Foco',xv,yv);
		if vertical then begin
			xv:= vEnt - ((vEnt - xv) div 2);
			c:= (vEnt - xv) div 2;
			if c<0 then
				c:= -c;
			if vEnt> xv then
				c:= -c;
		end
		else begin
			yv:= vEnt - ((vEnt - yv) div 2);
			c:= (vEnt - yv) div 2;
			if c<0 then
				c:= -c;
			if vEnt> yv then
				c:= -c;
		end;
		vertical:= not vertical;
	end;
procedure focoVertice(var vertical: boolean; var c: real; var xv,yv: integer);
	var
		ok: boolean;
		xf,yf: integer;
	begin
		repeat
			ok:= true;
			writeln('  A fines de simplificacion, los puntos solo pueden ser de valores enteros');
			writeln;
			leerPuntoEntero('  Foco',xf,yf);
			writeln;
			writeln;
			leerPuntoEntero('  Vertice',xv,yv);
			if xf= xv then begin
				vertical:= true;
				c:= yf - yv;
			end
			else if yf= yv then begin
				vertical:= false;
				c:= xf - xv;
			end
			else begin
				ok:= false;
				writeln;
				writeln('  El foco y el vertice tienen que estar alineados horizontal o verticalmente');
				writeln('  Presione Enter para volver a cargar los datos');
				write('  '); readln;
			end;
		until ok;
	end;
procedure verticePuntos(var vertical: boolean; var c: real; var xv,yv: integer);
	var
		ok: boolean;
		x1,x2,y1,y2: integer;
		c2: real;
	begin
		writeln('  A fines de simplificacion, los puntos solo pueden ser de valores enteros');
		writeln;
		leerPuntoEntero('  Vertice',xv,yv);
		writeln;
		writeln;
		leerPuntoEntero('  Punto 1',x1,y1);
		writeln;
		writeln;
		leerPuntoEntero('  Punto 2',x2,y2);
		if (y1>= yv) and (y2>= yv) or (y1<= yv) and (y2<= yv) then begin
			vertical:= true;
			c:= (pot(x1-xv,2))/(4*(y1-yv));
			c2:= (pot(x2-xv,2))/(4*(y2-yv));
			if (c-0.25<= c2) and (c+0.25>= c2) then
				ok:= true
			else
				ok:= false;
		end
		else if (x1>= xv) and (x2>= xv) or (x1<= xv) and (x2<= xv) then begin
			vertical:= false;
			c:= (pot(y1-yv,2))/(4*(x1-xv));
			c2:= (pot(y2-yv,2))/(4*(x2-xv));
			if (c-0.25<= c2) and (c+0.25>= c2) then
				ok:= true
			else
				ok:= false;
		end
		else
			ok:= false;
		writeln;
		if ok then begin
			writeln('  La parabola de ecuacion');
			if vertical then
				writeln('                         (X - (',xv,'))^2 = 4.(',c:0:resNum,').(Y - (',yv,'))')
			else
				writeln('                         (X - (',xv,'))^2 = 4.(',c:0:resNum,').(Y - (',yv,'))');
				writeln;
			writeln('  Contiene al vertice y puntos ingresados');
		end
		else begin
			writeln('  No existe parabola que pase por el verice y los dos puntos');
			writeln('  Se completo con una parabola generica');
			enterContinuar();
			c:= 1;
			xv:= 0;
			yv:= 0;
		end;
	end;
procedure ecuacionParabola(var vertical: boolean; var c: real; var xv,yv: integer);
	begin
		vertical:= true;
		c:= 1;
		xv:= 0;
		yv:= 0;
		writeln('  Sin hacer');
		write('  '); readln;
	end;
procedure leerParabola(frase: string; var vertical: boolean; var c: real; var xv,yv: integer);
	var
		opc: char;
	begin
		writeln(frase);
		writeln;
		writeln('    A -  Eje focal, distancia focal y vertice');
		writeln('    B -  Eje focal, distancia focal y foco');
		writeln('    C -  Directriz y vertice');
		writeln('    D -  Directriz y foco');
		writeln('    E -  Foco y vertice');
		writeln('    F -  Vertice y 2 puntos');
		writeln('    G -  Ecuacion');
		leerOpcion('A','G',opc);
		writeln;
		writeln;
		case opc of
			'A':	ejeDistFocalVertice(vertical,c,xv,yv);
			'B':	ejeDistFocalFoco(vertical,c,xv,yv);
			'C':	directrizVertice(vertical,c,xv,yv);
			'D':	directrizFoco(vertical,c,xv,yv);
			'E':	focoVertice(vertical,c,xv,yv);
			'F':	verticePuntos(vertical,c,xv,yv);
			'G':	ecuacionParabola(vertical,c,xv,yv);
		end;
	end;


procedure formulaParabola();
	var
		vertical: boolean;
		c: real;
		xv,yv: integer;
	begin
		saltosLinea30();
		leerParabola('  Ingrese los datos',vertical,c,xv,yv);
		writeln;
		writeln;
		writeln('  La ecuacion estandar es:');
		if vertical then
			writeln('                          (X - (',xv,'))^2 = 4.(',c:0:resNum,').(Y - (',yv,'))')
		else
			writeln('                          (X - (',xv,'))^2 = 4.(',c:0:resNum,').(Y - (',yv,'))');
		enterContinuar();
	end;

procedure colocarParabola();
	var
		vertical: boolean;
		c: real;
		xv,yv: integer;
	begin
		saltosLinea30();
		leerParabola('  Ingrese la parabola a graficar',vertical,c,xv,yv);
		actPlanoParabola(vertical,c,xv,yv);
		writeln;
		writeln;
		imprimirPlano();
		enterContinuar();
	end;

procedure interseccionParabola();
	var
		vertical,funcion: boolean;
		c,m,o,c2,c3,dsc,x1,x2,y1,y2: real;
		xv,yv: integer;
	begin
		pImp:= pVacio;
		saltosLinea30();
		leerParabola('  Ingrese la parabola',vertical,c,xv,yv);
		actPlanoParabola(vertical,c,xv,yv);
		writeln;
		writeln;
		leerRecta('  Ingrese la recta',funcion,m,o);
		actPlanoRecta(funcion,m,o);
		writeln;
		writeln;
		if vertical then begin
			c2:= -2*xv -4*c*m;
			c3:= xv*xv -4*c*(o - yv);
			dsc:= c2*c2 - 4*c3;
		end
		else begin
			c2:= -2*xv -4*c*m;
			c3:= xv*xv -4*c*(o - yv);
			dsc:= c2*c2 - 4*c3;
		end;
		if dsc>=0 then begin
			dsc:= raiz(2,dsc);
			x1:= (-c2 + dsc)/2;
			y1:= m*x1 + o;
			actPlanoPunto(x1,y1);
			if dsc<>0 then begin
				x2:= (-c2 - dsc)/2;
				y2:= m*x2 + o;
				actPlanoPunto(x2,y2);
				imprimirPlano();
				writeln;
				writeln('  La parabola y la recta se intersectan en los puntos');
				writeln('    A: (',x1:0:resNum,',',y1:0:resNum,')');
				writeln('    B: (',x2:0:resNum,',',y2:0:resNum,')');
			end
			else begin
				imprimirPlano();
				writeln;
				writeln('  La parabola y la recta se intersectan en el punto');
				writeln('    A: (',x1:0:resNum,',',y1:0:resNum,')');
			end;	
		end
		else begin
			imprimirPlano();
			writeln;
			writeln('  La parabola y la recta no se intersectan en ningun punto');
		end;
		enterContinuar();
	end;

procedure geometriaParabola();
	var
		bTema: boolean;
		opc: char;
	begin
		bTema:= true;
		pImp:= pVacio;
		repeat
			saltosLinea30();
			writeln('  MENU PARABOLA');
			writeln;
			writeln('  Ingrese la letra de la herramienta');
			writeln;
			writeln('    A -  Calcular formula');
			writeln('    B -  Graficar');
			writeln('    C -  Calcular interseccion con recta');
			writeln;
			writeln('    D -  Vaciar Plano');
			writeln('    E -  Volver al Menu Geometria');
			leerOpcion('A','E',opc);
			case opc of
				'A':	formulaParabola();
				'B':	colocarParabola();
				'C':	interseccionParabola();
				'D':	vaciarPlano();
				'E':	bTema:= false;
			end;
		until not bTema;
	end;




// CONFIGURACIONES
procedure cambiarPixelPlano();
	var
		opc: char;
		ok: boolean;
	begin
		repeat
			saltosLinea30();
			writeln('  Actualmente el plano se marca con: ',pixel,' para el dibujado de');
			writeln('  puntos, rectas, circunferencias y parabolas');
			writeln;
			writeln('  Ingrese el nuevo estilo de marca');
			write('  Caracter: '); readln(opc);
			writeln;
			writeln('  Esta seguro que quiere que la nueva marca sea: ', opc);
			leerSiNo(ok);
			if not ok then begin
				writeln('  Vuelve a ingresar el estilo de marca');
				write('  '); readln;
			end;
		until ok;
		pixel:= opc;
		writeln('  Estilo de marca actualizada con exito');
		enterContinuar;
	end;

procedure cambiarResolucionNumeros();
	var
		n: word;
	begin
		saltosLinea30();
		writeln('  Actualmente la cantidad de decimales para ver los numeros es: ',resNum);
		writeln;
		writeln('  Ingrese la nueva cantidad de decimales, desde 0 en adelante');
		leerNatural('  Cantidad: ',n);
		resNum:= n;
		writeln;
		writeln('  Resolucion actulizada con exito');
		enterContinuar;
	end;

procedure geometriaConfig();
	var
		opc: char;
	begin
		repeat
			saltosLinea30();
			writeln('  MENU CONFIGURACIONES');
			writeln;
			writeln('  Configuraciones disponibles');
			writeln;
			writeln('    A -  Cambiar estilo de marca en plano');
			writeln('    B -  Cambiar resolucion visual de los numeros');
			writeln;
			writeln('    C -  Volver al Menu Geometria');
			leerOpcion('A','C',opc);
			if opc= 'A' then
				cambiarPixelPlano()
			else if opc= 'B' then
				cambiarResolucionNumeros();
		until opc= 'C';
	end;




procedure capGeometria();
	var
		bTema: boolean;
		opc: char;
	begin
		presetsGeometria();
		bTema:= true;
		while bApp and bTema do begin
			saltosLinea30();
			writeln('  MENU GEOMETRIA');
			writeln;
			writeln('  Ingrese la letra del tema');
			writeln;
			writeln('    A -  Puntos');
			writeln('    B -  Rectas');
			writeln('    C -  Circunferencias');
			writeln('    D -  Parabolas');
			writeln;
			writeln('    E -  Configuraciones');
			writeln('    F -  Volver al Menu Capitulos');
			writeln('    G -  Cerrar Aplicacion');
			leerOpcion('A','G',opc);
			case opc of
				'A':	geometriaPunto();
				'B':	geometriaRecta();
				'C':	geometriaCircunferencia();
				'D':	geometriaParabola();
				'E':	geometriaConfig();
				'F':	bTema:= false;
				'G':	bApp:= false;
			end;
		end;
	end;




// PROGRAMA PRINCIPAL
begin
	bApp:= true;
	while bApp do begin
		capGeometria();
		write('Se supone que ahora irias al menu de capitulos pero f'); readln;
	end;
end.
