Program P2E3;
const
	valorAlto = 32000;
type
	str = string[50];
	
	producto = record
		codigo: integer;
		precio: real;
		stockAct: integer;
		stockMin: integer;
		nombre: str;
	end;
	
	venta = record
		codigo: integer;
		cantidad: integer;
	end;
	
	maestro = file of producto;
	detalle = file of venta;

	{-------------------PROCESOS-------------------}

procedure leer (var det: detalle; var regD: venta);
begin
	if (not EOF(det)) then
		read(det, regD)
	else
		regD.codigo:= valorAlto;
end;

procedure actualizarMaestro (var mae: maestro; var det: detalle);
var
	regM: producto;
	regD: venta;
	cod, cantT: integer;
begin
	reset(mae);
	reset(det);
	read(mae, regM);
	leer(det, regD);
	while (regD.codigo <> valorAlto) do
	begin
		cod:= regD.codigo;
		cantT:= 0;
		while (regD.codigo = cod) do
		begin
			cantT:= cantT + regD.cantidad;
			leer(det, regD);
		end;
		while (regM.codigo <> cod) do
			read(mae, regM);
		regM.stockAct:= regM.stockAct - cantT;
		seek(mae, filePos(mae) - 1);
		write(mae, regM);
		if (not EOF(mae)) then
			read(mae, regM);
	end;
	close(det);
	close(mae);
end;

procedure exportarATxt (var mae: maestro);
var
	txt: text;
	p: producto;
begin
	assign(txt, 'stock_minimo.txt');
	rewrite(txt);
	reset(mae);
	while (not EOF(mae)) do
	begin
		read(mae, p);
		if (p.stockAct < p.stockMin) then
			writeln(txt, p.codigo, ' ', p.precio:0:2, ' ', p.stockAct, ' ', p.stockMin, ' ', p.nombre);
	end;
	close(mae);
	close(txt);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	mae: maestro;
	det: detalle;
BEGIN
	actualizarMaestro(mae, det);
	exportarATxt(mae);
END.

	{-------------------ENUNCIADO-------------------}
{
 El encargado de ventas de un negocio de productos de limpieza desea administrar el stock de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
realizar un programa con opciones para:

a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del archivo detalle.
● El archivo detalle sólo contiene registros que están en el archivo maestro.

b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo stock actual esté por debajo del stock mínimo permitido.
}
