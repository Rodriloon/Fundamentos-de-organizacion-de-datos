Program P304y05;
const
	valorAlto = 32000;
type
	str = string[50];

	reg_flor = record
		nombre: String[45];
		codigo:integer;
	end;
	
	tArchFlores = file of reg_flor;

	{-------------------PROCESOS-------------------}

procedure leerFlor (var f: reg_flor);
begin
	readln(f.codigo);
	if (f.codigo <> valorAlto) then
		readln(f.nombre);
end;

procedure cabecera (var arc: tArchFlores);
var
	f: reg_flor;
begin
	f.codigo:= 0;
	f.nombre:= 'Cabecera';
	write(arc, f);
end;

procedure cargarArchivo (var arc: tArchFlores);
var
	f: reg_flor;
	ruta: str;
begin
	readln(ruta);
	assign(arc, ruta);
	rewrite(arc);
	cabecera(arc);
	leerFlor(f);
	while (f.codigo <> valorAlto) do
	begin
		write(arc, f);
		leerFlor(f);
	end;
	close(arc);
end;

procedure eliminarFlor (var arc: tArchFlores);
var
	f, aux: reg_flor;
	cod: integer;
	ok: boolean;
begin
	reset(arc);
	ok:= false;
	readln(cod);
	read(arc, aux);
	while (not EOF(arc)) and (not ok) do
	begin
		read(arc, f);
		if (f.codigo = cod) then
		begin
			ok:= true;
			seek(arc, filePos(arc) - 1);
			write(arc, aux);
			aux.codigo:= (filePos(arc) - 1) * - 1;
			seek(arc, 0);
			write(arc, aux);
		end;
	end;
	close(arc);
end;

procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);
var
	f, aux: reg_flor;
begin
	reset(a);
	read(a, aux);
	f.nombre:= nombre;
	f.codigo:= codigo;
	if (aux.codigo = 0) then
	begin
		seek(a, filePos(a));
		write(a, f);
	end
	else begin
		seek(a, (aux.codigo * - 1));
		read(a, aux);
		seek(a, filePos(a) - 1);
		write(a, f);
		seek(a, 0);
		 write(a, aux);
	end;
	close(a);
end;

procedure imprimirArchivo (var arc: tArchFlores);
var
	f: reg_flor;
begin
	reset(arc);
	f.codigo:= 0;
	seek(arc, 1);
	while (not EOF(arc)) do
	begin
		read(arc, f);
		if (f.codigo <= 0) then
			writeln('Espacio disponible')
		else
			writeln('Codigo ', f.codigo, ' Nombre ', f.nombre);
	end;
	close(arc);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	tArc: tArchFlores;
	nombre: string;
	codigo: integer;
BEGIN
	cargarArchivo(tArc);
	eliminarFlor(tArc);
	readln(nombre);
	readln(codigo);
	agregarFlor(tArc, nombre, codigo);
	imprimirArchivo(tArc);
END.

	{-------------------ENUNCIADO-------------------}
{
4) 
Dada la siguiente estructura:

 type
	reg_flor = record
		nombre: String[45];
		codigo:integer;
	end;
	
	tArchFlores = file of reg_flor;

 Las bajas se realizan apilando registros borrados y las altas reutilizando registros borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
 
 a. Implemente el siguiente módulo:

(Abre el archivo y agrega una flor, recibida como parámetro manteniendo la política descrita anteriormente)
	procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);

 b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que considere necesario para obtener el listado.

5)
Dada la estructura planteada en el ejercicio anterior, implemente el siguiente módulo:
(Abre el archivo y elimina la flor recibida como parámetro manteniendo la política descripta anteriormente)
	procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);
}
