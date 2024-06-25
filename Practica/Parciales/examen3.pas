Program examen3;
const
	valorAlto = 32000;
	dimF = 5;
type
	str = string[50];
	rango = 1..dimF;
	
	datoMae = record
		codigo: integer;
		nombre: str;
		descripcion: str;
		stock: integer;
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
		if (vecR[i].codigo < valorAlto) then
		begin
			min:= vecR[i];
			pos:= i;
		end;
	if (min.codigo <> valorAlto) then
		read(vecD[pos], vecR[pos]);
end;

procedure actualizarMaestro (var mae: maestro; var vecD: vectorD);
var
	i, codAct: integer;
	vecR: vectorR;
	regM: datoMae;
	min: datoDet;
begin
	reset(mae);
	for i:= 1 to dimF do
	begin
		reset(vecD[i]);
		read(vecD[i], vecR[i]);
	end;
	minimo(vecD, vecR, min);
	read(mae, regM);
	while (min.codigo <> valorAlto) do
	begin
		while (min.codigo <> regM.codigo) do
			read(mae, regM);
		codAct:= min.codigo;
		while (min.codigo = codAct) do
		begin
			regM.stock:= regM.stock - min.cantidad;
			minimo(vecD, vecR, min);
		end;
		seek(arc, filePos(arc) - 1);
		write(arc, regM);
	end;
	for i:= 1 to dimF do
		close(vecD[i]);
	close(mae);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	mae: maestro;
	vecD: vectorD;
BEGIN
	recibirMaestro(mae)						//Se dispone y se asigna.
	recibirDetalles(vecD)					//Se dispone y se asignan.
	actualizarMaestro(mae, vecD);
END.

	{-------------------ENUNCIADO-------------------}
{
 Una editorial de diarios y revistas distribuye y vende sus productos (diarios y revistas) al interior del país. La editorial cuenta con 5 
distribuidoras. Cada distribuidora envía un listado con los productos vendidos indicando: código de producto y cantidad vendida del mismo.

 La editorial posee un archivo maestro en donde almacena la información de todos los diarios y revistas que distribuye, para ello el archivo
maestro cuenta con el código de producto, nombre, descripción y el stock actual de cada producto.

 Escriba el programa principal con la declaración de los tipos de datos necesarios y realice un proceso que reciba los 5 detalles y actualice
el archivo maestro con la información proveniente de los archivos de detalle.

 Tanto el maestro como los detalles se encuentran ordenados por el código de producto. No se realizan ventas de ejemplares sin stock.

Nota: la solución planteada debe ser escalable en cuanto a la cantidad de detalles.
}
