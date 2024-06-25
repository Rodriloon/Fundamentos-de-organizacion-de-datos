Program P306;
const
	valorAlto = 32000;
type
	str = string[50];

	infoMae = record
		cod_prenda: integer;
		descripcion: str;
		colores: str;
		tipo_prenda: str;
		stock: integer;
		precio_unitario: real;
	end;

	infoDet = record
		cod_prenda: integer;
	end;

	maestro = file of infoMae;
	detalle = file of infoDet;

	{-------------------PROCESOS-------------------}

procedure leer(var det: detalle; var regD: infoDet);
begin
	if (not EOF(det)) then
		read(det, regD)
	else
		regD.cod_prenda:= valorAlto;
end; 

procedure bajaLogica (var mae: maestro; var det: detalle);
var
	regM: infoMae;
	regD: infoDet;
begin
	reset(mae);
	reset(det);
	regM.cod_prenda:= 0;
	leer(det, regD);
	while (regD.cod_prenda <> valorAlto) do
	begin
		seek(mae, 0);
		while (regD.cod_prenda <> regM.cod_prenda) do
			read(mae, regM);
		regM.stock:= regM.stock * - 1;
		seek(mae, filePos(mae) - 1);
		write(mae, regM);
	end;
	close(det);
	close(mae);
end;

procedure nuevoMaestro (var mae, mae2: maestro);
var
	regM: infoMae;
	ruta: str;
begin
	readln(ruta);
	assign(mae2, ruta);
	reset(mae);
	rewrite(mae2);
	while (not EOF(mae)) do
	begin
		read(mae, regM);
		if (regM.cod_prenda >= 0) then
			write(mae2, regM);
	end;
	close(mae2);
	close(mae);
	erase(mae);								// DESASIGNADO DE RUTA	
	rename(mae2, 'maestro.dat');			// RENOMBRADO DE RUTA
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	mae, mae2: maestro;
	det: detalle;
BEGIN
	bajaLogica(mae, det);
	nuevoMaestro(mae, mae2);
END.

	{-------------------ENUNCIADO-------------------}
{
 Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con la información correspondiente a las prendas que se encuentran a la venta. De cada
prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las
prendas a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las prendas que quedarán obsoletas. Deberá implementar un procedimiento que reciba
ambos archivos y realice la baja lógica de las prendas, para ello deberá modificar el stock de la prenda correspondiente a valor negativo.
 Adicionalmente, deberá implementar otro procedimiento que se encargue de efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la
información de las prendas a la venta. Para ello se deberá utilizar una estructura auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente aquellas prendas
que no están marcadas como borradas. Al finalizar este proceso de compactación del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro original.
}
