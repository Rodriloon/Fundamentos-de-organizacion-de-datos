Program examen10;
const
	valorAlto = 32000;
type
	str = string[50];

	TEstudiante = record
		numero_matricula: integer;
		nombre: str;
		apellido: str;
		carrera: str;
		anio_ingreso: integer;
	end;

	TArchivoEstudiantes = file of TEstudiante;

	{-------------------PROCESOS-------------------}

procedure leer (var arc: TArchivoEstudiantes; var e: TEstudiante);
begin
	if (not EOF(arc)) then
		read(arc, e);
	else
		e.numero_matricula:= valorAlto;
end;

procedure leerEstudiante (var e: TEstudiante);
begin
	readln(e.numero_matricula);
	if (e.numero_matricula <> valorAlto) then
	begin
		readln(e.nombre);
		readln(e.apellido);
		readln(e.carrera);
		readln(e.anio_ingreso);
	end;
end;

function existeEstudiante (var arc: TArchivoEstudiantes; num: integer): boolean;
var
	regArc: TEstudiante;
	existe: boolean;
begin
	existe:= false;
	reset(arc);
	leer(arc, regArc);
	while (not EOF(arc)) and (not existe) do
	begin
		if (regArc.numero_matricula = num) then
			existe:= true;
		leer(arc, regArc);
	end;
	close(arc);
	existeEstudiante:= existe;
end;

procedure agregarEstudiante (var arc: TArchivoEstudiantes);
var
	aux, regArc: TEstudiante;
begin
	leerEstudiante(regArc);
	if (existeEstudiante(arc, regArc.numero_matricula)) then
		writeln('Ya existe');
	else begin
		reset(arc);
		leer(arc, aux);
		if (aux.numero_matricula = 0) then
		begin
			seek(arc, fileSize(arc));
			write(arc, regArc);
		end
		else begin
			Seek(arc, (aux.numero_matricula * - 1));
			leer(arc, aux);
			Seek(arc, filePos(arc) - 1);
			write(arc, regArc);
			Seek(arc, 0);
			write(arc, aux);
		end;
		close(arc);
	end;
end;

procedure quitarEstudiante (var arc: TArchivoEstudiantes);
var
	aux, regArc: TEstudiante;
	num: integer;
begin
	readln(num);
	if (not existeEstudiante(arc, num)) then
		writeln('No existe el numero en el archivo');
	else begin
		reset(arc);
		leer(arc, aux);
		leer(arc, regArc);
		while (regArc.numero_matricula <> num) do
			leer(arc, regArc);
		Seek(arc, filePos(arc) - 1);
		write(arc, aux);
		regArc.numero_matricula:= ((filePos(arc) * - 1) - 1);
		Seek(arc, 0);
		write(arc, regArc);
		close(arc);
	end;
end;
	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arc: archivo;
	ruta: str;
BEGIN
	readln(ruta);
	Assign(arc, ruta);
	agregarEstudiante(arc);
	quitarEstudiante(arc);
END.

	{-------------------ENUNCIADO-------------------}
{
 Agregar Estudiante: Implementa una función agregarEstudiante que reciba el archivo y permita al usuario ingresar datos para agregar un nuevo estudiante. Verifica si el número 
de matrícula ya existe utilizando la función existeEstudiante (que asumimos ya está implementada). Si el estudiante no existe, agrégalo al archivo reutilizando espacio libre si es necesario.

 Quitar Estudiante: Implementa una función quitarEstudiante que permita al usuario ingresar el número de matrícula de un estudiante y eliminarlo del archivo si existe. Utiliza 
la función existeEstudiante para verificar la existencia del estudiante antes de eliminarlo.
}
