Program P1E4;
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

function cumple (var arc: archivo, num: integer): boolean;
var
	encontre: boolean;
	e: empleado;
begin
	encontre:= false;
	while (not EOF(arc) and (not encontre)) do
	begin
		read(arc, e);
		if (e.numero = numero) then
			encontre:= true;
	end;
	cumple:= not encontre;
end;

procedure agregarEmpleados (var arc: archivo);
var
	e: empleado;
begin
	rewrite(arc);
	leerEmpleado(e);
	if (cumple(arc, e.numero)) do
	begin
		seek(fileSize(arc));
		write(arc, e);
	end;
	close(arc);
end;

procedure modificarEdad (var arc: archivo);
var
	e: empleado;
	edad, num: integer;
	encontre: boolean;
begin
	encontre:= false;
	reset(arc);
	readln(num);
	readln(edad);
	while (not EOF(arc) and (not encontre)) do
	begin
		read(arc, e);
		if (e.numero = num) then
		begin
			encontre:= true;
			e.edad:= edad;
			seek(arc, filePos(arc) - 1);
			write(arc, e);
		end;	
	end;
	close(arc);
end;

procedure exportarTxt (var arc: archivo);
var
	e: empleado;
	txt: text;
begin
	assign(txt, 'todos_empleados.txt');
	rewrite(txt);
	reset(arc);
	while (not EOF(arc)) do
	begin
		read(emp, e);
		writeln(txt, e.numero, ' ', e.edad, ' ', e.dni, ' ', e.nombre);
		writeln(txt, e.apellido);
	end;
	close(arc);
	close(txt);
end;

procedure exportarTxtDni (var arc: archivo);
var
	e: empleado;
	txtDni: text;
begin
	assign(txtDni, 'faltaDNIEmpleado.txt');
	rewrite(txtDni);
	reset(arc);
	while (not EOF(arc)) do
	begin
		read(emp, e);
		if (e.dni = 00) then
		begin
			writeln(txtDni, e.numero, ' ', e.edad, ' ', e.dni, ' ', e.nombre);
			writeln(txtDni, e.apellido);
		end;
	end;
	close(arc);
	close(txtDni);
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
	writeln('5. Añadir una o mas empleados al final del archivo.');
	writeln('6. Modificar la edad a una o mas empleados.');
	writeln('7. Exportar el contenido del archivo a un archivo de texto');
	writeln('8. Exportar a un archivo de texto de los empleados que no tengan cargado el DNI');
	readln(opcion);
	case opcion of
		1: crearArchivo(arc);
		2: apellidoDeterminado(arc);
		3: empleadosFila(arc);
		4: empleadosJubilados(arc);
		5: agregarEmpleados(arc);
		6: modificarEdad(arc);
		7: exportarTxt(arc);
		8: exportarTxtDni(arc);
	end;
END.

	{-------------------ENUNCIADO-------------------}
{
 Agregar al menú del programa del ejercicio 3, opciones para:
a. Añadir una o más empleados al final del archivo con sus datos ingresados por teclado.
b. Modificar edad a una o más empleados.
c. Exportar el contenido del archivo a un archivo de texto llamado “todos_empleados.txt”.
d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados que no tengan cargado el DNI (DNI en 00).
NOTA: Las búsquedas deben realizarse por número de empleado.
}
