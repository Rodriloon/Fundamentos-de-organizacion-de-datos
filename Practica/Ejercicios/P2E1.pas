Program P2E1;
const

	valorAlto = 32000;
	
type

	ingresos = record
		codigo: integer;
		nombre: string[30];
		monto: real;
	end;
	
	archivo = file of ingresos;
	archivoCompac = file of ingresos;

	{-------------------PROCESOS-------------------}

procedure compactar (var A, AC: archivo);

	procedure leer (var A: archivo; var ing: ingresos);
	begin
		if (not EOF(A)) then
			read(A, ing)
		else
			ing.codigo:= valorAlto;
	end;

var
	ing: ingresos;
	codAct: integer;
	total: real;
begin
	reset(A);
	assign(AC, 'CompactadisimoXD');
	rewrite(AC);
	leer(A, ing);
	while (ing.codigo <> valorAlto) do
	begin
		codAct:= ing.codigo;
		total:= 0;
		while (codAct <> valorAlto) and (codAct = ing.codigo) do
		begin
			total:= total + ing.monto;
			leer(A, ing);
		end;
		ing.monto:= total;
		write(AC, ing);
	end;
	close(AC);
	close(A);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arc: archivo;
	arcCompac: archivoCompac;
BEGIN
	compactar(arc, arcCompac);
END.

{ Una empresa posee un archivo con información de los ingresos percibidos por diferentes empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.

 Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.

 NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser recorrido una única vez.}
