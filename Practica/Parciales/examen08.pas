Program examen8;
const
	valorAlto = 32000;
type
	str = string[50];

	TPaciente = record
		numero_historia: integer;
		nombre: str;
		apellido: str;
		edad: integer;
		diagnostico: str;
	end;

	TArchivoPacientes = file of TPaciente;

	{-------------------PROCESOS-------------------}

procedure leer (var arc: TArchivoPacientes; var p: TPaciente);
begin
	if (not EOF(arc)) then
		read(arc, p)
	else
		p.numero_historia:= valorAlto;
end;

procedure leerPaciente (var p: TPaciente);
begin
	readln(p.numero_historia);
	if (p.numero_historia <> valorAlto) then
	begin
		readln(p.nombre);
		readln(p.apellido);
		readln(p.edad);
		readln(p.diagnostico);
	end;
end;

function existePaciente (var arc: TArchivoPacientes; cod: integer): boolean;
var
	p: TPaciente;
	existe: boolean;
begin
	existe:= false;
	reset(arc);
	leer(arc, p);
	while (p.numero_historia <> valorAlto) and (not existe) do
	begin
		if (p.numero_historia = cod) then
			existe:= true;
		leer(arc, p);
	end;
	close(arc);
	existePaciente:= existe;
end;

procedure agregarPaciente (var arc: TArchivoPacientes);
var
	aux, regArc: TPaciente;
begin
	leerPaciente(regArc);
	if (existePaciente(arc, regArc.numero_historia)) then
		writeln('Ya existe este paciente banana')
	else begin
		reset(arc);
		leer(arc, aux);
		if (aux.numero_historia = 0) then
		begin
			seek(arc, fileSize(arc));
			write(arc, regArc);
		end
		else begin
			seek(arc, aux.numero_historia * - 1);
			read(arc, aux);
			seek(arc, filePos(arc) - 1);
			write(arc, regArc);
			seek(arc, 0);
			write(arc, aux);
		end;
		close(arc);
	end;
end;

procedure quitarPaciente (var arc: TArchivoPacientes);
var
	aux, regArc: TPaciente;
	cod: integer;
begin
	readln(cod);
	if (not existePaciente(arc, cod)) then
		writeln('No existe absolutamente nada de lo que pones pelotudo')
	else begin
		reset(arc);
		leer(arc, aux);
		leer(arc, regArc);
		while (regArc.numero_historia <> cod) do
			leer(arc, regArc);
		Seek(arc, filePos(arc) - 1);
		write(arc, aux);
		regArc.numero_historia:= ((filePos(arc) - 1) * - 1);
		Seek(arc, 0);
		write(arc, regArc);
		close(arc);
	end;
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arc: TArchivoPacientes;
	ruta: str;
BEGIN
	readln(ruta);
	Assign(arc, ruta);
	agregarPaciente(arc);
	quitarPaciente(arc);
END.

	{-------------------ENUNCIADO-------------------}
{
 Agregar Paciente: Implementa una función agregarPaciente que reciba el archivo y permita al usuario ingresar datos para agregar un nuevo paciente. Verifica si el 
número de historia clínica ya existe utilizando la función existePaciente (que asumimos ya está implementada). Si el paciente no existe, agrégalo al archivo reutilizando espacio libre si es necesario.

 Quitar Paciente: Implementa una función quitarPaciente que permita al usuario ingresar el número de historia clínica de un paciente y eliminarlo del archivo si existe. Utiliza 
la función existePaciente para verificar la existencia del paciente antes de eliminarlo.
}
