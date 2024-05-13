Program P2E6;
const
	valorAlto = 32000;
type

	sesion = record
        codigo: integer;
        tiempo: real;
        fecha: string;
    end;
	
	maestro = file of sesion;
	detalle = file of sesion;
	
	vecCompu = array [1..5] of sesion;
	vecDetalle = array [1..5] of detalle;

	{-------------------PROCESOS-------------------}

procedure leer (var det: detalle; var ses: sesion);
begin
	if (not EOF(det)) then
		read(det, ses)
	else
		ses.codigo:= valorAlto;
end;

procedure minimo(var vec: vecDetalle; var vecReg: vecCompu; var min: sesion);
var
    i, pos: integer;
begin
    min.codigo:= valoralto;
    min.fecha:= 'ZZZZ';
    for i:= 1 to 5 do
        if (vecReg[i].codigo < min.codigo) or ((vecReg[i].codigo = min.codigo) and (vecReg[i].fecha < min.fecha)) then
            begin
                min:= vecReg[i];
                pos:= i;
            end;
    if(min.codigo <> valoralto) then
        leer(vec[pos], vecReg[pos]);
end;

procedure imprimirMaestro(var mae: maestro);
var
    s: sesion;
begin
    reset(mae);
    while (not eof(mae)) do
        begin
            read(mae, s);
            writeln('Codigo = ', s.codigo, ' Fecha = ', s.fecha, ' Tiempo = ', s.tiempo:0:2);
        end;
    close(mae);
end;

procedure crearUnSoloDetalle(var det: detalle);
var
    carga: text;
    nombre: string;
    s: sesion;
begin
    writeln('Ingrese la ruta del detalle');
    readln(nombre);
    assign(carga, nombre);
    reset(carga);
    writeln('Ingrese un nombre para el archivo detalle');
    readln(nombre);
    assign(det, nombre);
    rewrite(det);
    while(not eof(carga)) do
        begin
            with s do
                begin
                    readln(carga, codigo, tiempo, fecha);
                    write(det, s);
                end;
        end;
    writeln('Archivo binario detalle creado');
    close(det);
    close(carga);
end;

procedure crearDetalles(var vec: vecDetalle);
var
    i: integer;
begin
    for i:= 1 to 5 do
        crearUnSoloDetalle(vec[i]);
end;

procedure crearMaestro(var mae: maestro; var vec: vecDetalle);
var
    min, aux: sesion;
    vecC: vecCompu;
    i: integer;
begin
    //assign(mae, './var/log'); No funciona;
    assign(mae, 'ArcMaestro');
    rewrite(mae);
    for i:= 1 to 5 do
        begin
            reset(vec[i]);
            leer(vec[i], vecC[i]);
        end;
    minimo(vec, vecC, min);
    while(min.codigo <> valoralto) do
        begin
            aux.codigo:= min.codigo;
            while(aux.codigo = min.codigo) do
                begin
                    aux.fecha:= min.fecha;
                    aux.tiempo:= 0;
                    while(aux.codigo = min.codigo) and (aux.fecha = min.fecha) do
                        begin
                            aux.tiempo:= aux.tiempo + min.tiempo;
                            minimo(vec, vecC, min);
                        end;
                    write(mae, aux);
                end;
        end;
    close(mae);
    for i:= 1 to 5 do
        close(vec[i]);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	vec: vecDetalle;
    mae: maestro;
BEGIN
    crearDetalles(vec);
	crearMaestro(mae, vec);
    imprimirMaestro(mae);
END.

{Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos: cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha, tiempo_total_de_sesiones_abiertas.
Notas:
● Cada archivo detalle está ordenado por cod_usuario y fecha.
● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o inclusive, en diferentes máquinas.
● El archivo maestro debe crearse en la siguiente ubicación física: /var/log.}
