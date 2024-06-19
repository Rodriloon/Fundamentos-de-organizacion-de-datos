Program P2E2;
const
	valorAlto = 32000;
type
	str = string[50];
	
	alumno = record
		codigo: integer;
		apellido: str;
		nombre: str;
		materias: integer;
		finales: integer;
	end;
	
	materia = record
		codigo: integer;
		estado: char;
	end;
	
	detalle = file of materia;
	maestro = file of alumno;

	{-------------------PROCESOS-------------------}

procedure leer (var det: detalle; var regD: materia);
begin
	if (not EOF(det)) then
		read(det, regD)
	else
		regD.codigo:= valorAlto;
end;

procedure actualizarMaestro (var mae: maestro; var det: detalle);
var
	regM: alumno;
	regD: materia;
	curs, fina, codigo: integer;
begin
	reset(mae);
	reset(det);
	read(mae, regM);
	leer(det, regD);
	while (regD.codigo <> valorAlto) do
	begin
		codigo:= regD.codigo;
		curs:= 0;
		fina:= 0;
		while (regD.codigo = codigo) do
		begin
			if (regD.estado = '0') then
				curs:= curs + 1
			else
				fina:= fina + 1;
		end;
		while (regM.codigo <> codigo) do
			read(mae, regM);
		regM.finales := regM.finales + fina;
		regM.materias := regM.materias - fina;
		regM.materias := regM.materias + curs;
 		seek(mae, filepos(mae)-1);
  		write(mae, regM);
  		if(not EOF(mae))then 
   			read(mae, regM);
	end;
	close(det);
	close(mae);
end;

procedure exportarATxt (var mae: maestro);
var
	txt: text;
	a: alumno;
begin
	assign(txt, 'alumno.txt');
	rewrite(txt);
	reset(mae);
	while (not EOF(mae)) do
	begin
		read(mae, a);
		if (a.finales > a.materias) then
			writeln(txt, a.codigo, ' ', a.materias, ' ', a.finales, ' ', a.apellido, ' ', a.nombre);
	end;
	close(mae);
	close(txt);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	det: detalle;
	mae: maestro;
BEGIN
	actualizarMaestro(mae, det);
	exportarATxt(mae);
END.

	{-------------------ENUNCIADO-------------------}
{
 Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final). Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un programa con opciones para:

a. Actualizar el archivo maestro de la siguiente manera:
i. Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado, y se decrementa en uno la cantidad de materias sin final aprobado.
ii. Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin final.

b. Listar en un archivo de texto aquellos alumnos que tengan más materias con finales aprobados que materias sin finales aprobados. Teniendo en cuenta que este listado
es un reporte de salida (no se usa con fines de carga), debe informar todos los campos de cada alumno en una sola línea del archivo de texto.

 NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez
}
