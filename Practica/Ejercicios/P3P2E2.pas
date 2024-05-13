Program P3P2E2;
const
	valoralto = 9999;
type
	str = string[50];
	
	localidad = record
        codigo: integer;
        mesa: integer;
        cant: integer;
    end;
    
    archivo = file of localidad;

	{-------------------PROCESOS-------------------}

procedure corteDeControl (var arc: archivo; var arcAux: archivo; var cantTotal: integer);
var
	loc, aux: localidad;
	ok: boolean;
begin
	reset(arc);
    assign(arcAux, 'ArchivoAuxiliar');
    rewrite(arcAux);
    cantTotal:= 0;
	while (not EOF(arc)) do
	begin
		read(arc, loc);
		ok:= false;
		seek(arcAux, 0);
		while (not EOF(arcAux) and (not ok)) do
		begin
			read(arcAux, aux);
			if (aux.codigo = loc.codigo) then
				ok:= true;
		end;
		if (ok) then
		begin
			aux.cant:= aux.cant + l.cant;
            seek(arcAux, filepos(arcAux)-1);
            write(arcAux, aux);
		end
		else
			write(arcAux, loc);
		cantTotal:= cantTotal + loc.cant;
	end;
    close(arcAux);
    close(arc);
end;

procedure cargarArchivo(var arc: archivo);
var
    txt: text;
    loc: localidad;
begin
    assign(txt, 'archivo.txt');
    reset(txt);
    assign(arc, 'ArchivoMaestro');
    rewrite(arc);
    while(not eof(txt)) do
        begin
            with loc do
                begin
                    readln(txt, codigo, mesa, cant);
                    write(arc, loc);
                end;
        end;
    writeln('Archivo maestro generado');
    close(arc);
    close(txt);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arc, arcAux: archivo;
    cantTotal: integer;
BEGIN
	cargarArchivo(arc);
    corteDeControl(arc, arcAux, cantTotal);
END.

	{-------------------ENUNCIADO-------------------}
{
 Se necesita contabilizar los votos de las diferentes mesas electorales registradas por localidad en la provincia de Buenos Aires. Para ello, se posee un archivo con la
siguiente información: código de localidad, número de mesa y cantidad de votos en dicha mesa. Presentar en pantalla un listado como se muestra a continuación:

	Código de Localidad 				Total de Votos
	...................					..............
	...................					..............
	Total General de Votos: 			..............

 NOTAS:
● La información en el archivo no está ordenada por ningún criterio.
● Trate de resolver el problema sin modificar el contenido del archivo dado.
● Puede utilizar una estructura auxiliar, como por ejemplo otro archivo, para llevar el control de las localidades que han sido procesadas.
}

