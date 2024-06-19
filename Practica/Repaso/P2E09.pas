Program P2E9;
const
	valorAlto = 32000;
type
	str = string[50];
	
	voto = record
		codProv: integer;
		codLoc: integer;
		numMesa: integer;
		cantVotosMesa: integer;
	end;
	
	archivo = file of voto;

	{-------------------PROCESOS-------------------}

procedure leer (var arc: archivo; var v: voto);
begin
	if (not EOF(arc)) then
		read(arc, v)
	else
		v.codProv:= valorAlto;
end;

procedure procesar (var arc: archivo);
var
	v: voto;
	total, totProv, totLoc, codProv, codLoc: integer;
begin
	reset(arc);
	total:= 0;
	leer(arc, v);
	while (v.codProv <> valorAlto) do
	begin
		totProv:= 0;
		codProv:= v.codProv;
		while (v.codProv = codProv) do
		begin
			totLoc:= 0;
			codLoc:= v.codLoc;
			while (v.codProv = codProv) and (v.codLoc = codLoc) do
			begin
				totLoc:= totLoc + v.cantVotosMesa;
				leer(arc, v);
			end;
			totProv:= totProv + totLoc;
		end;
		total:= total + totProv;
	end;
	writeln('Total general de votos: ', total);
	close(arc);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arc: archivo;
BEGIN
	procesar(arc);
END.

	{-------------------ENUNCIADO-------------------}
{
Se necesita contabilizar los votos de las diferentes mesas electorales registradas por provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa. 
Presentar en pantalla un listado como se muestra a continuación:

				Código de Provincia

				Código de Localidad					Total de Votos
				................... 				..............
				...................					..............

				Total de Votos Provincia: ____
				Código de Provincia

				Código de Localidad					Total de Votos
				................... 				..............

				Total de Votos Provincia: ___
				..................................................

				Total General de Votos: ___

NOTA: La información está ordenada por código de provincia y código de localidad.
}
