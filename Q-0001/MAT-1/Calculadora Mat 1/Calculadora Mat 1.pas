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


var
	bApp,bCap: boolean;
	cTema: char;
	nombreUsuario: string;




// CONFIGURACIONES DEFAULTS
procedure configsDefaults();
	begin
		bApp:= true;
		bCap:= false;
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

//   LEER OPCIONES
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
procedure leerUsuario();
	var
		ok: boolean;
	begin
		repeat
			saltosLinea30();
			write('  Ingrese su nombre de usuario: '); readln(nombreUsuario);
			writeln;
			writeln('  Esta seguro que su nombre de usuario sea: ',nombreUsuario);
			leerSiNo(ok);
			if not ok then begin
				writeln('  De acuerdo, presione Enter para ingresar uno nuevo');
				write('  '); readln;
			end;
		until ok;
	end;

//   LEER NUMEROS
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

//   MANEJO ENTEROS
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

//   MANEJO CARACTERES
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

//   FUNCIONES MATEMATICAS
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
function fact(x: word): qword;
	var
		n: integer;
	begin
		fact:= 1;
		if x<21 then
			for n:= x downto 2 do
				fact:= fact*n
	end;
function fibonacci(x: word): qword;
	var
		n,r1,r2: word;
	begin
		if x>0 then begin
			fibonacci:= 1;
			r1:=1;
			for n:= 3 to x do begin
				r2:= r1;
				r1:= fibonacci;
				fibonacci:= fibonacci + r2;
			end;
		end
		else
			fibonacci:= 0;
	end;



// CAPITULOS
//   CAPITULO GEOMETRIA
procedure capGeometria();
	const
		TAM_R2= 20;
		PIXEL_DEFAULT_PLANO= '*';
		DECIMALES_DEFAULT_NUMEROS= 0;

	type
		plano= array[-TAM_R2..TAM_R2,-TAM_R2..TAM_R2] of char;

	var
		pVacio,pImp: plano;
		pixel: char;
		resNum: word;

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




//   CAPITULO CONJUNTOS
procedure capConjuntos();
	var
		opc: char;
	begin
		saltosLinea30();
		writeln('  MENU DEMOSTRACIONES, CONJUNTOS Y FUNCIONES');
		writeln;
		writeln('    En este capitulo se trabaja de una manera mas teorica, con ejercitacion enfocada');
		writeln('    en el analizis, justificacion y desarrollo de conceptos, metodos y definiciones');
		writeln;
		writeln('    Por este echo es dificil la creacion de herramientas para resolver los diferentes');
		writeln('    ejercicios planteados durante el capitulo, ya que tienen mas areas que solo aplicar');
		writeln('    formulas, reglas de operacion y resultados finitos');
		writeln;
		writeln('  Ingrese la letra del apartado querido');
		writeln;
		writeln('    A -  Volver al Menu Capitulos');
		writeln('    B -  Cerrar Aplicacion');
		leerOpcion('A','B',opc);
		if opc= 'B' then
			bApp:= false;
	end;




//   CAPITULO ALEBRABOOLE
procedure capAlgebraBoole();
	type
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
		opc: char;
	begin
		saltosLinea30();
		writeln('  MENU ALGEBRAS DE BOOLE');
		writeln;
		writeln('    Este apartado esta sin terminar');
		writeln;
		writeln('    Solo esta la toma de datos y traduccion de los datos, queda la simplificacion');
		writeln('    de la funcion ingresada');
		writeln;
		writeln('  Ingrese la letra del apartado querido');
		writeln;
		writeln('    A -  Volver al Menu Capitulos');
		writeln('    B -  Cerrar Aplicacion');
		leerOpcion('A','B',opc);
		if opc= 'B' then
			bApp:= false;
	end;




//   CAPITULO SUCESIONES
procedure capSucesiones();
		const
			CANT_VARIABLES_ECUACION= 1;

		type
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

		var
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

		// ECUACIONES
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

		procedure leerRangoSumatoria(var ini,fin: integer);
			begin
				writeln('  Ingrese el rango de la sumatoria a calcular');
				repeat
					writeln;
					leerRangoEntero('    Sumatoria inicia en: ','    Sumatoria termina en: ',ini,fin);
				until ini> 0;
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




//   CAPITULO COMBINATORIA
procedure capCombinatoria();
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

	// CARACTERES
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




//   CAPITULO MATRICES
procedure capMatrices();
	const
		RESOLUCION_DEFAULT_ELEMENTO_MATRIZ= 1;
		ESPACIO_DEFAULT_ELEMENTO_MATRIZ= 6;

	type
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
		mAux: matriz;
		lMatrices: listaM;
		resElem,espElem,cantVariables: word;

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




//   CAPITULO SISTEMA ECUACIONES
procedure capSistEcuaciones();
	var
		opc: char;
	begin
		saltosLinea30();
		writeln('  MENU SISTEMAS DE ECUACIONES Y DETERMINANTES');
		writeln;
		writeln('    Sinceramente me quede sin ganas de seguir programando esta aplicacion, pero eso no');
		writeln('    quiere decir que tu no puedas hacerlo, asique te invito a intentar crear el codigo');
		writeln('    necesario para resolver los problemas planteados en este capitulo');
		writeln;
		writeln('    En resumen lo que falta es: leer las ecuaciones lineales e introducir los datos en el');
		writeln('    codigo de matrices con algunas reformas y se pueden resolver los sistemas. Para');
		writeln('    los determinantes hay que hacer los algoritmos practicamente de 0 pero no es imposible');
		writeln;
		writeln('  Ingrese la letra del apartado querido');
		writeln;
		writeln('    A -  Volver al Menu Capitulos');
		writeln('    B -  Cerrar Aplicacion');
		leerOpcion('A','B',opc);
		if opc= 'B' then
			bApp:= false;
	end;




// MENU PRINCIPAL
procedure infoGeneral();
	begin
		saltosLinea30();
		writeln('  INFORMACION GENERAL');
		writeln;
		writeln('    Esta aplicacion fue creada con la intencion de poner a prueba conceptos aprendidos');
		writeln('    en la carrera y demostrar que todo lo que se aprende se puede utilizar con fines');
		writeln('    practicos y de utilidad');
		writeln;
		writeln('    En pocas palabras la aplicacion brinda la posibilidad de resolver un gran apartado');
		writeln('    de los ejercicios dados en la materia Matematica 1, Lic. informatica, UNLP; de modo');
		writeln('    que los estudiantes-companieros tengan una herramienta de autocorreccion aproximada');
		writeln;
		writeln('    El funcionamiento es sencillo, primero se elige el capitulo que se esta estudiando');
		writeln('    y luego se procede a elegir la herramienta especifica para determinado ejercicio,');
		writeln('    luego continua dentro del mismo capitulo, cambia a otro o simplemente cierra la app');
		writeln;
		enterContinuar();
	end;
procedure menuCapitulos();
	var
		opc: char;
	begin
		if bApp and bCap then begin
			saltosLinea30();
			writeln('  MENU CAPITULOS');
			writeln;
			writeln('  Ingrese la letra del apartado querido');
			writeln;
			writeln('    A -  Geometria');
			writeln('    B -  Demostraciones, Conjuntos y Funciones');
			writeln('    C -  Algebras de Boole');
			writeln('    D -  Sucesiones e Induccion');
			writeln('    E -  Combinatoria y Metodos de conteo');
			writeln('    F -  Matrices');
			writeln('    G -  Sist. de Ecuaciones y Determinantes');
			writeln;
			writeln('    H -  Volver al Menu Inicio');
			writeln('    I -  Cerrar Aplicacion');
			leerOpcion('A','I',opc);
			case opc of
				'A'..'G':	cTema:= opc;
				'H':	bCap:= false;
				'I':	bApp:= false;
			end;
		end;
	end;
procedure creditos();
	begin
		saltosLinea30();
		writeln('  CREDITOS');
		writeln;
		writeln('    Fecha: 08/2021');
		writeln('    Lenguaje: Pascal');
		writeln('    Creador: Josue S.A.');
		writeln('    Conocimientos adquiridos en Materia: CADP');
		writeln('                                Carrera: Lic. Informatica');
		writeln('                                Facultad: Informatica UNLP');
		writeln;
		enterContinuar();
	end;

procedure menuInicial();
	var
		opc: char;
	begin
		while bApp and (not bCap) do begin
			saltosLinea30();
			writeln('  MENU INICIAL');
			writeln;
			writeln('  Ingrese la letra del apartado querido');
			writeln;
			writeln('    A -  Informacion general de la aplicacion');
			writeln('    B -  Menu de los capitulos');
			writeln('    C -  Creditos');
			writeln;
			writeln('    D -  Cerrar aplicacion');
			leerOpcion('A','D',opc);
			case opc of
				'A':	infoGeneral();
				'B':	bCap:= true;
				'C':	creditos();
				'D':	bApp:= false;
			end;
		end;
	end;




// EXTRAS
procedure mensajeInicial();
	begin
		leerUsuario();
		saltosLinea30();
		writeln('  ADVERTENCIA:');
		writeln;
		writeln('    Usted usa la aplicacion bajo su eleccion, los resultados no estan');
		writeln('    verificados al 100% y en algunos casos solo son aproximaciones a de los');
		writeln('    resultados-resoluciones reales');
		writeln;
		writeln('    Es posible encontrar errores y crasheos de la aplicacion, en caso de');
		writeln('    experimentar error puede contactar al creador o intentar resolverlo');
		writeln('    dentro del codigo por usted mimso, si se cerro solo vuelva a abrirla');
		writeln;
		enterContinuar();
		saltosLinea30();
		writeln('  Bienvenida/o a Calculadora Mat 1');
		writeln;
		writeln('    Se espera que las herramientas brindadas le sean de utilidad');
		writeln('    y que tenga una buena jornada de estudio ',nombreUsuario);
		writeln;
		enterContinuar();
	end;
procedure mensajeCierre();
	begin
		saltosLinea30();
		writeln('  Que haya tenido una buena jornada de estudio y que la aplicacion le');
		writeln('  fuera de utilidad');
		writeln;
		writeln('    Adios ',nombreUsuario,', gracias por usar Calculadora Mat 1');
		writeln;
		writeln;
		writeln('  Presione Enter para cerrar la ventana ');
		write('  '); readln;
	end;




// PROGRAMA PRINCIPAL
begin
	configsDefaults();
	mensajeInicial;
	menuInicial();
	while bApp do begin
		menuCapitulos();
		while bApp and bCap do begin
			case cTema of
				'A':	capGeometria();
				'B':	capConjuntos();
				'C':	capAlgebraBoole();
				'D':	capSucesiones();
				'E':	capCombinatoria();
				'F':	capMatrices();
				'G':	capSistEcuaciones();
			end;
			menuCapitulos
		end;
		menuInicial();
	end;
	mensajeCierre();
end.
