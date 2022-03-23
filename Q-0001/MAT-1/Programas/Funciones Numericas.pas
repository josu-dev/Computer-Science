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
		else if x= 0 then
			raiz:= 0
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

var
	x: integer;
begin
	while true do begin
		readln(x);
		writeln(raiz(2,x));
	end;
end.
