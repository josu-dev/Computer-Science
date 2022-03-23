
procedure imprimirSum(total: extended);
	begin
		writeln();
		writeln('El resultado de la sumatoria es: ', total:0:0);
		writeln();
		writeln();
	end;

procedure aDato1();
	var
		t1,tU,d,n: integer;
	begin
		write('Ingrese valor primer termino: ');readln(t1);
		write('Ingrese valor ultimo termino: ');readln(tU);
		write('Ingrese diferencia: ');readln(d);
		n:= ((tU-t1) div d) +1;
		imprimirSum( n*(t1 + tU)/2 );
	end;
procedure aDato2();
	var
		t1,tU,d,n: integer;
	begin
		write('Ingrese valor del primer termino: ');readln(t1);
		write('Ingrese cantidad de terminos: ');readln(n);
		write('Ingrese diferencia: ');readln(d);
		tU:= t1 + (n-1)*d;
		imprimirSum( n*(t1 + tU)/2 );
	end;
procedure aDato3();
	var
		t1,tU,d,n: integer;
	begin
		write('Ingrese valor del ultimo termino: ');readln(tU);
		write('Ingrese cantidad de terminos: ');readln(n);
		write('Ingrese diferencia: ');readln(d);
		t1:= tU - (n-1)*d;
		imprimirSum( n*(t1 + tU)/2 );
	end;
procedure aDato4();
	var
		t1,tU,n,pos1,pos2: integer;
	begin
		writeln('Ingrese dos terminos de la sucecion para sumar los terminos comprendidos entre ellos');
		write('Ingrese la posicion del termino: ');readln(pos1);
		write('Ingrese su valor: ');readln(t1);
		write('Ingrese la posicion del otro termino: ');readln(pos2);
		write('Ingrese su valor: ');readln(tU);
		if pos1 > pos2 then
			n:= pos1 - pos2 +1
		else
			n:= pos2 - pos1 +1;
		imprimirSum( n*(t1 + tU)/2 );
	end;

procedure potencia(var n: extended; exp: integer);
	var
		i: integer;
		base: extended;
	begin
		base:=n;
		if exp=0 then
			n:=1
		else if exp >0 then
			for i:=2 to exp do
				n:= n*base
		else begin
			for i:=-2 downto exp do
				n:= n*base;
			n:= 1/n;
		end;
	end;

procedure gDato1();
	var
		t1,iU,r: integer;
		pot,n: extended;
	begin
		write('Sumatoria termina en: ');readln(iU);
		write('Valor del primer termino: ');readln(t1);
		write('Razon de cambio: ');readln(r);
		pot:= r;
		potencia(pot,iU);
		n:= (1-pot)/(1-r);
		imprimirSum( n*t1 );
	end;
procedure gDato2();
	var
		t1,iI,iU,r: integer;
		potI,potU,n: extended;
	begin
		write('Sumatoria comienza en: ');readln(iI);
		write('Sumatoria termina en: ');readln(iU);
		write('Valor del primer termino: ');readln(t1);
		write('Razon de cambio: ');readln(r);
		potI:= r;
		potU:= r;
		potencia(potI,iI-1);
		potencia(potU,iU);
		n:= (1-potU)/(1-r) - (1-potI)/(1-r);
		imprimirSum( n*t1 );
	end;



function validarOpcM(opc: char):boolean;
	begin
		validarOpcM:= (opc= '1') or (opc= '2') or (opc= 's') or (opc= 'S');
	end;
procedure menuPrincipal(var opc: char);
	var
		estado: boolean;
	begin
		repeat
			writeln('Ingrese el valor de lo que desea hacer');
			writeln('    1 | Para trabajar con suceciones aritmeticas');
			writeln('    2 | Para trabajar con sucesiones geometricas');
			writeln;
			writeln('    S | Para cerrar la aplicacion');
			write('  '); readln(opc);
			estado:= validarOpcM(opc);
			if not estado then
				writeln('Opcion ingresada invalida, intente nuevamente');
			writeln();
		until estado;
	end;


function validarCoS(opc: char):boolean;
	begin
		validarCoS:= (opc='s') or (opc='S') or (opc='c') or (opc='C');
	end;


function validarOpcA(opc: char):boolean;
	begin
		validarOpcA:= ((opc>='1') and (opc<='4')) or (opc='c')or (opc='C')or (opc='s')or (opc='S');
	end;
procedure menuAritmetico(var opc: char);
	var
		estado: boolean;
	begin
		repeat
			writeln('Elija el modo a operar:');
			writeln('    1 - Dando el primer termino, ultimo termino y la diferencia');
			writeln('    2 - Dando el primer termino, cantidad de terminos y la diferencia');
			writeln('    3 - Dando el ultimo termino, cantidad de terminos y la diferencia');
			writeln('    4 - Dando dos terminos de la sucesion');
			writeln();
			writeln('    C | Para cambiar modo de aplicacion');
			writeln('    S | Para cerrar la aplicacion');
			write('  '); readln(opc);
			estado:= validarOpcA(opc);
			if not estado then
				writeln('Opcion ingresada invalida, intente nuevamente');
			writeln();
		until estado;
	end;
procedure modoAritmetico(var opc: char);
	begin
		repeat
			menuAritmetico(opc);
			case opc of
				'1' : aDato1();
				'2' : aDato2();
				'3' : aDato3();
				'4' : aDato4();
			end;
		until validarCoS(opc);
	end;


function validarOpcG(opc: char):boolean;
	begin
		validarOpcG:= (opc='1') or (opc='2') or (opc='c')or (opc='C')or (opc='s')or (opc='S');
	end;
procedure menuGeometrico(var opc: char);
	var
		estado: boolean;
	begin
		repeat
			writeln('Elija el modo a operar:');
			writeln('    1 - Sumatoria comienza en 1, termina en z, primer termino y razon de cambio');
			writeln('    2 - Sumatoria comienza en x, termina en z, primer termino y razon de cambio');
			writeln();
			writeln('    C | Para cambiar modo de aplicacion');
			writeln('    S | Para cerrar la aplicacion');
			write('  '); readln(opc);
			estado:= validarOpcG(opc);
			if not estado then
				writeln('Opcion ingresada invalida, intente nuevamente');
			writeln();
		until estado;
	end;
procedure modoGeometrico(var opc: char);
	begin
		repeat
			menuGeometrico(opc);
			case opc of
				'1' : gDato1();
				'2' : gDato2();
			end;
		until validarCoS(opc);
	end;




var
	opc: char;
begin
	menuPrincipal(opc);
	while (opc <> 's') and (opc <> 'S') do begin
		if opc= '1' then
			modoAritmetico(opc)
		else 
			modoGeometrico(opc);
		if (opc <> 's') and (opc <> 'S') then
			menuPrincipal(opc);
	end;
	writeln();
	writeln();
	writeln('Cerrando aplicacion');
end.
	
