Program P1E2;
const
	valoralto = 30000;
type
	str = string[50];
	
	archivo = file of integer;

	{-------------------PROCESOS-------------------}

procedure imprimir (var arc: archivo);
var
	aux, cant, cantM: integer;
	promedio: real;
begin
	cant:= 0;
	cantM:= 0;
	promedio:= 0;
	reset(arc);
	while (not EOF(arc)) do
	begin
		cant:= cant + 1;
		read(arc, aux);
		promedio:= promedio + aux;
		if (aux < 1500) then
			cantM:= cantM + 1;
		writeln(aux);
	end;
	close(arc);
	writeln('La cantidad de numeros menos a 1500 son: ', cantM);
	writeln('El promedio de los numeros ingresados es: ', promedio / cant :0:2);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arc: archivo;
	nom_fis: string;
BEGIN
	readln(nom_fis);
	Assign(arc, nom_fis);
	imprimir(arc);
END.

	{-------------------ENUNCIADO-------------------}
{
 Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados creado en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
promedio de los números ingresados. El nombre del archivo a procesar debe ser proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.
}

