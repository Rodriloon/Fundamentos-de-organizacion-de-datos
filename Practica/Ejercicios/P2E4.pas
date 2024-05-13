Program P2E4;
const
	valorAlto = 'ZZZ';
type

	alfab = record
		nombreProv: string[30];
		personasAlf: integer;
		total: integer;
	end;
	
	censo = record
		nombreProv: string[30];
		codigo: integer;
		personasAlf: integer;
		total: integer;
	end;

	maestro = file of alfab;
	detalle = file of censo;

	{-------------------PROCESOS-------------------}
	
procedure leer (var det: detalle; var rdet: censo);
begin
	if (not EOF(det)) then
		read(det, rdet)
	else
		rdet.nombreProv:= valorAlto;
end;

procedure minimo (var min: censo; var rdet1: censo; var rdet2: censo; var det1: detalle; var det2: detalle);
begin
	if (rdet1.nombreProv <= rdet2.nombreProv) then 
	begin
		min:= rdet1;
		leer(det1, rdet1);
	end
	else begin 
		min:= rdet2;
		leer(det2, rdet2);
	end;
end;

procedure actualizar (var mae: maestro; var det1: detalle; var det2: detalle);
var
	rmae: alfab;
	rdet1, rdet2, min: censo;
	prov: string[30];
begin
	reset(mae);
	reset(det1);
	reset(det2);
	leer(det1, rdet1);
	leer(det2, rdet2);
	minimo(min, rdet1, rdet2, det1, det2);
	while (min.nombreProv <> valorAlto) do
	begin
		read(mae, rmae);
		while (rmae.nombreProv <> valorAlto) do
			read(mae, rmae);
		prov:= rmae.nombreProv;
		while (min.nombreProv <> valorAlto) and (prov = min.nombreProv) do
		begin
			rmae.personasAlf:= rmae.personasAlf + min.personasAlf; 
			rmae.total:= rmae.total + min.total;
			minimo(min, rdet1, rdet2, det1, det2);
		end;
		seek(mae, filePos(mae)-1);
		write(mae, rmae);
	end;
	close(det2);
	close(det1);
	close(mae);
end;

procedure menu (var mae: maestro; var det1, det2: detalle);

	procedure cargarArchivoMaestro (var mae: maestro);
	var
		alf: alfab;
	begin	
		with alf do begin
			rewrite(mae);
			write('NOMBRE: '); readln(nombreProv);
			while (nombreProv <> '') do begin
				write('ALFABETIZADOS: '); readln(personasAlf);
				write('ENCUESTADOS: '); readln(total);
				write(mae, alf);
				writeln();
				write('NOMBRE: '); readln(nombreProv);
			end;
			close(mae);
		end;
	end;

	procedure cargarDetalle1 (var det1: detalle);
	var	
		cen: censo;
	begin
		with cen do begin
			rewrite(det1);
			write('NOMBRE: '); readln(nombreProv);
			while (nombreProv <> '') do begin
				write('CODIGO LOCALIDAD: '); readln(codigo);
				write('ALFABETIZADOS: '); readln(personasAlf);
				write('ENCUESTADOS: '); readln(total);
				write(det1,cen);
				writeln();
				write('NOMBRE: '); readln(nombreProv);
			end;
			close(det1);
		end;
	end;
	
	procedure cargarDetalle2 (var det2: detalle);
	var	
		cen: censo;
	begin
		with cen do begin
			rewrite(det2);
			write('NOMBRE: '); readln(nombreProv);
			while (nombreProv <> '') do begin
				write('CODIGO LOCALIDAD: '); readln(codigo);
				write('ALFABETIZADOS: '); readln(personasAlf);
				write('ENCUESTADOS: '); readln(total);
				write(det2,cen);
				writeln();
				write('NOMBRE: '); readln(nombreProv);
			end;
			close(det2);
		end;
	end;
	
	procedure mostrarOpciones (var op: integer);
	begin
		writeln('1 - Cargar maestro ');
		writeln('2 - Cargar detalle1 ');
		writeln('3 - Cargar detalle2 ');
		writeln('4 - Imprimir maestro ');
		writeln('5 - Imprimir detalle1 ');
		writeln('6 - Imprimir detalle2 ');
		writeln('7 - Actualizar maestro ');
		writeln('0 - Finalizar');
		write('OPCION ELEGIDA-------> '); readln(op);
	end;
	
	procedure imprimirMaestro (var mae: maestro);
	var
		alf: alfab;
	begin
		reset(mae);
		with alf do begin
			while (not EOF(mae)) do begin
				read(mae,alf);
				writeln('NOMBRE: ', nombreProv);
				writeln('ALFABETIZADOS: ', personasAlf);
				writeln('ENCUESTADOS: ', total);
				writeln();
			end;
		end;
		close(mae);
	end;
	
	procedure imprimirDetalle1 (var det1: detalle);
	var
		cen: censo;
	begin
		reset(det1);
		with cen do begin
			while (not EOF(det1)) do begin
				read(det1,cen);
				writeln('CODIGO: ', codigo);
				writeln('NOMBRE: ', nombreProv);
				writeln('ALFABETIZADOS: ', personasAlf);
				writeln('ENCUESTADOS: ', total);
				writeln();
			end;
		end;
		close(det1);
	end;
	
	procedure imprimirDetalle2 (var det2: detalle);
	var
		cen: censo;
	begin
		reset(det2);
		with cen do begin
			while (not EOF(det2)) do begin
				read(det2, cen);
				writeln('CODIGO: ', codigo);
				writeln('NOMBRE: ', nombreProv);
				writeln('ALFABETIZADOS: ', personasAlf);
				writeln('ENCUESTADOS: ', total);
				writeln();
			end;
		end;
		close(det2);
	end;
	
var
	op: integer;
begin
	mostrarOpciones(op);
	while (op <> 0) do begin
		case op of
			1: cargarArchivoMaestro(mae);
			2: cargarDetalle1(det1);
			3: cargarDetalle2(det2);
			4: imprimirMaestro(mae);
			5: imprimirDetalle1(det1);
			6: imprimirDetalle2(det2);
			7: actualizar(mae, det1, det2);
			else writeln('Opcion incorrecta!');
		end;
		mostrarOpciones(op);
	end;	
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	mae: maestro;
	det1, det2: detalle;
BEGIN
	assign(det1, 'detalle1P2E4');
	assign(det2, 'detalle2P2E4');
	assign(mae, 'maestroP2E4');
	menu(mae, det1, det2);
END.

{A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.

NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle pueden venir 0, 1 ó más registros por cada provincia.}
