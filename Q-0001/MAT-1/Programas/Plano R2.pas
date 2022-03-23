const
	TAM_R2= 20;
	PIXEL_DEFAULT_PLANO= '*';

type
	plano= array[-TAM_R2..TAM_R2,-TAM_R2..TAM_R2] of char;
	
var
	pVacio,pImp: plano;
	pixel: char;




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

function raiz(n: integer; x: real): real;
	begin
		if x> 0 then
			raiz:= exp(ln(x)/n)
		else if x=0 then
			raiz:=0
		else raiz:= -1;
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

procedure presetsPlano();
	begin
		pixel:= PIXEL_DEFAULT_PLANO;
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
			pImp[y][x]:= 'o';
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
	


begin
	presetsPlano();
	pImp:= pVacio;
	readln;
end.
