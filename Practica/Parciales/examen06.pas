Program examen6;
const
	valorAlto = 32000;
type
	str = string[50];

	recordDinos = record
		codigo: integer;
		tipo: str;
		altura: real;
		peso: real;
		descripcion: str;
		zona: str;
	end;
	
	tArchDinos = file of recordDinos;

	{-------------------PROCESOS-------------------}

procedure leer (var arc: tArchDinos; var d: recordDinos);
begin
	if (not EOF(arc)) then
		read(arc, d)
	else
		d.codigo:= valorAlto;
end;

procedure leerDinos (var d: recordDinos);
begin
	readln(d.codigo);
	if (d.codigo <> valorAlto) then
	begin
		readln(d.tipo);
		readln(d.altura);
		readln(d.peso);
		readln(d.descripcion);
		readln(d.zona);
	end;
end;

function existeDinos (var arc: tArchDinos; cod: integer): boolean;
var
	aux: recordDinos;
	existe: boolean;
begin
	existe:= false;
	reset(arc);
	leer(arc, aux);
	while (aux.codigo <> valorAlto) and (not existe) do
	begin
		if (aux.codigo = cod) then
			existe:= true;
		leer(arc, aux);
	end;
	close(arc);
	existeDinos:= existe;
end;

procedure quitarDinosaurios (var arc: tArchDinos);
var
	aux, regArc: recordDinos;
	cod: LongInt;
begin
	readln(cod);
	reset(arc);
	while (cod <> 100000) do
	begin
		if (not existeDinos(arc, cod)) then
			writeln('Que flashas inventandote codigos monstri')
		else begin
			leer(arc, aux);
			leer(arc, regArc);
			while (regArc.codigo <> cod) do
				leer(arc, regArc);
			Seek(arc, filePos(arc) - 1);
			write(arc, aux);
			aux.codigo:= (filePos(arc) - 1) * - 1;
			Seek(arc, 0);
			write(arc, aux);
		end;
	end;
	close(arc);
end;

procedure agregarDinosaurios (var arc: tArchDinos; registro: recordDinos);
var
	aux, regArc: recordDinos;
begin
	if (existeDinos(arc, registro.codigo)) then
		writeln('Ya existe el dino que querese meter capo')
	else begin
		reset(arc);
		leer(arc, aux);
		if (aux.codigo = 0) then
		begin
			seek(arc, fileSize(arc));
			write(arc, registro);
		end
		else begin
			Seek(arc, (aux.codigo * - 1));
			leer(arc, regArc);
			Seek(arc, filePos(arc) - 1);
			write(arc, registro);
			Seek(arc, 0);
			write(arc, regArc);
		end;
		close(arc);
	end;
end;

procedure listarTxt (var arc: tArchDinos);
var
	txt: text;
	regArc: recordDinos;
begin
	assign(arc, 'textoInmundo');
	rewrite(txt);
	reset(arc);
	leer(arc, regArc);
	while (regArc.codigo <> valorAlto) do
	begin
		if (regArc.codigo > 0) then
		begin
			writeln(txt, ' codigo: ', regArc.codigo, ' altura: ', regArc.altura, ' peso: ', regArc.peso, ' tipo: ', regArc.tipo);
			writeln(txt, ' descripcion: ', regArc.descripcion);
			writeln(txt, ' zona: ', regArc.zona);
		end;
	end;
	close(arc);
	close(txt);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arc: tArchDinos;
	ruta: str;
	registro: recordDinos;
BEGIN
	readln(ruta);
	Assign(arc, ruta);
	quitarDinosaurios(arc);
	leerDinos(registro);
	agregarDinosaurios(arc, registro);
END.

	{-------------------ENUNCIADO-------------------}
{
 Se cuenta con un archivo que almacena información sobre los tipos de dinosaurios que habitaron durante la era mesozoica, de cada tipo se almacena: código, tipo de
dinosaurio, altura y peso promedio, descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice un programa que elimine tipos de dinosaurios
que estuvieron en el periodo jurásico de la era mesozoica. Para ello se recibe por teclado los códigos de los tipos a eliminar.

 Las bajas se realizan apilando registros borrados y las altas reutilizando registros borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.

 Dada la estructura planteada en el ejercicio, implemente los siguientes módulos: 
(Abre el archivo y agrega un tipo de dinosaurios, recibido como parámetro manteniendo la política descripta anteriormente)
a. procedure agregarDinosaurios (var a: tArchDinos ; registro: recordDinos);
b. Liste el contenido del archivo en un archivo de texto, omitiendo los tipos de dinosaurios eliminados. Modifique lo que considere necesario para obtener el listado.
}
