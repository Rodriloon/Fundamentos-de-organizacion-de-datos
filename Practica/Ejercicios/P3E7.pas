Program P3E7;
const
	valoralto = 9999;
type
	str = string[50];

	ave = record
		codigo: integer;
		nombre: str;
		familia: str;
		descripcion: str;
		zona: str;
	end;
	
	archivo = file of ave;

	{-------------------PROCESOS-------------------}

procedure leerAve (var a: ave); 
begin
	readln(a.codigo);
	if (a.codigo <> -1) then
	begin
		readln(a.nombre);
		readln(a.familia);
		readln(a.descripcion);
		readln(a.zona);
	end;
end;

procedure cargarArchivo (var arc: archivo);
var
	a: ave;
begin
	assign (arc, 'P3E7Maestro');
	rewrite(arc);
	leerAve(a);
	while (a.codigo <> -1) do
	begin
		write(arc, a);
		leerAve(a);
	end;
	close(arc);
end;

procedure bajaLogica (var arc: archivo);
var
	a: ave;
	cod: integer;
	ok: boolean;
begin
	reset(arc);
	readln(cod);
	while (cod <> valorAlto) do
	begin
		ok:= false;
		while (not EOF(arc) and (not ok)) do
		begin
			read(arc, a);
			if (a.codigo = cod) then
				ok:= true;
		end;
		if (ok) then
		begin
			writeln('Se elimino la especie con codigo ', cod);
			a.codigo:= -1;
			seek(arc, filePos(arc) - 1);
			write(arc, a);
		end
		else
			writeln('No se encontro la especie con codigo ', cod);
		readln(cod);
	end;
	close(arc);
end;

procedure leer (var arc: archivo; var a: ave);
begin
	if (not EOF(arc)) then
		read(arc, a)
	else
		a.codigo:= valorAlto;
end;

procedure compactarArchivo (var arc: archivo);
var
	a: ave;
	pos: integer;
begin
	reset(arc);
	leer(arc, a);
	while (a.codigo <> valorAlto) do
	begin
		if (a.codigo < 0) then
		begin
			pos:= (filePos(arc) - 1);
			seek(arc, fileSize(arc) - 1);
			read(arc, a);
			if ((filePos(arc) - 1) <> 0) then
				while (a.codigo < 0) do
				begin
					seek(arc, fileSize(arc) - 1);
					truncate(arc);
					seek(arc, fileSize(arc) - 1);
					read(arc, a);
				end;
				seek(arc, pos);
				write(arc, a);
				seek(arc, fileSize(arc) - 1);
				truncate(arc);
				seek(arc, pos);
		end;
		leer(arc, a);
	end;
	close(arc);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arc: archivo;
BEGIN
	cargarArchivo(arc);
    writeln('Archivo original');
    bajaLogica(arc);
    compactarArchivo(arc);
    writeln('Archivo compactado');
END.

{ Se cuenta con un archivo que almacena información sobre especies de aves en vía de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice un programa que elimine especies de aves, para ello se recibe por teclado las
especies a eliminar. Deberá realizar todas las declaraciones necesarias, implementar todos los procedimientos que requiera y una alternativa para borrar los registros. Para
ello deberá implementar dos procedimientos, uno que marque los registros a borrar y posteriormente otro procedimiento que compacte el archivo, quitando los registros
marcados. Para quitar los registros se deberá copiar el último registro del archivo en la posición del registro a borrar y luego eliminar del archivo el último registro de forma tal
de evitar registros duplicados.

 Nota: Las bajas deben finalizar al recibir el código 500000}
