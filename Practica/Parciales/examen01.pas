Program examen1;
const
	valorAlto = 32000;
type
	str = string[50];

	producto = record
		codigo: integer;
		nombre: str;
		descripcion: str;
		precio: real;
		ubicacion: str;
	end;
	
	archivo = file of producto;

	{-------------------PROCESOS-------------------}

procedure leerProducto (var p: producto);
begin
	readln(p.codigo);
	if (p.codigo <> valorAlto) then
	begin
		readln(p.nombre);
		readln(p.descripcion);
		readln(p.precio);
		readln(p.ubicacion);
	end;
end;

procedure leer (var arc: archivo; var p: producto);
begin
	if (not EOF(arc)) then
		read(arc, p)
	else
		p.codigo:= valorAlto;
end;

function existeProducto (var arc: archivo; cod: integer): boolean;
var
	p: producto;
	existe: boolean;
begin
	existe:= false;
	reset(arc);
	leer(arc, p);
	while (p.codigo <> valorAlto) and (not existe) do
		if (p.codigo = cod) then
			existe:= true;
		leer(arc, p);
	close(arc);
	existeProducto:= existe;
end;

procedure agregarProducto (var arc: archivo);
var
	p, aux: producto;
begin
	leerProducto(p);
	if (existeProducto(arc, p.codigo)) then
		writeln('El producto ingresado ya existe en el archivo')
	else begin
		reset(arc);
		read(arc, aux);
		if (aux.codigo = 0) then
		begin
			seek(arc, filePos(arc));
			write(arc, p);
		end
		else begin
			seek(arc, aux.codigo * - 1);
			read(arc, aux);
			seek(arc, filePos(arc) - 1);
			write(arc, p);
			seek(arc, 0);
			write(arc, aux);
		end;
		close(arc);
	end;
end;

procedure quitarProducto (var arc: archivo);
var
	p, aux: producto;
	cod: integer;
begin
	readln(cod);
	if (existeProducto(arc, cod) = false) then
		writeln('El producto ingresado no existe en el archivo')
	else begin
		reset(arc);
		read(arc, aux);
		read(arc, p);
		while (p.codigo <> cod) do
			read(arc, p);
		seek(arc, filePos(arc) - 1);
		write(arc, aux);
		aux.codigo:= (filePos(arc) - 1) * - 1;
		seek(arc, 0);
		write(arc, aux);
		close(arc);
	end;
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arch: archivo;
BEGIN
	assign(arch, 'archivo.dat');
	agregarProducto(arch);
	quitarProducto(arch);
END.

	{-------------------ENUNCIADO-------------------}
{
 Suponga que tiene un archivo con informacion referente a los productos que se comercializan en un supermercado. De cada producto se 
conoce codigo de producto (unico), nombre del producto, descripcion, precio de compra, precio de venta y ubicacion en deposito.

 Se solicita hacer el mantenimiento de este archivo utilizando la tecnica de reutilizacion de espacio llamada lista invertida.
 
 Declare las estructuras de datos necesarias e implemente los siguientes modulos:
 
 Agregar producto: recibe el archivo sin abrir y solicita al usuario que ingrese los datos del producto y lo agrega al archivo solo si el 
codigo ingresado no existe. Suponga que existe una funcion llamada existeProducto que recibe un codigo de producto y un archivo y devuelve
verdadero si el codigo existe en el archivo o falso en caso contrario. La funcion existeProducto no debe implementarla. Si el producto ya 
existe debe informarlo en pantalla.

 Quitar producto: recibe el archivo sin abrir y solicita al usuario que ingrese un codigo y lo elimina del archivo solo si este codigo existe. Puede
utilizar la funcion existeProducto. En caso de que el producto no exista debe informarse en pantalla.

 Nota: Los modulos que debe implementar deberan guardar en memoria secundaria todo cambio que se produzca en el archivo.
}
