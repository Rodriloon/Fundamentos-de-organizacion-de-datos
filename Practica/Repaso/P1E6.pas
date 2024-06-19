Program P1E6;
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

procedure leerCelular (var c: celular);
begin
	readln(c.codigo);
	readln(c.nombre);
	readln(c.descripcion);
	readln(c.marca);
	readln(c.precio);
	readln(c.stockMin);
	readln(c.stockDisp); 
end;

procedure agregarCelulares (var arc: archivo);
var
	c: celular;
begin
	reset(arc);
	leerCelular(c);
	seek(arc, fileSize(arc));
	write(arc, c);
	close(arc);
end;

procedure modificarStock (var arc: archivo);
var
	c: celular;
	stock: integer;
	nombre: str;
	encontre: boolean;
begin
	encontre:= false;
	readln(nombre);
	readln(stock);
	reset(arc);
	while (not EOF(arc) and (not encontre)) do
	begin
		read(arc, c);
		if (c.nombre = nombre) then
		begin
			encontre:= true;
			c.stockDisp:= stock;
			seek(arc, filePos(arc) - 1);
			write(arc, c);
		end;
	end;
	close(arc);
end;

procedure exportarSinStock (var arc: archivo);
var
	c: celular;
	txt: text;
begin
	assign(txt, 'SinStock.txt');
	rewrite(txt);
	reset(arc);
	while (not EOF(arc)) do
	begin
		read(arc, c);
		if (c.stockDisp = 0) then
		begin
			writeln(txt, c.codigo, ' ', c.precio, ' ', c.marca);  
			writeln(txt, c.stockDisp, ' ', c.stockMin, ' ', c.descripcion); 
			writeln(txt, c.nombre);
		end;
	end;
	close(arc);
	close(txt);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arc: archivo;
	opcion: integer;
BEGIN
	repeat
        writeln('Menu:');
        writeln('1. Crear archivo de celulares');
        writeln('2. Listar celulares con stock menor al maximo');
        writeln('3. Buscar celulares por descripcion');
        writeln('4. Exportar archivo de celulares');
        writeln('5. Agregar uno o más celulares al final del archivo');
		writeln('6. Modificar el stock de un celular');
		writeln('7. Exportar celulares sin stock a un archivo de texto');
        writeln('0. Salir');
        write('Ingrese una opcion: ');
        readln(opcion);
        case opcion of
            1: cargarDesdeTxt(arc);
			2: stockInferior(arc);
			3: buscarCadena(arc);
			4: exportarATxt(arc);
            5: agregarCelulares(arc);
			6: modificarStock(arc);
			7: exportarSinStock(arc);
            0: writeln('Terminando programa...');
        else
            writeln('Opción no válida.');
        end;
    until opcion = 0;
END.

	{-------------------ENUNCIADO-------------------}
{
Agregar al menú del programa del ejercicio 5, opciones para:

a. Añadir uno o más celulares al final del archivo con sus datos ingresados por teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado: ”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular.
}
