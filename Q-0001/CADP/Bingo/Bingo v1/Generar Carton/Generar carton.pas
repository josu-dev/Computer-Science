const
	MAXF= 9;
	MAXC= 2;
	MAXNB= 99;
type
	casilla= record
		num: integer;
		estado: integer;
	end;
	fila= array[0..MAXF] of integer;
	columna= array[0..MAXC] of casilla;
	matrizCarton= array[0..MAXF] of columna;
	numeros0A99= array[0..MAXNB] of boolean;
var
	vN0A99: numeros0A99;

procedure iniciarVN0A99();
	var
		i: integer;
	begin
		for i:=0 to MAXNB do
			vN0A99[i]:= false;
	end;

procedure iniciarCarton(var mCarton: matrizCarton);
	var
		i,j: integer;
	begin
		for i:= 0 to MAXC do
			for j:= 0 to MAXF do begin
				mCarton[j][i].num:= -1;
				mCarton[j][i].estado:= 0;
			end;
	end;

procedure iniciarCantEnColumnas(var cantEnColumnas: fila);
	var
		i: integer;
	begin
		for i:= 0 to MAXF do
			cantEnColumnas[i]:= 0;
	end;

function cualCasilla(n: integer): integer;
	begin
		if (n>=0) and (n< 3) then
			cualCasilla:= 0
		else if n<7 then
			cualCasilla:= 1
		else
			cualCasilla:= 2;
	end;

procedure fueGenerado(var vN0A99Aux: numeros0A99; num: integer; var bFueGenerado: boolean);
	begin
		if vN0A99Aux[num]= false then begin
			vN0A99Aux[num]:= true;
			bFueGenerado:= false;
		end
		else
			bFueGenerado:= true;
	end;

procedure agregarEnCasilla(var columnaCarton: columna; nColumna,n: integer);
	begin
		if columnaCarton[nColumna].estado= 0 then begin
			columnaCarton[nColumna].num:= n;
			columnaCarton[nColumna].estado:= 1;
		end
		else
			case nColumna of
				0 : begin
						if columnaCarton[nColumna].num < n then begin
							columnaCarton[nColumna +1].num:= n;
							columnaCarton[nColumna +1].estado:= 1;
						end
						else begin
							columnaCarton[nColumna +1].num:= columnaCarton[nColumna].num;
							columnaCarton[nColumna +1].estado:= 1;
							columnaCarton[nColumna].num:= n;
						end;
					end;
				1 : begin
						if columnaCarton[nColumna].num < n then begin
							columnaCarton[nColumna +1].num:= n;
							columnaCarton[nColumna +1].estado:= 1;
						end
						else begin
							columnaCarton[nColumna -1].num:= n;
							columnaCarton[nColumna -1].estado:= 1;
						end;
					end;
				2 : begin
						if columnaCarton[nColumna].num < n then begin
							columnaCarton[nColumna -1].num:= columnaCarton[nColumna].num;
							columnaCarton[nColumna -1].estado:= 1;
							columnaCarton[nColumna].num:= n;
						end
						else begin
							columnaCarton[nColumna -1].num:= n;
							columnaCarton[nColumna -1].estado:= 1;
						end;
					end;
			end;
	end;
procedure generarCarton(var mCarton: matrizCarton);
	var
		n,c2: integer;
		nCargados,nFila,nColumna: integer;
		bFueGenerado: boolean;
		cantEnColumnas: fila;
	begin
		c2:= 0;
		nCargados:= 0;
		iniciarVN0A99();
		iniciarCantEnColumnas(cantEnColumnas);
		iniciarCarton(mCarton);
		repeat
			n:= random(100);
			fueGenerado(vN0A99,n,bFueGenerado);
			if not bFueGenerado then begin
				nColumna:= cualCasilla(n mod 10);
				nFila:= n div 10;
				if cantEnColumnas[nFila]= 0 then begin
					mCarton[nFila][nColumna].num:= n;
					mCarton[nFila][nColumna].estado:= 1;
					cantEnColumnas[nFila]:= cantEnColumnas[nFila] +1;
					nCargados:= nCargados +1;
				end
				else if (cantEnColumnas[nFila]= 1) and (c2< 5) then begin
					agregarEnCasilla(mCarton[nFila],nColumna,n);
					cantEnColumnas[nFila]:= cantEnColumnas[nFila] +1;
					c2:= c2 +1;
					nCargados:= nCargados +1;
				end;
			end;
		until nCargados= 15;
	end;



var
	m: matrizCarton;
	i,j: integer;
begin
	randomize;
	while true do begin
		generarCarton(m);
		writeln(chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196));
		for j:= 0 to MAXC do begin
			for i:= 0 to MAXF do begin
				if (m[i][j].num=-1) then
					write('   ')
				else if (m[i][j].num<10) and (m[i][j].num>-1) then
					write(' ',m[i][j].num,' ')
				else 
					write(m[i][j].num,' ')
			end;
			writeln;
		end;
		writeln(chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196),chr(196));
		readln;
	end;
end.
