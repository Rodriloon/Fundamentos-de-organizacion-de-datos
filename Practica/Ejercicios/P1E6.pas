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

procedure crearArchivo (var Ar: archivo);
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

	{----------------------------------------------------------------------------------------------------}

procedure agregarCelulares (var Ar: archivo);
var
	C: celulares;
begin
	Reset(Ar);
	Seek(Ar, fileSize(Ar));
	leerCelulares(C);
    while (C.nombre = 'ZZZ') do
    begin
        Write(Ar, C);
        leerCelulares(C);
    end;
    Close(Ar);
end;

procedure modificarStock (var Ar: archivo);
var
	C: celulares;
	nom: string;
	stock: integer;
	encontrado: boolean;
begin
	Reset(Ar);
	readln(nom);
	encontrado := false;
	while (not EOF(Ar)) and (not encontrado) do
    begin
        Read(Ar, C);
        if (C.nombre = nom) then
        begin
            writeln('Ingrese el nuevo stock para ', nom, ': ');
            readln(stock);
            C.stockDisp := stock;
            Seek(Ar, FilePos(Ar) - 1);
            Write(Ar, C);
            encontrado := true;
        end;
    end;
    if (not encontrado) then
        writeln('Celular no encontrado.');
    Close(Ar);
end;

procedure exportarSinStock (var Ar: archivo);
var
	sinStock: text;
	C: celulares;
begin
	Assign(sinStock, 'SinStock.txt');
	reWrite(sinStock);
	reset(Ar);
	while not EOF(Ar) do 
	begin
		Read(Ar, C); 
		if (C.stockDisp = 0) then 
		begin
			writeln(sinStock, 'Codigo: ', C.codigo);
			writeln(sinStock, 'Nombre: ', C.nombre);
			writeln(sinStock, 'Descripcion: ', C.descripcion);
			writeln(sinStock, 'Marca: ', C.marca);
			writeln(sinStock, 'Precio: ', C.precio);
			writeln(sinStock, 'Stock maximo: ', C.stockMax);
			writeln(sinStock, 'Stock disponible: ', C.stockDisp);
			writeln(sinStock); 
		end;
	end;
	Close(Ar); 
	Close(sinStock);
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
        writeln('5. Agregar uno o más celulares al final del archivo');
		writeln('6. Modificar el stock de un celular');
		writeln('7. Exportar celulares sin stock a un archivo de texto');
        writeln('0. Salir');
        write('Ingrese una opción: ');
        readln(opcion);
        case opcion of
            1: crearArchivo(Arc);
            2: stockMenor(Arc);
            3: descEspecifica(Arc);
            4: exportarCelulares(Arc);
            5: agregarCelulares(Arc);
			6: modificarStock(Arc);
			7: exportarSinStock(Arc);
            0: writeln('Terminando programa...');
        else
            writeln('Opción no válida.');
        end;
    until opcion = 0;
END.

{Agregar al menú del programa del ejercicio 5, opciones para:

a. Añadir uno o más celulares al final del archivo con sus datos ingresados por teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado: ”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular.}
