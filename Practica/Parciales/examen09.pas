Program examen9;
const
	valorAlto = 'ZZZ';
type
	str = string[50];

	TVehiculo = record
		numero_chasis: str;
		marca: str;
		modelo: str;
		anio: integer;
		precio: real;
	end;

	TArchivoVehiculos = file of TVehiculo;

	{-------------------PROCESOS-------------------}

procedure leer (var arc: TArchivoVehiculos; var v: TVehiculo);
begin
	if (not EOF(arc)) then
		read(arc, v)
	else
		v.numero_chasis:= valorAlto;
end;

procedure leerVehiculo (var v: TVehiculo);
begin
	readln(v.numero_chasis);
	if (v.numero_chasis <> valorAlto) then
	begin
		readln(v.marca);
		readln(v.modelo);
		readln(v.anio);
		readln(v.precio);
	end;
end;

function existeVehiculo (var arc: TArchivoVehiculos; num: str): boolean;
var
	regArc: TVehiculo;
	existe: boolean;
begin
	existe:= false;
	reset(arc);
	leer(arc, regArc);
	while (not EOF(arc)) and (not existe) do
	begin
		if (regArc.numero_chasis = num) then
			existe:= true;
		leer(arc, regArc);
	end;
	close(arc);
	existeVehiculo:= existe;
end;

procedure agregarVehiculo (var arc: TArchivoVehiculos);
var
	aux, regArc: TVehiculo;
begin
	leerVehiculo(regArc);
	if (existeVehiculo(arc, regArc.numero_chasis)) then
		writeln('Ya existe este vehiculo')
	else begin
		reset(arc);
		leer(arc, aux);
		if (aux.anio = 0) then
		begin
			Seek(arc, fileSize(arc));
			write(arc, regArc);
		end
		else begin
			Seek(arc, aux.anio * - 1);
			leer(arc, aux);
			Seek(arc, filePos(arc) - 1);
			write(arc, regArc);
			Seek(arc, 0);
			write(arc, aux);
		end;
		close(arc);
	end; 
end;

procedure quitarVehiculo (var arc: TArchivoVehiculos);
var
	aux, regArc: TVehiculo;
	num: str;
begin
	readln(num);
	if (not existeVehiculo(arc, num) then
		writeln('No existe ese vehiculo')
	else begin
		reset(arc);
		leer(arc, aux);
		leer(arc, regArc);
		while (regArc.numero_chasis <> num) do
			leer(arc, regArc);
		Seek(arc, filePos(arc) - 1);
		write(arc, aux);
		aux.anio:= (filePos(arc) - 1) * - 1;
		Seek(arc, 0);
		write(arc, aux);
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
	agregarVehiculo(arc);
	quitarVehiculo(arc);
END.

	{-------------------ENUNCIADO-------------------}
{
 Agregar Vehículo: Implementa una función agregarVehiculo que reciba el archivo y permita al usuario ingresar datos para agregar un nuevo vehículo. Verifica si el 
número de chasis ya existe utilizando la función existeVehiculo (que asumimos ya está implementada). Si el vehículo no existe, agrégalo al archivo reutilizando espacio libre si es necesario.

 Quitar Vehículo: Implementa una función quitarVehiculo que permita al usuario ingresar el número de chasis de un vehículo y eliminarlo del archivo si existe. Utiliza la 
función existeVehiculo para verificar la existencia del vehículo antes de eliminarlo.
}
