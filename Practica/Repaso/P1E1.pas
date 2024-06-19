Program P1E1;
const
	valoralto = 30000;
type
	str = string[50];
	
	archivo = file of integer; 

	{-------------------PROCESOS-------------------}

procedure crearArchivo (var arc: archivo);
var
	num: integer;
	nom_fis: string;
begin
	readln(nom_fis);
	assign(arc, nom_fis);
	rewrite(arc);
	readln(num);
	while (num <> valorAlto) do
	begin
		write(arc, num);
		readln(num);
	end;
	close(arc);
end;

procedure imprimir (var arc: archivo);
var
	num: integer;
begin
	reset(arc);
	if (not EOF(arc)) then
		writeln('Imprimiendo: ');
	while (not EOF(arc)) do
	begin
		read(arc, num);
		writeln(num);
	end;
	close(arc);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arc: archivo;
BEGIN
	crearArchivo(arc);
	imprimir(arc);
END.

	{-------------------ENUNCIADO-------------------}
{
Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita incorporar datos al archivo. Los números son ingresados desde teclado. La carga finaliza
cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del archivo debe ser proporcionado por el usuario desde teclado.
}
