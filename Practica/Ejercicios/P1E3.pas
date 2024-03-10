Program P1E3;
type
	rango = 0..4;

	empleado = record
		numero: integer;
		apellido: string;
		nombre: string;
		edad: integer;
		dni: integer;
	end;

	archivo = file of empleado;

	{-------------------PROCESOS-------------------}

procedure cargarArchivo(var Ar: archivo; var fis: string);

	procedure leerEmpleados(var E: empleado);
	begin
		readln(E.apellido);
		if (E.apellido <> 'fin') then
		begin
			readln(E.nombre);
			readln(E.numero);
			readln(E.edad);
			readln(E.dni);
		end;
	end;

var
	E: empleado;
begin
	readln(fis);
	Assign(Ar, fis);
	Rewrite(Ar);
	leerEmpleados(E);
	while (E.apellido <> 'fin') do
	begin
		Write(Ar, E);
		leerEmpleados(E);
	end;
	Close(Ar);
end;

procedure imprimirEmpleado(E: empleado);
begin
	writeln(E.apellido);
	writeln(E.nombre);
	writeln(E.numero);
	writeln(E.edad);
	writeln(E.dni);
end;

procedure imprimirAlgunos(var Ar: archivo; fis: string);
var
	E: empleado;
	determinado: string;
begin
	readln(determinado);
	Reset(Ar);
	while (not EOF(Ar)) do
	begin
		Read(Ar, E);
		if ((E.apellido = determinado) or (E.nombre = determinado)) then
		begin
			imprimirEmpleado(E);
		end
	end;
	Close(Ar);
end;

procedure imprimirTodos(var Ar: archivo; fis: string);
var
	E: empleado;
begin
	Reset(Ar);
	while (not EOF(Ar)) do
	begin
		Read(Ar, E);
		imprimirEmpleado(E);
	end;
	Close(Ar);
end;

procedure imprimir70(var Ar: archivo; fis: string);
var
	E: empleado;
begin
	Reset(Ar);
	while (not EOF(Ar)) do
	begin
		Read(Ar, E);
		if (E.edad > 70) then
		begin
			imprimirEmpleado(E);
		end
	end;
	Close(Ar);
end;

procedure menu (var Ar: archivo; var fis: string);
var
	num: rango;
begin
	writeln('Ingrese 0 para crear un archivo de empleados');
	writeln('Ingrese 1 para listar en pantalla los datos de empleados que tengan un nombre o apellido determinado');
	writeln('Ingrese 2 para listar en pantalla los empleados de a uno por línea');
	writeln('Ingrese 3 para listar en pantalla empleados mayores de 70 años, próximos a jubilarse');
	writeln('Ingrese 4 para terminar el programa');
	readln(num);
	while (num <> 4) do
	begin
		if (num = 0) then
			cargarArchivo(Ar, fis)
		else
			if (num = 1) then
				imprimirAlgunos(Ar, fis)
			else
				if (num = 2) then
					imprimirTodos(Ar, fis)
				else
					imprimir70(Ar, fis);
		readln(num);
	end;
	writeln('Termino el programa.');
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	Arc: archivo;
	fis: string;
BEGIN
	menu(Arc, fis);
END.

{ Realizar un programa que presente un menú con opciones para:

a. Crear un archivo de registros no ordenados de empleados y completarlo con datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.

b. Abrir el archivo anteriormente generado y:
 i. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.
 ii. Listar en pantalla los empleados de a uno por línea.
 iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.
 
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario una única vez.}

