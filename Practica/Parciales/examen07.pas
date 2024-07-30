Program examen7;
const
	valorAlto = 32000;
type
	str = string[50];

	TLibro = record
		isbn: str;
		titulo: str;
		autor: str;
		genero: str;
		anio: integer;
	end;

	TArchivoLibros = file of TLibro;

	{-------------------PROCESOS-------------------}

procedure leerTLibro (var l: TLibro);
begin
	readln(l.anio);
	if (l.anio <> valorAlto) then
	begin
		readln(l.titulo);
		readln(l.autor);
		readln(l.genero);
		readln(l.isbn);
	end;
end;

procedure leer (var arc: archivo; var l: TLibro);
begin
	if (not EOF(arc)) then
		read(arc, l)
	else
		l.anio:= valorAlto;
end;

function existeLibro (var arc: archivo; isbn: str): boolean;
var
	aux: TLibro;
	existe: boolean;
begin
	existe: false;
	reset(arc);
	leer(arc, aux);
	while (aux.anio <> valorAlto) and (not existe) do
	begin
		if (aux.isbn = isbn) then
			existe:= true;
		leer(arc, aux);
	end;
	close(arc);
	existeLibro:= existe;
end;

procedure agregarLibro (var arc: archivo);
var
	l, aux: TLibro;
begin
	leerTLibro(l);
	if (existeLibro(arc, l)) then
		writeln('El libro ingresado ya existe en el archivo ')
	else begin
		reset(arc);
		leer(arc, aux);
		if (aux.anio = 0) then
		begin
			seek(arc, fileSize(arc));
			write(arc, l);
		end
		else begin
			seek(arc, aux.anio * - 1);
			read(arc, aux);
			seek(arc, filePos(arc) - 1);
			write(arc, l);
			seek(arc, 0);
			write(arc, aux);
		end;
		close(arc);
	end;
end;

procedure quitarLibro (var arc: archivo);
var
	l, aux: TLibro;
	isbn: str;
begin
	readln(isbn);
	if (existeLibro(arc, isbn)) then
	begin
		reset(arc);
		leer(arc, aux);
		leer(arc, l);
		while (l.isbn <> isbn) do
			leer(arc, l);
		seek(arc, filePos(arc) - 1);
		write(arc, aux);
		aux.anio:= (filePos(arc) - 1) * - 1;
		seek(arc, 0);
		write(arc, aux);
		close(arc);
	end
	else
		writeln('El libro buscado no se encuentra en el archivo ');
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arc: archivo;
	ruta: str;
BEGIN
	readln(ruta);
	Assign(arc, ruta);
	agregarLibro(arc);
	quitarLibro(arc);
END.

	{-------------------ENUNCIADO-------------------}
{
 Agregar Libro: Implementa una función agregarLibro que reciba el archivo y permita al usuario ingresar datos para agregar un nuevo libro. Verifica si el ISBN del libro 
ya existe utilizando la función existeLibro (que asumimos ya está implementada). Si el libro no existe, agrégalo al archivo reutilizando espacio libre si es necesario.

 Quitar Libro: Implementa una función quitarLibro que permita al usuario ingresar el ISBN de un libro y eliminarlo del archivo si existe. Utiliza la función existeLibro 
para verificar la existencia del libro antes de eliminarlo.
}
