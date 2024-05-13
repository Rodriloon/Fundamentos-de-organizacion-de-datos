Program P3P2E1;
const
	valoralto = 9999;
type
	str = string[50];
	
	producto = record
		codigo: integer;
		nombre: str;
		precio: real;
		stockAct: integer;
		stockMin: integer;
	end;
	
	venta = record
		codigo: integer;
		cantidad: integer;
	end;
	
	archivoM = file of producto;
	archivoD = file of venta;

	{-------------------PROCESOS-------------------}

procedure actualizarMaestro (var mae: archivoM; var det: archivoD);
var
	prod: producto;
	ven: venta;
	cantAct: integer;
begin
	reset(mae);
	reset(det);
	while (not EOF(mae)) do
	begin
		read(mae, prod);
		cantAct:= 0;
		while (not EOF(det)) do
		begin
			read(det, ven);
			if (ven.codigo = prod.codigo) then
				cantAct:= cantAct + ven.cantidad;
		end;
		seek(det, 0);
		if (cantAct > 0) then
		begin
			prod.stockAct:= prod.stockAct - cantAct;
			seek(mae, filePos(mae) - 1);
			write(mae, prod);
		end;
	end;
	reset(det);
	reset(mae);
end;

procedure cargarMaestro (var mae: archivoM; var carga: text);
var
	nombre: string;
	prod: producto;
begin
	reset(carga);
	nombre:= 'P3P2E1Maestro';
	assign(mae, nombre);
	rewrite(mae);
	while (not EOF(carga)) do
	begin
		with prod do
		begin
			readln(carga, codigo, precio, stockAct, stockMin, nombre);
			write(mae, prod);
		end;
	end;
	close(mae);
	close(carga);
end;

procedure cargarDetalle (var det: archivoD; var carga: text);
var
	nombre: string;
	ven: venta;
begin
	reset(carga);
	nombre:= 'P3P2E1Detalle';
	assign(det, nombre);
	rewrite(det);
	while (not EOF(carga)) do
	begin
		with ven do
		begin
			readln(carga, codigo, cantidad);
			write(det, ven);
		end;
	end;
	close(det);
	close(carga);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arcM: archivoM;
	arcD: archivoD;
	cargaMae, cargaDet: text;
BEGIN
	cargarMaestro(arcM, cargaMae);
	cargarDetalle(arcD, cargaDet);
	actualizarMaestro(arcM, arcD);
END.

	{-------------------ENUNCIADO-------------------}
{
 El encargado de ventas de un negocio de productos de limpieza desea administrar el stock de los productos que vende. Para ello, genera un archivo maestro donde figuran
todos los productos que comercializa. De cada producto se maneja la siguiente información: código de producto, nombre comercial, precio de venta, stock actual y
stock mínimo. Diariamente se genera un archivo detalle donde se registran todas las ventas de productos realizadas. De cada venta se registran: código de producto y
cantidad de unidades vendidas. Resuelve los siguientes puntos:

a. Se pide realizar un procedimiento que actualice el archivo maestro con el archivo detalle, teniendo en cuenta que:
i. Los archivos no están ordenados por ningún criterio.
ii. Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del archivo detalle.

b. ¿Qué cambios realizaría en el procedimiento del punto anterior si se sabe que cada registro del archivo maestro puede ser actualizado por 0 o 1 registro del archivo detalle?
}

