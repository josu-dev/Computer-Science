program completar_cuadrados;

var
a,a1,b,b1,r,r1,coefx2,coefx1,coefy2,coefy1,ti,rai,c: real;
elecc,signo1,signo2,term1,term2: string;
begin
	repeat
		repeat 
			writeln('Ingrese el numero de la herramienta a utilizar');
			writeln(' 0 || Completar cuadrados de circunferencia');
			writeln(' 1 || Completar cuadrados de parabola');
			writeln(' 2 || Cerrar la aplicacion');
			readln(elecc);
			writeln();
		until (elecc='0') or (elecc='1') or (elecc='2');
		if elecc='0' then begin
			repeat
				signo1:='';
				signo2:='';
				writeln('Ingrese los datos solicitados de el siguiente tipo de ecuacion ax^2 + bx + ay^2 + cy + d = 0');
				writeln('coeficiente de x^2');
				readln(coefx2);
				writeln('coeficiente de x');
				readln(coefx1);
				writeln('coeficiente de y^2');
				readln(coefy2);
				writeln('coeficiente de y');
				readln(coefy1);
				writeln('termino independiente');
				readln(ti);
				if coefx2=coefy2 then begin
					coefx1:=coefx1/coefx2;
					coefx2:=1;
					ti:=ti/coefy2;
					coefy1:=coefy1/coefy2;
					coefy2:=1;
					a:=coefx1/2;
					b:=coefy1/2;
					a1:=a*a;
					b1:=b*b;
					r1:=-ti+a1+b1;
					r:=0;
					repeat
						r:=r+0.0001;
						rai:= r*r;
					until (r1=rai) or ((r1-rai)<0.0001);
					if a>=0 then
						signo1:='+ ';
					if b>=0 then
						signo2:='+ ';
					writeln('Despues de completar cuadrados a la ecuacion ingresada el resultado es:');
					writeln('(x ',signo1,a:4:2,')^2 + (y ',signo2,b:4:2,')^2 = ',r:5:3,'^2');
					repeat 
						writeln('Ingrese el numero de lo que quiera hacer');
						writeln(' 0 || Repetir herramienta');
						writeln(' 1 || Cambiar herramienta');
						writeln(' 2 || Cerrar la aplicacion');
						readln(elecc);
						writeln();
					until (elecc='0') or (elecc='1') or (elecc='2');
				end
				else begin
					writeln('No ingreso los datos de una circunferencia');
					writeln('Intentelo denuevo');
					writeln();
				end;
			until (elecc='1') or (elecc='2');
		end
		else if elecc='1' then begin
			repeat
				repeat 
					writeln('Ingrese el numero del tipo de parabola');
					writeln(' 0 || Parabola vertical( tiene x^2 )');
					writeln(' 1 || Parabola horizontal( tiene y^2 )');
					readln(elecc);
					writeln();
				until (elecc='0') or (elecc='1');
				if elecc='0' then begin
					term1:='x';
					term2:='y'
				end
				else begin
					term1:='y';
					term2:='x'
				end;
				writeln('Ingrese los datos solicitados de el siguiente tipo de ecuacion a',term1,'^2 + bx + cy + d = 0');
				writeln('coeficiente de ',term1,'^2');
				readln(coefx2);
				writeln('coeficiente de x');
				readln(coefx1);
				writeln('coeficiente de y');
				readln(coefy1);
				writeln('termino independiente');
				readln(ti);
				if coefx2<>1 then begin
					coefx1:=coefx1/coefx2;
					ti:=ti/coefx2;
					coefy1:=coefy1/coefx2;
					coefx2:=1;
				end;
				if term1='y' then begin
					coefy2:=coefx1;
					coefx1:=coefy1;
					coefy1:=coefy2;
				end;
				a:= coefx1/2;
				a1:=a*a;
				b:= (-ti+a1)/-coefy1;
				c:=-coefy1/4;
				if a>=0 then
					signo1:='+ ';
				if b>=0 then
					signo2:='+ ';
				writeln('Despues de completar cuadrados a la ecuacion ingresada el resultado es:');
				writeln('(',term1,' ',signo1,a:4:2,')^2 = 4.',c:4:2,'(',term2,' ',signo2,b:4:2,')');
					repeat 
						writeln('Ingrese el numero de lo que quiera hacer');
						writeln(' 0 || Repetir herramienta');
						writeln(' 1 || Cambiar herramienta');
						writeln(' 2 || Cerrar la aplicacion');
						readln(elecc);
						writeln();
					until (elecc='0') or (elecc='1') or (elecc='2');
			until (elecc='1') or (elecc='2');
			end;
	until elecc='2';
	writeln('Aplicacion finalizada con exito');
	writeln('Autor: Josué Suarez');
	readln(); 
end.
