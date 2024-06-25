Program P2E14;
const
	valorAlto = 32000;
	dimF = 10;
type
	str = string[50];
	rango = 1..dimF;
	
	informacion = record
		codProv: integer;
		nomProv: str;
		codLoc: integer;
		nomLoc: str;
		sinLuz: integer;
		sinGas: integer;
		chapa: integer;
		sinAgua: integer;
		sinSanit: integer;
	end;
	
	info2 = record
		codProv: integer;
		codLoc: integer;
		conLuz: integer;
		construidas: integer;
		conAgua: integer;
		conGas: integer;
		sanitarios: integer;
	end;
	
	maestro = file of informacion;
	detalle = file of info2;
	
	vectorD = array [rango] of detalle;
	vectorR = array [rango] of info2;

	{-------------------PROCESOS-------------------}

procedure leer (var det: detalle; var i: info2);
begin
	if (not EOF(det)) then
		read(det, i)
	else
		i.codProv:= valorAlto;
end;

procedure minimo (var vecD: vectorD; var vecR: vectorR; var min: info2);
var
	i, pos: integer;
begin
	min.codProv:= valorAlto;
	for i:= 1 to dimF do
	begin
		if (vecR[i].codProv < min.codProv) or ((vecR[i].codProv = min.codProv) and (vecR[i].codLoc < min.codLoc)) then
		begin
			pos:= i;
			min:= vecR[i];
		end;
	end;
	leer(vecD[pos], vecR[pos]);
end;

procedure actualizarMaestro (var arc: maestro; var vecD: vectorD);
var
	vecR: vectorR;
	regM, aux: informacion;
	min: info2;
	i: integer;
	provAct, locAct, sinChapa: integer;
	cumple: boolean;
	ruta: str;
begin
	reset(arc);
	sinChapa:= 0;
	for i:= 1 to dimF do
	begin
		readln(ruta);
		assign(vecD[i], ruta);
		reset(vecD[i]);
		leer(vecD[i], vecR[i]);
	end;
	minimo(vecD, vecR, min);
	read(arc, regM);
	aux:= regM;
	while (min.codProv <> valorAlto) do
	begin
		provAct:= min.codProv;
		while (min.codProv = provAct) do
		begin
			locAct:= min.codLoc;
			while (min.codLoc = locAct) do
			begin
				aux.sinLuz:= aux.sinLuz - min.conLuz;
				aux.sinAgua:= aux.sinAgua - min.conAgua;
				aux.chapa:= aux.chapa - min.construidas;
				aux.sinGas:= aux.sinGas - min.conGas;
				aux.sinSanit:= aux.sinSanit - min.sanitarios;
				minimo(vecD, vecR, min);
			end;
			while (regM.codProv <> provAct) and (regM.codLoc <> locAct) do
			begin
				read(arc, regM);
				cumple:= false;
				if (regM.chapa = 0) and (not cumple) then
				begin
					sinChapa:= sinChapa + 1;
					cumple:= true;
				end;
			end;
			seek(arc, filePos(arc) - 1);
			write(arc, aux);
			if (aux.chapa = 0) and (not cumple) then
				sinChapa:= sinChapa + 1;
		end;
	end;
	writeln('La cantidad de localidades sin viviendas de chapa son: ', sinChapa);
	for i:= 1 to dimF do
		close(vecD[i]);
	close(arc);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arc: maestro;
	vec: vectorD;
BEGIN
	actualizarMaestro(arc, vec);
END.

	{-------------------ENUNCIADO-------------------}
{
 Se desea modelar la información de una ONG dedicada a la asistencia de personas con carencias habitacionales. La ONG cuenta con un archivo maestro conteniendo información
como se indica a continuación: Código pcia, nombre provincia, código de localidad, nombre de localidad, #viviendas sin luz, #viviendas sin gas, #viviendas de chapa, #viviendas sin
agua, # viviendas sin sanitarios.

 Mensualmente reciben detalles de las diferentes provincias indicando avances en las obras de ayuda en la edificación y equipamientos de viviendas en cada provincia. La información
de los detalles es la siguiente: Código pcia, código localidad, #viviendas con luz, #viviendas construidas, #viviendas con agua, #viviendas con gas, #entrega sanitarios.

 Se debe realizar el procedimiento que permita actualizar el maestro con los detalles recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
provincia y código de localidad.

 Para la actualización del archivo maestro, se debe proceder de la siguiente manera:
● Al valor de viviendas sin luz se le resta el valor recibido en el detalle.
● Idem para viviendas sin agua, sin gas y sin sanitarios.
● A las viviendas de chapa se le resta el valor recibido de viviendas construidas

 La misma combinación de provincia y localidad aparecen a lo sumo una única vez.

 Realice las declaraciones necesarias, el programa principal y los procedimientos que requiera para la actualización solicitada e informe cantidad de localidades sin viviendas de
chapa (las localidades pueden o no haber sido actualizadas).
}
