-- Funcion que recibe el identificador del cliente y regresa su edad.
CREATE OR REPLACE FUNCTION reconoceredad(p_idCliente INT)
RETURNS INT
AS $$
DECLARE
    v_fecha_nacimiento DATE;
BEGIN
    SELECT c.FechaNacimiento
      INTO v_fecha_nacimiento
      FROM CLIENTE AS c
     WHERE c.IDCliente = p_idCliente;

    IF v_fecha_nacimiento IS NULL THEN
        RETURN NULL;
    END IF;

    RETURN DATE_PART('year', AGE(CURRENT_DATE, v_fecha_nacimiento))::INT;
END;
$$
LANGUAGE plpgsql;

-- Ejemplo de ejecucion:
-- SELECT reconoceredad(200);


-- Funcion que recibe la sucursal y calcula sus ganancias durante el anio 2026.
CREATE OR REPLACE FUNCTION calculaganancias(p_nombre_sucursal VARCHAR(120))
RETURNS NUMERIC(12,2)
AS $$
DECLARE
    v_ganancia_medicamentos NUMERIC(12,2);
    v_ganancia_consultas    NUMERIC(12,2);
BEGIN
    SELECT COALESCE(SUM(m.PrecioPublico * c.Cantidad), 0)
      INTO v_ganancia_medicamentos
      FROM SUCURSAL AS s
      JOIN TICKET AS t ON t.IDSucursal = s.IDSucursal
      JOIN COMPRAR AS c ON c.IDTicket = t.IDTicket
      JOIN MEDICAMENTO AS m ON m.IDMedicamento = c.IDMedicamento
     WHERE s.Nombre = p_nombre_sucursal
       AND EXTRACT(YEAR FROM t.Fecha) = 2026;

    SELECT COALESCE(SUM(con.CostoConsulta), 0)
      INTO v_ganancia_consultas
      FROM SUCURSAL AS s
      JOIN CLINICA AS cl ON cl.IDSucursal = s.IDSucursal
      JOIN CONSULTA AS con ON con.IDClinica = cl.IDClinica
     WHERE s.Nombre = p_nombre_sucursal
       AND EXTRACT(YEAR FROM con.Fecha) = 2026;

    RETURN v_ganancia_medicamentos + v_ganancia_consultas;
END;
$$
LANGUAGE plpgsql;

-- Ejemplo de ejecucion para una sucursal especifica:
-- SELECT calculaganancias('Sucursal Los SuperDatos 001');

-- Ejemplo de ejecucion para ver todas las sucursales y sus ganancias:
-- SELECT Nombre, calculaganancias(Nombre)
-- FROM SUCURSAL;
