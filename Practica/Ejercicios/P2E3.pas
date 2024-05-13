Program P2E3;
type

	producto = record
		codigo: integer;
		nombre: string;
		precio: real;
		stockAct: integer;
		stockMin: integer;
	end;
	
	venta = record
		codigo: integer;
		cantUni: integer;
	end;
	
	maestro = file of producto;
	detalle = file of venta;

	{-------------------PROCESOS-------------------}

procedure actualizar (var mae: maestro; var det: detalle);
var
	prod: producto;
	ven: venta;
	codAct: integer;
	total: integer;
begin
	reset(mae);
	reset(det);
	while (not EOF(det)) do
	begin
		read(mae, prod);
		read(det, ven);
		while (not EOF(mae) and (prod.codigo <> ven.codigo)) do
            read(mae, prod);
        if (not EOF(mae)) then
        begin
            codAct:= ven.codigo;
            total:= 0;
            while (not EOF(det) and (ven.codigo = codAct)) do
            begin
                total:= total + ven.cantUni;
                read(det, ven);
            end;
            prod.stockAct:= prod.stockAct - total;
            seek(mae, filepos(mae) - 1);
            write(mae, prod);
        end;
	end;
	close(det);
	close(mae);
end;

procedure crearTxt (var mae: maestro; var arc: text);
var
	prod: producto;
begin
	reset(mae);
	rewrite(arc);
	while (not EOF(mae)) do
	begin
		read(mae, prod);
		if (prod.stockAct < prod.stockMin) then
			writeln(arc, prod.codigo,' ',prod.nombre,' ',prod.precio:0:2,' ',prod.stockAct,' ',prod.stockMin);
	end;
	close(arc);
	close(mae);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	mae: maestro;
	det: detalle;
	arc: text;
BEGIN
	actualizar(mae, det);
	crearTxt(mae, arc);
END.

{ El encargado de ventas de un negocio de productos de limpieza desea administrar el stock de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
realizar un programa con opciones para:

a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del archivo detalle.
● El archivo detalle sólo contiene registros que están en el archivo maestro.

b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo stock actual esté por debajo del stock mínimo permitido.}
