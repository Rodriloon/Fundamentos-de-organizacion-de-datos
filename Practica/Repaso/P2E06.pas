Program P2E6;
const
	valorAlto = 32000;
	dimF = 5;
type
	str = string[50];
	rango = 1..dimF;
	
	sesion = record
		codigo: integer;
		fecha: char;
		tiempo: real;
	end;
	
	maestro = file of sesion;
	detalle = file of sesion;
	
	vectorD = array [rango] of detalle;
	vectorR = array [rango] of sesion;

	{-------------------PROCESOS-------------------}

procedure leer (var det: detalle; var regD: sesion);
begin
	if (not EOF(det)) then
		read(det, regD)
	else
		regD.codigo:= valorAlto;
end;

procedure minimo (var vD: vectorD; var vR: vectorR; var min: sesion);
var
	i, pos: integer;
begin
	min.codigo:= valorAlto;
	for i:= 1 to dimF do
	begin
		if (vR[i].codigo <= min.codigo) then
		begin
			min:= vR[i];
			pos:= i;
		end;
	end;
	if (min.codigo <> valorAlto) then
		leer(vD[pos], vR[pos]);
end;

procedure crearMaestro (var mae: maestro; var vD: vectorD);
var
	i: integer;
	regM, min: sesion;
	vR: vectorR;
begin
	assign(mae, '/var/log');
	rewrite(mae);
	for i:= 1 to dimF do
	begin
		reset(vD[i]);
		leer(vD[i], vR[i]);
	end;
	minimo(vD, vR, min);
	while (min.codigo <> valorAlto) do
	begin
		regM.codigo:= min.codigo;
		while (min.codigo = regM.codigo) do
		begin
			regM.fecha:= min.fecha;
			regM.tiempo:= 0;
			while (min.codigo = regM.codigo) and (min.fecha = regM.fecha) do
			begin
				regM.tiempo:= regM.tiempo + min.tiempo;
				minimo(vD, vR, min);
			end;
			write(mae, regM);
		end;
	end;
	for i:= 1 to dimF do
		close(vD[i]);
	close(mae);
end;

	{-------------------PROGRAMA PRINCIPAL-------------------}

var
	mae: maestro;
	vecD: vectorD;
BEGIN
	crearMaestro(mae, vecD);
END.

	{-------------------ENUNCIADO-------------------}
{
 Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos: cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha, tiempo_total_de_sesiones_abiertas.

 Notas:
● Cada archivo detalle está ordenado por cod_usuario y fecha.
● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o inclusive, en diferentes máquinas.
● El archivo maestro debe crearse en la siguiente ubicación física: /var/log.
}
