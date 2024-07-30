Program examen5;
const
	valorAlto = 32000;
type
	str = string[50];
	rango1 = 1..31;
	rango2 = 1..12;
	rango3 = 1900..2024;

	fecha = record
		dia: rango1;
		mes: rango2;
		anio: rango3;
	end;
	
	empleado = record
		dni: integer;
		nombre: str;
		apellido: str;
		edad: integer;
		domicilio: str;
		nacimiento: fecha;
	end;
	
	archivo = file of empleado;

	{-------------------PROCESOS-------------------}

procedure leerEmpleado (var e: empleado);

	procedure leerFecha (var f: fecha);
	begin
		readln(f.dia);
		readln(f.mes);
		readln(f.anio);
	end;

var
	f: fecha;
begin
	readln(e.dni);
	readln(e.nombre);
	readln(e.apellido);
	readln(e.edad);
	readln(e.domicilio);
	leerFecha(f);
end;

procedure leer (var arc: archivo; var e: empleado);
begin
	if (not EOF(arc)) then
		read(arc, e)
	else
		e.dni:= valorAlto;
end;

function existeEmpleado (var arc: archivo; dni: integer): boolean;
var
	e: empleado;
	existe: boolean;
begin
	existe:= false;
	reset(arc);
	leer(arc, e);
	while (e.dni <> valorAlto) and (not existe) do
	begin
		if (e.dni = dni) then
			existe:= true;
		leer(arc, e);
	end;
	close(arc);
	existeEmpleado:= existe;
end;

procedure agregarEmpleado (var arc: archivo);
var
	e, aux: empleado;
begin
	leerEmpleado(e);
	if (not existeEmpleado(arc, e.dni)) then
	begin
		reset(arc);
		leer(arc, aux);
		if (aux.dni = 0) then
		begin
			seek(arc, fileSize(arc));
			write(arc, e);
		end
		else begin
			seek(arc, aux.dni * - 1);
			leer(arc, aux);
			seek(arc, filePos(arc) - 1);
			write(arc, e);
			seek(arc, 0);
			write(arc, aux);
		end;
		close(arc);
	end
	else
		writeln('La persona ingresada ya existe en el archivo');
end;

procedure quitarEmpleado (var arc: archivo);
var
	e, aux: empleado;
	dni: integer;
begin
	readln(dni);
	if (existeEmpleado(arc, dni)) then
	begin
		reset(arc);
		leer(arc, aux);
		leer(arc, e);
		while (e.dni <> dni) do
			leer(arc, e);
		seek(arc, filePos(arc) - 1);
		write(arc, aux);
		aux.dni:= (filePos(arc) - 1) * - 1;
		seek(arc, 0);
		write(arc, aux);
		close(arc);
	end
	else
		writeln('La persona buscada no existe en el archivo');
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arc: archivo;
	ruta: str;
BEGIN
	readln(ruta);
	Assign(arc, ruta);
	agregarEmpleado(arc);
	quitarEmpleado(arc);
END.

	{-------------------ENUNCIADO-------------------}
{
 Suponga que tiene un archivo con información referente a los empleados que trabajan en una multinacional. De cada empleado se conoce el dni (único), nombre, apellido, edad,
domicilio y fecha de nacimiento.
 Se solicita hacer el mantenimiento de este archivo utilizando la técnica de reutilización de espacio llamada lista invertida.

 Declare las estructuras de datos necesarias e implemente los siguientes módulos:
a. Agregar empleado: solicita al usuario que ingrese los datos del empleado y lo agrega al archivo sólo si el dni ingresado no existe. Suponga que existe una función llamada
existeEmpleado que recibe un dni y un archivo y devuelve verdadero si el dni existe en el archivo o falso en caso contrario. La función existeEmpleado no debe implementarla. Si el
empleado ya existe, debe informarlo en pantalla.

b. Quitar empleado: solicita al usuario que ingrese un dni y lo elimina del archivo solo si este dni existe. Debe utilizar la función existeEmpleado. En caso de que el empleado no exista
debe informarse en pantalla.

 Nota: Los módulos que debe implementar deberán guardar en memoria secundaria todo cambio que se produzca en el archivo.
}
