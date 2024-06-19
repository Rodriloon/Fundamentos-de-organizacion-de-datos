Program P2E4;
const
	valorAlto = 'ZZZ';
type
	str = string[50];
	
	alfab = record
		nombreProv: str;
		cantAlf: longInt;
		cantTot: longInt;
	end;
	
	agencia = record
		nombreProv: str;
		codigo: integer;
		cantAlf: longInt;
		cantTot: longInt;
	end;
	
	maestro = file of alfab;
	detalle = file of agencia;

	{-------------------PROCESOS-------------------}

procedure leer (var det: detalle; var regD: agencia);
begin
	if (not EOF(det)) then
		read(det, regD)
	else
		regD.nombreProv:= valorAlto;
end;

procedure minimo (var det1, det2: detalle; var regD1, regD2, min: agencia);
begin
	if (regD1.nombreProv <= regD2.nombreProv) then
	begin
		min:= regD1;
		leer(det1, regD1);
	end
	else begin
		min:= regD2;
		leer(det2, regD2);
	end;
end;

procedure actualizarMaestro (var mae: maestro; var det1, det2: detalle);
var
	regM: alfab;
	regD1, regD2, min: agencia;
begin
	reset(mae);
	reset(det1);
	reset(det2);
	leer(det1, regD1);
	leer(det2, regD2);
	minimo(det1, det2, regD1, regD2, min);
	while (min.nombreProv <> valorAlto) do
	begin
		read(mae, regM);
		while (regM.nombreProv <> min.nombreProv) do
			read(mae, regM);
		while (regM.nombreProv = min.nombreProv) do
		begin
			regM.cantAlf:= regM.cantAlf + min.cantAlf;
			regM.cantTot:= regM.cantTot + min.cantTot;
			minimo(det1, det2, regD1, regD2, min);
		end;
		seek(mae, filePos(mae) - 1);
		write(mae, regM);
	end;
	close(det2);
	close(det1);
	close(mae);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	mae: maestro;
	det1, det2: detalle;
BEGIN
	actualizarMaestro(mae, det1, det2);
END.

	{-------------------ENUNCIADO-------------------}
{
A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.

NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle pueden venir 0, 1 ó más registros por cada provincia.
}
