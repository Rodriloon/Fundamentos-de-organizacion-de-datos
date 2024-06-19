Program P1E5;
const
	valoralto = 9999;
type
	str = string[50];
	
	celular = record
		codigo: integer;
		nombre: str;
		descripcion: str;
		marca: str;
		precio: real;
		stockMin: integer;
		stockDisp: integer; 
	end;
	
	archivo = file of celular;

	{-------------------PROCESOS-------------------}

procedure cargarDesdeTxt (var arc: archivo);
var
	txt: text;
	c: celular;
begin
	rewrite(arc);
	assign(txt, 'celulares.txt');
	reset(txt);
	while (not EOF(txt)) do
	begin
		readln(txt, c.codigo, c.precio, c.marca);
		readln(txt, c.stockDisp, c.stockMin, c.descripcion);
        readln(txt, c.nombre);
	end;
	close(txt);
	close(arc);
end;

procedure imprimirCelular (c: celular);
begin
	writeln(' Codigo: ', c.codigo,
            ' Nombre: ', c.nombre,
            ' Descripcion: ', c.descripcion,
            ' Marca: ', c.marca,
            ' Precio: ', c.precio:0:2,
            ' Stock minimo: ', c.stockMin,
            ' Stock disponible: ', c.stockDisp
            );
end;

procedure stockInferior (var arc: archivo);
var
	c: celular;
begin
	reset(arc);
	while (not EOF(arc)) do
	begin
		read(arc, c);
		if (c.stockDisp < c.stockMin) then
			imprimirCelular(c);
	end;
	close(arc);
end;

procedure buscarCadena (var arc: archivo);
var
	c: celular;
	cadena: str;
	posicion: integer;
begin
	reset(arc);
	readln(cadena);
	while (not EOF(arc)) do
	begin
		read(arc, c);
		posicion:= pos(cadena, c.descripcion);
		if (posicion > 0) then
			imprimirCelular(c);
	end;
	close(arc);
end;

procedure exportarATxt (var arc: archivo);
var
	c: celular;
	txt: text;
begin
	assign(txt, 'celulares.txt');
	rewrite(txt);
	reset(arc);
	while (not EOF(arc)) do
	begin
		read(arc, c);
		writeln(txt, c.codigo, ' ', c.precio, ' ', c.marca);  
		writeln(txt, c.stockDisp, ' ', c.stockMin, ' ', c.descripcion); 
		writeln(txt, c.nombre);
	end;
	close(arc);
	close(txt);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arc: archivo;
	opcion: integer;
BEGIN
	writeln('Ingrese por teclado la opcion que desea realizar: ');
	writeln('1. Crear archivo desde txt');
	writeln('2. Listar en pantalla los celulares que tengan stock inferior al minimo');
	writeln('3. Listar en pantalla los celulares cuya descripcion tenga una cadena de caracteres proporcionada por el usuario');
	writeln('4. Exportar el archivo a un txt');
	readln(opcion);
	case opcion of
		1: cargarDesdeTxt(arc);
		2: stockInferior(arc);
		3: buscarCadena(arc);
		4: exportarATxt(arc);
	end;
END.

	{-------------------ENUNCIADO-------------------}
{
Realizar un programa para una tienda de celulares, que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares, deben contener: código de celular, el nombre, descripcion, marca, precio, stock mínimo y el stock disponible.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock mínimo.
c. Listar en pantalla los celulares del archivo cuya descripción contenga una cadena de caracteres proporcionada por el usuario.
d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado “celulares.txt” con todos los celulares del mismo.

NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario una única vez.
NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en tres líneas consecutivas: en la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo “celulares.txt”.
}

