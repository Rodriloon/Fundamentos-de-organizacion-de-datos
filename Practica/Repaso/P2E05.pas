Program P2E5;
const
	valorAlto = 32000;
	dimF = 30;
type
	str = string[50];
	rango = 1..dimF;
	
	producto = record
		codigo: integer;
		nombre: str;
		descripcion: str;
		stockAct: integer;
		stockMin: integer;
		precio: real;
	end;
	
	venta = record
		codigo: integer;
		cantVen: integer;
	end;
	
	maestro = file of producto;
	detalle = file of venta;
	vectorD = array [rango] of detalle;
	vectorR = array [rango] of venta;

	{-------------------PROCESOS-------------------}

procedure leer (var det: detalle; var regD: venta);
begin
	if (not EOF(det)) then
		read(det, regD)
	else
		regD.codigo:= valorAlto;
end;

procedure minimo (var vD: vectorD; var vR: vectorR; var min: venta);
var
	i, pos: integer;
begin
	min.codigo:= valorAlto;
	for i:= 1 to dimF do
	begin
		if (vR[i].codigo <= min.codigo) then
		begin
			min:= vR[i];
			pos:= i;
		end;	
	end;
	if (min.codigo <> valorAlto) then
		leer(vD[pos], vR[pos]);
end;

procedure actualizarMaestro (var mae: maestro; var vD: vectorD);
var
	min: venta;
	regM: producto;
	vR: vectorR;
	codigo, cant, i: integer;
begin
	reset(mae);
	read(mae, regM);
	for i:= 1 to dimF do
	begin
		reset(vD[i]);
		leer(vD[i], vR[i]);
	end;
	minimo(vD, vR, min);
	while (min.codigo <> valorAlto) do
	begin
		codigo:= min.codigo;
		cant:= 0;
		while (min.codigo = codigo) do
		begin
			cant:= cant + min.cantVen;
			minimo(vD, vR, min);
		end;
		while (regM.codigo <> codigo) do
			read(mae, regM);
		regM.stockAct:= regM.stockAct - cant;
		seek(mae, filePos(mae) - 1);
		write(mae, regM);
	end;
	for i:= 1 to dimF do
		close(vD[i]);
	close(mae);
end;

procedure exportarATxt (var mae: maestro);
var
	txt: text;
	p: producto;
	ruta: str;
begin
	readln(ruta);
	assign(txt, ruta);
	rewrite(txt);
	reset(mae);
	while (not EOF(mae)) do
	begin
		read(mae, p);
		if (p.stockAct < p.stockMin) then
		begin
			writeln(txt, p.stockAct, ' ', p.nombre);
			writeln(txt, p.precio:0:2, ' ', p.descripcion);
		end;
	end;
	close(mae);
	close(txt);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	mae: maestro;
	vecD: vectorD;
BEGIN
	actualizarMaestro(mae, vecD);
	exportarATxt(mae);
END.

	{-------------------ENUNCIADO-------------------}
{
 Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados. De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
 Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por debajo del stock mínimo. Pensar alternativas sobre realizar el informe en el mismo
procedimiento de actualización, o realizarlo en un procedimiento separado (analizar ventajas/desventajas en cada caso).

 Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle puede venir 0 o N registros de un determinado producto.
}
