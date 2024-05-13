Program P2E2;
type

	alumno = record
		codigo: integer;
		apellido: string;
		nombre: string;
		cursadas: integer;
		finales: integer;
	end;
	
	materia = record
		codigo: integer;
		estado: char; 	//1 si aprobo la materia, 0 si aprobo la cursada
	end;

	detalle = file of materia;
	maestro = file of alumno;

	{-------------------PROCESOS-------------------}

procedure actualizar (var mae: maestro; var det: detalle);
var
	alum: alumno;
	mat: materia;
	codAct: integer;
begin
	reset(mae);
	reset(det);
	while (not EOF(det)) do
	begin
		read(mae, alum);
		read(det, mat);
		while (not EOF(mae) and (alum.codigo <> mat.codigo)) do
            read(mae, alum);
        if (not EOF(mae)) then
        begin
            codAct:= mat.codigo;
            while (not EOF(det) and (mat.codigo = codAct)) do
            begin
                if (mat.estado = '0') then
                    alum.cursadas:= alum.cursadas + 1
                else
                begin
                    alum.finales:= alum.finales + 1;
                    alum.cursadas:= alum.cursadas - 1;
                end;
                Seek(mae, FilePos(mae) - 1);
                write(mae, alum);
                read(det, mat);
            end;
        end;
	end;
	close(det);
	close(mae);
end;

procedure crearTxt (var mae: maestro; var arc: text);
var
	alum: alumno;
begin
	reset(mae);
	rewrite(arc);
	while (not EOF(mae)) do
	begin
		read(mae, alum);
		writeln(arc, alum.codigo,' ',alum.apellido,' ',alum.nombre,' ',alum.cursadas,' ',alum.finales);
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

{ Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final). Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un programa con opciones para:

a. Actualizar el archivo maestro de la siguiente manera:
i. Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado, y se decrementa en uno la cantidad de materias sin final aprobado.
ii. Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin final.

b. Listar en un archivo de texto aquellos alumnos que tengan más materias con finales aprobados que materias sin finales aprobados. Teniendo en cuenta que este listado
es un reporte de salida (no se usa con fines de carga), debe informar todos los campos de cada alumno en una sola línea del archivo de texto.

 NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez}
