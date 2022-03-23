uses
	sysutils;

const
	TAM_V= 150000;
	
type
	vector= array[1..TAM_V] of integer;


procedure cargarVector(var v: vector);
	var
		i: longInt;
	begin
		for i := 1 to TAM_V do
			v[i]:= random(32001);
	end;

function estaOrdenado(v: vector): boolean;
	var
		i: longInt;
		ok: boolean;
	begin
		i:= 1;
		ok:= true;
		while (i< (TAM_V-1)) and ok do begin
			ok:= v[i]<= v[i+1];
			i:= i +1;
		end;
		estaOrdenado:= ok;
	end;

// Algoritmos de ordenamiento
Procedure Seleccion(var v: vector; dimLog: longInt);
	var
		i, j, p: longInt;
		item: integer;
	begin
		for i:=1 to dimLog-1 do begin
			p := i;
			for j := i+1 to dimLog do
				if v[ j ] < v[ p ] then
					p:=j;
			item := v[ p ];   
			v[ p ] := v[ i ];   
			v[ i ] := item;
		end;
	end;

Procedure Insercion(var v: vector; dimLog: longInt);
	var
		i, j: longInt;
		actual: integer;
	begin
		for i:=2 to dimLog do begin
			actual:= v[i];
			j:= i-1; 
			while (j > 0) and (v[j] > actual) do begin
				v[j+1]:= v[j];
			j:= j -1;
			end;  
			 v[j+1]:= actual;
		end;
	end;

procedure QuickSort(var v: vector; ALo, AHi: longInt);
	var
		Lo, Hi, Pivot: longInt;
		item: integer;
	begin
		Lo := ALo;
		Hi := AHi;
		Pivot := v[(Lo + Hi) div 2];
		repeat
			while v[Lo] < Pivot do
				Lo:= lo +1;
			while v[Hi] > Pivot do
				Hi:= Hi -1;
			if Lo <= Hi then begin
				item := v[Lo];
				v[Lo] := v[Hi];
				v[Hi] := item;
				Lo:= lo +1;
				Hi:= Hi -1;
			end;
		until Lo > Hi;
		if Hi > ALo then
			QuickSort(v, ALo, Hi) ;
		if Lo < AHi then
			QuickSort(v, Lo, AHi) ;
	end;



// Programa PRINCIPAL
var
	vBase,vCopia: vector;
	inicio,fin: TDateTime;
	nTests,i: integer;

begin
	while true do begin
		writeln;
		writeln;
		writeln;
		writeln;
		writeln('  Comparacion Tiempos de Ordenamiento de Vector');
		writeln;
		writeln('  El vector a ordenar tiene ',TAM_V,' elementos');
		write('  Ingrese la cantidad de tests: '); readln(nTests);
		writeln;
		write('  Enter para comenzar '); readln;
		for i:= 1 to nTests do begin
			randomize();
			cargarVector(vBase);
			writeln;
			writeln;
			writeln('  Test ',i);
			
			writeln;
			write('    Seleccion:   ');
			vCopia:= vBase;
			inicio:= time;
			Seleccion(vCopia,TAM_V);
			fin:= time;
			writeln('Tiempo: ',TimeToStr(fin - inicio),'   Ordenado: ', estaOrdenado(vCopia));
			
			writeln;
			write('    Insercion:   ');
			vCopia:= vBase;
			inicio:= time;
			Insercion(vCopia,TAM_V);
			fin:= time;
			writeln('Tiempo: ',TimeToStr(fin - inicio),'   Ordenado: ', estaOrdenado(vCopia));
			
			writeln;
			write('    QuickSort:   ');
			inicio:= time;
			QuickSort(vBase, 1, TAM_V);
			fin:= time;
			writeln('Tiempo: ',TimeToStr(fin - inicio),'   Ordenado: ', estaOrdenado(vBase));
		end;
		writeln;
		writeln;
		write('  Enter para comenzar nuevamente '); readln;
	end;
end.
