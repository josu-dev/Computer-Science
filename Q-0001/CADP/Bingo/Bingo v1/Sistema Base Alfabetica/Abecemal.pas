
type
	decToAbc= array[0..25] of char;
	abcToDec= array['A'..'Z'] of integer;

var
	vDecAbc: decToAbc;
	vAbcDec: abcToDec;

// Modulos generales
function POT(n: integer; exp: integer): int64;
	var
		i: integer;
		suma: int64;
	begin
		suma:= 1;
		if exp<>0 then
			for i:= 1 to exp do
				suma:= suma*n;
		pot:= suma;
	end;


// Modulos Sistema Abcemal
procedure setearVDecAbcYAbcDec();
	var
		L: char;
		N: integer;
	begin
		N:=-1;
		for L:= 'A' to 'Z' do begin
			N:= N +1;
			vDecAbc[N]:= L;
			vAbcDec[L]:= N;
		end;
	end;

procedure convertirDecAbc(Ndec: int64; var Nabc: string);
	begin
		Nabc:= '';
		while (Ndec<>1) and (Ndec>=26) do begin
			Nabc:= Nabc + vDecAbc[Ndec mod 26];
			Ndec:= Ndec div 26;
		end;
		Nabc:= Nabc + vDecAbc[Ndec];
	end;


procedure convertirAbcDec(Nabc: string; var Ndec: int64);
	var
		tam: integer;
		i: integer;
	begin
		Ndec:=0;
		tam:= length(Nabc);
		for i:=0 to (tam-1) do
			Ndec:= Ndec + vAbcDec[ Nabc[i+1] ] *POT(26,i);
	end;

var
	N,Ndec: int64;
	Nabc: string;
begin
	randomize;
	setearVDecAbcYAbcDec();
	while true do begin
	//N:= randseed;
	readln(N);
	//writeln(randseed);
	
	convertirDecAbc(N,Nabc);
	writeln(Nabc);

	convertirAbcDec(Nabc,Ndec);
	writeln(Ndec);
	end;
end.
