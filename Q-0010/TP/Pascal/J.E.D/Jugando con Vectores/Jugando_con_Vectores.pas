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
	B_App,B_Ope,B_Vector: boolean;
	C_Tema: char;
	
	Rango_Min,Rango_Max: integer;
	
	V_Imp: vector;
	Cant_Elem,Dim_F,Dim_L: integer;
	marcoInd,marcoInf,marcoSup,marcoDL,marcoDF,marcoVacio: string;



//  CONFIGURACIONES DEFAULTS
procedure configsDefaultVector();
	begin
		B_App:= true;
		B_Ope:= false;
		B_Vector:= false;
		Rango_Min:= CARGA_RANGO_MIN;
		Rango_Max:= CARGA_RANGO_MAX;
		Dim_F:= MAX_CANT_ELEM -1;
		Dim_L:= -1;
		Cant_Elem:= MAX_CANT_ELEM;
	end;




//  MODULOS GENERICOS
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




//  VECTORES
//    MODULOS COMUNES
function randomCarga(): integer;
	begin
		randomCarga:= Rango_Min + random(Rango_Max - Rango_Min +1);
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
procedure eliminarVector();
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
				'D'	:	eliminarVector();
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
		if B_App and B_Ope then begin
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
			writeln('    L -  Menu Inicio');
			writeln('    M -  Cerrar Aplicacion');
			leerOpcion('A','M',opc);
			case opc of
				'A'..'J':	C_Tema:= opc;
				'K':	B_Vector:= false;
				'L':	B_Ope:= false;
				'M':	B_App:= false;
			end;
		end;
	end;



//    MENU INICIAL 
procedure infoVectores();
	begin
		saltosLinea30(); saltosLinea30();
		writeln('  INFORMACION:');
		writeln;
		writeln('    Esta es una pequenia aplicacion con el fin de ayudar a entender la');
		writeln('    estructura de datos listas simples, a la vez de ser una manera de poner');
		writeln('    en practica los conocimientos sobre estos mismos');
		writeln;
		writeln('    Usted podra crear una lista y realizar algunas operaciones sobre ella');
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
		while B_App and not B_Ope do begin
			saltosLinea30(); saltosLinea30();
			writeln('  MENU VECTORES');
			writeln;
			writeln('  Ingrese la letra del apartado requerido');
			writeln;
			writeln('    A -  Crear VECTOR');
			writeln('    B -  Informacion Vectores');
			writeln;
			writeln('    C -  Cerrar aplicacion');
			leerOpcion('A','C',opc);
			case opc of
				'A':	B_Ope:= true;
				'B':	infoVectores();
				'C':	B_App:= false;
			end;
		end;
	end;

procedure mensajeCierre();
	begin
		saltosLinea30(); saltosLinea30();
		writeln('  Se espera que la aplicacion le haya ayudado a entender un poco mas');
		writeln('  el funcionamiento de vectores simples');
		writeln;
		writeln('    Que disfrute de Conceptos de CADP y TP :D');
		writeln;
		writeln;
		writeln('  Presione Enter para cerrar la ventana ');
		write('  '); readln;
	end;




//  PROGRAMA PRINCIPAL
begin
	configsDefaultVector();
	menuVector();
	while B_App do begin
		repeat
			crearVector(V_Imp);
			menuOperacionesVector();
			while B_App and B_Ope and B_Vector do begin
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
		until not B_App or not B_Ope;
		menuVector();
	end;
	setlength(V_Imp,0);
	mensajeCierre();
end.

