Program P1E3;
const
	valoralto = 9999;
type
	str = string[50];
	
	empleado = record
		apellido: str;
		nombre: str;
		numero: integer;
		edad: integer;
		dni: integer;
	end;
	
	archivo = file of empleado;

	{-------------------PROCESOS-------------------}

procedure leerEmpleado (var e: empleado);
begin
	readln(e.apellido);
	if (e.apellido <> 'fin') then
	begin
		readln(e.nombre);
		readln(e.numero);
		readln(e.edad);
		readln(e.dni);
	end;
end;

procedure imprimirEmpleado (e: empleado);
begin
	writeln('Los datos del empleado son: ');
	writeln(e.numero);
	writeln(e.apellido);
	writeln(e.nombre);
	writeln(e.edad);
	writeln(e.dni);
end;

procedure crearArchivo (var arc: archivo);
var
	e: empleado;
	nom_fis: str;
begin
	readln(nom_fis);
	assign(arc, nom_fis);
	rewrite(arc);
	leerEmpleado(e);
	while (e.apellido <> 'fin') do
	begin
		write(arc, e);
		leerEmpleado(e);
	end;
	close(arc);
end;

procedure apellidoDeterminado (var arc: archivo);
var
	aux: str;
	e: empleado;
begin
	readln(aux);
	reset(arc);
	while (not EOF(arc)) do
	begin
		read(arc, e);
		if (e.apellido = aux) or (e.nombre = aux) then
			imprimirEmpleado(e);
	end;
	close(arc);
end;

procedure empleadosFila (var arc: archivo);
var
	e: empleado;
begin
	reset(arc);
	while (not EOF(arc)) do
	begin
		read(arc, e);
		imprimirEmpleado(e);
	end;
	close(arc);
end;

procedure empleadosJubilados (var arc: archivo);
var
	e: empleado;
begin
	reset(arc);
	while (not EOF(arc)) do
	begin
		read(arc, e);
		if (e.edad > 70) then
			imprimirEmpleado(e);
	end;
	close(arc);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arc: archivo;
	opcion: integer;
BEGIN
	writeln('Ingrese por teclado la opcion que desea realizar: ');
	writeln('1. Crear un archivo.');
	writeln('2. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.');
	writeln('3. Listar en pantalla los empleados de a uno por linea.');
	writeln('4. Listar en pantalla empleados mayores de 70 anos, proximos a jubilarse.');
	readln(opcion);
	case opcion of
		1: crearArchivo(arc);
		2: apellidoDeterminado(arc);
		3: empleadosFila(arc);
		4: empleadosJubilados(arc);
	end;
END.

	{-------------------ENUNCIADO-------------------}
{
 Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
b. Abrir el archivo anteriormente generado y
 i. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.
 ii. Listar en pantalla los empleados de a uno por línea.
 iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario una única vez.
}
