Program P2E7;
const
	valorAlto = 32000;
	dimF = 10;
type
	str = string[50];
	rango = 1..dimF;
	
	municipio = record
		codigoLoc: integer;
		localidad: str;
		codigoCepa: integer;
		cepa: str;
		casosActivos: longInt;
		casosNuevos: longInt;
		recuperados: longInt;
		fallecidos: longInt;
	end;
	
	diario = record
		codigoLoc: integer;
		codigoCepa: integer;
		casosActivos: longInt;
		casosNuevos: longInt;
		recuperados: longInt;
		fallecidos: longInt;
	end;

	maestro = file of municipio;
	detalle = file of diario;
	
	vectorD = array [rango] of detalle;
	vectorR = array [rango] of diario;

	{-------------------PROCESOS-------------------}

procedure leer (var det: detalle; var regD: diario);
begin
	if (not EOF(det)) then
		read(det, regD)
	else
		regD.codigoLoc:= valorAlto;
end;

procedure minimo (var vD: vectorD; var vR: vectorR; var min: diario);
var
	i, pos: integer;
begin
	min.codigoLoc:= valorAlto;
	for i:= 1 to dimF do
	begin
		if (vR[i].codigoLoc < min.codigoLoc) then
		begin
			min:= vR[i];
			pos:= i;
		end;
	end;
	if (min.codigoLoc <> valorAlto) then
		read(vD[pos], vR[pos]);
end;

procedure actualizarMaestro (var mae: maestro; var vD: vectorD);
var
	i: integer;
	codigoLoc, codigoCepa, cantCasosLocalidad, cant: integer;
	vR: vectorR;
	regM: municipio;
	min: diario;
begin
	cant:= 0;
	reset(mae);
	for i:= 1 to dimF do
	begin
		rewrite(vD[i]);
		leer(vD[i], vR[i]);
	end;
	read(mae, regM);
	minimo(vD, vR, min);
	while (min.codigoLoc <> valorAlto) do
	begin
		codigoLoc:= min.codigoLoc;
		cantCasosLocalidad:= 0;
		while (min.codigoLoc = codigoLoc) do
		begin
			codigoCepa:= min.codigoCepa;
			while (min.codigoLoc = codigoLoc) and (min.codigoCepa = codigoCepa) do
			begin
				regM.fallecidos:= regM.fallecidos + min.fallecidos;
				regM.recuperados:= regM.recuperados + min.recuperados;
				regM.casosActivos:= min.casosActivos;
				regM.casosNuevos:= min.casosNuevos;
				cantCasosLocalidad:= cantCasosLocalidad + min.casosActivos;
				minimo(vD, vR, min);
			end;
			while (regM.codigoLoc <> codigoLoc) do
				read(mae, regM);
			seek(mae, filePos(mae) - 1);
			write(mae, regM);
		end;
		if (cantCasosLocalidad > 50) then
			cant:= cant + 1;
	end;
	writeln('La cantidad de localidades con mas de 50 casos es ', cant);
	for i:= 1 to dimF do
		close(vD[i]);
	close(mae);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	mae: maestro;
	vecD: vectorD;
BEGIN
	actualizarMaestro(mae, vecD);
END.

	{-------------------ENUNCIADO-------------------}
{
Se desea modelar la información necesaria para un sistema de recuentos de casos de covid para el ministerio de salud de la provincia de buenos aires.
 Diariamente se reciben archivos provenientes de los distintos municipios, la información contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad de
casos activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos fallecidos.
 El ministerio cuenta con un archivo maestro con la siguiente información: código localidad, nombre localidad, código cepa, nombre cepa, cantidad de casos activos, cantidad de casos
nuevos, cantidad de recuperados y cantidad de fallecidos. Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de localidad y código de cepa.

 Para la actualización se debe proceder de la siguiente manera:
1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2. Idem anterior para los recuperados.
3. Los casos activos se actualizan con el valor recibido en el detalle.
4. Idem anterior para los casos nuevos hallados.

 Realice las declaraciones necesarias, el programa principal y los procedimientos que requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).
}
