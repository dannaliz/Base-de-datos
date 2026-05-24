create or replace function reconoceredad(p_idCliente INT)
returns INT
as $$
declare
	fecha_hoy DATE;
	fechaNacimiento DATE;
	edad INT;

begin
	fecha_hoy  := CURRENT_DATE;
	select c.fechaNacimiento
	into fechaNacimiento
	from Cliente as c
	where c.idcliente = p_idcliente;
	edad := DATE_PART('year', AGE(fecha_hoy, fechaNacimiento));
	return edad;
	
end;
$$ 
language plpgsql;

select reconoceredad(200);

create or replace function calculaganancias(s_Nombre VARCHAR(120))
returns numeric(12,2)
as $$
declare 
	ganancia_medicamentos numeric(12,2);
	ganancia_consultas numeric(12,2);

begin
	select coalesce(sum(m.PrecioPublico),0) --Esto lo hice para no tener problema en caso de haber nulls
	into ganancia_medicamentos
	from Sucursal as s
	inner join Ticket as t on t.idSucursal = s.idSucursal
	inner join Comprar as c on c.idTicket = t.idTicket
	inner join Medicamento as m on m.idMedicamento = c.idMedicamento
	where s.Nombre = s_Nombre;

	select coalesce(sum(con.CostoConsulta),0) --Esto lo hice para no tener problema en caso de haber nulls
	into ganancia_consultas
	from Sucursal as s
	inner join Clinica as cl on cl.idSucursal = s.idSucursal
	inner join Consulta as con on con.idClinica = cl.idClinica
	where s.Nombre = s_Nombre
    and extract(year from con.Fecha) = 2026;

	return ganancia_medicamentos + ganancia_consultas;
	
end;
$$
language plpgsql;

SELECT Nombre, calculaganancias(Nombre) --Esto para poder ver todas las sucursales y sus ganancias.
FROM Sucursal;

