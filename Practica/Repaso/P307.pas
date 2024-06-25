Program P307;
const
	valorAlto = 32000;
type
	str = string[50];

	informacion = record
		codigo: longInt;
		nombre: str;
		familia: str;
		descripcion: str;
		zona: str;
	end;
	
	archivo = file of informacion;

	{-------------------PROCESOS-------------------}

procedure leer (var arc: archivo; var i: informacion);
begin
	if (not EOF(arc)) then
		read(arc, i)
	else
		i.codigo:= valorAlto;
end;

procedure bajaLogica (var arc: archivo);
var
	i: informacion;
	cod: longInt;
	encontre: boolean;
begin
	reset(arc);
	readln(cod);
	while (cod <> 500000) do
	begin
		seek(arc, 0);
		encontre:= false;
		leer(arc, i);
		while (i.codigo <> valorAlto) and (not encontre) do
		begin
			if (i.codigo = cod) then
			begin
				encontre:= true;
				i.nombre:= '***';
				seek(arc, filePos(arc) - 1);
				write(arc, i);
			end;
			leer(arc, i);
		end;
		readln(cod);
	end;
	close(arc);
end;

procedure bajaFisica (var arc: archivo);
var
	i: informacion;
	pos: integer;
begin
	reset(arc);
	leer(arc, i);
	while (i.codigo <> valorAlto) do
	begin
		if (i.nombre = '***') then
		begin
			pos:= filePos(arc) - 1;
			seek(arc, fileSize(arc) - 1);
			read(arc, i);
			seek(arc, pos);
			write(arc, i);
			seek(arc, fileSize(arc) - 1);
			truncate(arc);
		end;
		leer(arc, i);
	end;
	close(arc);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arc: archivo;
BEGIN
	bajaLogica(arc);
	bajaFisica(arc);
END.

	{-------------------ENUNCIADO-------------------}
{
 Se cuenta con un archivo que almacena información sobre especies de aves en vía de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice un programa que elimine especies de aves, para ello se recibe por teclado las
especies a eliminar. Deberá realizar todas las declaraciones necesarias, implementar todos los procedimientos que requiera y una alternativa para borrar los registros. Para
ello deberá implementar dos procedimientos, uno que marque los registros a borrar y posteriormente otro procedimiento que compacte el archivo, quitando los registros
marcados. Para quitar los registros se deberá copiar el último registro del archivo en la posición del registro a borrar y luego eliminar del archivo el último registro de forma
tal de evitar registros duplicados.
 
 Nota: Las bajas deben finalizar al recibir el código 500000
}
