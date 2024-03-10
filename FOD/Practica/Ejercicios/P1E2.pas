Program P1E2;
type

	archivo = file of integer;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	Ar: archivo;
	fis: String;
	cant, num: integer;
	prom: real;
BEGIN
	cant:= 0;
	prom:= 0;
	readln(fis);
	Assign(Ar, fis);
	Reset(Ar);
	while (not EOF(Ar)) do
	begin
		Read(Ar, num);
		if (num < 1500) then
			cant:= cant + 1;
		prom:= prom + num;
	end;
	if (FileSize(Ar) > 0) then
		prom:= prom / FileSize(Ar);
	writeln('Cantidad de números menores a 1500: ', cant);
    writeln('Promedio de los números ingresados: ', prom);
END.

{ Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados creados en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y
 el promedio de los números ingresados. El nombre del archivo a procesar debe ser proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
 contenido del archivo en pantalla.}
