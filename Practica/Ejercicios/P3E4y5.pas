Program P3E4y5;
type

	reg_flor = record
		codigo:integer;
		nombre: String[45];
	end;
	
	tArchFlores = file of reg_flor;

	{-------------------PROCESOS-------------------}

procedure leerFlor (var f: reg_flor);
begin
	readln(f.codigo);
	if (f.codigo <> -1) then
		readln(f.nombre);
end;

procedure cargarArchivo (var arc: tArchFlores);

	procedure primera (var arc: tArchFlores; var f: reg_flor);
	begin
		f.codigo:= 0;
		f.nombre:= 'Cabecera';
		write(arc, f);
	end;

var
	f: reg_flor;
begin
	rewrite(arc);
	primera(arc, f);
	leerFlor(f);
	while (f.codigo <> -1) do
	begin
		Write(arc, f);
		leerFlor(f);
	end;
	close(arc);
end;

procedure agregarFlor (var a: tArchFlores; nombre: string; codigo:integer);
var
	f, cabecera: reg_flor;
begin
	reset(a);
	read(a, cabecera);
	f.nombre:= nombre;
	f.codigo:= codigo;
	if (cabecera.codigo = 0) then
	begin
		seek(a, filesize(a));
		write(a, f);
	end
	else begin
		seek(a, cabecera.codigo * -1);
		read(a, cabecera);
		seek(a, filePos(a) - 1);
		write(a, f);
		seek(a, 0);
		write(a, cabecera);
	end;
	close(a);
end;

procedure eliminarFlor (var arc: tArchFlores; flor: reg_flor);
var
	f, cabecera: reg_flor;
    ok: boolean;
begin
	ok:= false;
    reset(arc);
    read(arc, cabecera);
    while(not eof(arc) and (not ok)) do
        begin
            read(arc, f);
            if(f.codigo = flor.codigo) then
                begin
                    ok:= true;
                    seek(arc, filepos(arc)-1);
                    write(arc, cabecera);
                    cabecera.codigo:= (filepos(arc)-1) * -1;
                    seek(arc, 0);
                    write(arc, cabecera);
                end;
        end;
    close(arc);
    if(ok) then
        writeln('Se elimino la novela con codigo ', flor.codigo)
    else
        writeln('No se encontro la novela con codigo ', flor.codigo);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arc: tArchFlores;
	f: reg_flor;
	cod: integer;
	fis, nom: string;
BEGIN
	readln(fis);
	Assign(arc, fis);
	reset(arc);
	cargarArchivo(arc);
	readln(nom);
	readln(cod);
	agregarFlor(arc, nom, cod);
	leerFlor(f);
	eliminarFlor(arc, f);
END.

{4) 
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
