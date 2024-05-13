Program P3E3;
type
	rango = -1..4;
	str = string[50];
	
	novela = record
		codigo: integer;
		genero: str;
		nombre: str;
		duracion: real;
		director: str;
		precio: real;
	end;
	
	archivo = file of novela;

	{-------------------PROCESOS-------------------}

procedure leerNovela (var n: novela);
begin
	readln(n.codigo);
	if (n.codigo <> -999) then
	begin
		readln(n.genero);
		readln(n.nombre);
		readln(n.duracion);
		readln(n.director);
		readln(n.precio);
	end;
end;

procedure cargarArchivo (var arc: archivo);
	
	procedure primera (var arc: archivo; var n: novela);
	begin
		n.codigo:= 0;
		n.genero:= '';
		n.nombre:= '';
		n.duracion:= 0;
		n.director:= '';
		n.precio:= 0;
		write(arc, n);
	end;

var
	n: novela;
begin
	rewrite(arc);
	primera(arc, n);
	leerNovela(n);
	while (n.codigo <> -999) do
	begin
		write(arc, n);
		leerNovela(n);
	end;
	close(arc);
end;

procedure altaNovela (var arc: archivo);
var
	n, aux: novela;
begin
	reset(arc);
	read(arc, aux);
	leerNovela(n);
	if (aux.codigo = 0) then
	begin
		seek(arc, filesize(arc));
		write(arc, n);
	end
	else begin
		seek(arc, aux.codigo * -1);
		read(arc, aux);
		seek(arc, filePos(arc) - 1);
		write(arc, n);
		seek(arc, 0);
		write(arc, aux);
	end;
	close(arc);
end;

procedure modificarNovela (var arc: archivo);

	procedure modNov (var n: novela);
	var
		opcion: char;
	begin
		writeln('MENU DE NOVELAS');
		writeln('Opcion A: Modificar la novela entera (el codigo no puede ser modificado)');
		writeln('Opcion B: Modificar el genero de la novela');
		writeln('Opcion C: Modificar el nombre de la novela');
		writeln('Opcion D: Modificar la duracion de la novela');
		writeln('Opcion E: Modificar el director de la novela');
		writeln('Opcion F: Modificar el precio de la novela');
		readln(opcion);
		case opcion of
			'A': 
				begin
					writeln('Ingrese el genero de la novela');
					readln(n.genero);
					writeln('Ingrese el nombre de la novela');
					readln(n.nombre);
					writeln('Ingrese la duracion de la novela');
					readln(n.duracion);
					writeln('Ingrese el director de la novela');
					readln(n.director);
					writeln('Ingrese el precio de la novela');
					readln(n.precio);
				end;
			'B': 
				begin
					writeln('Ingrese el genero de la novela');
					readln(n.genero);
				end;
			'C':
				begin
					writeln('Ingrese el nombre de la novela');
					readln(n.nombre);
				end;
			'D':
				begin
					writeln('Ingrese la duracion de la novela');
					readln(n.duracion);
				end;
			'E':
				begin
					writeln('Ingrese el director de la novela');
					readln(n.director);
				end;
			'F':
				begin
					writeln('Ingrese el precio de la novela');
					readln(n.precio);
				end;
		else
			writeln('Opcion invalida');
		end;
	end;

var
	n: novela;
	cod: integer;
	ok: boolean;
begin
	ok:= false;
	reset(arc);
	readln(cod);
	while (not EOF(arc) and (not ok)) do
	begin
		read(arc, n);
		if (n.codigo = cod) then
		begin
			ok:= true;
			modNov(n);
			seek(arc, filePos(arc) - 1);
			write(arc, n);
		end;
	end;
	if(ok) then
        writeln('Se modifico la novela con codigo ', cod)
    else
        writeln('No se encontro la novela con codigo ', cod);
    close(arc);
end;

procedure bajaNovela (var arc: archivo);
var
	n, aux: novela;
	cod: integer;
	ok: boolean;
begin
	ok:= false;
	reset(arc);
	writeln('Ingrese el codigo de novela a eliminar');
    readln(cod);
    read(arc, aux);
    while (not EOF(arc) and (not ok)) do
    begin
		read(arc, n);
		if (n.codigo = cod) then
		begin
			ok:= true;
			seek(arc, filePos(arc) -1);
			write(arc, aux);
			aux.codigo:= (filePos(arc) - 1) * -1;
			seek(arc, 0);
			write(arc, aux);
		end;
    end;
    close(arc);
    if(ok) then
        writeln('Se elimino la novela con codigo ', cod)
    else
        writeln('No se encontro la novela con codigo ', cod);
end;

procedure pasarTxT (var arc: archivo);
var
	txt: text;
	n: novela;
begin
	reset(arc);
	seek(arc, 1);
	assign(txt, 'novelas.txt');
	rewrite(txt);
	while (not EOF(arc)) do
	begin
		read(arc, n);
		if (n.codigo < 1) then
			write(txt, 'Novela eliminada');
		write(txt, ' Codigo = ', n.codigo, ' Genero = ', n.genero, ' Nombre = ', n.nombre, ' Duracion = ', n.duracion:0:2, ' Director = ', n.director, ' Precio = ', n.precio:0:2);
	end;
	writeln('Archivo de texto creado');
    close(txt);
    close(arc);
end;

procedure menu (var arc: archivo);
var
	num: rango;
begin
	writeln('Ingrese -1 para terminar el programa');
	writeln('Ingrese ');
	readln(num);
	while (num <> -1) do
	begin
		case num of
			0: cargarArchivo(arc);
			1: altaNovela(arc);
			2: modificarNovela(arc);
			3: bajaNovela(arc);
			4: pasarTxT(arc);
		end;
		writeln;
		writeln('Operación completada. Ingrese otra opción:');
		readln(num);
	end;
	writeln('Termino el programa.');
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arc: archivo;
	fis: str;
BEGIN
	readln(fis);
	Assign(arc, fis);
	reset(arc);
	menu(arc);
END.

{ Realizar un programa que genere un archivo de novelas filmadas durante el presente año. De cada novela se registra: código, género, nombre, duración, director y precio.
 El programa debe presentar un menú con las siguientes opciones:
 
 a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se utiliza la técnica de lista invertida para recuperar espacio libre en el
archivo. Para ello, durante la creación del archivo, en el primer registro del mismo se debe almacenar la cabecera de la lista. Es decir un registro
ficticio, inicializando con el valor cero (0) el campo correspondiente al código de novela, el cual indica que no hay espacio libre dentro del
archivo.

 b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el inciso a., se utiliza lista invertida para recuperación de espacio. En
particular, para el campo de ´enlace´ de la lista, se debe especificar los números de registro referenciados con signo negativo, (utilice el código de
novela como enlace).Una vez abierto el archivo, brindar operaciones para:
  i. Dar de alta una novela leyendo la información desde teclado. Para esta operación, en caso de ser posible, deberá recuperarse el
	espacio libre. Es decir, si en el campo correspondiente al código de novela del registro cabecera hay un valor negativo, por ejemplo -5,
	se debe leer el registro en la posición 5, copiarlo en la posición 0 (actualizar la lista de espacio libre) y grabar el nuevo registro en la
	posición 5. Con el valor 0 (cero) en el registro cabecera se indica que no hay espacio libre.
  ii. Modificar los datos de una novela leyendo la información desde teclado. El código de novela no puede ser modificado.
  iii. Eliminar una novela cuyo código es ingresado por teclado. Por ejemplo, si se da de baja un registro en la posición 8, en el campo
	código de novela del registro cabecera deberá figurar -8, y en el registro en la posición 8 debe copiarse el antiguo registro cabecera.
 
 c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.

NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser proporcionado por el usuario.}
