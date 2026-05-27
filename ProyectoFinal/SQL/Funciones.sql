-- ============================================================
--  Funciones.sql - Funciones solicitadas
--  Esquema: Clinica / Farmacia (PostgreSQL / PL-pgSQL)
-- ============================================================
--  Este archivo contiene las dos funciones pedidas:
--
--  1) reconoceredad(p_idCliente)
--     Recibe el identificador de un cliente y regresa su edad.
--
--  2) calculaganancias(p_nombre_sucursal)
--     Recibe el nombre de una sucursal y calcula sus ganancias
--     durante el anio 2026.
--
--  Nota de carga:
--  Los ejemplos al final de cada funcion estan comentados para
--  que el archivo pueda ejecutarse sin lanzar consultas de prueba.
-- ============================================================


-- ============================================================
--  i. Funcion: reconoceredad
-- ============================================================
--  Objetivo:
--      Calcular la edad actual de un cliente.
--
--  Parametro:
--      p_idCliente INT
--          ID del cliente que se buscara en la tabla CLIENTE.
--
--  Regresa:
--      INT
--          Edad calculada con base en CLIENTE.FechaNacimiento.
--          Si el cliente no existe, o no se encuentra fecha, regresa NULL.
--
--  Desarrollo:
--      1. Busca la FechaNacimiento del cliente.
--      2. Si no se encontro fecha, termina regresando NULL.
--      3. AGE(CURRENT_DATE, fecha) calcula el intervalo de tiempo.
--      4. DATE_PART('year', ...) extrae los anios completos.
--      5. Se convierte el resultado a INT porque DATE_PART regresa DOUBLE.
-- ============================================================
CREATE OR REPLACE FUNCTION reconoceredad(p_idCliente INT)
RETURNS INT
AS $$
DECLARE
    v_fecha_nacimiento DATE;
BEGIN
    -- Obtener la fecha de nacimiento del cliente solicitado.
    SELECT c.FechaNacimiento
      INTO v_fecha_nacimiento
      FROM CLIENTE AS c
     WHERE c.IDCliente = p_idCliente;

    -- Si no hay cliente o la fecha no existe, no se puede calcular edad.
    IF v_fecha_nacimiento IS NULL THEN
        RETURN NULL;
    END IF;

    -- Regresar solo los anios completos de edad.
    RETURN DATE_PART('year', AGE(CURRENT_DATE, v_fecha_nacimiento))::INT;
END;
$$
LANGUAGE plpgsql;

-- Ejemplo de ejecucion:
-- SELECT reconoceredad(200);


-- ============================================================
--  ii. Funcion: calculaganancias
-- ============================================================
--  Objetivo:
--      Calcular las ganancias de una sucursal durante el anio 2026.
--
--  Parametro:
--      p_nombre_sucursal VARCHAR(120)
--          Nombre exacto de la sucursal, tomado de SUCURSAL.Nombre.
--
--  Regresa:
--      NUMERIC(12,2)
--          Suma de:
--          - ventas de medicamentos en tickets del anio 2026;
--          - costos de consultas realizadas en el anio 2026.
--
--  Desarrollo:
--      1. Calcula ganancia por medicamentos:
--         SUCURSAL, TICKET, COMPRAR y MEDICAMENTO.
--         Se multiplica PrecioPublico * Cantidad para respetar
--         cuantas unidades se vendieron en cada ticket.
--
--      2. Calcula ganancia por consultas:
--         SUCURSAL, CLINICA y CONSULTA.
--         Se suma CONSULTA.CostoConsulta.
--
--      3. En ambas consultas se filtra por anio 2026.
--
--      4. COALESCE evita regresar NULL cuando no hay ventas o consultas.
-- ============================================================
CREATE OR REPLACE FUNCTION calculaganancias(p_nombre_sucursal VARCHAR(120))
RETURNS NUMERIC(12,2)
AS $$
DECLARE
    v_ganancia_medicamentos NUMERIC(12,2);
    v_ganancia_consultas    NUMERIC(12,2);
BEGIN
    -- Ganancia por medicamentos vendidos en tickets de la sucursal.
    SELECT COALESCE(SUM(m.PrecioPublico * c.Cantidad), 0)
      INTO v_ganancia_medicamentos
      FROM SUCURSAL AS s
      JOIN TICKET AS t ON t.IDSucursal = s.IDSucursal
      JOIN COMPRAR AS c ON c.IDTicket = t.IDTicket
      JOIN MEDICAMENTO AS m ON m.IDMedicamento = c.IDMedicamento
     WHERE s.Nombre = p_nombre_sucursal
       AND EXTRACT(YEAR FROM t.Fecha) = 2026;

    -- Ganancia por consultas realizadas en clinicas de la sucursal.
    SELECT COALESCE(SUM(con.CostoConsulta), 0)
      INTO v_ganancia_consultas
      FROM SUCURSAL AS s
      JOIN CLINICA AS cl ON cl.IDSucursal = s.IDSucursal
      JOIN CONSULTA AS con ON con.IDClinica = cl.IDClinica
     WHERE s.Nombre = p_nombre_sucursal
       AND EXTRACT(YEAR FROM con.Fecha) = 2026;

    -- Total de ganancias de la sucursal durante 2026.
    RETURN v_ganancia_medicamentos + v_ganancia_consultas;
END;
$$
LANGUAGE plpgsql;

-- Ejemplo de ejecucion para una sucursal especifica:
-- SELECT calculaganancias('Sucursal Los SuperDatos 001');

-- Ejemplo de ejecucion para ver todas las sucursales y sus ganancias:
-- SELECT Nombre, calculaganancias(Nombre)
-- FROM SUCURSAL;
