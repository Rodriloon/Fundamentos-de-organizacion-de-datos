Program examen4;
const
	valorAlto = 'ZZZZ';
type
	str = string[50];

	dato = record
		nombre_sistema_operativo: str;
		cantidad_instalaciones: integer;
		es_de_codigo_abierto: boolean;
		tipo_licencia: str;
	end;
	
	archivo = file of dato;

	{-------------------PROCESOS-------------------}

procedure leerDato (var d: dato);
var
	opcion: integer;
begin
	readln(d.nombre_sistema_operativo);
	readln(d.cantidad_instalaciones);
	readln(opcion);
	if (opcion = 0) then
		d.es_de_codigo_abierto:= false
	else
		d.es_de_codigo_abierto:= true;
	readln(d.tipo_licencia);
end;

procedure leer (var arc: archivo; var d: dato);
begin
	if (not EOF(arc)) then
		read(arc, d)
	else
		d.nombre_sistema_operativo:= valorAlto;
end;

procedure alta (var arc: archivo; registro: dato);
var
	aux, regArc: dato;
begin
	reset(arc);
	leer(arc, aux);
	if (aux.cantidad_instalaciones = 0) then
		writeln('No hay espacio libre')
	else begin
		seek(arc, (aux.cantidad_instalaciones * - 1));
		leer(arc, aux);
		seek(arc, filePos(arc) - 1);
		write(arc, registro);
		seek(arc, 0);
		write(arc, aux);
	end;
	close(arc);
end;

function existe (var arc: archivo; registro: dato): boolean;
var
	regArc: dato;
	ex: boolean;
begin
	ex:= false;
	reset(arc);
	leer(arc, regArc);
	while (regArc.nombre_sistema_operativo <> valorAlto) and (not ex) do
		if (regArc.nombre_sistema_operativo <> registro.nombre_sistema_operativo) then
			ex:= true;
		leer(arc, regArc);
	close(arc);
	existe:= ex;
end;

procedure baja (var arc: archivo; registro: dato);
var
	aux, regArc: dato;
begin
	if (not existe(arc, registro)) then
		writeln('Flaco lo que ingresaste no existe...')
	else begin
		reset(arc);
		leer(arc, aux);
		leer(arc, regArc);
		while (regArc.nombre_sistema_operativo <> registro.nombre_sistema_operativo) do
			leer(arc, regArc);
		Seek(arc, filePos(arc) - 1);
		write(arc, aux);
		regArc.cantidad_instalaciones:= ((filePos(arc) - 1) * - 1);
		Seek(arc, 0);
		write(arc, regArc);
		close(arc);
	end;
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arc: archivo;
	registro: dato;
	ruta: str;
BEGIN
	readln(ruta);
	Assign(arc, ruta);
	leerDato(registro);
	alta(arc, registro);
	leerDato(registro);
	baja(arc, registro);
END.

	{-------------------ENUNCIADO-------------------}
{
 Suponga que tiene un archivo que contiene información de los sistemas operativos más utilizados en la actualidad. Cada registro contiene los siguientes campos:
nombre_sistema_operativo, cantidad_instalaciones, es_de_codigo_abierto (un sistema operativo puede ser de código abierto o no), tipo_licencia (GPL, BSD, MPL, etc.). Realice
los siguientes procedimientos utilizando el registro cabecera para implementar una lista invertida que permita la reasignación de espacio:

1- Alta de sistema operativo: recibe un registro con información de un sistema operativo y un archivo. Debe dar el alta el registro en el archivo reutilizando espacio
libre en caso de que exista.

2- Baja de sistema operativo: recibe un registro con información de un sistema operativo y un archivo. Debe dar de baja el sistema operativo del archivo, en caso de que exista. De lo
contrario debe informar que el sistema operativo no existe en el archivo. Tenga en cuenta que deberá dejar preparado el archivo para futuras altas con reasignación de espacio.
}
