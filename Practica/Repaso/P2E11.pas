Program P2E11;
const
	valorAlto = 32000;
type
	str = string[50];
	
	informacion = record
		anio: integer;
		mes: integer;
		dia: integer;
		idUsuario: integer;
		tiempoAcc: real;
	end;
	
	archivo = file of informacion;

	{-------------------PROCESOS-------------------}

procedure leer (var arc: archivo; var info: informacion);
begin
	if (not EOF(arc)) then
		read(arc, info)
	else
		info.anio:= valorAlto;
end;

function existe (var arch: archivo; x: integer):boolean;
var
    dato: informacion;
    aux: boolean;
begin
    leer(arch, dato);
    aux := false;
    while (dato.anio <> valorAlto) or (aux = false) do begin
        if (dato.anio = x) then
            aux := true;
        leer(arch,dato);
    end;
    existe := aux;
end;

procedure recorrido (var arc: archivo);
var
	i: informacion;
	anioBusc, mesAct, diaAct, idAct: integer;
	tieAnio, tieMes, tieDia, tieUsu: real;
begin
	reset(arc);
	readln(anioBusc);
	if (existe(arc, anioBusc)) then
	begin
		Seek(arc, filePos(arc) - 1);
		leer(arc, i);
		tieAnio:= 0;
		while (i.anio = anioBusc) do
		begin
			mesAct:= i.mes;
			tieMes:= 0;
			while (i.mes = mesAct) do
			begin
				diaAct:= i.dia;
				tieDia:= 0;
				while (i.dia = diaAct) do
				begin
					idAct:= i.idUsuario;
					tieUsu:= 0;
					while (idAct = i.idUsuario) do
					begin
						tieUsu:= tieUsu + i.tiempoAcc;
						leer(arc, i);
					end;
					writeln('idUsuario ', i.idUsuario, ' Tiempo total de acceso en el dia ', i.dia, ' mes ', i.mes);
					writeln(tieUsu);
					tieDia:= tieDia + tieUsu;
				end;
				writeln('Tiempo total acceso dia ', i.dia, ' mes ', i.mes);
				writeln(tieDia);
				tieMes:= tieMes + tieDia;
			end;
			writeln('Total tiempo de acceso mes', i.mes);
			writeln(tieMes);
			tieAnio:= tieAnio + tieMes;
		end;
		writeln('Total tiempo de acceso año', anioBusc);
		writeln(tieAnio);
	end
	else
		writeln('anio no encontrado');
	close(arc);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	arc: archivo;
BEGIN
	recorrido(arc);
END.

	{-------------------ENUNCIADO-------------------}
{
 La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio web de la organización. En dicho servidor, se almacenan en un archivo todos los accesos que se
realizan al sitio. La información que se almacena en el archivo es la siguiente: año, mes, día, idUsuario y tiempo de acceso al sitio de la organización. El archivo se encuentra ordenado
por los siguientes criterios: año, mes, día e idUsuario.
 Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará el año calendario sobre el cual debe realizar el informe. El mismo debe respetar el formato
mostrado a continuación:

Año : ---
	Mes:-- 1
		día:-- 1
			idUsuario 1 Tiempo Total de acceso en el dia 1 mes 1
			--------
			idusuario N Tiempo total de acceso en el dia 1 mes 1
		Tiempo total acceso dia 1 mes 1
	-------------
	día N
			idUsuario 1 Tiempo Total de acceso en el dia N mes 1
			--------
			idusuario N Tiempo total de acceso en el dia N mes 1
		Tiempo total acceso dia N mes 1
	Total tiempo de acceso mes 1
	------
	Mes 12
	día 1
		idUsuario 1 Tiempo Total de acceso en el dia 1 mes 12
		--------
		idusuario N Tiempo total de acceso en el dia 1 mes 12
	  Tiempo total acceso dia 1 mes 12
	-------------
	día N
		idUsuario 1 Tiempo Total de acceso en el dia N mes 12
		--------
		idusuario N Tiempo total de acceso en el dia N mes 12
		
		Tiempo total acceso dia N mes 12
	Total tiempo de acceso mes 12
Total tiempo de acceso año

Se deberá tener en cuenta las siguientes aclaraciones:
● El año sobre el cual realizará el informe de accesos debe leerse desde el teclado.
● El año puede no existir en el archivo, en tal caso, debe informarse en pantalla “año no encontrado”.
● Debe definir las estructuras de datos necesarias.
● El recorrido del archivo debe realizarse una única vez procesando sólo la información necesaria.
}
