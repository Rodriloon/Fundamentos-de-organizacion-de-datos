Program P308;
const
	valorAlto = 32000;
type
	str = string[50];

	info = record
		nombre: str;
		anio: integer;
		version: integer;
		cantidad: integer;
		descripcion: str;
	end;
	
	archivo = file of info;

	{-------------------PROCESOS-------------------}

procedure leerInfo (var i: info);
begin
	readln(i.nombre);
	if (i.nombre <> 'ZZZ') then
	begin
		readln(i.anio);
		readln(i.version);
		readln(i.cantidad);
		readln(i.descripcion);
	end;
end;

function ExisteDistribucion (var arc: archivo; nombre: str): boolean;
var
	i: info;
	existe: boolean;
begin
	reset(arc);
	existe:= false;
	while (not EOF(arc)) and (not existe) do
	begin
		read(arc, i);
		if (i.nombre = nombre) then
			existe:= true;
	end;
	close(arc);
	ExisteDistribucion:= existe;
end;

procedure AltaDistribucion (var arc: archivo);
var
	i, aux: info;
begin
	leerInfo(i);
	if (ExisteDistribucion(arc, i.nombre)) then
		writeln('Ya existe la distribucion')
	else
		reset(arc);
		read(arc, aux);
		if (aux.anio = 0) then
		begin
			seek(arc, filePos(arc));
			write(arc, i);
		end
		else begin
			seek(arc, aux.anio * - 1);
			read(arc, aux);
			seek(arc, filePos(arc) - 1);
			write(arc, i);
			seek(arc, 0);
			write(arc, aux);
		end;
		close(arc);
end;

procedure BajaDistribucion (var arc: archivo);
var
	i, aux: info;
	nom: str;
begin
	readln(nom);
	if (not ExisteDistribucion(arc, nom)) then
		writeln('No se encontro la distribucion')
	else begin
		reset(arc);
		read(arc, aux);
		read(arc, i);
		while (i.nombre <> nom) do
			read(arc, i);
		seek(arc, filePos(arc) - 1);
		write(arc, aux);
		aux.anio:= (filePos(arc) - 1) * - 1;
		seek(arc, 0);
		write(arc, aux);
		close(arc);
	end;
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arc: archivo;
BEGIN
	AltaDistribucion(arc);
	BajaDistribucion(arc);
END.

	{-------------------ENUNCIADO-------------------}
{
Se cuenta con un archivo con información de las diferentes distribuciones de linux existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las distribuciones no puede repetirse. Este archivo debe ser mantenido realizando bajas
lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida.

Escriba la definición de las estructuras de datos necesarias y los siguientes procedimientos:

a. ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve verdadero si la distribución existe en el archivo o falso en caso contrario.

b. AltaDistribución: módulo que lee por teclado los datos de una nueva distribución y la agrega al archivo reutilizando espacio disponible en caso
de que exista. (El control de unicidad lo debe realizar utilizando el módulo anterior). En caso de que la distribución que se quiere agregar ya exista se
debe informar “ya existe la distribución”.

c. BajaDistribución: módulo que da de baja lógicamente una distribución  cuyo nombre se lee por teclado. Para marcar una distribución como
borrada se debe utilizar el campo cantidad de desarrolladores para mantener actualizada la lista invertida. Para verificar que la distribución a
borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no existir se debe informar “Distribución no existente”.
}
