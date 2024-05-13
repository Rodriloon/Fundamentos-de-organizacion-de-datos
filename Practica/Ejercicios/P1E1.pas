Program P1E1;
type

	archivo = file of integer;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	Ar: archivo;
	aux: integer;
	fis: String;
BEGIN
	readln(fis);
	Assign(Ar, fis);
	Rewrite(Ar);
	readln(aux);
	while (aux <> 30000) do
	begin
		Write(Ar, aux);
		readln(aux);
	end;
	Close(Ar);
END.

{ Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita incorporar datos al archivo. Los números son ingresados desde teclado. El nombre del
 archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando se ingrese el número 30000, que no debe incorporarse al archivo.}
