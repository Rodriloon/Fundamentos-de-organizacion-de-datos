Program P2E10;
const
	valorAlto = 32000;
type
	str = string[50];
	rangoC = 1..15;

	empleado = record
		departamento: integer;
		division: integer;
		numero: integer;
		categoria: rangoC;
		cantHoras: integer;
	end;
	
	dato = record
		cat: rangoC;
		monto: real;
	end;
	
	archivo = file of empleado;
	vector = array [rangoC] of real;

	{-------------------PROCESOS-------------------}

procedure importarVector(var v : vector);
var
	txt : text;
	reg : dato;
begin
	assign(txt, 'valores.txt');
	reset(txt);
	while(not eof(txt))do begin
		readln(txt, reg.cat, reg.monto);
		v[reg.cat] := reg.monto;
	end;
	writeln('Vector creado');
	close(txt);
end;

procedure leer (var arc: archivo; var e: empleado);
begin
	if (not EOF(arc)) then
		read(arc, e)
	else
		e.departamento:= valorAlto;
end;

procedure procesar (var arc: archivo; v: vector);
var
	e: empleado;
	departamento, division, numero, totHor, totHorDiv, totHorDep: integer;
	montoT, montoTDiv, montoTDep: real;
begin
	reset(arc);
	leer(arc, e);
	while (e.departamento <> valorAlto) do
	begin
		totHorDep:= 0;
		montoTDep:= 0;
		departamento:= e.departamento;
		while (e.departamento = departamento) do
		begin
			totHorDiv:= 0;
			montoTDiv:= 0;
			division:= e.division;
			while (e.departamento = departamento) and (e.division = division) do
			begin
				totHor:= 0;
				montoT:= 0;
				numero:= e.numero;
				while (e.departamento = departamento) and (e.division = division) and (e.numero = numero) do
				begin
					totHor:= totHor + e.cantHoras;
					leer(arc, e);
				end;
				montoT:= montoT + (v[e.categoria] * totHor);
				writeln('Numero de empleado ', e.numero, ' Total de horas ', totHor, ' Importe a cobrar ', montoT:0:2);
				totHorDiv:= totHorDiv + totHor;
				montoTDiv:= montoTDiv + montoT;
			end;
			writeln('Total horas por division ', totHorDiv, ' Monto total por division ', montoTDiv:0:2);
			totHorDiv:= totHorDiv + totHor;
			montoTDiv:= montoTDiv + montoT;
		end;
		writeln('Total horas por departamento ', totHorDep, 'Monto total por departamento ', montoTDep:0:2);
	end;
	close(arc);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arc: archivo;
	vec: vector;
BEGIN
	importarVector(vec);
	procesar(arc, vec);
END.

	{-------------------ENUNCIADO-------------------}
{
 Se tiene información en un archivo de las horas extras realizadas por los empleados de una empresa en un mes. Para cada empleado se tiene la siguiente información: departamento,
división, número de empleado, categoría y cantidad de horas extras realizadas por el empleado. Se sabe que el archivo se encuentra ordenado por departamento, luego por
división y, por último, por número de empleado. Presentar en pantalla un listado con el siguiente formato:

				Departamento
				División
				Número de Empleado			Total de Hs.			Importe a cobrar
				..................			............			................
				..................			............			................
				Total de horas división: ____
				Monto total por división: ____

				División
				........
				Total horas departamento: ____
				Monto total departamento: ____

 Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía
de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la
posición del valor coincidente con el número de categoría
}
