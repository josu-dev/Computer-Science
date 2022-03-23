program JED;
var
	B_1Vez,B_App,B_Est,B_Ope: boolean;
	C_Tipo: char;

	Rango_Min,Rango_Max: integer;




//  CONFIGURACIONES DEFAULTS
procedure configsDefaultAplicacion();
	begin
		B_1Vez:= true;
		B_App:= true;
		B_Est:= false;
		B_Ope:= false;
		C_Tipo:= ' ';
		randomize();
	end;




//  MODULOS COMUNES
procedure saltosLinea30();
	begin
		writeln;writeln;writeln;writeln;writeln; writeln;writeln;writeln;writeln;writeln;
		writeln;writeln;writeln;writeln;writeln; writeln;writeln;writeln;writeln;writeln;
		writeln;writeln;writeln;writeln;writeln; writeln;writeln;writeln;writeln;writeln;
	end;
procedure enterContinuar();
	begin
		writeln;
		writeln('  Presione Enter para continuar ');
		write('  '); readln;
	end;

procedure leerOpcion(min,max: char; var opc: char);
	var
		ok,mayus: boolean;
	begin
		mayus:= (min>= 'A') and (max<= 'Z');
		writeln;
		repeat
			write('  Opcion: '); readln(opc);
			if mayus and (opc>= 'a') and (opc<= 'z') then
				opc:= chr(ord(opc)-32);
			ok:= (opc>= min) and (opc<= max);
			if not ok then begin
				writeln('  Entrada invalida, presione Enter para volver a intentar');
				write('  '); readln;
			end;
		until ok;
	end;
procedure leerEntero(frase: string; var e: integer);
	var
		code: word;
		rString: string;
	begin
		repeat
			write(frase); readln(rString);
			val(rString,e,code);
			if code<> 0 then begin
				writeln('  Solo numeros enteros, intente nuevamente');
				write('  '); readln;
			end;
		until code=0;
	end;
procedure leerRangoEntero(fraseInf,fraseSup: string; var inf,sup: integer);
	begin
		repeat
			leerEntero(fraseInf,inf);
			leerEntero(fraseSup,sup);
			if inf= sup then begin
				writeln('  Un rango consta de mas de un valor, intente nuevamente');
				write('  '); readln;
			end
			else if inf> sup then begin
				writeln('  Primero el valor mas chico luego el mas grande, intente nuevamente');
				write('  '); readln;
			end;
		until inf< sup;
	end;

function intToStr(n: integer): string;
	begin
		if n>9 then
			intToStr:= intToStr(n div 10) + chr(48 + n mod 10) 
		else
			intToStr:= chr(48 + n);
	end;
function intToLttToStr(n: integer): string;
	begin
		if n>25 then
			intToLttToStr:=  intToLttToStr(n div 26) + chr(65 + (n mod 26))
		else
			intToLttToStr:= chr(65 + n);
	end;

function randomCarga(): integer;
	begin
		randomCarga:= Rango_Min + random(Rango_Max - Rango_Min +1);
	end;





//  ESTRUCTURAS
//    VECTOR
procedure estructuraVector();
	const
		CARGA_RANGO_MIN= 0;
		CARGA_RANGO_MAX= 999;
		MAX_CANT_ELEM= 32;
		VEC_INI= 0;

	type
		dato= record
			nInt: integer;
			est: boolean;
		end;

		vector= array of dato;

	var
		B_Vector: boolean;
		C_Tema: char;
		
		V_Imp: vector;
		Cant_Elem,Dim_F,Dim_L: integer;
		marcoInd,marcoInf,marcoSup,marcoDF,marcoDL,marcoVacio: string;



	//  CONFIGURACIONES DEFAULTS VECTOR
	procedure configsDefaultVector();
		begin
			B_Ope:= false;
			B_Vector:= false;
			Rango_Min:= CARGA_RANGO_MIN;
			Rango_Max:= CARGA_RANGO_MAX;
			Dim_F:= MAX_CANT_ELEM -1;
			Dim_L:= -1;
			Cant_Elem:= MAX_CANT_ELEM;
		end;

	//    MODULOS COMUNES
	function enteroCorregido(n: integer):string;
		begin
			enteroCorregido:= intToStr(n);
			case length(enteroCorregido) of
				1:	enteroCorregido:= '   ' + enteroCorregido;
				2:	enteroCorregido:= '  ' + enteroCorregido;
				3:	enteroCorregido:= ' ' + enteroCorregido;
			end;
		end;
	function cadenaBasura(): string;
		begin
			cadenaBasura:= chr(33 + random(15)) + chr(33 + random(15));
		end;

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
			marcoDF:= marcoVacio;
			marcoDF[Cant_Elem*6-2]:= 'D';
			marcoDF[Cant_Elem*6-1]:= 'F';
		end;
	procedure iniciarVImp();
		var
			i: integer;
		begin
			setLength(V_Imp,Cant_Elem);
			Dim_F:= Cant_Elem -1;
			for i:= VEC_INI to Dim_F do
				V_Imp[i].est:= false;
			Dim_L:= -1;
		end;

	procedure agregarDerecha(var v: vector; val: integer);
		begin
			Dim_L:= Dim_L +1;
			v[Dim_L].nInt:= val;
			v[Dim_L].est:= true;
		end;
	procedure insertarCreciente(var v: vector; val: integer);
		var
			i,j: integer;
		begin
			i:= VEC_INI;
			while (i<= Dim_L) and (v[i].nInt< val) do
				i:= i +1;
			if i<= Dim_L then begin
				for j:= Dim_L downto i do
					v[j +1].nInt:= v[j].nInt;
				v[i].nInt:= val;
			end
			else
				v[Dim_L +1].nInt:= val;
			Dim_L:= Dim_L +1;
			v[Dim_L].est:= true;
		end;

	function buscarVectorCreciente(v: vector; val: integer): integer;
		var
			i: integer;
		begin
			i:= VEC_INI;
			while (i<= Dim_L) and (v[i].nInt< val) do
				i:= i +1;
			if v[i].nInt= val then
				buscarVectorCreciente:= i
			else
				buscarVectorCreciente:= VEC_INI -1;
		end;
	function buscarVectorDesorden(v: vector; val: integer): integer;
		var
			i: integer;
		begin
			i:= VEC_INI;
			while (i<= Dim_L) and (v[i].nInt<> val) do
				i:= i +1;
			if v[i].nInt= val then
				buscarVectorDesorden:= i
			else
				buscarVectorDesorden:= VEC_INI -1;
		end;

	procedure copiarVector(vB: vector; var vC: vector);
		var
			i: integer;
		begin
			setLength(vC,Cant_Elem);
			for i:= VEC_INI to Dim_F do
				vC[i]:= vB[i]
		end;

	//    IMPRIMIR
	procedure imprimirElemento(d: dato; indice: integer);
		begin
			writeln;
			writeln('   INDICE   ELEM');
			writeln('           _____');
			write('    ',enteroCorregido(indice +1),'  |');
			if d.est then
				write(enteroCorregido(d.nInt),' |')
			else
				write(' BSR |');
			if indice= Dim_L then
				writeln('  DL')
			else
				writeln;
			write('          |_____|');
			if indice= Dim_F then
				writeln('  DF')
			else
				writeln;
		end;
	procedure imprimirVector(v: vector);
		var
			i: integer;
		begin
			marcoDL:= marcoVacio;
			marcoDL[(Dim_L +1)*6 -2]:= 'D';
			marcoDL[(Dim_L +1)*6 -1]:= 'L';
			writeln;
			writeln('   INDICE:',marcoInd);
			writeln('          ',marcoSup);
			write('    ELEM: |');
			for i:= VEC_INI to Dim_F do begin
				if v[i].est then
					write(enteroCorregido(v[i].nInt),' |')
				else
					write(' BSR |');
			end;
			writeln;
			writeln('          ',marcoInf);
			writeln('          ',marcoDF);
			if Dim_L>= VEC_INI then
				writeln('          ',marcoDL)
			else
				writeln('   DL= 0');
		end;
	procedure imprimirVectorMensaje(v: vector; str: string);
		begin
			writeln('  Vector:');
			imprimirVector(V_Imp);
			writeln;
			writeln(str);
		end;

	//    CREAR
	procedure leerTamanioVector();
		begin
			writeln('  Se recomienda un maximo de ', MAX_CANT_ELEM div 2,' elementos para una buena visualizacion');
			writeln;
			repeat
				leerEntero('  Tamanio del vector: ',Cant_Elem);
				if Cant_Elem< 1 then begin
					writeln('  Un vector al menos tiene un elemento, intente nuevamente');
					write('  '); readln;
				end
				else if Cant_Elem> MAX_CANT_ELEM then begin
					writeln('  No se puede mostrar correctamente, ingrese una cantidad menor');
					write('  '); readln;
				end;
			until (Cant_Elem> 0) and (Cant_Elem<= MAX_CANT_ELEM);
		end;
	procedure recomendacionCarga();
		begin
			writeln;
			writeln('  Se recomienda cargar un rango de valores de 0 a 999');
		end;
	procedure cargarVectorManual(var v: vector; modo: char);
		var
			ok: boolean;
			code: word;
			i: integer;
			rString: string;
			d: dato;
		begin
			i:= 0;
			writeln;
			writeln;
			writeln('  Carga Manual');
			writeln;
			writeln('  Ingrese n o N para dejar de ingresar valores');
			recomendacionCarga();
			writeln;
			repeat
				i:= i +1;
				repeat
					write('    Valor ',i,': '); readln(rString);
					val(rString,d.nInt,code);
					ok:= (code= 0) or (rString[code]= 'n') or (rString[code]= 'N');
					if not ok then begin
						writeln('  Solo numeros enteros, intente nuevamente');
						write('  '); readln;
					end
				until ok;
				if code= 0 then begin
					if modo= 'A' then
						agregarDerecha(v,d.nInt)
					else
						insertarCreciente(v,d.nInt);
				end;
			until (code<> 0) or (i= Cant_Elem);
			if i= Cant_Elem then begin
				writeln;
				writeln('  Ya se ingreso la maxima cantidad representable correctamente');
			end;
		end;
	procedure cargarVectorAleatorio(var v: vector; modo: char);
		var
			cant,i: integer;
		begin
			writeln;
			writeln;
			writeln('  Carga Aleatoria');
			recomendacionCarga();
			writeln;
			leerRangoEntero('    Valor Minimo incluido: ','    Valor Maximo incluido: ',Rango_Min,Rango_Max);
			writeln;
			repeat
				leerEntero('    Cantidad elementos a cargar: ',cant);
				if cant< 0 then begin
					writeln('    Un vector tiene al menos 0 elementos cargados, ingrese una cantidad mayor');
					write('  '); readln;
				end
				else if cant> Cant_Elem then begin
					writeln('    No puede cargar mas elementos que el tamanio del vector, ingrese una cantidad menor');
					write('  '); readln;
				end;
			until (cant>= 0) and (cant<= Cant_Elem);
			cant:= cant -1;
			for i:= VEC_INI to cant do begin
				if modo= 'A' then
					agregarDerecha(v, randomCarga())
				else
					insertarCreciente(v, randomCarga());
			end;
		end;
	procedure crearVector(var v: vector);
		var
			carga,modo: char;
		begin
			saltosLinea30(); saltosLinea30();
			writeln('  MENU CREAR VECTOR');
			writeln;
			writeln('  Ingrese la letra del apartado requerido');
			writeln;
			writeln('    A -  Cargar Manual');
			writeln('    B -  Cargar Aleatorio');
			leerOpcion('A','B',carga);
			writeln;
			writeln('  Bajo que criterio se creara');
			writeln;
			writeln('    A -  Agregar');
			writeln('    B -  Insertar Creciente');
			leerOpcion('A','B',modo);
			saltosLinea30(); saltosLinea30();
			leerTamanioVector();
			iniciarMarcos();
			iniciarVImp();
			if carga= 'A' then
				cargarVectorManual(v,modo)
			else
				cargarVectorAleatorio(v,modo);
			writeln;
			writeln;
			writeln;
			writeln('  Vector cargado:');
			imprimirVector(v);
			writeln;
			enterContinuar();
			B_Vector:= true;
		end;

	//    VISUALIZAR
	procedure imprimirVectorVertical(v: vector);
		var
			i: integer;
		begin
			writeln;
			writeln('   INDICE   ELEM');
			writeln('           _____');
			for i:= VEC_INI to Dim_F do begin
				write('    ',enteroCorregido(i+1),'  |');
				if v[i].est then
					write(enteroCorregido(v[i].nInt),' |')
				else
					write(' BSR |');
				if i= Dim_L then
					writeln('  DL')
				else
					writeln;
				write('          |_____|');
				if i = Dim_F then
					writeln('  DF')
				else
					writeln;
			end;
		end;
	procedure vectorVisualizar();
		var
			opc: char;
		begin
			saltosLinea30(); saltosLinea30();
				writeln('  MENU VISUALIZACION');
				writeln;
				writeln('  Ingrese la letra del apartado requerido');
				writeln;
				writeln('    A -  Ver normal');
				writeln('    B -  Ver vertical');
				leerOpcion('A','B',opc);
				writeln;
				writeln;
				writeln('  Vector:');
				if opc= 'A' then
					imprimirVector(V_Imp)
				else
					imprimirVectorVertical(V_Imp);
			if Dim_L= VEC_INI -1 then begin
				writeln;
				writeln('  El vector solo tiene basura porque no esta cargado');
			end;
			writeln;
			enterContinuar();
		end;

	//    AGREGAR
	procedure vectorAgregarValor();
		var
			carga,modo: char;
			n,i: integer;
		begin
			saltosLinea30(); saltosLinea30();
			if Dim_L< Dim_F then begin
				writeln('  MENU AGREGAR');
				writeln;
				writeln('  Ingrese la letra del apartado requerido');
				writeln;
				writeln('    A -  Valor Manual');
				writeln('    B -  Valor Aleatorio');
				leerOpcion('A','B',carga);
				writeln;
				writeln('  Bajo que criterio se agregara');
				writeln;
				writeln('    A -  Agregar');
				writeln('    B -  Insertar Creciente');
				leerOpcion('A','B',modo);
				saltosLinea30(); saltosLinea30();
				if carga= 'A' then begin
					recomendacionCarga();
					leerEntero('  Valor a cargar: ',n);
				end
				else begin
					writeln('  Valor random creado');
					n:= randomCarga();
				end;
				writeln;
				writeln;
				writeln('  Vector base:');
				imprimirVector(V_Imp);
				if modo= 'A' then begin
					agregarDerecha(V_Imp,n);
					i:= Dim_L
				end
				else begin
					insertarCreciente(V_Imp,n);
					i:= buscarVectorCreciente(V_Imp,n);
				end;
				writeln;
				writeln('  Valor a cargar:');
				imprimirElemento(V_Imp[i],i);
				writeln;
				writeln('  Vector cargado:');
				imprimirVector(V_Imp);
			end
			else
				imprimirVectorMensaje(V_Imp,'  Como Dimension Logica = Dimension Fisica no se pueden agregar mas valores');
			writeln;
			enterContinuar();
		end;

	//    ESTADISTICAS
	procedure tieneOrden(v: vector; var creciente,decreciente: boolean);
		var
			i: integer;
		begin
			if Dim_L> 0 then begin
				creciente:= true;
				decreciente:= true;
				i:= VEC_INI +1;
				while (i<= Dim_L) and (creciente or decreciente) do begin
					if v[i-1].nInt< v[i].nInt then
						decreciente:= false
					else if  v[i-1].nInt> v[i].nInt then
						creciente:= false;
					i:= i +1;
				end;
			end
			else begin
				creciente:= false;
				decreciente:= false;
			end;
		end;
	procedure minimoVector(v: vector; var min: integer);
		var
			i: integer;
		begin
			min:= VEC_INI;
			for i:= VEC_INI to Dim_L do
				if v[i].nInt< v[min].nInt then
					min:= i;
		end;
	procedure maximoVector(v: vector; var max: integer);
		var
			i: integer;
		begin
			max:= VEC_INI;
			for i:= VEC_INI to Dim_L do
				if v[i].nInt> v[max].nInt then
					max:= i;
		end;
	procedure vectorEstadisticas();
		var
			min,max: integer;
			creciente,decreciente: boolean;
		begin
			saltosLinea30(); saltosLinea30();
			if Dim_L>= VEC_INI then begin
				tieneOrden(V_Imp,creciente,decreciente);
				minimoVector(V_Imp,min);
				maximoVector(V_Imp,max);
				writeln('  ESTADISTICAS');
				writeln;
				writeln;
				writeln('  Vector:');
				imprimirVector(V_Imp);
				writeln;
				writeln('  Cantidad elementos cargado: ',Dim_L+1,' de ',Cant_Elem,' totales');
				writeln;
				writeln('  Orden');
				if Dim_L> VEC_INI then
					writeln('        Creciente: ',creciente,'   Decreciente: ',decreciente,'   Desordenada: ',not(creciente or decreciente))
				else
					writeln('        Como solo hay un elemento cargado, no existe orden alguno');
				writeln;
				writeln('  Minimo:');
				imprimirElemento(V_Imp[min],min);
				writeln;
				writeln('  Maximo:');
				imprimirElemento(V_Imp[max],max);
			end
			else
				imprimirVectorMensaje(V_Imp,'  Como no hay elementos cargados, no se puede calcular nada');
			writeln;
			enterContinuar();
		end;

	//    BUSCAR
	procedure vectorBuscarValor();
		var
			val,i: integer;
		begin
			saltosLinea30(); saltosLinea30();
			if Dim_L>= VEC_INI then begin
				leerEntero('  Valor a buscar: ',val);
				i:= buscarVectorDesorden(V_Imp,val);
				writeln;
				writeln;
				writeln('  Vector:');
				imprimirVector(V_Imp);
				if i>= VEC_INI then begin
					writeln;
					writeln('  El valor buscado se encuentra en el elemento:');
					imprimirElemento(V_Imp[i],i);
				end
				else
					writeln('  El valor no se encuentra en vector');
			end
			else
				imprimirVectorMensaje(V_Imp,'  Como no hay elementos cargados, no se puede buscar valor alguno');
			writeln;
			enterContinuar();
		end;

	//    SUMA
	function sumarValoresVector(v: vector): integer;
		var
			i: integer;
		begin
			sumarValoresVector:= 0;
			for i:= VEC_INI to Dim_L do
				sumarValoresVector:= v[i].nInt + sumarValoresVector;
		end;
	procedure vectorSumarValores();
		begin
			saltosLinea30(); saltosLinea30();
			if Dim_L>= VEC_INI then begin
				writeln('  Vector a sumar valores:');
				imprimirVector(V_Imp);
				writeln;
				writeln('  La sumatoria es: ',sumarValoresVector(V_Imp));
			end
			else
				imprimirVectorMensaje(V_Imp,'  Como no hay elementos cargados, no se puede sumar valor alguno');
			writeln;
			enterContinuar();
		end;

	//    ESCALAR
	procedure escalarValoresVector(var v: vector; esc: integer);
		var
			i: integer;
		begin
			for i:= VEC_INI to Dim_L do
				v[i].nInt:= v[i].nInt * esc;
		end;
	procedure vectorEscalarValores();
		var
			esc: integer;
		begin
			saltosLinea30(); saltosLinea30();
			if Dim_L>= VEC_INI then begin
				leerEntero('  Valor del escalar: ',esc);
				writeln;
				writeln('  Vector base:');
				imprimirVector(V_Imp);
				escalarValoresVector(V_Imp,esc);
				writeln;
				writeln('  Vector escalado:');
				imprimirVector(V_Imp);
			end
			else
				imprimirVectorMensaje(V_Imp,'  Como no hay elementos cargados, no se puede escalar valor alguno');
			writeln;
			enterContinuar();
		end;

	//    ELIMINAR
	procedure eliminarValorVector(var v: vector; val: integer; var est: boolean);
		var
			i: integer;
		begin
			i:= buscarVectorDesorden(v,val);
			if i>= VEC_INI then begin
				Dim_L:= Dim_L -1;
				for i:= i to Dim_L do
					v[i].nInt:= v[i+1].nInt;
				est:= true;
			end
			else
				est:= false;
		end;
	procedure eliminarValoresIgualesVector(var v: vector; val: integer; var est: boolean);
		var
			i,j: integer;
		begin
			i:= VEC_INI;
			est:= false;
			while i<= Dim_L do begin
				if v[i].nInt<> val then
					i:= i +1
				else begin
					Dim_L:= Dim_L -1;
					for j:= i to Dim_L do
						v[j].nInt:= v[j+1].nInt;
					est:= true;
				end
			end;
		end;
	procedure eliminarValoresRangoVector(var v: vector; min,max: integer; var est: boolean);
		var
			i,j: integer;
		begin
			i:= VEC_INI;
			est:= false;
			while i<= Dim_L do begin
				if (v[i].nInt< min) or (v[i].nInt> max) then
					i:= i +1
				else begin
					Dim_L:= Dim_L -1;
					for j:= i to Dim_L do
						v[j].nInt:= v[j+1].nInt;
					est:= true;
				end
			end;
		end;
	procedure eliminarValoresVector();
		begin
			Dim_L:= VEC_INI -1;
		end;
	procedure vectorEliminar();
		var
			opc: char;
			val,min,max: integer;
			est: boolean;
		begin
			saltosLinea30(); saltosLinea30();
			if Dim_L>= VEC_INI then begin
				writeln('  MENU ELIMINAR');
				writeln;
				writeln('  Ingrese la letra del apartado requerido');
				writeln;
				writeln('    A -  Eliminar un valor');
				writeln('    B -  Eliminar un valor y sus repeticiones');
				writeln('    C -  Eliminar rango');
				writeln('    D -  Eliminar todos los valores');
				leerOpcion('A','D',opc);
				writeln;
				writeln;
				case opc of
					'A'..'B':	leerEntero('  Valor a eliminar: ',val);
					'C'	:	leerRangoEntero('  Valor minimo a eliminar: ','  Valor maximo a eliminar: ',min,max);
				end;
				if opc<> 'D' then begin
					writeln;
					writeln;
				end;
				writeln('  Vector base:');
				imprimirVector(V_Imp);
				case opc of
					'A' :	eliminarValorVector(V_Imp,val,est);
					'B'	:	eliminarValoresIgualesVector(V_Imp,val,est);
					'C'	:	eliminarValoresRangoVector(V_Imp,min,max,est);
					'D'	:	eliminarValoresVector();
				end;
				writeln;
				writeln('  Vector despues de eliminar:');
				imprimirVector(V_Imp);
				if not est then begin
					writeln;
					writeln('  Como no se encontro valor/es a eliminar el vector no se modifico');
				end;
			end
			else
				imprimirVectorMensaje(V_Imp,'  Como no hay elementos cargados, no se puede eliminar valor alguno');
			writeln;
			enterContinuar();
		end;

	//    ORDENAR
	Procedure insercionCreciente(var v: vector);
		var
			i,j,actual: integer;
		begin
			for i:= VEC_INI +1 to Dim_L do begin
				actual:= v[i].nInt;
				j:= i-1; 
				while (j > VEC_INI-1) and (v[j].nInt > actual) do begin
					v[j+1]:= v[j];
				j:= j -1;
				end;  
				 v[j+1].nInt:= actual;
			end;
		end;
	Procedure insercionDecreciente(var v: vector);
		var
			i,j,actual: integer;
		begin
			for i:= VEC_INI +1 to Dim_L do begin
				actual:= v[i].nInt;
				j:= i-1; 
				while (j > VEC_INI-1) and (v[j].nInt < actual) do begin
					v[j+1]:= v[j];
				j:= j -1;
				end;  
				 v[j+1].nInt:= actual;
			end;
		end;
	procedure vectorOrdenar();
		var
			opc: char;
		begin
			saltosLinea30(); saltosLinea30();
			if Dim_L> VEC_INI then begin
				writeln('  MENU ORDENAR');
				writeln;
				writeln('  Ingrese la letra del apartado requerido');
				writeln;
				writeln('    A -  Ordenar Creciente');
				writeln('    B -  Ordenar Decreciente');
				leerOpcion('A','B',opc);
				writeln;
				writeln;
				writeln('  Vector base:');
				imprimirVector(V_Imp);
				if opc= 'A' then
					insercionCreciente(V_Imp)
				else
					insercionDecreciente(V_Imp);
				writeln;
				write('  Vector ordenado de forma ');
				if opc= 'A' then
					writeln('creciente:')
				else
					writeln('decreciente:');
				imprimirVector(V_Imp);
			end
			else if Dim_L= VEC_INI then
				imprimirVectorMensaje(V_Imp,'  Como solo hay un elemento cargado no tiene sentido ordenar el vector')
			else
				imprimirVectorMensaje(V_Imp,'  Como no hay elementos cargados no se puede ordenar el vector');
			writeln;
			enterContinuar();
		end;

	//    INVERTIR
	procedure invertirVector(var v: vector);
		var
			i,j,aux: integer;
		begin
			j:= Dim_L +1;
			for i:= VEC_INI to Dim_L div 2 do begin
				j:= j -1;
				aux:= v[i].nInt;
				v[i].nInt:= v[j].nInt;
				v[j].nInt:= aux;
			end;
		end;
	procedure vectorInvertir();
		begin
			saltosLinea30(); saltosLinea30();
			if Dim_L> VEC_INI then begin
				writeln('  Vector base:');
				imprimirVector(V_Imp);
				invertirVector(V_Imp);
				writeln;
				writeln('  Vector invertido:');
				imprimirVector(V_Imp);
			end
			else if Dim_L= VEC_INI then
				imprimirVectorMensaje(V_Imp,'  Como solo hay un elemento cargado no tiene sentido invertir el vector')
			else
				imprimirVectorMensaje(V_Imp,'  Como no hay elementos cargados no se puede invertir el vector');
			writeln;
			enterContinuar();
		end;

	//    COMPARACION ORDENAMIENTO
	procedure seleccionMedicion(v: vector; var comp,asig: integer);
		var
			i, j, k, item: integer;
		begin
			comp:= 1;
			asig:= 1;
			for i:= VEC_INI to Dim_L -1 do begin
				k:= i;
				asig:= asig +3;
				comp:= comp +2;
				for j:= i+1 to Dim_L do begin
					comp:= comp +2;
					asig:= asig +1;
					if v[j].nInt < v[k].nInt then begin
						k:= j;
						asig:= asig +1;
					end;
				end;
				item:= v[k].nInt;   
				v[k].nInt:= v[i].nInt;   
				v[i].nInt:= item;
				asig:= asig +3;
			end;
		end;
	procedure insercionMedicion(v: vector; var comp,asig: integer);
		var
			i, j, actual: integer;
		begin
			comp:= 1;
			asig:= 1;
			for i:= VEC_INI+1 to Dim_L do begin
				actual:= v[i].nInt;
				j:= i-1; 
				asig:= asig +3;
				comp:= comp +3;
				while (j > VEC_INI-1) and (v[j].nInt > actual) do begin
					v[j+1].nInt:= v[j].nInt;
					j:= j -1;
					asig:= asig +2;
					comp:= comp +2;
				end;  
				v[j+1].nInt:= actual;
				asig:= asig +1;
			end;
		end;
	procedure vectorComparacion();
		var
			selComp,selAsig,insComp,insAsig: integer;
			vSel,vIns: vector;
		begin
			saltosLinea30(); saltosLinea30();
			if Dim_L> VEC_INI then begin
				copiarVector(V_Imp,vSel);
				seleccionMedicion(vSel,selComp,selAsig);
				copiarVector(V_Imp,vIns);
				insercionMedicion(vIns,insComp,insAsig);
				writeln('  Comparacion de Algoritmos de Ordenamiento de Vectores');
				writeln;
				writeln('    Como los vectores con los que se trabaja tienen pocos elementos, calcular el tiempo');
				writeln('    de ejecucion no muestra diferencia alguna, por lo que se comparara mediante cantidad');
				writeln('    de asignaciones y comparaciones de manera aproximada, lo cual indica cual ordena en');
				writeln('    menos instrucciones');
				writeln;
				enterContinuar();
				writeln;
				writeln;
				writeln('  Vector base:');
				imprimirVector(V_Imp);
				writeln;
				writeln;
				writeln('  Vector por seleccion:');
				imprimirVector(vSel);
				writeln('    Comparaciones: ',selComp,'   Asignaciones: ',selAsig);
				writeln;
				writeln;
				writeln('  Vector por insercion:');
				imprimirVector(vIns);
				writeln('    Comparaciones: ',insComp,'   Asignaciones: ',insAsig);
			end
			else if Dim_L= VEC_INI then
				imprimirVectorMensaje(V_Imp,'  Como solo hay un elemento cargado no tiene sentido comparar ordenamientos')
			else
				imprimirVectorMensaje(V_Imp,'  Como no hay elementos cargados no se puede comparar ordenamientos');
			writeln;
			enterContinuar();
		end;

	//    MENU OPERACIONES
	procedure menuOperacionesVector();
		var
			opc: char;
		begin
			C_Tema:= ' ';
			if B_App and B_Est and B_Ope then begin
				saltosLinea30(); saltosLinea30();
				writeln('  MENU OPERACIONES');
				writeln;
				writeln('  Ingrese la letra del apartado requerido');
				writeln;
				writeln('    A -  Visualizar');
				writeln('    B -  Agregar Valor');
				writeln('    C -  Estadisticas');
				writeln('    D -  Buscar Valor');
				writeln('    E -  Sumar Valores');
				writeln('    F -  Escalar Valores');
				writeln('    G -  Eliminar');
				writeln('    H -  Ordenar');
				writeln('    I -  Invertir');
				writeln('    J -  Comparar Algoritmos Ordenamiento');
				writeln;
				writeln('    K -  Nuevo Vector');
				writeln;
				writeln('    L -  Menu Vector');
				writeln('    M -  Menu Inicio');
				writeln('    N -  Cerrar Aplicacion');
				leerOpcion('A','N',opc);
				case opc of
					'A'..'J':	C_Tema:= opc;
					'K':	B_Vector:= false;
					'L':	B_Ope:= false;
					'M':	B_Est:= false;
					'N':	B_App:= false;
				end;
			end;
		end;

	//    MENU VECTOR 
	procedure infoVectores();
		begin
			saltosLinea30(); saltosLinea30();
			writeln('  INFORMACION:');
			writeln;
			writeln('    Este apartado de la aplicacion tiene el fin de ayudar a entender la');
			writeln('    estructura de datos Vectores, a la vez de ser una manera de poner en');
			writeln('    practica los conocimientos sobre estos mismos');
			writeln;
			writeln('    Usted podra crear un vector y realizar algunas operaciones sobre el');
			writeln('    viendo como se almacenan logicamente los datos. En particular los');
			writeln('    datos son valores enteros, pero es posible modificarlo de asi requerirlo');
			writeln('    mediante el codigo de la aplicacion');
			writeln;
			enterContinuar();
		end;
	procedure menuVector();
		var
			opc: char;
		begin
			while B_App and B_Est and not B_Ope do begin
				saltosLinea30(); saltosLinea30();
				writeln('  MENU VECTORES');
				writeln;
				writeln('  Ingrese la letra del apartado requerido');
				writeln;
				writeln('    A -  Crear VECTOR');
				writeln('    B -  Informacion Vectores');
				writeln;
				writeln('    C -  Menu Inicio');
				writeln('    D -  Cerrar aplicacion');
				leerOpcion('A','D',opc);
				case opc of
					'A':	B_Ope:= true;
					'B':	infoVectores();
					'C':	B_Est:= false;
					'D':	B_App:= false;
				end;
			end;
		end;

	//  PROGRAMA PRINCIPAL VECTOR
	begin
		configsDefaultVector();
		menuVector();
		while B_App and B_Est do begin
			repeat
				crearVector(V_Imp);
				menuOperacionesVector();
				while B_App and B_Est and B_Ope and B_Vector do begin
					case C_Tema of
						'A':	vectorVisualizar();
						'B':	vectorAgregarValor();
						'C':	vectorEstadisticas();
						'D':	vectorBuscarValor();
						'E':	vectorSumarValores();
						'F':	vectorEscalarValores();
						'G':	vectorEliminar();
						'H':	vectorOrdenar();
						'I':	vectorInvertir();
						'J':	vectorComparacion();
					end;
					menuOperacionesVector();
				end;
			until not B_App or not B_Est or not B_Ope;
			menuVector();
		end;
		setlength(V_Imp,0);
	end;



//    LISTA
procedure estructuraLista();
	const
		CARGA_RANGO_MIN= -9;
		CARGA_RANGO_MAX= 99;
		CARGA_CANT_NODOS= 9;
		MAX_CANT_NODOS= 100;
		NODOS_LINEA= 10;

	type
		dato= record
			nInt: integer;
			nomAct: string;
			nomSig: string;
		end;
		lista= ^nodo;
		nodo= record
			elem: dato;
			sig: lista;
		end;

	var
		B_Lista: boolean;
		C_Tema: char;
		L_Imp,L_Aux: lista;
		Cant_Nodos: integer;

	//  CONFIGURACIONES DEFAULTS LISTA
	procedure configsDefaultLista();
		begin
			B_Ope:= false;
			B_Lista:= false;
			L_Imp:= nil;
			L_Aux:= nil;
			Rango_Min:= CARGA_RANGO_MIN;
			Rango_Max:= CARGA_RANGO_MAX;
			Cant_Nodos:= CARGA_CANT_NODOS;
		end;

	//    MODULOS COMUNES
	procedure crearNodo(var nue: lista; var n: integer; val: integer);
		begin
			n:= n +1;
			new(nue);
			nue^.elem.nInt:= val;
			nue^.elem.nomAct:= intToLttToStr(n);
			nue^.elem.nomSig:= 'NIL';
			if n< 10 then
				nue^.elem.nomAct:= nue^.elem.nomAct +' ';
			nue^.sig:= nil;
		end;
	procedure crearNodoDefault(var nue: lista;val: integer);
		begin
			new(nue);
			nue^.elem.nInt:= val;
			nue^.elem.nomAct:= 'DEFAULT';
			nue^.elem.nomSig:= 'NIL';
			nue^.sig:= nil;
		end;

	procedure agregarDerecha(var l,ult: lista; nue: lista);
		begin
			if l= nil then
				l:= nue
			else begin
				ult^.elem.nomSig:= nue^.elem.nomAct;
				ult^.sig:= nue;
			end;
			ult:= nue;
		end;
	procedure agregarDerechaRecorrido(var l: lista; nue: lista);
		var
			act: lista;
		begin
			if l<> nil then begin
				act:= l;
				while act^.sig <> nil do
					act:= act^.sig;
				act^.elem.nomSig:= nue^.elem.nomAct;
				act^.sig:= nue;
			end
			else
				l:= nue;
		end;
	procedure agregarIzquierda(var l: lista; nue: lista);
		begin
			nue^.sig:= l;
			if l<> nil then
				nue^.elem.nomSig:= l^.elem.nomAct;
			l:= nue;
		end;
	procedure insertarCreciente(var l: lista; nue: lista);
		var
			ant,act: lista;
		begin
			act:= l;
			while (act<> nil) and (act^.elem.nInt< nue^.elem.nInt) do begin
				ant:= act;
				act:= act^.sig;
			end;
			if act<> nil then
				nue^.elem.nomSig:= act^.elem.nomAct;
			if act= l then
				l:= nue
			else begin
				ant^.elem.nomSig:= nue^.elem.nomAct;
				ant^.sig:= nue;
			end;
			nue^.sig:= act;
		end;
	procedure eliminarLista(var l: lista);
		var
			act: lista;
		begin
			while l<> nil do begin
				act:= l;
				l:= l^.sig;
				dispose(act);
			end;
		end;
	function buscarListaDesorden(l: lista; n: integer): lista;
		begin
			while (l<> nil) and (l^.elem.nInt<> n) do
				l:= l^.sig;
			buscarListaDesorden:= l;
		end;
	procedure actualizarNomSig(l: lista);
		begin
			while l<> nil do begin
				if l^.sig<> nil then
					l^.elem.nomSig:= l^.sig^.elem.nomAct
				else
					l^.elem.nomSig:= 'NIL';
				l:= l^.sig;
			end;
		end;

	//    IMPRIMIR
	procedure imprimirNodoLista(l: lista);
		begin
			if l<> nil then begin
				writeln('    Nodo: ',l^.elem.nomAct);
				writeln('      Valor: ',l^.elem.nInt);
				writeln('      Sig: ',l^.elem.nomSig);
			end
			else
				writeln('  No existe nodo');
		end;
	procedure imprimirListaLinea(l: lista);
		var
			lA: lista;
			i: integer;
		begin
			lA:= l;
			i:= 0;
			while (lA<> nil) and (i< NODOS_LINEA) do begin
				i:= i +1;
				write('  Nodo: ',lA^.elem.nomAct,'   ');
				if length(lA^.elem.nomAct)=1 then
					write(' ');
				lA:= lA^.sig;
			end;
			lA:= l;
			writeln;
			i:= 0;
			while (lA<> nil) and (i< NODOS_LINEA) do begin
				i:= i +1;
				write('    Val: ');
				write(lA^.elem.nInt,'  ');
				if (lA^.elem.nInt< 10) and (lA^.elem.nInt> -1) then
					write(' ');
				lA:= lA^.sig;
			end;
			writeln;
			i:= 0;
			while (l<> nil) and (i< NODOS_LINEA) do begin
				i:= i +1;
				write('    Sig: ',l^.elem.nomSig,'  ');
				if length(l^.elem.nomSig)=1 then
					write(' ');
				l:= l^.sig;
			end;
			writeln;
			writeln;
			if l<> nil then
				imprimirListaLinea(l);
		end;

	//    CREAR
	procedure recomendacionCarga();
		begin
			writeln('  RECOMENDACION');
			writeln;
			writeln('    Cargar un rango de valores de 0 a 99, con una cantidad ');
			writeln('    maxima de ',NODOS_LINEA -2,' valores para una buena visualizacion');
			writeln;
			writeln;
		end;
	procedure cargarListaManual(var l: lista; modo: char);
		var
			ok: boolean;
			code: word;
			i,n: integer;
			rString: string;
			d: dato;
			nue,ult: lista;
		begin
			eliminarLista(l);
			n:= -1;
			i:= 0;
			writeln('  Carga Manual');
			writeln;
			writeln('  Ingrese n o N para dejar de ingresar valores');
			writeln;
			writeln;
			repeat
				i:= i +1;
				repeat
					write('    Valor ',i,': '); readln(rString);
					val(rString,d.nInt,code);
					ok:= (code= 0) or (rString[code]= 'n') or (rString[code]= 'N');
					if not ok then begin
						writeln('  Solo numeros enteros, intente nuevamente');
						write('  '); readln;
					end
				until ok;
				if code= 0 then begin
					crearNodo(nue,n,d.nInt);
					case modo of
						'A': 	agregarDerecha(l,ult,nue);
						'B':	agregarIzquierda(l,nue);
						'C':	insertarCreciente(l,nue);
					end;
				end
				else
					if i= 1 then begin
						writeln('  Una lista al menos tiene un nodo, intente nuevamente');
						write('  '); readln;
						i:= i -1;
						code:= 0;
					end;
			until (code<> 0) or (n= MAX_CANT_NODOS);
			if n= MAX_CANT_NODOS then
				writeln('  Ya se ingreso la maxima cantidad representable correctamente');
			Cant_Nodos:= n;
		end;
	procedure cargarListaAleatorio(var l: lista; modo: char);
		var
			i,n: integer;
			ult,nue: lista;
		begin
			eliminarLista(l);
			n:= -1;
			writeln('  Carga Aleatoria');
			writeln;
			leerRangoEntero('    Valor Minimo incluido: ','    Valor Maximo incluido: ',Rango_Min,Rango_Max);
			writeln;
			repeat
				leerEntero('    Cantidad de valores de la lista: ',Cant_Nodos);
				if Cant_Nodos< 1 then begin
					writeln('    Una lista al menos tiene un valor, intente nuevamente');
					write('  '); readln;
				end
				else if Cant_Nodos> MAX_CANT_NODOS then begin
					writeln('    No se puede mostrar correctamente, ingrese una cantidad menor');
					write('  '); readln;
				end;
			until (Cant_Nodos> 0) and (Cant_Nodos< MAX_CANT_NODOS +1);
			for i:= 1 to Cant_Nodos do begin
				crearNodo(nue,n,randomCarga());
				case modo of
					'A': 	agregarDerecha(l,ult,nue);
					'B':	agregarIzquierda(l,nue);
					'C':	insertarCreciente(l,nue);
				end;
			end;
		end;
	procedure crearLista(var l: lista);
		var
			carga,modo: char;
		begin
			saltosLinea30(); saltosLinea30();
			writeln('  MENU CREAR LISTA');
			writeln;
			writeln('  Ingrese la letra del apartado requerido');
			writeln;
			writeln('    A -  Cargar Manual');
			writeln('    B -  Cargar Aleatorio');
			leerOpcion('A','B',carga);
			writeln;
			writeln('  Bajo que criterio se creara');
			writeln;
			writeln('    A -  Agregar Ultimo');
			writeln('    B -  Agregar Primero');
			writeln('    C -  Insertar Creciente');
			leerOpcion('A','C',modo);
			saltosLinea30(); saltosLinea30();
			recomendacionCarga();
			if carga= 'A' then
				cargarListaManual(l,modo)
			else
				cargarListaAleatorio(l,modo);
			writeln;
			writeln;
			writeln('  Lista cargada:');
			imprimirListaLinea(l);
			writeln;
			enterContinuar();
			B_Lista:= true;
		end;

	//    VISUALIZAR
	procedure imprimirListaDiagonal(l: lista);
		var
			esp: string;
		begin
			esp:= '';
			writeln;
			while l<> nil do begin
				writeln('  Nodo: ',l^.elem.nomAct);
				writeln(esp,'    Valor: ',l^.elem.nInt);
				write(esp,'    Sig: ',l^.elem.nomSig,'  ');
				l:= l^.sig;
				esp:= esp + '             ';
			end;
		end;
	procedure imprimirListaVertIniFin(l: lista);
		begin
			while l<> nil do begin
				writeln;
				writeln('    Nodo: ',l^.elem.nomAct);
				writeln('      Valor: ',l^.elem.nInt);
				writeln('      Sig: ',l^.elem.nomSig);
				l:= l^.sig;
			end;
		end;
	procedure imprimirListaVertFinIni(l: lista);
		begin
			writeln;
			if l<> nil then begin
				imprimirListaVertFinIni(l^.sig);
				writeln;
				writeln('    Nodo: ',l^.elem.nomAct);
				writeln('      Valor: ',l^.elem.nInt);
				writeln('      Sig: ',l^.elem.nomSig);
			end;
		end;

	procedure listaVisualizar();
		var
			opc: char;
		begin
			saltosLinea30(); saltosLinea30();
			if L_Imp<> nil then begin
				writeln('  MENU VISUALIZACION');
				writeln;
				writeln('  Ingrese la letra del apartado requerido');
				writeln;
				writeln('    A -  Ver en sucesion');
				writeln('    B -  Ver en diagonal');
				writeln('    C -  Ver en vertical inicio - final');
				writeln('    D -  Ver en vertical final - inicio');
				leerOpcion('A','D',opc);
				writeln;
				writeln;
				writeln('  Lista:');
				case opc of
					'A' :	imprimirListaLinea(L_Imp);
					'B'	:	imprimirListaDiagonal(L_Imp);
					'C'	:	imprimirListaVertIniFin(L_Imp);
					'D'	:	imprimirListaVertFinIni(L_Imp);
				end;
			end
			else
				writeln('  No hay lista para visualizar');
			writeln;
			enterContinuar();
		end;

	//    AGREGAR
	procedure listaAgregarValor();
		var
			carga,modo: char;
			n: integer;
			nue: lista;
		begin
			saltosLinea30(); saltosLinea30();
			writeln('  MENU AGREGAR');
			writeln;
			writeln('  Ingrese la letra del apartado requerido');
			writeln;
			writeln('    A -  Valor Manual');
			writeln('    B -  Valor Aleatorio');
			leerOpcion('A','B',carga);
			writeln;
			writeln('  Bajo que criterio se agregara');
			writeln;
			writeln('    A -  Agregar Ultimo');
			writeln('    B -  Agregar Primero');
			writeln('    C -  Insertar Creciente');
			leerOpcion('A','C',modo);
			saltosLinea30(); saltosLinea30();
			if carga= 'A' then begin
				recomendacionCarga();
				leerEntero('  Valor a cargar: ',n);
			end
			else begin
				writeln('  Valor random creado');
				n:= randomCarga();
			end;
			crearNodo(nue,Cant_Nodos,n);
			writeln;
			writeln;
			writeln('  Lista base:');
			imprimirListaLinea(L_Imp);
			writeln;
			writeln('  Valor a cargar:');
			imprimirNodoLista(nue);
			
			case modo of
				'A': 	agregarDerechaRecorrido(L_Imp,nue);
				'B':	agregarIzquierda(L_Imp,nue);
				'C':	insertarCreciente(L_Imp,nue);
			end;
			writeln;
			writeln('  Lista cargada:');
			imprimirListaLinea(L_Imp);
			writeln;
			enterContinuar();
		end;

	//    ESTADISTICAS
	function cantidadNodosLista(l: lista): integer;
		begin
			if l<> nil then
				cantidadNodosLista:= 1 + cantidadNodosLista(l^.sig)
			else
				cantidadNodosLista:= 0;
		end;
	procedure tieneOrden(l: lista; var creciente,decreciente: boolean);
		var
			ant: lista;
		begin
			ant:= l;
			creciente:= true;
			decreciente:= true;
			while (l<> nil) and (creciente or decreciente) do begin
				if ant^.elem.nInt< l^.elem.nInt then
					decreciente:= false
				else if ant^.elem.nInt> l^.elem.nInt then
					creciente:= false;
				ant:= l;
				l:= l^.sig;
			end;
		end;
	procedure minimoLista(l: lista; var min: lista);
		begin
			if l<> nil then begin
				minimoLista(l^.sig,min);
				if l^.elem.nInt< min^.elem.nInt then
					min:= l;
			end
			else
				crearNodoDefault(min,9999);
		end;
	procedure maximoLista(l: lista; var max: lista);
		begin
			if l<> nil then begin
				maximoLista(l^.sig,max);
				if l^.elem.nInt> max^.elem.nInt then
					max:= l;
			end
			else
				crearNodoDefault(max,-9999);
		end;
	procedure listaEstadisticas();
		var
			cant: integer;
			min,max: lista;
			creciente,decreciente: boolean;
		begin
			saltosLinea30(); saltosLinea30();
			if L_Imp<> nil then begin
				cant:= cantidadNodosLista(L_Imp);
				tieneOrden(L_Imp,creciente,decreciente);
				minimoLista(L_Imp,min);
				maximoLista(L_Imp,max);
				writeln('  ESTADISTICAS');
				writeln;
				writeln;
				writeln('  Lista:');
				imprimirListaLinea(L_Imp);
				writeln;
				writeln('    Cantidad de nodos: ',cant);
				writeln;
				writeln('    Orden');
				writeln('          Creciente: ',creciente,'   Decreciente: ',decreciente,'   Desordenada: ',not(creciente or decreciente));
				writeln;
				writeln('    Minimo:');
				imprimirNodoLista(min);
				writeln;
				writeln('    Maximo:');
				imprimirNodoLista(max);
			end
			else
				writeln('  No hay lista para ver estadisticas');
			writeln;
			enterContinuar();
		end;

	//    BUSCAR
	procedure listaBuscarValor();
		var
			v: integer;
			lAux: lista;
		begin
			saltosLinea30(); saltosLinea30();
			if L_Imp<> nil then begin
				leerEntero('  Valor a buscar: ',v);
				lAux:= buscarListaDesorden(L_Imp,v);
				writeln;
				writeln;
				writeln('  Lista:');
				imprimirListaLinea(L_Imp);
				if lAux<> nil then begin
					writeln;
					writeln('  El valor buscado se encuentra en el nodo:');
					imprimirNodoLista(lAux);
				end
				else
					writeln('  El valor no se encuentra en la lista');
			end
			else
				writeln('  No hay lista para buscar algun valor');
			writeln;
			enterContinuar();
		end;

	//    SUMA
	function sumarValoresLista(l: lista): integer;
		begin
			if l<> nil then
				sumarValoresLista:= l^.elem.nInt + sumarValoresLista(l^.sig)
			else
				sumarValoresLista:= 0;
		end;
	procedure listaSumarValores();
		begin
			saltosLinea30(); saltosLinea30();
			if L_Imp<> nil then begin
				writeln('  Lista a sumar valores:');
				imprimirListaLinea(L_Imp);
				writeln;
				writeln('  La sumatoria es: ',sumarValoresLista(L_Imp));
			end
			else
				writeln('  No hay lista para sumar');
			writeln;
			enterContinuar();
		end;

	//    ESCALAR
	procedure escalarValoresLista(l: lista; esc: integer);
		begin
			while l<> nil do begin
				l^.elem.nInt:= l^.elem.nInt * esc;
				l:= l^.sig;
			end;
		end;
	procedure listaEscalarValores();
		var
			esc: integer;
		begin
			saltosLinea30(); saltosLinea30();
			if L_Imp<> nil then begin
				leerEntero('  Valor del escalar: ',esc);
				writeln;
				writeln('  Lista base:');
				imprimirListaLinea(L_Imp);
				escalarValoresLista(L_Imp,esc);
				writeln;
				writeln('  Lista escalada:');
				imprimirListaLinea(L_Imp);
			end
			else
				writeln('  No hay lista para escalar');
			writeln;
			enterContinuar();
		end;

	//    ELIMINAR
	procedure eliminarNodoLista(var l: lista; n: integer);
		var
			ant,act: lista;
		begin
			act:= l;
			while (act<> nil) and (act^.elem.nInt<> n) do begin
				ant:= act;
				act:= act^.sig;
			end;
			if act<> nil then begin
				if act= l then
					l:= l^.sig
				else begin
					if act^.sig<> nil then
						ant^.elem.nomSig:= act^.sig^.elem.nomAct
					else
						ant^.elem.nomSig:= 'NIL';
					ant^.sig:= act^.sig;
				end;
				dispose(act);
			end;
		end;
	procedure eliminarNodosIgualesLista(var l: lista; n: integer);
		var
			ant,act,aux: lista;
		begin
			act:= l;
			while act<> nil do begin
				if act^.elem.nInt<> n then begin
					ant:= act;
					act:= act^.sig;
				end
				else begin
					if act= l then
						l:= l^.sig
					else
						ant^.sig:= act^.sig;
					aux:= act;
					act:= act^.sig;
					dispose(aux);
				end;
			end;
			actualizarNomSig(l);
		end;
	procedure eliminarNodosRangoLista(var l: lista; min,max: integer);
		var
			ant,act,aux: lista;
		begin
			act:= l;
			while act<> nil do begin
				if (act^.elem.nInt< min) or (act^.elem.nInt> max) then begin
					ant:= act;
					act:= act^.sig;
				end
				else begin
					if act= l then
						l:= l^.sig
					else
						ant^.sig:= act^.sig;
					aux:= act;
					act:= act^.sig;
					dispose(aux);
				end;
			end;
			actualizarNomSig(l);
		end;
	procedure listaEliminar();
		var
			opc: char;
			val,min,max: integer;
		begin
			saltosLinea30(); saltosLinea30();
			if L_Imp<> nil then begin
				writeln('  MENU ELIMINAR');
				writeln;
				writeln('  Ingrese la letra del apartado requerido');
				writeln;
				writeln('    A -  Eliminar un valor');
				writeln('    B -  Eliminar un valor y sus repeticiones');
				writeln('    C -  Eliminar rango');
				writeln('    D -  Eliminar lista');
				leerOpcion('A','D',opc);
				writeln;
				writeln;
				case opc of
					'A'..'B':	leerEntero('  Valor a eliminar: ',val);
					'C'	:	leerRangoEntero('  Valor minimo a eliminar: ','  Valor maximo a eliminar: ',min,max);
				end;
				if opc<> 'D' then begin
					writeln;
					writeln;
				end;
				writeln('  Lista base:');
				imprimirListaLinea(L_Imp);
				case opc of
					'A' :	eliminarNodoLista(L_Imp,val);
					'B'	:	eliminarNodosIgualesLista(L_Imp,val);
					'C'	:	eliminarNodosRangoLista(L_Imp,min,max);
					'D'	:	eliminarLista(L_Imp);
				end;
				writeln;
				writeln('  Lista despues de eliminar:');
				if L_Imp<> nil then
					imprimirListaLinea(L_Imp)
				else begin
					writeln;
					writeln('  Vacia');
				end;
			end
			else
				writeln('  No hay lista para eliminar');
			writeln;
			enterContinuar();
		end;

	//    INVERTIR
	procedure invertirLista(l: lista; var n: integer; var lNue,ult: lista);
		var
			aux: lista;
		begin
			if l<> nil then begin
				invertirLista(l^.sig,n,lNue,ult);
				crearNodo(aux,n,l^.elem.nInt);
				agregarDerecha(lNue,ult,aux);
			end
			else begin
				lNue:= nil;
				n:= -1;
			end;
		end;
	procedure listaInvertir();
		var
			n: integer;
			lUlt: lista;
		begin
			saltosLinea30(); saltosLinea30();
			if L_Imp<> nil then begin
				writeln('  Lista base:');
				imprimirListaLinea(L_Imp);
				invertirLista(L_Imp,n,L_Aux,lUlt);
				writeln;
				writeln('  Lista invertida:');
				imprimirListaLinea(L_Aux);
				eliminarLista(L_Imp);
				L_Imp:= L_Aux;
				L_Aux:= nil;
			end
			else
				writeln('  No hay lista para invertir');
			writeln;
			enterContinuar();
		end;

	//    ORDENAR
	procedure ordenarListaCreciente(l: lista);
		var
			lA,lAct,lMax: lista;
			aux: dato;
		begin
			lA:= l;
			while l<> nil do begin
				lMax:= l;
				lAct:= l^.sig;
				while lAct<> nil do begin
					if lAct^.elem.nInt< lMax^.elem.nInt then
						lMax:= lAct;
					lAct:= lAct^.sig;
				end;
				if l<> lMax then begin
					aux:= l^.elem;
					l^.elem:= lMax^.elem;
					lMax^.elem:= aux;
				end;
				l:= l^.sig;
			end;
			actualizarNomSig(lA);
		end;
	procedure ordenarListaDecreciente(l: lista);
		var
			lA,lAct,lMax: lista;
			aux: dato;
		begin
			lA:= l;
			while l<> nil do begin
				lMax:= l;
				lAct:= l^.sig;
				while lAct<> nil do begin
					if lAct^.elem.nInt> lMax^.elem.nInt then
						lMax:= lAct;
					lAct:= lAct^.sig;
				end;
				if l<> lMax then begin
					aux:= l^.elem;
					l^.elem:= lMax^.elem;
					lMax^.elem:= aux;
				end;
				l:= l^.sig;
			end;
			actualizarNomSig(lA);
		end;
	procedure listaOrdenar();
		var
			opc: char;
		begin
			saltosLinea30(); saltosLinea30();
			if L_Imp<> nil then begin
				writeln('  MENU ORDENAR');
				writeln;
				writeln('  Ingrese la letra del apartado requerido');
				writeln;
				writeln('    A -  Ordenar Creciente');
				writeln('    B -  Ordenar Decreciente');
				leerOpcion('A','B',opc);
				writeln;
				writeln;
				writeln('  Lista base:');
				imprimirListaLinea(L_Imp);
				if opc= 'A' then
					ordenarListaCreciente(L_Imp)
				else
					ordenarListaDecreciente(L_Imp);
				writeln;
				write('  Lista ordenada de forma');
				if opc= 'A' then
					writeln('creciente:')
				else
					writeln('decreciente:');
				imprimirListaLinea(L_Imp);
			end
			else
				writeln('  No hay lista para ordenar');
			writeln;
			enterContinuar();
		end;

	//    MERGE
	procedure minimoEntreListas(var lPri,lSeg: lista; var elem: dato);
		begin
			if lPri<> nil then begin
				if lSeg<> nil then begin
					if lPri^.elem.nInt<= lSeg^.elem.nInt then begin
						elem:= lPri^.elem;
						lPri:= lPri^.sig;
					end
					else begin
						elem:= lSeg^.elem;
						lSeg:= lSeg^.sig;
					end;
				end
				else begin
					elem:= lPri^.elem;
					lPri:= lPri^.sig;
				end
			end
			else if lSeg<> nil then begin
				elem:= lSeg^.elem;
				lSeg:= lSeg^.sig;
			end;
		end;
	procedure mergeListaOrdenado(lPri,lSeg: lista; var lNue: lista);
		var
			d: dato;
			n: integer;
			nue,ult: lista;
		begin
			n:= -1;
			lNue:= nil;
			while (lPri<> nil) or (lSeg<> nil) do begin
				minimoEntreListas(lPri,lSeg,d);
				crearNodo(nue,n,d.nInt);
				agregarDerecha(lNue,ult,nue);
			end;
		end;
	procedure listaMerge();
		var
			creciente,decreciente: boolean;
			lNue: lista;
		begin
			saltosLinea30(); saltosLinea30();
			if L_Imp<> nil then begin
				tieneOrden(L_Imp,creciente,decreciente);
				writeln('  MENU MERGE');
				writeln;
				if creciente then begin
					writeln('  Para hacer merge se necesita una segunda lista ordenada');
					writeln('  de forma creciente, creela ahora');
					writeln;
					enterContinuar();
					crearLista(L_Aux);
					tieneOrden(L_Aux,creciente,decreciente);
					if not creciente then
						ordenarListaCreciente(L_Aux);
					mergeListaOrdenado(L_Imp,L_Aux,lNue);
					saltosLinea30(); saltosLinea30();
					writeln('  Merge');
					writeln;
					writeln;
					writeln('  Lista 1:');
					imprimirListaLinea(L_Imp);
					writeln;
					writeln('  Lista 2:');
					imprimirListaLinea(L_Aux);
					writeln;
					writeln;
					writeln('  Lista Resultante:');
					imprimirListaLinea(lNue);
					eliminarLista(L_Imp);
					eliminarLista(L_Aux);
					L_Imp:= lNue;
				end
				else if decreciente then begin
					writeln('  La lista inicial tiene orden decreciente, cambielo');
					writeln('  a creciente para poder proseguir');
				end
				else begin
					writeln('  La lista inicial esta desordenada, ordendela de forma');
					writeln('  creciente para poder proseguir');
				end;
			end
			else
				writeln('  No hay lista inicial para combinar');
			writeln;
			enterContinuar();
		end;

	//    MENU OPERACIONES
	procedure menuOperacionesLista();
		var
			opc: char;
		begin
			C_Tema:= ' ';
			if B_App and B_Est and B_Ope then begin
				saltosLinea30(); saltosLinea30();
				writeln('  MENU OPERACIONES');
				writeln;
				writeln('  Ingrese la letra del apartado requerido');
				writeln;
				writeln('    A -  Visualizar');
				writeln('    B -  Agregar Valor');
				writeln('    C -  Estadisticas');
				writeln('    D -  Buscar Valor');
				writeln('    E -  Sumar Valores');
				writeln('    F -  Escalar Valores');
				writeln('    G -  Eliminar');
				writeln('    H -  Invertir');
				writeln('    I -  Ordenar');
				writeln('    J -  Merge');
				writeln;
				writeln('    K -  Nueva Lista');
				writeln;
				writeln('    L -  Menu Listas');
				writeln('    M -  Menu Inicio');
				writeln('    N -  Cerrar Aplicacion');
				leerOpcion('A','N',opc);
				case opc of
					'A'..'J':	C_Tema:= opc;
					'K':	B_Lista:= false;
					'L':	B_Ope:= false;
					'M':	B_Est:= false;
					'N':	B_App:= false;
				end;
			end;
		end;

	//    MENU LISTAS 
	procedure infoListas();
		begin
			saltosLinea30(); saltosLinea30();
			writeln('  INFORMACION:');
			writeln;
			writeln('    Este apartado de la aplicacion tiene el fin de ayudar a entender la');
			writeln('    estructura de datos Listas, a la vez de ser una manera de poner en');
			writeln('    practica los conocimientos sobre estos mismos');
			writeln;
			writeln('    Usted podra crear una lista y realizar algunas operaciones sobre ella');
			writeln('    viendo como se almacenan logicamente los datos. En particular los');
			writeln('    datos son valores enteros, pero es posible modificarlo de asi requerirlo');
			writeln('    mediante el codigo de la aplicacion');
			writeln;
			enterContinuar();
		end;
	procedure menuLista();
		var
			opc: char;
		begin
			while B_App and B_Est and not B_Ope do begin
				saltosLinea30(); saltosLinea30();
				writeln('  MENU LISTAS');
				writeln;
				writeln('  Ingrese la letra del apartado requerido');
				writeln;
				writeln('    A -  Crear LISTA');
				writeln('    B -  Informacion Listas');
				writeln;
				writeln('    C -  Menu Inicio');
				writeln('    D -  Cerrar aplicacion');
				leerOpcion('A','D',opc);
				case opc of
					'A':	B_Ope:= true;
					'B':	infoListas();
					'C':	B_Est:= false;
					'D':	B_App:= false;
				end;
			end;
		end;

	//  PROGRAMA PRINCIPAL LISTA
	begin
		configsDefaultLista();
		menuLista();
		while B_App and B_Est do begin
			repeat
				crearLista(L_Imp);
				menuOperacionesLista();
				while B_App and B_Est and B_Ope and B_Lista do begin
					case C_Tema of
						'A':	listaVisualizar();
						'B':	listaAgregarValor();
						'C':	listaEstadisticas();
						'D':	listaBuscarValor();
						'E':	listaSumarValores();
						'F':	listaEscalarValores();
						'G':	listaEliminar();
						'H':	listaInvertir();
						'I':	listaOrdenar();
						'J':	listaMerge();
					end;
					menuOperacionesLista();
				end;
			until not B_App or not B_Est or not B_Ope;
			menuLista();
		end;
		eliminarLista(L_Imp);
	end;



//    ARBOL
procedure estructuraArbol();
	const
		N_NODOS= 16;

	type
		dato= record
			nInt: integer;
		end;
		arbol= ^nodo;
		nodo= record
			elem: dato;
			hi: arbol;
			hd: arbol;
		end;
		lista= ^nodoL;
		nodoL= record
			elem: arbol;
			sig: lista;
		end;

	var
		B_Arbol,B_Orientacion: boolean;
		C_Tema: char;

		A_Imp: arbol;

	// CONFIGURACIONES DEFAULTS ARBOL
	procedure configsDefaultArbol();
		begin
			B_Ope:= false;
			B_Arbol:= false;
			B_Orientacion:= true;
			A_Imp:= nil;
			Rango_Min:= -9;
			Rango_Max:= 99;
		end;

	//    MODULOS COMUNES
	function pot(x,n: integer): integer;
		begin
			if n> 0 then
				pot:= x* pot(x,n-1)
			else
				pot:= 1;
		end;
	function max(a,b : integer): integer; 
		begin
			if (a>= b) then
				max:= a
			else
				max:= b;
		end;
	function altura(a: arbol) : integer;
		begin
			if (a <> nil) then
				altura := 1 + max(altura(a^.hi), altura(a^.hd))
			else
				altura := 0;
		end;
	procedure espacios(n: integer);
		var
			i: integer;
		begin
			for i:= 1 to n do
				write(' ');
		end;
	procedure agregarUltimo(var l: lista; a: arbol);
		var
			nue,act: lista;
		begin
			new(nue);
			nue^.elem:= a;
			nue^.sig:= nil;
			if l<> nil then begin
				act:= l;
				while act^.sig <> nil do
					act:= act^.sig;
				act^.sig:= nue;
			end
			else
				l:= nue;
		end;
	procedure invertirLista(l: lista; var lNue: lista);
		begin
			if l<> nil then begin
				invertirLista(l^.sig,lNue);
				agregarUltimo(lNue,l^.elem);
			end
			else
				lNue:= nil;
		end;
	procedure buscarNodoValor(a: arbol; v: integer; var lvl: integer; var l: lista);
		begin
			if a<> nil then begin
				lvl:= lvl +1;
				if a^.elem.nInt< v then begin
					agregarUltimo(l,a);
					buscarNodoValor(a^.hd,v,lvl,l)
				end
				else if a^.elem.nInt> v then begin
					agregarUltimo(l,a);
					buscarNodoValor(a^.hi,v,lvl,l)
				end
				else
					agregarUltimo(l,a);
			end
			else begin
				l:= nil;
				lvl:= 0;
			end;
		end;

	//    IMPRIMIR
	procedure imprimirNivel(a: arbol; max: integer; lvl: integer; esp: integer);
		begin
			lvl:= lvl +1;
			if lvl<> max then begin
				if a<> nil then begin
					imprimirNivel(a^.hi,max,lvl,esp);
					imprimirNivel(a^.hd,max,lvl,esp);
				end
				else begin
					imprimirNivel(a,max,lvl,esp);
					imprimirNivel(a,max,lvl,esp);
				end;
			end
			else begin
				espacios(esp);
				if a<> nil then begin
					if (a^.elem.nInt< 10) and (a^.elem.nInt> -1) then
						write(' ');
					write(a^.elem.nInt)
				end
				else
					write('  ');
				espacios(esp);
			end;
		end;
	procedure imprimirArbolNiveles(a: arbol);
		var
			max,lvl,i,esp,n: integer;
		begin
			max:= altura(a);
			if B_Orientacion then begin
				esp:= pot(2,max-1)*2;
				for i:=1 to max do begin
					lvl:= 0;
					esp:= esp div 2;
					imprimirNivel(a,i,lvl,esp -1);
					writeln;
				end;
			end
			else begin
				esp:= 1;
				n:= 0;
				for i:=max downto 1 do begin
					lvl:= 0;
					if i<> max then begin
						n:= n +1;
						esp:= pot(2,n);
					end;
					imprimirNivel(a,i,lvl,esp -1);
					writeln;
				end;
			end;
		end;

	procedure imprimirNivelValor(a,n: arbol; max: integer; lvl: integer; esp: integer);
		begin
			lvl:= lvl +1;
			if lvl<> max then begin
				if a<> nil then begin
					imprimirNivelValor(a^.hi,n,max,lvl,esp);
					imprimirNivelValor(a^.hd,n,max,lvl,esp);
				end
				else begin
					imprimirNivelValor(a,n,max,lvl,esp);
					imprimirNivelValor(a,n,max,lvl,esp);
				end;
			end
			else begin
				espacios(esp);
				if a<> nil then begin
					if a<> n then
						write('  ')
					else begin
						if (a^.elem.nInt< 10) and (a^.elem.nInt> -1) then
							write(' ');
						write(a^.elem.nInt);
					end;
				end
				else
					write('  ');
				espacios(esp);
			end;
		end;
	procedure imprimirRamaValorNivel(a: arbol; max: integer; l: lista);
		var
			lvl,i,esp,n: integer;
			lInv: lista;
		begin
			if B_Orientacion then begin
				esp:= pot(2,max-1)*2;
				for i:=1 to max do begin
					lvl:= 0;
					esp:= esp div 2;
					imprimirNivelValor(a,l^.elem,i,lvl,esp -1);
					writeln;
					l:= l^.sig;
				end;
			end
			else begin
				invertirLista(l,lInv);
				esp:= 1;
				n:= 0;
				for i:=max downto 1 do begin
					lvl:= 0;
					if i<> max then begin
						n:= n +1;
						esp:= pot(2,n);
					end;
					imprimirNivelValor(a,lInv^.elem,i,lvl,esp -1);
					writeln;
					lInv:= lInv^.sig;
				end;
			end;
		end;

	//    CREAR
	procedure insertarArbol(var a: arbol; d: dato);
		begin
			if a= nil then begin
				new(a);
				a^.elem:= d;
				a^.hi:= nil;
				a^.hd:= nil;
			end
			else begin
				if a^.elem.nInt< d.nInt then
					insertarArbol(a^.hd,d)
				else
					insertarArbol(a^.hi,d)
			end;
		end;
	procedure recomendacionCarga();
		begin
			writeln('  RECOMENDACION');
			writeln;
			writeln('    Se recomienda cargar un rango de valores de 0 a 99');
			writeln('    con un maximo de ',N_NODOS,' nodos para una buena visualizacion');
			writeln;
			writeln;
		end;
	procedure cargarArbolManual(var a: arbol);
		var
			ok: boolean;
			code: word;
			i: integer;
			rString: string;
			d: dato;
		begin
			a:= nil;
			i:= 0;
			writeln('  Carga Manual');
			writeln;
			writeln('  Ingrese n o N para dejar de ingresar valores');
			writeln;
			writeln;
			repeat
				i:= i +1;
				repeat
					write('    Valor ',i,': '); readln(rString);
					val(rString,d.nInt,code);
					ok:= (code= 0) or (rString[code]= 'n') or (rString[code]= 'N');
					if not ok then begin
						writeln('  Solo numeros enteros, intente nuevamente');
						write('  '); readln;
					end
				until ok;
				if code= 0 then
					insertarArbol(a,d)
				else
					if i= 1 then begin
						writeln('  Un arbol al menos tiene un nodo, intente nuevamente');
						write('  '); readln;
						i:= i -1;
						code:= 0;
					end;
			until code<> 0;
		end;
	procedure cargarArbolAleatorio(var a: arbol);
		var
			nNodos,i: integer;
			d: dato;
		begin
			writeln('  Carga Aleatoria');
			writeln;
			leerRangoEntero('    Valor Minimo incluido: ','    Valor Maximo incluido: ',Rango_Min,Rango_Max);
			writeln;
			repeat
				leerEntero('    Cantidad de nodos del arbol: ',nNodos);
				if nNodos< 1 then begin
					writeln('    Un arbol al menos tiene un nodo, intente nuevamente');
					write('  '); readln;
				end;
			until nNodos> 0;
			new(a);
			a^.elem.nInt:= randomCarga();
			a^.hi:= nil;
			a^.hd:= nil;
			for i:= 1 to nNodos -1 do begin
				d.nInt:= randomCarga();
				insertarArbol(a,d);
			end;
		end;
	procedure crearArbol();
		var
			opc: char;
		begin
			saltosLinea30(); saltosLinea30();
			writeln('  MENU CREAR ARBOL');
			writeln;
			writeln('  Ingrese la letra del apartado requerido');
			writeln;
			writeln('    A -  Cargar Manual');
			writeln('    B -  Cargar Aleatorio');
			leerOpcion('A','B',opc);
			saltosLinea30(); saltosLinea30();
			recomendacionCarga();
			if opc= 'A' then
				cargarArbolManual(A_Imp)
			else
				cargarArbolAleatorio(A_Imp);
			writeln;
			writeln;
			writeln('  Arbol cargado:');
			imprimirArbolNiveles(A_Imp);
			writeln;
			enterContinuar();
			B_Arbol:= true;
		end;

	//    VISUALIZAR
	procedure imprimirArbolListaDescendente(a: arbol; var i: integer);
		begin
			if a<> nil then begin
				imprimirArbolListaDescendente(a^.hd,i);
				i:= i +1;
				write('  ',a^.elem.nInt);
				if i= 16 then begin
					writeln;
					write('  ');
					i:= 0;
				end;
				imprimirArbolListaDescendente(a^.hi,i);
			end;
		end;
	procedure imprimirArbolListaAscendente(a: arbol; var i: integer);
		begin
			if a<> nil then begin
				imprimirArbolListaAscendente(a^.hi,i);
				i:= i +1;
				write('  ',a^.elem.nInt);
				if i= 16 then begin
					writeln;
					write('  ');
					i:= 0;
				end;
				imprimirArbolListaAscendente(a^.hd,i);
			end;
		end;
	procedure arbolVisualizar();
		var
			i: integer;
			opc: char;
		begin
			saltosLinea30(); saltosLinea30();
			if A_Imp<> nil then begin
				writeln('  MENU VISUALIZACION');
				writeln;
				writeln('  Ingrese la letra del apartado requerido');
				writeln;
				writeln('    A -  Ver arbol entero');
				writeln('    B -  Lista valores ascendente');
				writeln('    C -  Lista valores descendente');
				leerOpcion('A','C',opc);
				writeln;
				writeln;
				writeln('  Arbol:');
				write('  ');
				i:= 0;
				case opc of
					'A' :	imprimirArbolNiveles(A_Imp);
					'B'	:	imprimirArbolListaAscendente(A_Imp,i);
					'C'	:	imprimirArbolListaDescendente(A_Imp,i);
				end;
			end
			else
				writeln('  No hay arbol para visualizar');
			writeln;
			enterContinuar();
		end;

	//    BUSCAR
	procedure arbolBuscarValor();
		var
			v,lvl: integer;
			l: lista;
			a: arbol;
		begin
			saltosLinea30(); saltosLinea30();
			leerEntero('  Valor a buscar: ',v);
			a:= A_Imp;
			lvl:= 0;
			l:= nil;
			buscarNodoValor(a,v,lvl,l);
			writeln;
			if l<> nil then begin
				writeln('  El valor buscado se encuentra en el nivel: ',lvl);
				writeln;
				writeln('  Rama mas directa:');
				imprimirRamaValorNivel(a,lvl,l)
			end
			else
				writeln('  El valor no se encuentra en el arbol');
			writeln;
			enterContinuar();
		end;

	//    SUMAR
	function sumarNodosArbol(a: arbol): real;
		begin
			if a<> nil then
				sumarNodosArbol:= a^.elem.nInt + sumarNodosArbol(a^.hi) + sumarNodosArbol(a^.hd)
			else
				sumarNodosArbol:= 0;
		end;
	procedure arbolSumarValores();
		var
			sum: real;
		begin
			saltosLinea30(); saltosLinea30();
			if A_Imp<> nil then begin
				sum:= sumarNodosArbol(A_Imp);
				writeln('  Arbol a sumar valores:');
				imprimirArbolNiveles(A_Imp);
				writeln;
				writeln('  La sumatoria es: ',sum:0:0);
			end
			else
				writeln('  No hay valores en el arbol para sumar');
			writeln;
			enterContinuar();
		end;

	//    ESCALAR
	procedure escalarNodosArbol(a: arbol; esc: integer);
		begin
			if a<> nil then begin
				a^.elem.nInt:= a^.elem.nInt* esc;
				escalarNodosArbol(a^.hi, esc);
				escalarNodosArbol(a^.hd, esc);
			end;
		end;
	procedure arbolEscalarValores();
		var
			esc: integer;
		begin
			saltosLinea30(); saltosLinea30();
			if A_Imp<> nil then begin
				leerEntero('  Valor del escalar: ',esc);
				writeln;
				writeln('  Arbol base:');
				imprimirArbolNiveles(A_Imp);
				escalarNodosArbol(A_Imp,esc);
				writeln;
				writeln('  Arbol escalado:');
				imprimirArbolNiveles(A_Imp);
			end
			else
				writeln('  No hay valores en el arbol para escalar');
			writeln;
			enterContinuar();
		end;

	//    MINIMO MAXIMO
	procedure buscarMinimoArbolLista(a: arbol; var v: integer; var lvl: integer; var l: lista);
		begin
			if a<> nil then begin
				if a^.elem.nInt<= v then begin
					lvl:= lvl +1;
					v:= a^.elem.nInt;
					agregarUltimo(l,a);
					buscarMinimoArbolLista(a^.hi,v,lvl,l)
				end
			end;
		end;
	procedure buscarMaximoArbolLista(a: arbol; var v: integer; var lvl: integer; var l: lista);
		begin
			if a<> nil then begin
				if a^.elem.nInt>= v then begin
					lvl:= lvl +1;
					v:= a^.elem.nInt;
					agregarUltimo(l,a);
					buscarMaximoArbolLista(a^.hd,v,lvl,l)
				end
			end;
		end;
	procedure arbolBuscarMinMax();
		var
			opc: char;
			l: lista;
			v,lvl: integer;
		begin
			saltosLinea30(); saltosLinea30();
			if A_Imp<> nil then begin
				writeln('  MENU MINIMO/MAXIMO');
				writeln;
				writeln('  Ingrese la letra del apartado requerido');
				writeln;
				writeln('    A -  Buscar Minimo');
				writeln('    B -  Buscar Maximo');
				leerOpcion('A','B',opc);
				saltosLinea30(); saltosLinea30();
				writeln('  Arbol:');
				imprimirArbolNiveles(A_Imp);
				l:= nil;
				lvl:= 0;
				writeln;
				if opc= 'A' then begin
					v:= 32000;
					buscarMinimoArbolLista(A_Imp,v,lvl,l);
					write('  El minimo es: ',v);
				end
				else begin
					v:= -32000;
					buscarMaximoArbolLista(A_Imp,v,lvl,l);
					write('  El maximo es: ',v);
				end;
				writeln(' en el nivel: ',lvl);
				writeln;
				writeln('  Rama mas directa es:');
				imprimirRamaValorNivel(A_Imp,lvl,l);
			end
			else
				writeln('  No hay arbol para buscar minimo o maximo');
			writeln;
			enterContinuar();
		end;

	//    NIVELES
	procedure arbolNumeroNiveles();
		begin
			saltosLinea30(); saltosLinea30();
			if A_Imp<> nil then begin
				writeln('  Arbol:');
				imprimirArbolNiveles(A_Imp);
				writeln;
				writeln('  El arbol tiene ',altura(A_Imp),' niveles');
			end
			else
				writeln('  El arbol no tiene niveles');
			writeln;
			enterContinuar();
		end;

	//    ELIMINAR VALOR
	procedure buscarMinimoArbolNodo(a: arbol; var n: arbol);
		begin
			if a<> nil then begin
				if a^.elem.nInt<= n^.elem.nInt then begin
					n:= a;
					buscarMinimoArbolNodo(a^.hi,n)
				end
			end;
		end;
	procedure buscarMaximoArbolNodo(a: arbol; var n: arbol);
		begin
			if a<> nil then begin
				if a^.elem.nInt>= n^.elem.nInt then begin
					n:= a;
					buscarMaximoArbolNodo(a^.hd,n)
				end
			end;
		end;
	procedure eliminarNodoArbol(aAnt,aElim: arbol);
		var
			fin: arbol;
		begin
			new(fin);
			fin^.elem.nInt:= 9999;
			if (aAnt<> aElim) then begin
				if aElim^.hd<> nil then begin
					if aElim^.hi<> nil then begin
						buscarMinimoArbolNodo(aElim^.hd,fin);
						fin^.hi:= aElim^.hi;
					end;
					if aAnt^.hi= aElim then
						aAnt^.hi:= aElim^.hd
					else
						aAnt^.hd:= aElim^.hd;
				end
				else if aElim^.hi<> nil then begin
					if aAnt^.hi= aElim then
						aAnt^.hi:= aElim^.hi
					else
						aAnt^.hd:= aElim^.hi;
				end
				else begin
					if aAnt^.hi= aElim then
						aAnt^.hi:= nil
					else
						aAnt^.hd:= nil;
				end;
			end
			else if aElim^.hd<> nil then begin
				if aElim^.hi<> nil then begin
					buscarMinimoArbolNodo(aElim^.hd,fin);
					fin^.hi:= aElim^.hi;
				end;
				A_Imp:= aElim^.hd;
			end
			else if aElim^.hi<> nil then
				A_Imp:= aElim^.hi
			else
				A_Imp:= nil;
			dispose(aElim);
		end;
	procedure arbolEliminarValor();
		var
			v,lvl: integer;
			l,lAnt: lista;
		begin
			saltosLinea30(); saltosLinea30();
			if A_Imp<> nil then begin
				leerEntero('  Valor a eliminar: ',v);
				lvl:= 0;
				l:= nil;
				buscarNodoValor(A_Imp,v,lvl,l);
				writeln;
				if l<> nil then begin
					writeln('  Arbol Base');
					imprimirArbolNiveles(A_Imp);
					lAnt:= l;
					while l^.sig<> nil do begin
						lAnt:= l;
						l:= l^.sig
					end;
					eliminarNodoArbol(lAnt^.elem,l^.elem);
					writeln;
					writeln('  Arbol con el valor eliminado');
					imprimirArbolNiveles(A_Imp);
				end
				else
					writeln('  El valor no se encuentra en el arbol, por lo tanto no se puede eliminar');
			end
			else
				writeln('  No hay valores en el arbol para eliminar');
			writeln;
			enterContinuar();
		end;

	//    ELIMINAR RAMA
	procedure eliminarRamaArbol(aAnt,aElim: arbol);
		begin
			if aElim<> nil then begin
				eliminarRamaArbol(aElim,aElim^.hi);
				eliminarRamaArbol(aElim,aElim^.hd);
				if aAnt^.hi= aElim then
						aAnt^.hi:= nil
					else
						aAnt^.hd:= nil;
				if aAnt= aElim then
					A_Imp:= nil;
				dispose(aElim);
			end;
		end;
	procedure arbolEliminarRama();
		var
			v,lvl: integer;
			l,lAnt: lista;
		begin
			saltosLinea30(); saltosLinea30();
			if A_Imp<> nil then begin
				leerEntero('  Valor de rama a eliminar incluido: ',v);
				lvl:= 0;
				l:= nil;
				buscarNodoValor(A_Imp,v,lvl,l);
				writeln;
				if l<> nil then begin
					writeln('  Arbol Base');
					imprimirArbolNiveles(A_Imp);
					lAnt:= l;
					while l^.sig<> nil do begin
						lAnt:= l;
						l:= l^.sig
					end;
					eliminarRamaArbol(lAnt^.elem,l^.elem);
					writeln;
					writeln('  Arbol con rama eliminada');
					imprimirArbolNiveles(A_Imp);
				end
				else
					writeln('  El valor no se encuentra en el arbol, por lo tanto no se puede eliminar');
			end
			else
				writeln('  No hay valores en el arbol para eliminar');
			writeln;
			enterContinuar();
		end;

	//    MENU OPERACIONES
	procedure cambiarImpresion();
		var
			opc: char;
		begin
			saltosLinea30(); saltosLinea30();
			write('  Actualmente el arbol entero se imprime con la ');
			if B_Orientacion then
				writeln('raiz arriba y las hojas abajo')
			else
				writeln('las hojas arriba y la raiz abajo');
			writeln;
			writeln;
			writeln('  Como quiere ver el arbol');
			writeln;
			writeln('    A -  Raiz arriba y hojas abajo');
			writeln('    B -  Hojas arriba y raiz abajo');
			leerOpcion('A','B',opc);
			B_Orientacion:= opc= 'A';
			writeln;
			writeln;
			write('  Ahora el arbol se imprimira con la ');
			if B_Orientacion then
				writeln('raiz arriba y las hojas abajo')
			else
				writeln('las hojas arriba y la raiz abajo');
			enterContinuar;
		end;
	procedure menuOperacionesArbol();
		var
			opc: char;
		begin
			C_Tema:= ' ';
			while B_App and B_Est and B_Ope and B_Arbol and (C_Tema=' ') do begin
				saltosLinea30(); saltosLinea30();
				writeln('  MENU OPERACIONES');
				writeln;
				writeln('  Ingrese la letra del apartado requerido');
				writeln;
				writeln('    A -  Visualizar');
				writeln('    B -  Buscar Valor');
				writeln('    C -  Sumar Valores');
				writeln('    D -  Escalar Valores');
				writeln('    E -  Buscar Minimo/Maximo');
				writeln('    F -  Cantidad Niveles');
				writeln('    G -  Eliminar Valor');
				writeln('    H -  Eliminar Rama');
				writeln;
				writeln('    I -  Nuevo Arbol');
				writeln('    J -  Cambiar Impresion Arbol');
				writeln;
				writeln('    K -  Menu Arboles');
				writeln('    L -  Menu Inicio');
				writeln('    M -  Cerrar Aplicacion');
				leerOpcion('A','M',opc);
				case opc of
					'A'..'H':	C_Tema:= opc;
					'I':	B_Arbol:= false;
					'J':	cambiarImpresion();
					'K':	B_Ope:= false;
					'L':	B_Est:= false;
					'M':	B_App:= false;
				end;
			end;
		end;

	//    MENU ARBOLES
	procedure infoArboles();
		begin
			saltosLinea30(); saltosLinea30();
			writeln('  INFORMACION:');
			writeln;
			writeln('    Este apartado de la aplicacion tiene el fin de ayudar a entender la');
			writeln('    estructura de datos Arboles Binarios de Busqueda, a la vez de ser una');
			writeln('    manera de poner en practica los conocimientos sobre estos mismos');
			writeln;
			writeln('    Usted podra crear un arbol y realizar algunas operaciones sobre el');
			writeln('    viendo como se almacenan logicamente los datos. En particular los');
			writeln('    datos son valores enteros, pero es posible modificarlo de asi requerirlo');
			writeln('    mediante el codigo de la aplicacion');
			writeln;
			enterContinuar();
		end;
	procedure menuArbol();
		var
			opc: char;
		begin
			while B_App and B_Est and not B_Ope do begin
				saltosLinea30(); saltosLinea30();
				writeln('  MENU ARBOLES');
				writeln;
				writeln('  Ingrese la letra del apartado requerido');
				writeln;
				writeln('    A -  Crear ARBOL');
				writeln('    B -  Informacion Arboles');
				writeln;
				writeln('    C -  Menu Inicio');
				writeln('    D -  Cerrar Aplicacion');
				leerOpcion('A','D',opc);
				case opc of
					'A':	B_Ope:= true;
					'B':	infoArboles();
					'C':	B_Est:= false;
					'D':	B_App:= false;
				end;
			end;
		end;

	// PROGRAMA PRINCIPAL ARBOL
	begin
		configsDefaultArbol();
		menuArbol();
		while B_App and B_Est do begin
			repeat
				crearArbol();
				menuOperacionesArbol();
				while B_App and B_Est and B_Ope and B_Arbol do begin
					case C_Tema of
						'A':	arbolVisualizar();
						'B':	arbolBuscarValor();
						'C':	arbolSumarValores();
						'D':	arbolEscalarValores();
						'E':	arbolBuscarMinMax();
						'F':	arbolNumeroNiveles();
						'G':	arbolEliminarValor();
						'H':	arbolEliminarRama();
					end;
					menuOperacionesArbol();
				end;
			until not B_App or not B_Est or not B_Ope;
			menuArbol();
		end;
	end;




//  MENU PRINCIPAL
procedure mensajeBienvenida();
	begin
		if B_1Vez then begin
			B_1Vez:= false;
			writeln('  Bienvenida/o a');
			writeln('                 Jugando con Estructuras de Datos  ( J.E.D. )');
			writeln;
			writeln('    Se espera que las herramientas brindadas le sean de utilidad');
			writeln('    y que pase un buen rato jugando');
			writeln;
			writeln;
		end;
	end;

procedure infoAplicacion();
	begin
		saltosLinea30(); saltosLinea30();
		writeln('  INFORMACION GENERAL');
		writeln;
		writeln('    Esta aplicacion fue creada con la intencion de poner a prueba conceptos aprendidos');
		writeln('    en la carrera y demostrar que todo lo que se aprende se puede utilizar con fines');
		writeln('    practicos, utiles y entretenimiento aunque sean basicos - antiguos');
		writeln;
		writeln('    En pocas palabras la aplicacion brinda la posibilidad de operar y ver los cambios');
		writeln('    efectuados en las Estructuras de Datos disponibles para entender mejor que sucede');
		writeln('    con la informacion que procesan y guardan los algoritmos que las utilizan');
		writeln;
		writeln('    El funcionamiento es sencillo, primero se elige el tipo de estructura a jugar, luego');
		writeln('    se procede a cargarla inicialmente y por ultimo se pueden efectuar procesos para ver');
		writeln('    que sucede con la informacion. En cualquier momento se puede generar nuevamente la');
		writeln('    estructua, cambiar el tipo o cerrar la aplicacion');
		writeln;
		enterContinuar();
	end;

procedure menuEstructuras();
	var
		opc: char;
	begin
		if B_App and B_Est then begin
			saltosLinea30(); saltosLinea30();
			writeln('  MENU ESTRUCTURAS');
			writeln;
			writeln('  Ingrese la letra del apartado requerido');
			writeln;
			writeln('    A -  Vector');
			writeln('    B -  Lista');
			writeln('    C -  Arbol Binario de Busqueda');
			writeln;
			writeln('    D -  Menu Inicio');
			writeln('    E -  Cerrar Aplicacion');
			leerOpcion('A','E',opc);
			case opc of
				'A'..'C':	C_Tipo:= opc;
				'D':	B_Est:= false;
				'E':	B_App:= false;
			end;
		end;
	end;

procedure creditos();
	begin
		saltosLinea30(); saltosLinea30();
		writeln('  CREDITOS');
		writeln;
		writeln('    Fecha: 09/2021');
		writeln('    Lenguaje: Pascal');
		writeln('    Creador: Josue S.A.');
		writeln('    Contacto por Discord: Josu#0987');
		writeln('    Conocimientos adquiridos en Materias: CADP y Taller de Programacion');
		writeln('                                Carrera: Lic. Informatica');
		writeln('                                Facultad: Informatica UNLP');
		writeln('    Agradecimiento:');
		writeln('                   Los companieros de cursada por hacer apoyo');
		writeln('                   y ser los Beta Testers del programa');
		writeln;
		enterContinuar();
	end;

procedure menuInicio();
	var
		opc: char;
	begin
		while B_App and (not B_Est) do begin
			saltosLinea30(); saltosLinea30();
			mensajeBienvenida();
			writeln('  MENU INICIO');
			writeln;
			writeln('  Ingrese la letra del apartado requerido');
			writeln;
			writeln('    A -  Menu Estructuras');
			writeln;
			writeln('    B -  Informacion Aplicacion');
			writeln('    C -  Creditos');
			writeln;
			writeln('    D -  Cerrar Aplicacion');
			leerOpcion('A','D',opc);
			case opc of
				'A':	B_Est:= true;
				'B':	infoAplicacion();
				'C':	creditos();
				'D':	B_App:= false;
			end;
		end;
	end;




//  EXTRAS
procedure mensajeInicial();
	begin
		saltosLinea30(); saltosLinea30();
		writeln('  ADVERTENCIA:');
		writeln;
		writeln('    Usted debe usar la aplicacion con fines de entrenimiento y como guia');
		writeln('    para entender desde otro punto algunas de las estructuras de datos');
		writeln('    basicas. Los algoritmos utilizados pueden no ser los mas optimos, solo');
		writeln('    cumplen el trabajo para el fin de la aplicacion');
		writeln;
		writeln('    Es posible encontrar errores de representacion o que la aplicacion se');
		writeln('    cierre por un error, dado el primer problema trate de trabajar segun');
		writeln('    los parametros recomendados, dado el segundo problema contacte al creador');
		writeln('    o intente arreglarlo por su cuenta dentro del codigo');
		writeln;
		writeln('    Contacto por Discord: Josu#0987');
		writeln;
		enterContinuar();
	end;

procedure mensajeCierre();
	begin
		saltosLinea30(); saltosLinea30();
		writeln('  Se espera que J.E.D. le haya ayudado a entender un poco mas');
		writeln('  el funcionamiento de las Estructuras de Datos disponibles');
		writeln;
		writeln('    Que tenga un lindo dia :)');
		writeln;
		writeln;
		writeln('  Presione Enter para cerrar la ventana ');
		write('  '); readln;
	end;




//  PROGRAMA PRINCIPAL
begin
	configsDefaultAplicacion();
	mensajeInicial();
	menuInicio();
	while B_App do begin
		menuEstructuras();
		while B_App and B_Est do begin
			case C_Tipo of
				'A':	estructuraVector();
				'B':	estructuraLista();
				'C':	estructuraArbol();
			end;
			menuEstructuras();
		end;
		menuInicio();
	end;
	mensajeCierre();
end.
