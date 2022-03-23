const
	MAXF= 9;
	MAXC= 2;
	MAXNB= 99;
	MAXNC= 15;
	MAXP= 20;
type
	columnaBolillero= array[0..9] of string[34];
	
	matrizNumero= array[3..8] of string[6];
	vectorMatrizNumeros= array[0..9] of matrizNumero;

	casilla= record
		num: integer;
		estado: integer;
	end;
	fila= array[0..MAXF] of integer;
	columna= array[0..MAXC] of casilla;
	matrizCarton= array[0..MAXF] of columna;
	numeros0A99= array[0..MAXNB] of boolean;
	
	jugador= record
		nombre: string;
		puntos: integer;
		nAcertados: integer;
		nFullCartones: integer;
		carton: matrizCarton;
	end;

	listaJugadores= ^nodoJ;

	nodoJ= record
		dato: jugador;
		sig: listaJugadores;
	end;
var
	marcoS,marcoI,marcoM: string;
	mBV,mBD,mBI: columnaBolillero;
	vMN: vectorMatrizNumeros;
	nBolilla: integer;
	bPartida: boolean;

//	Matriz Bolillero
procedure iniciarMBVacia();
	var
		nColumna: integer;
	begin
		for nColumna:= 0 to 9 do
			mBV[nColumna]:='';
	end;
procedure iniciarMBDibujado();
	begin
		mBD[0]:= '     '+chr(218)+chr(196)+chr(196)+chr(196)+chr(196)+chr(196)+chr(196)+chr(191)+'                     ';
		mBD[1]:= '   '+chr(218)+chr(196)+chr(217)+'o     '+chr(192)+chr(196)+chr(191)+'                   ';
		mBD[2]:= '  '+chr(218)+chr(217)+'    o  o  '+chr(192)+chr(191)+'                  ';
		mBD[3]:= '  '+chr(179)+' o        o '+chr(179)+'                  ';
		mBD[4]:= '  '+chr(179)+'   o  o     '+chr(179)+'                  ';
		mBD[5]:= '  '+chr(192)+chr(196)+chr(191)+'   oo  o'+chr(218)+chr(196)+chr(217)+'                  ';
		mBD[6]:= '    '+chr(192)+chr(196)+chr(191)+'o   '+chr(218)+chr(196)+chr(217)+'                    ';
		mBD[7]:= '   '+chr(201)+chr(205)+chr(205)+chr(202)+chr(205)+chr(205)+chr(205)+chr(205)+chr(202)+chr(205)+chr(205)+chr(187)+'                   ';
		mBD[8]:= '   '+chr(186)+'    '+chr(192)+chr(217)+'    '+chr(186)+'                   ';
		mBD[9]:= '   '+chr(200)+chr(205)+chr(205)+chr(205)+chr(205)+chr(205)+chr(205)+chr(205)+chr(205)+chr(205)+chr(205)+chr(188)+'                   ';
	end;
procedure iniciarVMN();
	begin
		vMN[0][3]:= chr(218)+chr(196)+chr(196)+chr(196)+chr(196)+chr(191);
		vMN[0][4]:= chr(179)+'    '+chr(179);
		vMN[0][5]:= vMN[0][4];
		vMN[0][6]:= vMN[0][4];
		vMN[0][7]:= vMN[0][4];
		vMN[0][8]:= chr(192)+chr(196)+chr(196)+chr(196)+chr(196)+chr(217);
		
		vMN[1][3]:= '     '+chr(191);
		vMN[1][4]:= '     '+chr(179);
		vMN[1][5]:= vMN[1][4];
		vMN[1][6]:= vMN[1][4];
		vMN[1][7]:= vMN[1][4];
		vMN[1][8]:= '     '+chr(193);
		
		vMN[2][3]:= chr(196)+chr(196)+chr(196)+chr(196)+chr(196)+chr(191);
		vMN[2][4]:= vMN[1][4];
		vMN[2][5]:= chr(218)+chr(196)+chr(196)+chr(196)+chr(196)+chr(217);
		vMN[2][6]:= chr(179)+'    ';
		vMN[2][7]:= vMN[2][6];
		vMN[2][8]:= chr(192)+chr(196)+chr(196)+chr(196)+chr(196)+chr(196);
		
		vMN[3][3]:= vMN[2][3];
		vMN[3][4]:= vMN[1][4];
		vMN[3][5]:= chr(196)+chr(196)+chr(196)+chr(196)+chr(196)+chr(180);
		vMN[3][6]:= vMN[1][4];
		vMN[3][7]:= vMN[1][4];
		vMN[3][8]:= chr(196)+chr(196)+chr(196)+chr(196)+chr(196)+chr(217);
		
		vMN[4][3]:= chr(124)+'    '+chr(124);
		vMN[4][4]:= vMN[0][4];
		vMN[4][5]:= chr(192)+chr(196)+chr(196)+chr(196)+chr(196)+chr(180);
		vMN[4][6]:= vMN[1][4];
		vMN[4][7]:= vMN[1][4];
		vMN[4][8]:= vMN[1][8];
		
		vMN[5][3]:= chr(218)+chr(196)+chr(196)+chr(196)+chr(196)+chr(196);
		vMN[5][4]:= vMN[2][6];
		vMN[5][5]:= chr(192)+chr(196)+chr(196)+chr(196)+chr(196)+chr(191);
		vMN[5][6]:= vMN[1][4];
		vMN[5][7]:= vMN[1][4];
		vMN[5][8]:= vMN[3][8];
		
		vMN[6][3]:= vMN[5][3];
		vMN[6][4]:= vMN[2][6];
		vMN[6][5]:= chr(195)+chr(196)+chr(196)+chr(196)+chr(196)+chr(191);
		vMN[6][6]:= vMN[0][4];
		vMN[6][7]:= vMN[0][4];
		vMN[6][8]:= vMN[0][8];
		
		vMN[7][3]:= vMN[2][3];
		vMN[7][4]:= vMN[1][4];
		vMN[7][5]:= vMN[1][4];
		vMN[7][6]:= vMN[1][4];
		vMN[7][7]:= vMN[1][4];
		vMN[7][8]:= vMN[1][8];
		
		vMN[8][3]:= vMN[0][3];
		vMN[8][4]:= vMN[0][4];
		vMN[8][5]:= chr(195)+chr(196)+chr(196)+chr(196)+chr(196)+chr(180);
		vMN[8][6]:= vMN[0][4];
		vMN[8][7]:= vMN[0][4];
		vMN[8][8]:= vMN[0][8];
		
		vMN[9][3]:= vMN[0][3];
		vMN[9][4]:= vMN[0][4];
		vMN[9][5]:= chr(192)+chr(196)+chr(196)+chr(196)+chr(196)+chr(180);
		vMN[9][6]:= vMN[1][4];
		vMN[9][7]:= vMN[1][4];
		vMN[9][8]:= vMN[1][8];
	end;
procedure actualizarMBDibujado();
	var
		digD,digU,nColum,nFila: integer;
	begin
		digD:= nBolilla div 10;
		digU:= nBolilla mod 10;
		for nColum:= 0 to 5 do begin
			for nFila:= 0 to 5 do
				mBD[nColum +3][nFila +21]:= vMN[digD][nColum +3][nFila +1];
		end;
		for nColum:= 0 to 5 do begin
			for nFila:= 0 to 5 do
				mBD[nColum +3][nFila +28]:= vMN[digU][nColum +3][nFila +1];
		end;
	end;

//	Imprimir Carton
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

procedure setearMarcoSuperiorInferiorMedio();
	var
		i,tamBorde: integer;
	begin
		marcoS:= chr(218);
		marcoM:= chr(195);
		marcoI:= chr(192);
		tamBorde:= (MAXF+1)*4 +MAXF;
		for i:=1 to tamBorde  do begin
			if (i mod 5)= 0 then begin
				marcoS:= marcoS + chr(194);
				marcoM:= marcoM + chr(197);
				marcoI:= marcoI + chr(193);
			end
			else begin
				marcoS:= marcoS + chr(196);
				marcoM:= marcoM + chr(196);
				marcoI:= marcoI + chr(196);
			end;
		end;
		marcoS:= marcoS + chr(191);
		marcoM:= marcoM + chr(180);
		marcoI:= marcoI + chr(217);
	end;

procedure imprimirFilaCarton(mCarton: matrizCarton; nCCarton,nCBolillero: integer);
	var
		i: integer;
	begin
		write(mBI[nCBolillero+1],'    ',chr(179));
		for i:=0 to MAXF do begin
			if mCarton[i][nCCarton].estado= 0 then
				write('    ')
			else if mCarton[i][nCCarton].estado= 1 then begin
				if mCarton[i][nCCarton].num<10 then
					write('0');
				write(mCarton[i][nCCarton].num,'  ')
			end
			else begin
				if mCarton[i][nCCarton].num<10 then
					write('0');
				write(mCarton[i][nCCarton].num,' ',chr(219));
			end;
			write(chr(179));
		end;
		writeln;
		write(mBI[nCBolillero+2],'    ',chr(179));
		for i:=0 to MAXF do begin
			if mCarton[i][nCCarton].estado< 2 then
				write('    ')
			else
				write(chr(220),chr(220),chr(220),chr(219));
			write(chr(179));
		end;
		writeln;
	end;
procedure imprimirCarton(mCarton: matrizCarton; nombre: string);
	var
		nCCarton,nCBolillero: integer;
		espaciosTitulo: string;
	begin
		if bPartida then begin
			actualizarMBDibujado();
			mBI:= mBD;
			espaciosTitulo:= '                                      ';
		end
		else begin
			mBI:= MBV;
			espaciosTitulo:= '    ';
		end;
		nCCarton:=0;
		nCBolillero:= 0;
		writeln(espaciosTitulo,'Carton de: ',nombre);
		
		writeln;
		writeln(mBI[nCBolillero],'    ',marcoS);
		imprimirFilaCarton(mCarton,nCCarton,nCBolillero);
		
		nCCarton:= nCCarton +1;
		nCBolillero:= nCBolillero +3;
		writeln(mBI[nCBolillero],'    ',marcoM);
		imprimirFilaCarton(mCarton,nCCarton,nCBolillero);
		
		nCCarton:= nCCarton +1;
		nCBolillero:= nCBolillero +3;
		writeln(mBI[nCBolillero],'    ',marcoM);
		imprimirFilaCarton(mCarton,nCCarton,nCBolillero);
		
		writeln(mBI[nCBolillero+3],'    ',marcoI);
	end;
var
	mCarton: matrizCarton;
begin
	setearMarcoSuperiorInferiorMedio();
	iniciarCarton(mCarton);
	iniciarMBVacia();
	iniciarMBDibujado();
	iniciarVMN();
	bPartida:= true;
	while true do begin
		readln(nBolilla);
		imprimirCarton(mCarton,'Josu');
		readln;
	end;
end.
