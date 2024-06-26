Program P3E1;
type
	rango = -1..8;

	empleado = record
		numero: integer;
		apellido: string;
		nombre: string;
		edad: integer;
		dni: integer;
	end;

	archivo = file of empleado;

	{-------------------PROCESOS-------------------}

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

procedure cargarArchivo(var Ar: archivo; var fis: string);
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

procedure imprimirAlgunos(var Ar: archivo);
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

procedure imprimirTodos(var Ar: archivo);
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

procedure imprimir70(var Ar: archivo);
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
	writeln('Ingrese -1 para terminar el programa');
	writeln('Ingrese 0 para crear un archivo de empleados');
	writeln('Ingrese 1 para listar en pantalla los datos de empleados que tengan un nombre o apellido determinado');
	writeln('Ingrese 2 para listar en pantalla los empleados de a uno por línea');
	writeln('Ingrese 3 para listar en pantalla empleados mayores de 70 años, próximos a jubilarse');
	readln(num);
	while (num <> -1) do
	begin
		if (num = 0) then
			cargarArchivo(Ar, fis)
		else
			if (num = 1) then
				imprimirAlgunos(Ar)
			else
				if (num = 2) then
					imprimirTodos(Ar)
				else
					imprimir70(Ar);
		readln(num);
	end;
	writeln('Termino el programa.');
end;

	{----------------------------------------------------------------------------------------------------}

procedure agregarEmpleado (var Ar: archivo);
var
	E: empleado;
begin
	Reset(Ar);
	Seek(Ar, fileSize(Ar));
	leerEmpleados(E);
	while (E.apellido <> 'fin') do
	begin
		Write(Ar, E);
		leerEmpleados(E);
	end;
	Close(Ar);
end;

procedure modificarEdad (Var Ar: archivo);
var
	E: empleado;
	num, edad: integer;
begin
	Reset(Ar);
	readln(num);
	while (num <> -1) do
	begin
		while (not EOF(Ar)) do
		begin
			read(Ar, E);
			if (E.numero = num) then
			begin
				readln(edad);
				E.edad:= edad;
				Seek(Ar, FilePos(Ar) - 1);
				Write(Ar, E);
			end;
		end;
		seek(Ar, 0);
		readln(num);
	end;
	Close(Ar);
end;

procedure exportarTodosEmpleados(var Ar: archivo);
var
    ArchivoTexto: Text;
    E: empleado;
begin
	Assign(ArchivoTexto, 'todos_empleados.txt');
	Rewrite(ArchivoTexto);
	Reset(Ar); 
	while not EOF(Ar) do 
	begin
		Read(Ar, E); 
		writeln(ArchivoTexto, 'Apellido: ', E.apellido);
		writeln(ArchivoTexto, 'Nombre: ', E.nombre);
		writeln(ArchivoTexto, 'Número: ', E.numero);
		writeln(ArchivoTexto, 'Edad: ', E.edad);
		writeln(ArchivoTexto, 'DNI: ', E.dni);
		writeln(ArchivoTexto); 
	end;
    Close(Ar); 
    Close(ArchivoTexto);
end;

procedure exportarFaltaDNIEmpleado(var Ar: archivo);
var
	ArchivoTexto: Text;
	E: empleado;
begin
	Assign(ArchivoTexto, 'faltaDNIEmpleado.txt');
	Rewrite(ArchivoTexto);
	Reset(Ar); 
	while not EOF(Ar) do 
	begin
		Read(Ar, E); 
		if E.dni = 00 then 
		begin
			writeln(ArchivoTexto, 'Apellido: ', E.apellido);
			writeln(ArchivoTexto, 'Nombre: ', E.nombre);
			writeln(ArchivoTexto, 'Número: ', E.numero);
			writeln(ArchivoTexto, 'Edad: ', E.edad);
			writeln(ArchivoTexto, 'DNI: ', E.dni);
			writeln(ArchivoTexto); 
		end;
	end;
	Close(Ar); 
	Close(ArchivoTexto);
end;

procedure bajaEmpleado (var Ar: archivo);
var
	cod: integer;
	ultEmp, e: empleado;
begin
	reset(Ar);
	writeln('Ingrese el codigo del empleado de baja');
	readln(cod);
	seek(Ar, fileSize(Ar) - 1);
	read(Ar, ultEmp);
	seek(Ar, 0);
	read(Ar, e);
	while (not EOF(Ar) and (e.numero <> cod)) do
		read(Ar, e);
	if (e.numero = cod) then
	begin
		seek(Ar, filePos(Ar) - 1);
		write (Ar, ultEmp);
		seek(Ar, fileSize(Ar) - 1);
		truncate(Ar);
		writeln('Se encontro el empleado con codigo', cod , ' y se realizo la baja correctamente');
	end
	else begin
		writeln('No se encontro el empleado con codigo ', cod , ' y no se realizo ninguna baja');
	end;
	close(Ar);
end;

procedure menu2 (var Ar: archivo; var fis: string);
var
	num: rango;
begin
	writeln('Ingrese -1 para terminar el programa');
	writeln('Ingrese 0 para crear un archivo de empleados');
	writeln('Ingrese 1 para listar en pantalla los datos de empleados que tengan un nombre o apellido determinado');
	writeln('Ingrese 2 para listar en pantalla los empleados de a uno por línea');
	writeln('Ingrese 3 para listar en pantalla empleados mayores de 70 años, próximos a jubilarse');
	writeln('Ingrese 4 para añadir una o más empleados al final del archivo con sus datos ingresados por teclado');
	writeln('Ingrese 5 para modificar edad a uno o más empleados');
	writeln('Ingrese 6 para exportar el contenido del archivo a "todos_empleados.txt"');
	writeln('Ingrese 7 para exportar a "faltaDNIEmpleado.txt" los empleados que no tengan cargado el DNI');
	writeln('Ingrese 8 para dar de baja a un empleado');
	readln(num);
	while (num <> -1) do
	begin
		case num of
			0: cargarArchivo(Ar, fis);
			1: imprimirAlgunos(Ar);
			2: imprimirTodos(Ar);
			3: imprimir70(Ar);
			4: agregarEmpleado(Ar);
			5: modificarEdad(Ar);
			6: exportarTodosEmpleados(Ar);
			7: exportarFaltaDNIEmpleado(Ar);
			8: bajaEmpleado(Ar);
		end;
		writeln;
		writeln('Operación completada. Ingrese otra opción:');
		readln(num);
	end;
	writeln('Termino el programa.');
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	Arc: archivo;
	fis: string;
BEGIN
	menu2(Arc, fis);
END.

{Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados), agregándole una opción para realizar bajas copiando el último registro del archivo en
la posición del registro a borrar y luego truncando el archivo en la posición del último registro de forma tal de evitar duplicados.}
