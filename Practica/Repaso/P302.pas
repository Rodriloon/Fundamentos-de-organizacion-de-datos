Program P302;
const
	valorAlto = 32000;
type
	str = string[50];

	infoArc = record
		numero: integer;
		apeYnom: str;
		email: str;
		telefono: longInt;
		dni: longInt;
	end;
	
	archivo = file of infoArc;

	{-------------------PROCESOS-------------------}

procedure leerInfo (var i: infoArc);
begin
	readln(i.apeYnom);
	if (i.apeYnom <> 'ZZZ') then
	begin
		readln(i.numero);
		readln(i.email);
		readln(i.telefono);
		readln(i.dni);
	end;
end;

procedure cargarArchivo (var arc: archivo);
var
	i: infoArc;
	ruta: str;
begin
	readln(ruta);
	assign(arc, ruta);
	rewrite(arc);
	leerInfo(i);
	while (i.apeYnom <> 'ZZZ') do
	begin
		write(arc, i);
		leerInfo(i);
	end;
	close(arc);
end;

procedure inferiorA1000 (var arc: archivo);
var
	i: infoArc;
begin
	reset(arc);
	while (not EOF(arc)) do
	begin
		read(arc, i);
		if (i.numero < 1000) then
		begin
			i.apeYnom:= '@' + i.apeYnom;
			seek(arc, filePos(arc) - 1);
			write(arc, i);
		end;
	end;
	close(arc);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arc: archivo;
BEGIN
	cargarArchivo(arc);
	inferiorA1000(arc);
END.

	{-------------------ENUNCIADO-------------------}
{
 Definir un programa que genere un archivo con registros de longitud fija conteniendo información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de asistente inferior a 1000.
 
 Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo String a su elección. Ejemplo: ‘@Saldaño’.
}
