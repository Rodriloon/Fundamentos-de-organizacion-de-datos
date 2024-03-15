Program P1E5;
type

	celulares = record
		codigo: integer;
		nombre: string;
		descripcion: string;
		marca: string;
		precio: double;
		stockMax: integer;
		stockDisp: integer;
	end;

	archivo = file of celulares;

	{-------------------PROCESOS-------------------}

procedure crearArchivo (var Ar: archivo);

	procedure leerCelulares (Var C: celulares);
	begin
		readln(C.codigo);
		if (C.codigo <> -1) then
		begin
			readln(C.nombre);
			readln(C.descripcion);
			readln(C.marca);
			readln(C.precio);
			readln(C.stockMax);
			readln(C.stockDisp);
		end;
	end;

var
	C: celulares;
begin
	Assign(Ar, 'celulares');
	Rewrite(Ar);
	leerCelulares(C);
	while (C.codigo <> -1) do
	begin
		Write(Ar, C);
		leerCelulares(C);
	end;
	Close(Ar);
end;

procedure imprimir (C: celulares);
begin
	writeln(C.codigo);
	writeln(C.nombre);
	writeln(C.descripcion);
	writeln(C.marca);
	writeln(C.precio);
	writeln(C.stockMax);
	writeln(C.stockDisp);
end;

procedure stockMenor (var Ar: archivo);
var
	C: celulares;
begin
	Reset(Ar);
	while (not EOF(Ar)) do
	begin
		Read(Ar, C);
		if (C.stockMax < C.stockDisp) then
			imprimir(C);
	end;
	Close(Ar);
end;

procedure descEspecifica (var Ar: archivo);
var
	des: string;
	C: celulares;
begin
	readln(des);
	Reset(Ar);
	while (not EOF(Ar)) do
	begin
		Read(Ar, C);
		if (des = C.descripcion) then
			imprimir(C);
	end;
	Close(Ar);
end;

procedure exportarCelulares (var Ar: archivo);
var
	archivoCel: text;
	C: celulares;
begin
	Assign(archivoCel, 'celulares.txt');
	Rewrite(archivoCel);
	Reset(Ar);
	while (not EOF(Ar)) do
	begin
		Read(Ar, C);
		writeln(archivoCel, 'Codigo: ', C.codigo);
		writeln(archivoCel, 'Nombre: ', C.nombre);
		writeln(archivoCel, 'Descripcion: ', C.descripcion);
		writeln(archivoCel, 'Marca: ', C.marca);
		writeln(archivoCel, 'Precio: ', C.precio);
		writeln(archivoCel, 'Stock maximo: ', C.stockMax);
		writeln(archivoCel, 'Stock disponible: ', C.stockDisp);
		writeln(archivoCel); 
	end;
	Close(Ar);
	Close(archivoCel);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	Arc: archivo;
	opcion: integer;
BEGIN
	repeat
        writeln('Menú:');
        writeln('1. Crear archivo de celulares');
        writeln('2. Listar celulares con stock menor al máximo');
        writeln('3. Buscar celulares por descripción');
        writeln('4. Exportar archivo de celulares');
        writeln('0. Salir');
        write('Ingrese una opción: ');
        readln(opcion);
        case opcion of
            1: crearArchivo(Arc);
            2: stockMenor(Arc);
            3: descEspecifica(Arc);
            4: exportarCelulares(Arc);
            0: writeln('Terminando programa...');
        else
            writeln('Opción no válida.');
        end;
    until opcion = 0;
END.

{Realizar un programa para una tienda de celulares, que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares, deben contener: código de celular, el nombre, descripcion, marca, precio, stock mínimo y el stock disponible.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock mínimo.
c. Listar en pantalla los celulares del archivo cuya descripción contenga una cadena de caracteres proporcionada por el usuario.
d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado “celulares.txt” con todos los celulares del mismo.

NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario una única vez.
NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en tres líneas consecutivas: en la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo “celulares.txt”.}
