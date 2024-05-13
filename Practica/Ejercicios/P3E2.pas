Program P3E2;
type
	str = string[50];

	asistente = record
		numero: integer;
		AyN: str;
		email: string;
		telefono: integer;
		dni: integer;
	end;
	
	archivo = file of asistente;

	{-------------------PROCESOS-------------------}

procedure cargarArchivo (var arc: archivo);

	procedure leerAsistente (var A: asistente);
	begin
		readln(A.numero);
		if (A.numero <> -1) then
		begin
			readln(A.AyN);
			readln(A.email);
			readln(A.telefono);
			readln(A.dni);
		end;
	end;

var
	A: asistente;
begin
	rewrite(arc);
	leerAsistente(A);
	while (A.numero <> -1) do
	begin
		Write(arc, A);
		leerAsistente(A);
	end;
	close(arc);
end;

procedure eliminar1000 (var arc: archivo);
var
	A: asistente;
begin
	reset(arc);
	while (not EOF(arc)) do
	begin
		read(arc, A);
		if (A.numero < 1000) then
		begin
			A.email:= '@' + A.email;
			seek(arc, filePos(arc) - 1);
			write(arc, A);
		end;
	end;
	close(arc);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arc: archivo;
	fis: str;
BEGIN
	readln(fis);
	Assign(arc, fis);
	reset(arc);
	cargarArchivo(arc);
	eliminar1000(arc);
END.

{ Definir un programa que genere un archivo con registros de longitud fija conteniendo información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de asistente inferior a 1000.
 Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo String a su elección. Ejemplo: ‘@Saldaño’.}
