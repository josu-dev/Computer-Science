const
	CANT_ELEM_MAX= 32;
	VEC_INI= 0;


type
	dato= record
		nInt: integer;
		est: boolean;
	end;

	vector= array of dato;

var
	V_Imp: vector;
	Cant_Elem,Dim_F,Dim_L: integer;
	marcoInd,marcoInf,marcoSup,marcoDL,marcoVacio: string;


procedure iniciarMarcos();
	var
		i,n: integer;
	begin
		n:= 0;
		marcoVacio:= ' ';
		marcoSup:= ' ';
		marcoInf:= '|';
		for i:= 1 to Cant_Elem*6 do begin
			if i mod 6 = 0 then begin
				marcoSup:= marcoSup + ' ';
				marcoInf:= marcoInf + '|';
			end
			else begin
				marcoSup:= marcoSup + '_';
				marcoInf:= marcoInf + '_';
			end;
			marcoVacio:= marcoVacio + ' ';
		end;
		marcoInd:= marcoVacio;
		n:= -1;
		for i:= 1 to Cant_Elem do begin
			if i div 10<> 0 then
				marcoInd[n + 6*i -1]:= chr(48 + i div 10);
			marcoInd[n + 6*i]:= chr(48 + i mod 10);
		end;
		//marcoInd:= marcoInd + 'DF';
	end;
procedure iniciarVImp();
	var
		i: integer;
	begin
		setLength(V_Imp,Cant_Elem);
		for i:= VEC_INI to Dim_F do
			V_Imp[i].est:= false;
	end;
procedure generarVectorRandom();
	var
		i: integer;
	begin
		iniciarVImp();
		for i:= VEC_INI to Dim_L -1 do begin
			V_Imp[i].nInt:= random(16);
			V_Imp[i].est:= true;
		end;
	end;


function intToStr(n: integer): string;
	begin
		if n>9 then
			intToStr:= intToStr(n div 10) + chr(48 + n mod 10) 
		else
			intToStr:= chr(48 + n);
	end;

function enteroCorregido(n: integer):string;
	var
		tam: integer;
	begin
		enteroCorregido:= intToStr(n);
		tam:= length(enteroCorregido);
		case tam of
			1:	enteroCorregido:= '   ' + enteroCorregido;
			2:	enteroCorregido:= '  ' + enteroCorregido;
			3:	enteroCorregido:= ' ' + enteroCorregido;
		end;
	end;

function cadenaBasura(): string;
	begin
		cadenaBasura:= chr(33 + random(15)) + chr(33 + random(15));
	end;
procedure imprimirVector(v: vector; dl: integer);
	var
		i: integer;
		marcoDF: string;
	begin
		marcoDF:= marcoVacio;
		marcoDF[(Dim_F+1)*6-2]:= 'D';
		marcoDF[(Dim_F+1)*6-1]:= 'F';
		marcoDL:= marcoVacio;
		marcoDL[dl*6 -2]:= 'D';
		marcoDL[dl*6 -1]:= 'L';
		writeln(' INDICE:',marcoInd);
		writeln('        ',marcoSup);
		write('  ELEM: |');
		for i:= VEC_INI to Dim_F do begin
			if v[i].est then
				write(enteroCorregido(v[i].nInt),' |')
			else
				write(' BSR.|');
		end;
		writeln;
		writeln('        ',marcoInf);
		writeln('        ',marcoDF);
		writeln('        ',marcoDL);
	end;



begin
	while true do begin
		readln(Cant_Elem);
		Dim_F:= Cant_Elem -1;
		readln(Dim_L);
		iniciarMarcos();
		generarVectorRandom();
		writeln;
		writeln;
		imprimirVector(V_Imp,Dim_L);
	end;
end.
