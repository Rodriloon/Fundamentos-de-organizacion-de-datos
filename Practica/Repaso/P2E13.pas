Program P2E13;
const
	valorAlto = 'ZZZ';
type
	str = string[50];
	
	info1 = record
		destino: str;
		fecha: char;
		horaSal: char;
		asiDisp: integer;
	end;
	
	info2 = record
		destino: str;
		fecha: char;
		horaSal: char;
		asiComp: integer;
	end;
	
	maestro = file of info1;
	detalle = file of info2;
	
	

	{-------------------PROCESOS-------------------}

procedure leer (var det: detalle; var i2: info2);
begin
	if (not EOF(det)) then
		read(det, i2)
	else
		i2.destino:= valorAlto;
end;

procedure minimo (var det1, det2: detalle; var min: info2);
var
	reg1, reg2: info2;
begin
	reset(det1);
	reset(det2);
	read(det1, reg1);
	read(det2, reg2);
	if (reg1.destino < reg2.destino) then
		leer(det1, min)
	else 
		if ((reg1.destino = reg2.destino) and (reg1.fecha < reg2.fecha)) then
			leer(det1, min)
		else 
			if ((reg1.destino = reg2.destino) and (reg1.fecha = reg2.fecha) and (reg1.horaSal < reg2.horaSal)) then
				leer(det1, min)
			else 
				leer(det2, min);
	close(det2);
	close(det1);
end;

procedure actualizarMaestro (var mae: maestro; var det1, det2: detalle);
var
	regM: info1;
	min: info2;
	venTot, cant: integer;
	destAct: str;
	fecAct, salAct: char;
begin
	reset(mae);
	reset(det1);
	reset(det2);
	read(mae, regM);
	minimo(det1, det2, min);
	readln(cant);
	while (min.destino <> valorAlto) do
	begin
		destAct:= min.destino;
		fecAct:= min.fecha;
		while (min.destino = destAct) and (min.fecha = fecAct) do
		begin
			salAct:= min.horaSal;
			venTot:= 0;
			while (min.horaSal = salAct) do
			begin
				venTot:= venTot + min.asiComp;
				minimo(det1, det2, min);
			end;
			regM.asiDisp:= regM.asiDisp - venTot;
			if (regM.asiDisp < cant) then
				writeln('El vuelo con destino a ', regM.destino, ' el dia ', regM.fecha, ' a las ', regM.horaSal, 'hs. no alcanza la cantidad especificada de asientos disponibles ');
			while ((regM.destino <> destAct) or (regM.fecha <> fecAct)) or (regM.horaSal <> salAct) do
				read(mae, regM);
			seek(mae, filePos(mae) - 1);
			write(mae, regM);
		end;
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
 Una compañía aérea dispone de un archivo maestro donde guarda información sobre sus próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida y la
cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida
y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada
uno del maestro. Se pide realizar los módulos necesarios para:

a. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje sin asiento disponible.
b. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que tengan menos de una cantidad específica de asientos disponibles. La misma debe ser ingresada por teclado.

NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez.
}
