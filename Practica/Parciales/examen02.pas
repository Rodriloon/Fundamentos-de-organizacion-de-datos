Program examen2;
const
	valorAlto = 32000;
	dimF = 20;
type
	str = string[50];
	rango = 1..dimF;

	datoMae = record
		codigo: integer;
		nombre: str;
		precio: real;
		stockAct: integer;
		stockMin: integer;
	end;
	
	datoDet = record
		codigo: integer;
		cantidad: integer;
	end;

	maestro = file of datoMae;
	detalle = file of datoDet;
	
	vectorD = array [rango] of detalle;
	vectorR = array [rango] of datoDet;

	{-------------------PROCESOS-------------------}

procedure leer (var det: detalle; var regD: datoDet);
begin
	if (not EOF(det)) then
		read(det, regD)
	else
		regD.codigo:= valorAlto;
end;

procedure minimo (var vecD: vectorD; var vecR: vectorR; var min: datoDet);
var
	i, pos: integer;
begin
	min.codigo:= valorAlto;
	for i:= 1 to dimF do
		if (vecR[i].codigo < min.codigo) then
		begin
			min:= vecR[i];
			pos:= i;
		end;
	if (min.codigo <> valorAlto) then	
		leer(vecD[pos], vec[pos]);
end;

procedure informar (var txt: text; regM: datoMae);
begin
	writeln(txt, aux.codigo, ' Codigo');
	writeln(txt, aux.nombre, ' Nombre');
	writeln(txt, aux.precio:0:2, ' Precio');
	writeln(txt, aux.stockAct, ' Stock actual');
	writeln(txt, aux.stockMin, ' Stock minimo');;
end;

procedure actualizarMaestro (var mae: maestro; var vecD: vectorD);
var
	i, codAct: integer;
	vecR: vectorR;
	regM, aux: datoMae;
	min: datoDet;
	tot: real;
	txt: text;
begin
	Assign(txt, 'montoDiario.txt');
	rewrite(txt);
	reset(mae);
	for i:= 1 to dimF do
	begin
		reset(vecD[i]);
		leer(vecD[i], vecR[i]);
	end;
	
	read(mae, regM);
	aux:= regM;
	minimo(vecD, vecR, min);
	while (min.codigo <> valorAlto) do
	begin
		codAct:= min.codigo;
		tot:= 0;
		while (min.codigo = codAct) do
		begin
			aux.stockAct:= aux.stockAct - min.cantidad;
			tot:= tot + (aux.precio * min.cantidad);
			minimo(vecD, vecR, min);
		end;
		if (tot > 10000) then
			writeln(txt, aux.codigo, ' ', aux.precio, ' ', aux.stockAct, ' ', aux.stockMin, ' ', aux.nombre);
		while (min.codigo <> regM.codigo) do
			read(mae, regM);
		seek(mae, filePos(mae) - 1);
		write(mae, aux);
	end;
	
	for i:= 1 to dimF do
		close(vecD[i]);
	close(mae);
	close(txt);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	mae: maestro;
	vecD: vectorD;
BEGIN
	recibirMaestro(mae)				//Se dispone y se asigna.
	recibirDetalles(vecD)			//Se dispone y se asignan.
	actualizarMaestro(mae, vecD);
END.

	{-------------------ENUNCIADO-------------------}
{
 Una empresa dedicada a la venta de golosinas posee un archivo que contiene informacion sobre los productos que tiene a la venta. De cada
producto se registran los siguientes datos: codigo de producto, nombre comercial, precio de venta, stock actual y stock minimo.
 
 La empresa cuenta con 20 sucursales. Diariamente, se recibe un archivo detalle de cada una de las 20 sucursales de la empresa que indica las
ventas diarias efectuadas por cada sucursal. De cada venta se registra codigo de producto y cantidad vendida. Se debe realizar un procedimiento
que actualice el stock en el archivo maestro con la informacion disponible en los archivos detalles y que ademas informe en un archivo de texto 
aquellos productos cuyo monto total vendido en el dia supere los $10.000. En el archivo de texto a exportar, por cada producto incluido, se deben
informar todos sus datos. Los datos de un producto se deben organizar en el archivo de texto para facilitar el uso eventual del mismo como un archivo de carga.

 El objetivo del ejercicio es escribir el procedimiento solicitado, junto con las estructuras de datos y modulos usados en el mismo.
 
 Notas: 
- Todos los archivos se encuentran ordenados por codigo de producto.
- En un archivo detalles pueden haber 0, 1 o N registros de un producto determinado.
- Cada archivo detalle solo contiene productos que seguro existen en el archivo maestro.
- Los archivos se deben recorrer una sola vez. En el mismo recorrido, se debe realizar la actualizacion del archivo maestro con los archivos detalles, asi 
como la generacion del archivo de texto solicitado.
}
