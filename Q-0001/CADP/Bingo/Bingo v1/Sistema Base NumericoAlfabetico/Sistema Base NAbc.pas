const
	BASE= 62;
	TAMRANDOMDIGPASS= 2;
	TAMDIGPASS= 10;
type
	decToNAbc= array[0..61] of char;

var
	vDecNAbc: decToNAbc;
	passwordSala: string[TAMDIGPASS];

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
procedure setearVDecNAbc();
	var
		L: char;
		N: integer;
	begin
		N:= -1;
		for L:= '0' to '9' do begin
			N:= N +1;
			vDecNAbc[N]:= L;
		end;
		for L:= 'A' to 'Z' do begin
			N:= N +1;
			vDecNAbc[N]:= L;
		end;
		for L:= 'a' to 'z' do begin
			N:= N +1;
			vDecNAbc[N]:= L;
		end;
	end;

procedure convertirDecNAbc(Ndec: int64; var Nnabc: string);
	begin
		while (Ndec<>1) and (Ndec>= BASE) do begin
			Nnabc:= Nnabc + vDecNAbc[Ndec mod BASE];
			Ndec:= Ndec div BASE;
		end;
		Nnabc:= Nnabc + vDecNAbc[Ndec];
	end;

procedure crearPassword();
	var
		nom,nomT: string;
		i: integer;
		N: int64;
	begin
		passwordSala:= '';
		for i:= 1 to TAMRANDOMDIGPASS do
			passwordSala:= passwordSala + vDecNAbc[random(BASE +1)];
		nomT:= '';
		readln(nom);
		while nom<> 'stop' do begin
			nomT:= nomT + nom;
			readln(nom);
		end;
		
		N:= 0;
		for i := 1 to length(nomT) do
			N:= N + (ord(nomT[i]) * i);
		convertirDecNAbc(N,passwordSala);
	end;

begin
	randomize;
	setearVDecNAbc();
	while true do begin
		crearPassword();
		writeln(passwordSala);
		readln;
	end;
end.
