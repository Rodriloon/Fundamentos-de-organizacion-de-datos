Program P3E6;
type
	str = string[50];

	prendas = record
		cod_prenda: integer;
		descripcion: str;
		colores: str;
		tipo_prenda: str;
		stock: integer;
		precio_unitario: real;
	end;
	
	archivoM = file of prendas;
	
	archivoBajas = file of integer;

	{-------------------PROCESOS-------------------}

procedure cargarArchivoDesdeTxT (var arcM: archivoM);
var
	p: prendas;
	txt: text;
begin
	assign(txt, 'maestro.txt');
	reset(txt);
	assign(arcM, 'P3E6Maestro');
	rewrite(arcM);
	while (not EOF(txt)) do
	begin
		with p do
		begin
			readln(txt, cod_prenda, stock, precio_unitario, descripcion);
			readln(txt, colores);
			readln(txt, tipo_prenda);
			read(arcM, p);
		end;
	end;
	close(arcM);
	close(txt);
end;

procedure cargarDetalleDesdeTxT (var arcB: archivoBajas);
var
	carga: text;
	codigo: integer;
begin
	assign(carga, 'detalle.txt');
    reset(carga);
    assign(arcB, 'P3E6Detalle');
    rewrite(arcB);
    while (not EOF(carga)) do
    begin
		readln(carga, codigo);
		write(arcB, codigo);
    end;
    close(arcB);
    close(carga);
end;

procedure bajaLogica (var arcM: archivoM; var arcB: archivoBajas);
var
	infoDet: integer;
	infoMae: prendas;
begin
	reset(arcM);
	reset(arcB);
	while (not EOF(arcB)) do
	begin
		read(arcB, infoDet);
		seek(arcM, 0);
		read(arcM, infoMae);
		while (infoDet <> infoMae.cod_prenda) do
			read(arcM, infoMae);
		seek(arcM, filePos(arcM) - 1);
		infoMae.stock:= -1;
		write(arcM, infoMae);
	end;
	close(arcB);
	close(arcM);
end;

procedure imprimirMaestro(var arcM: archivoM);
var
    infoMae: prendas;
begin
    reset(arcM);
    while(not eof(arcM)) do
        begin
            read(arcM, infoMae);
            writeln('Codigo=', infoMae.cod_prenda, ' Desc=', infoMae.descripcion, ' Stock=', infoMae.stock, ' Precio=', infoMae.precio_unitario:0:2);
        end;
    close(arcM);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arcM1, arcM2: archivoM;
	arcB: archivoBajas;
BEGIN
	cargarArchivoDesdeTxT(arcM1);
    cargarDetalleDesdeTxT(arcB);
    writeln('Se realizan las bajas');
    bajaLogica(arcM1, arcB);
    imprimirMaestro(arcM2);
END.

{ Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con la información correspondiente a las prendas que se encuentran a la venta. De cada
prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las
prendas a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las prendas que quedarán obsoletas. Deberá implementar un procedimiento que reciba
ambos archivos y realice la baja lógica de las prendas, para ello deberá modificar el stock de la prenda correspondiente a valor negativo.
 Adicionalmente, deberá implementar otro procedimiento que se encargue de efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la
información de las prendas a la venta. Para ello se deberá utilizar una estructura auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente aquellas prendas
que no están marcadas como borradas. Al finalizar este proceso de compactación del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro original.}
