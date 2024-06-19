Program P2E8;
const
	valorAlto = 32000;
type
	str = string[50];
	rangoM = 1..12;
	rangoD = 1..31;
	
	venta = record
		codigo: integer;
		nombre: str;
		apellido: str;
		anio: integer;
		mes: rangoM;
		dia: rangoD;
		monto: real;
	end;
	
	dato = record
		codigo: integer;
		nombre: str;
		apellido: str;
		anio: integer;
		mes: rangoM;
	end;
	
	maestro = file of venta;

	{-------------------PROCESOS-------------------}

procedure leer (var mae: maestro; var regM: venta);
begin
	if (not EOF(mae)) then
		read(mae, regM)
	else
		regM.codigo:= valorAlto;
end;

procedure procesar (var mae: maestro);
var
	regM: venta;
	dat: dato;
	totalM, totalA, totalEmp: real;
begin
	reset(mae);
	leer(mae, regM);
	totalEmp:= 0;
	while (regM.codigo <> valorAlto) do
	begin
		dat.codigo:= regM.codigo;
		while (regM.codigo = dat.codigo) do
		begin
			dat.anio:= regM.anio;
			totalA:= 0;
			while (regM.codigo = dat.codigo) and (regM.anio = dat.anio) do
			begin
				dat.mes:= regM.mes;
				totalM:= 0;
				while (regM.codigo = dat.codigo) and (regM.anio = dat.anio) and (regM.mes = dat.mes) do
				begin
					totalM:= totalM + regM.monto;
					leer(mae, regM);
				end;
				if (totalM <> 0) then
					totalA:= totalA + totalM;
			end;
		end;
		writeln('Total gastado en el anio = ', totalA:0:2);
		totalEmp:= totalEmp + totalA;
	end;
	writeln('Monto total de ventas obtenido por la empresa ', totalEmp:0:2);
	close(mae);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	mae: maestro;
BEGIN
	procesar(mae);
END.

	{-------------------ENUNCIADO-------------------}
{
 Se cuenta con un archivo que posee información de las ventas que realiza una empresa a los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
cliente. Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido por la empresa.
 El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año, mes, día y monto de la venta. El orden del archivo está dado por: cod cliente, año y mes.

 Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron compras. No es necesario que informe tales meses en el reporte.
}

