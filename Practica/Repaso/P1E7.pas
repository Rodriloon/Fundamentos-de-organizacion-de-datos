Program P1E7;
const
	valoralto = 9999;
type
	str = string[50];

	novela = record
		codigo: integer;
		nombre: str;
		genero: str;
		precio: real;
	end;

	archivo = file of novela;

	{-------------------PROCESOS-------------------}

procedure cargar (var arc: archivo);
var
	ruta: str;
	txt: text;
	n: novela;
begin
	readln(ruta);
	assign(txt, 'novelas.txt');
	reset(txt);
	rewrite(arc);
	while (not EOF(txt)) do
	begin
		readln(txt, n.codigo, n.precio, n.genero);
		readln(txt, n.nombre);
		write(arc, n);
	end;
	close(arc);
	close(txt);
end;

procedure leerNovela (var n: novela);
begin
	readln(n.codigo);
	readln(n.nombre);
	readln(n.genero);
	readln(n.precio);
end;

procedure agregarNovela (var arc: archivo);
var
	n: novela;
begin
	leerNovela(n);
	reset(arc);
	seek(arc, fileSize(arc));
	write(arc, n);
end;

procedure modificarNombre (var arc: archivo);
var
	n: novela;
	codigo: integer;
	nombre: str;
	encontre: boolean;
begin
	readln(codigo);
	readln(nombre);
	reset(arc);
	encontre:= false;
	while (not EOF(arc) and (not encontre)) do
	begin
		read(arc, n);
		if (n.codigo = codigo) then
		begin
			encontre:= true;
			n.nombre:= nombre;
			seek(arc, filePos(arc) -1);
			write(arc, n);
		end;
	end;
	close(arc);
end;

procedure modificarPrecio (var arc: archivo);
var
	n: novela;
	codigo: integer;
	precio: real;
	encontre: boolean;
begin
	readln(codigo);
	readln(precio);
	reset(arc);
	encontre:= false;
	while (not EOF(arc) and (not encontre)) do
	begin
		read(arc, n);
		if (n.codigo = codigo) then
		begin
			encontre:= true;
			n.precio:= precio;
			seek(arc, filePos(arc) -1);
			write(arc, n);
		end;
	end;
	close(arc);
end;

procedure modificarGenero (var arc: archivo);
var
	n: novela;
	codigo: integer;
	genero: str;
	encontre: boolean;
begin
	readln(codigo);
	readln(genero);
	reset(arc);
	encontre:= false;
	while (not EOF(arc) and (not encontre)) do
	begin
		read(arc, n);
		if (n.codigo = codigo) then
		begin
			encontre:= true;
			n.genero:= genero;
			seek(arc, filePos(arc) -1);
			write(arc, n);
		end;
	end;
	close(arc);
end;

procedure menu2 (var arc: archivo);
var
	categoria: char;
begin
	categoria:= 'z';
	while(categoria <> 'd')do 
	begin
		writeln('¿Que desea modificar?');
		writeln('a._ Nombre.');
		writeln('b._ Genero');
		writeln('c._ Precio');
		writeln('d._ Volver atras');
		readln(categoria);
		case categoria of 
			'a' : modificarNombre(arc);
			'b' : modificarGenero(arc);
			'c' : modificarPrecio(arc);
			else 
				writeln('Caracter invalido');
		end;
	end;
end;

procedure menu (var arc : archivo);
var
	categoria: char;
begin
	categoria:= 'z';
	while(categoria <> 'c')do begin
		writeln('¿Que desea realizar?');
		writeln('a._ Agregar una novela.');
		writeln('b._ Modificar una existente.');
		writeln('c._ Cerrar menu');
		readln(categoria);
		case categoria of 
			'a' : agregarNovela(arc);
			'b' : menu2(arc);
			'c' : writeln('Menu cerrado');
			else 
				writeln('Caracter invalido');
		end;
	end;
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arc: archivo; 
BEGIN
	cargar(arc);
	menu(arc);
END.

	{-------------------ENUNCIADO-------------------}
{
Realizar un programa que permita:
a. Crear un archivo binario a partir de la información almacenada en un archivo de texto. El nombre del archivo de texto es: “novelas.txt”
b. Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar una novela y modificar una existente. Las búsquedas se realizan por código de novela.

NOTA: La información en el archivo de texto consiste en: código de novela, nombre,género y precio de diferentes novelas argentinas. De cada novela se almacena la
información en dos líneas en el archivo de texto. La primera línea contendrá la siguiente información: código novela, precio, y género, y la segunda línea almacenará el nombre de la novela.
}
