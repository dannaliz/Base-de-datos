-- SP.sql - Procedimientos almacenados
-- Farmacia De Otro Mundo
-- Este archivo contiene los dos procedimientos solicitados:
-- 1) sp_registrar_farmaceutico(...)
-- Registra un nuevo farmaceutico en PERSONAL y FARMACEUTICO.
-- 2) sp_eliminar_medicamento(p_id_medicamento)
-- Elimina un medicamento y primero elimina sus referencias
-- En tablas relacionadas.
-- Nota:
-- En PostgreSQL los procedimientos se ejecutan con CALL.


-- i. Procedimiento: sp_registrar_farmaceutico
-- Objetivo:
-- Insertar un nuevo integrante del personal y registrarlo
-- tambien como farmaceutico.
-- Parametros:
-- p_nombre, p_apellido_paterno, p_apellido_materno
-- Campos de nombre. No deben aceptar numeros ni simbolos.
-- p_cedula
-- Cedula profesional. El DDL exige longitud de 8 caracteres.
-- p_rfc
-- RFC del personal. El DDL exige longitud de 13 caracteres.
-- p_calle, p_num_ext, p_num_int, p_colonia, p_estado
-- Direccion del farmaceutico.
-- p_salario
-- Salario. Debe ser mayor o igual a 0.
-- p_id_sucursal
-- Sucursal donde trabajara. Debe existir en SUCURSAL.
-- Desarrollo:
-- 1. Elimina la version anterior del procedimiento para evitar
-- conflictos si cambia la firma.
-- 2. Valida que nombres y apellidos no esten vacios.
-- 3. Valida que nombres y apellidos solo tengan letras y espacios.
-- 4. Valida cedula, RFC, salario y sucursal.
-- 5. Bloquea PERSONAL de forma ligera para calcular MAX(IDPersonal)+1
-- sin que otra sesion tome el mismo ID al mismo tiempo.
-- 6. Inserta el registro base en PERSONAL.
-- 7. Inserta el mismo IDPersonal en FARMACEUTICO.

DROP PROCEDURE IF EXISTS sp_registrar_farmaceutico(
    VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR,
    VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR,
    DECIMAL, INT
);

CREATE OR REPLACE PROCEDURE sp_registrar_farmaceutico(
    IN p_nombre           VARCHAR,
    IN p_apellido_paterno VARCHAR,
    IN p_apellido_materno VARCHAR,
    IN p_cedula           VARCHAR,
    IN p_rfc              VARCHAR,
    IN p_calle            VARCHAR,
    IN p_num_ext          VARCHAR,
    IN p_num_int          VARCHAR,
    IN p_colonia          VARCHAR,
    IN p_estado           VARCHAR,
    IN p_salario          DECIMAL,
    IN p_id_sucursal      INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    -- ID que se asignara al nuevo personal.
    v_id_personal INT;

    -- Letras ASCII, vocales acentuadas, enie, dieresis y espacios.
    -- Se usan escapes Unicode para evitar problemas de codificacion.
    c_regex_nombre CONSTANT TEXT := U&'^[A-Za-z\00C1\00C9\00CD\00D3\00DA\00E1\00E9\00ED\00F3\00FA\00D1\00F1\00DC\00FC ]+$';
BEGIN
    -- Validar que los campos obligatorios de nombre no vengan vacios.
    IF p_nombre IS NULL OR TRIM(p_nombre) = '' THEN
        RAISE EXCEPTION 'El nombre no puede estar vacio.';
    END IF;
    IF p_apellido_paterno IS NULL OR TRIM(p_apellido_paterno) = '' THEN
        RAISE EXCEPTION 'El apellido paterno no puede estar vacio.';
    END IF;
    IF p_apellido_materno IS NULL OR TRIM(p_apellido_materno) = '' THEN
        RAISE EXCEPTION 'El apellido materno no puede estar vacio.';
    END IF;

    -- Validar que nombre y apellidos no tengan numeros ni simbolos.
    IF p_nombre !~ c_regex_nombre THEN
        RAISE EXCEPTION
            'El nombre "%" contiene caracteres invalidos. Solo se permiten letras y espacios.',
            p_nombre;
    END IF;
    IF p_apellido_paterno !~ c_regex_nombre THEN
        RAISE EXCEPTION
            'El apellido paterno "%" contiene caracteres invalidos. Solo se permiten letras y espacios.',
            p_apellido_paterno;
    END IF;
    IF p_apellido_materno !~ c_regex_nombre THEN
        RAISE EXCEPTION
            'El apellido materno "%" contiene caracteres invalidos. Solo se permiten letras y espacios.',
            p_apellido_materno;
    END IF;

    -- Validaciones que coinciden con restricciones declaradas en DDL.sql.
    IF p_cedula IS NULL OR CHAR_LENGTH(p_cedula) <> 8 THEN
        RAISE EXCEPTION 'La cedula profesional debe tener exactamente 8 caracteres.';
    END IF;
    IF p_rfc IS NULL OR CHAR_LENGTH(p_rfc) <> 13 THEN
        RAISE EXCEPTION 'El RFC debe tener exactamente 13 caracteres.';
    END IF;
    IF p_salario IS NULL OR p_salario < 0 THEN
        RAISE EXCEPTION 'El salario no puede ser negativo ni NULL.';
    END IF;

    -- Validar la sucursal antes del INSERT para dar un mensaje claro.
    IF NOT EXISTS (SELECT 1 FROM SUCURSAL WHERE IDSucursal = p_id_sucursal) THEN
        RAISE EXCEPTION 'La sucursal con IDSucursal = % no existe.', p_id_sucursal;
    END IF;

    -- Evita carreras al calcular el siguiente IDPersonal con MAX + 1.
    LOCK TABLE PERSONAL IN SHARE ROW EXCLUSIVE MODE;

    -- Calcular el nuevo identificador del personal.
    SELECT COALESCE(MAX(IDPersonal), 0) + 1
      INTO v_id_personal
      FROM PERSONAL;

    -- Insertar primero en PERSONAL porque FARMACEUTICO depende de PERSONAL.
    INSERT INTO PERSONAL (
        IDPersonal, IDSucursal,
        Nombre, ApellidoPaterno, ApellidoMaterno,
        CedulaProfesional, RFC,
        Calle, NumExterior, NumInterior, Colonia, Estado,
        Salario
    )
    VALUES (
        v_id_personal, p_id_sucursal,
        p_nombre, p_apellido_paterno, p_apellido_materno,
        p_cedula, p_rfc,
        p_calle, p_num_ext, p_num_int, p_colonia, p_estado,
        p_salario
    );

    -- Insertar la especializacion del personal como farmaceutico.
    INSERT INTO FARMACEUTICO (IDPersonal)
    VALUES (v_id_personal);

    -- Informar el ID generado al usuario que ejecuto el procedimiento.
    RAISE NOTICE 'Farmaceutico registrado con IDPersonal = %.', v_id_personal;
END;
$$;


-- ii. Procedimiento: sp_eliminar_medicamento
-- Objetivo:
-- Eliminar un producto/medicamento a partir de su ID.
-- Parametro:
-- p_id_medicamento INT
-- Identificador del medicamento que se eliminara.
-- Desarrollo:
-- 1. Verifica que el medicamento exista.
-- 2. Borra referencias en tablas que apuntan a MEDICAMENTO.
-- 3. Borra el registro principal de MEDICAMENTO.
-- 4. Usa RAISE NOTICE para mostrar cuantas filas se borraron
-- en cada tabla relacionada.
-- Motivo del orden:
-- El DDL usa llaves foraneas con restricciones. Por eso primero
-- se eliminan las filas hijas y al final el medicamento.

DROP PROCEDURE IF EXISTS sp_eliminar_medicamento(INT);

CREATE OR REPLACE PROCEDURE sp_eliminar_medicamento(
    IN p_id_medicamento INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    -- Indica si existe el medicamento antes de intentar eliminarlo.
    v_existe BOOLEAN;

    -- Guarda el numero de filas afectadas por cada DELETE.
    v_filas_borradas INT;
BEGIN
    -- Confirmar que el medicamento existe.
    SELECT EXISTS (
        SELECT 1
          FROM MEDICAMENTO
         WHERE IDMedicamento = p_id_medicamento
    )
      INTO v_existe;

    IF NOT v_existe THEN
        RAISE EXCEPTION 'No existe un medicamento con IDMedicamento = %.', p_id_medicamento;
    END IF;

    -- Eliminar suministros de proveedores asociados al medicamento.
    DELETE FROM PROVEER_MEDICAMENTO WHERE IDMedicamento = p_id_medicamento;
    GET DIAGNOSTICS v_filas_borradas = ROW_COUNT;
    RAISE NOTICE 'PROVEER_MEDICAMENTO: % fila(s) eliminada(s).', v_filas_borradas;

    -- Eliminar preparaciones hechas por farmaceuticos.
    DELETE FROM PREPARAR WHERE IDMedicamento = p_id_medicamento;
    GET DIAGNOSTICS v_filas_borradas = ROW_COUNT;
    RAISE NOTICE 'PREPARAR: % fila(s) eliminada(s).', v_filas_borradas;

    -- Eliminar la relacion entre medicamento e insumos.
    DELETE FROM UTILIZAR WHERE IDMedicamento = p_id_medicamento;
    GET DIAGNOSTICS v_filas_borradas = ROW_COUNT;
    RAISE NOTICE 'UTILIZAR: % fila(s) eliminada(s).', v_filas_borradas;

    -- Eliminar renglones de compra donde aparece el medicamento.
    DELETE FROM COMPRAR WHERE IDMedicamento = p_id_medicamento;
    GET DIAGNOSTICS v_filas_borradas = ROW_COUNT;
    RAISE NOTICE 'COMPRAR: % fila(s) eliminada(s).', v_filas_borradas;

    -- Eliminar solicitudes del medicamento en recetas.
    DELETE FROM PEDIR WHERE IDMedicamento = p_id_medicamento;
    GET DIAGNOSTICS v_filas_borradas = ROW_COUNT;
    RAISE NOTICE 'PEDIR: % fila(s) eliminada(s).', v_filas_borradas;

    -- Finalmente eliminar el medicamento de la tabla principal.
    DELETE FROM MEDICAMENTO WHERE IDMedicamento = p_id_medicamento;
    GET DIAGNOSTICS v_filas_borradas = ROW_COUNT;

    IF v_filas_borradas = 0 THEN
        RAISE EXCEPTION
            'No se pudo eliminar el medicamento con IDMedicamento = %.',
            p_id_medicamento;
    END IF;

    RAISE NOTICE 'Medicamento con IDMedicamento = % eliminado correctamente.', p_id_medicamento;
END;
$$;


-- Ejemplos de uso

-- Registrar un farmaceutico:
-- CALL sp_registrar_farmaceutico(
--     'Maria',
--     'Hernandez',
--     'Lopez',
--     'AB123456',
--     'HELM900101AB1',
--     'Av. Insurgentes',
--     '123',
--     NULL,
--     'Centro',
--     'Ciudad de Mexico',
--     12500.50,
--     1
-- );

-- Eliminar un medicamento:
-- CALL sp_eliminar_medicamento(42);



-- Triggers - Disparadores
-- Farmacia De Otro Mundo
-- Este archivo contiene los disparadores solicitados:
--
-- 1) Triggers de stock de MEDICAMENTO.
-- Actualizan el inventario cuando:
-- _un proveedor provee medicamento;
-- _un farmaceutico prepara medicamento;
-- _un cliente compra medicamento.
--
-- 2) Triggers de calculo del TICKET.
-- Calculan:
-- _PrecioBruto;
-- _DescuentoAplicado;
-- _PrecioNeto.


-- 0) Columnas usadas por estos triggers
-- MEDICAMENTO.Stock:
-- Guarda el inventario disponible por medicamento.
-- TICKET.PrecioBruto:
-- Suma de todos los renglones del ticket antes de descuento.
-- TICKET.DescuentoAplicado:
-- Porcentaje de descuento aplicado al ticket.
-- TICKET.PrecioNeto:
-- Total final despues de aplicar el descuento.
-- TICKET.Fecha:
-- Se usa para saber cuantos tickets previos existen en el mismo
-- anio y asi calcular el descuento.

-- i. Trigger de stock cuando un proveedor provee medicamento
-- Tabla observada:
-- PROVEER_MEDICAMENTO
-- Momento:
-- AFTER INSERT OR UPDATE OR DELETE
-- Desarrollo:
-- INSERT:
-- Suma NEW.Cantidad al stock del medicamento recibido.
-- UPDATE:
-- Resta OLD.Cantidad del medicamento anterior y suma
-- NEW.Cantidad al medicamento nuevo. Esto cubre tanto
-- cambios de cantidad como cambios de IDMedicamento.
-- DELETE:
-- Resta OLD.Cantidad porque ese suministro ya no existe.
-- Motivo de AFTER:
-- La fila ya paso las validaciones y llaves foraneas, por lo que
-- el cambio en inventario se hace solo cuando la operacion existe.

CREATE OR REPLACE FUNCTION fn_stock_proveer_medicamento()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE MEDICAMENTO
           SET Stock = Stock + NEW.Cantidad
         WHERE IDMedicamento = NEW.IDMedicamento;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE MEDICAMENTO
           SET Stock = Stock - OLD.Cantidad
         WHERE IDMedicamento = OLD.IDMedicamento;

        UPDATE MEDICAMENTO
           SET Stock = Stock + NEW.Cantidad
         WHERE IDMedicamento = NEW.IDMedicamento;

    ELSIF TG_OP = 'DELETE' THEN
        UPDATE MEDICAMENTO
           SET Stock = Stock - OLD.Cantidad
         WHERE IDMedicamento = OLD.IDMedicamento;
    END IF;

    RETURN NULL;
END;
$$;

DROP TRIGGER IF EXISTS trg_stock_proveer_medicamento ON PROVEER_MEDICAMENTO;

CREATE TRIGGER trg_stock_proveer_medicamento
AFTER INSERT OR UPDATE OR DELETE ON PROVEER_MEDICAMENTO
FOR EACH ROW
EXECUTE FUNCTION fn_stock_proveer_medicamento();


-- ii. Trigger de stock cuando un farmaceutico prepara medicamento
-- Tabla observada:
-- PREPARAR
-- Momento:
-- AFTER INSERT OR UPDATE OR DELETE
-- Desarrollo:
-- INSERT:
-- Suma al stock porque se preparo medicamento nuevo.
-- UPDATE:
-- Deshace el efecto de la fila anterior y aplica el nuevo.
-- DELETE:
-- Resta del stock porque se elimina una preparacion registrada.

CREATE OR REPLACE FUNCTION fn_stock_preparar()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE MEDICAMENTO
           SET Stock = Stock + NEW.Cantidad
         WHERE IDMedicamento = NEW.IDMedicamento;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE MEDICAMENTO
           SET Stock = Stock - OLD.Cantidad
         WHERE IDMedicamento = OLD.IDMedicamento;

        UPDATE MEDICAMENTO
           SET Stock = Stock + NEW.Cantidad
         WHERE IDMedicamento = NEW.IDMedicamento;

    ELSIF TG_OP = 'DELETE' THEN
        UPDATE MEDICAMENTO
           SET Stock = Stock - OLD.Cantidad
         WHERE IDMedicamento = OLD.IDMedicamento;
    END IF;

    RETURN NULL;
END;
$$;

DROP TRIGGER IF EXISTS trg_stock_preparar ON PREPARAR;

CREATE TRIGGER trg_stock_preparar
AFTER INSERT OR UPDATE OR DELETE ON PREPARAR
FOR EACH ROW
EXECUTE FUNCTION fn_stock_preparar();


-- iii. Trigger de stock cuando un cliente compra medicamento
-- Tabla observada:
-- COMPRAR
-- Momento:
-- AFTER INSERT OR UPDATE OR DELETE
-- Desarrollo:
-- INSERT:
-- Verifica que exista stock suficiente y descuenta la cantidad.
-- UPDATE:
-- Devuelve al stock la cantidad anterior y despues intenta
-- descontar la cantidad nueva.
-- DELETE:
-- Devuelve al inventario la cantidad que se habia vendido.
-- Validacion:
-- Si no hay suficiente stock, se lanza EXCEPTION para cancelar
-- la operacion de compra.

CREATE OR REPLACE FUNCTION fn_stock_comprar()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_stock_actual INT;
BEGIN
    IF TG_OP = 'INSERT' THEN
        SELECT Stock
          INTO v_stock_actual
          FROM MEDICAMENTO
         WHERE IDMedicamento = NEW.IDMedicamento;

        IF v_stock_actual IS NULL THEN
            RAISE EXCEPTION
                'No existe el medicamento con IDMedicamento = %.',
                NEW.IDMedicamento;
        END IF;

        IF v_stock_actual < NEW.Cantidad THEN
            RAISE EXCEPTION
                'Stock insuficiente para el medicamento %. Disponible: %, solicitado: %.',
                NEW.IDMedicamento, v_stock_actual, NEW.Cantidad;
        END IF;

        UPDATE MEDICAMENTO
           SET Stock = Stock - NEW.Cantidad
         WHERE IDMedicamento = NEW.IDMedicamento;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE MEDICAMENTO
           SET Stock = Stock + OLD.Cantidad
         WHERE IDMedicamento = OLD.IDMedicamento;

        SELECT Stock
          INTO v_stock_actual
          FROM MEDICAMENTO
         WHERE IDMedicamento = NEW.IDMedicamento;

        IF v_stock_actual IS NULL THEN
            RAISE EXCEPTION
                'No existe el medicamento con IDMedicamento = %.',
                NEW.IDMedicamento;
        END IF;

        IF v_stock_actual < NEW.Cantidad THEN
            RAISE EXCEPTION
                'Stock insuficiente para el medicamento %. Disponible: %, solicitado: %.',
                NEW.IDMedicamento, v_stock_actual, NEW.Cantidad;
        END IF;

        UPDATE MEDICAMENTO
           SET Stock = Stock - NEW.Cantidad
         WHERE IDMedicamento = NEW.IDMedicamento;

    ELSIF TG_OP = 'DELETE' THEN
        UPDATE MEDICAMENTO
           SET Stock = Stock + OLD.Cantidad
         WHERE IDMedicamento = OLD.IDMedicamento;
    END IF;

    RETURN NULL;
END;
$$;

DROP TRIGGER IF EXISTS trg_stock_comprar ON COMPRAR;

CREATE TRIGGER trg_stock_comprar
AFTER INSERT OR UPDATE OR DELETE ON COMPRAR
FOR EACH ROW
EXECUTE FUNCTION fn_stock_comprar();


-- iv. Funcion auxiliar: fn_calcular_descuento
-- Objetivo:
-- Calcular el porcentaje de descuento de un ticket segun
-- cuantos tickets previos existen en el mismo anio.
-- Regla usada:
-- tickets previos        descuento
-- 0 a 99                 0%
-- 100 a 499              5%
-- 500 a 1999             10%
-- 2000 o mas             15%
-- Se declara IMMUTABLE porque para el mismo numero de tickets
-- previos siempre regresa el mismo descuento.

CREATE OR REPLACE FUNCTION fn_calcular_descuento(p_tickets_previos INT)
RETURNS DECIMAL(5,2)
LANGUAGE plpgsql
IMMUTABLE
AS $$
BEGIN
    IF p_tickets_previos >= 2000 THEN
        RETURN 15.00;
    ELSIF p_tickets_previos >= 500 THEN
        RETURN 10.00;
    ELSIF p_tickets_previos >= 100 THEN
        RETURN 5.00;
    ELSE
        RETURN 0.00;
    END IF;
END;
$$;


-- v. Trigger para fijar descuento inicial del ticket
-- Tabla observada:
-- TICKET
-- Momento:
-- BEFORE INSERT
-- Desarrollo:
-- 1. Si NEW.Fecha viene NULL, usa CURRENT_DATE.
-- 2. Cuenta cuantos tickets ya existen en el mismo anio.
-- 3. Calcula DescuentoAplicado con fn_calcular_descuento.
-- 4. Inicializa PrecioBruto y PrecioNeto en 0 si vienen NULL.
-- Motivo de BEFORE:
-- El descuento debe quedar guardado en la fila antes de insertarla.

CREATE OR REPLACE FUNCTION fn_ticket_set_descuento()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_tickets_previos INT;
BEGIN
    IF NEW.Fecha IS NULL THEN
        NEW.Fecha := CURRENT_DATE;
    END IF;

    SELECT COUNT(*)
      INTO v_tickets_previos
      FROM TICKET
     WHERE EXTRACT(YEAR FROM Fecha) = EXTRACT(YEAR FROM NEW.Fecha)
       AND IDTicket <> NEW.IDTicket;

    NEW.DescuentoAplicado := fn_calcular_descuento(v_tickets_previos);

    IF NEW.PrecioBruto IS NULL THEN
        NEW.PrecioBruto := 0;
    END IF;

    IF NEW.PrecioNeto IS NULL THEN
        NEW.PrecioNeto := 0;
    END IF;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_ticket_set_descuento ON TICKET;

CREATE TRIGGER trg_ticket_set_descuento
BEFORE INSERT ON TICKET
FOR EACH ROW
EXECUTE FUNCTION fn_ticket_set_descuento();


-- vi. Trigger para recalcular precios del ticket
-- Tabla observada:
-- COMPRAR
-- Momento:
-- AFTER INSERT OR UPDATE OR DELETE
-- Desarrollo:
-- 1. Identifica que ticket fue afectado.
-- 2. Calcula PrecioBruto con:
-- SUM(COMPRAR.Cantidad * MEDICAMENTO.PrecioPublico)
-- 3. Lee el DescuentoAplicado ya guardado en TICKET.
-- 4. Calcula PrecioNeto:
-- PrecioBruto * (1 - DescuentoAplicado / 100)
-- 5. Actualiza TICKET.
-- 6. Si un UPDATE movio un renglon de un ticket a otro, tambien
-- recalcula el ticket anterior.
-- Motivo de AFTER:
-- El calculo necesita que la fila de COMPRAR ya exista, cambie o
-- desaparezca para sumar correctamente los renglones actuales.

CREATE OR REPLACE FUNCTION fn_ticket_recalcular_precios()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_ticket INT;
    v_bruto     DECIMAL(12,2);
    v_descuento DECIMAL(5,2);
    v_neto      DECIMAL(12,2);
BEGIN
    IF TG_OP = 'DELETE' THEN
        v_id_ticket := OLD.IDTicket;
    ELSE
        v_id_ticket := NEW.IDTicket;
    END IF;

    SELECT COALESCE(SUM(c.Cantidad * m.PrecioPublico), 0)
      INTO v_bruto
      FROM COMPRAR AS c
      JOIN MEDICAMENTO AS m ON m.IDMedicamento = c.IDMedicamento
     WHERE c.IDTicket = v_id_ticket;

    SELECT DescuentoAplicado
      INTO v_descuento
      FROM TICKET
     WHERE IDTicket = v_id_ticket;

    IF v_descuento IS NULL THEN
        v_descuento := 0;
    END IF;

    v_neto := ROUND(v_bruto * (1 - v_descuento / 100), 2);

    UPDATE TICKET
       SET PrecioBruto = v_bruto,
           PrecioNeto = v_neto
     WHERE IDTicket = v_id_ticket;

    IF TG_OP = 'UPDATE' AND OLD.IDTicket <> NEW.IDTicket THEN
        SELECT COALESCE(SUM(c.Cantidad * m.PrecioPublico), 0)
          INTO v_bruto
          FROM COMPRAR AS c
          JOIN MEDICAMENTO AS m ON m.IDMedicamento = c.IDMedicamento
         WHERE c.IDTicket = OLD.IDTicket;

        SELECT DescuentoAplicado
          INTO v_descuento
          FROM TICKET
         WHERE IDTicket = OLD.IDTicket;

        IF v_descuento IS NULL THEN
            v_descuento := 0;
        END IF;

        v_neto := ROUND(v_bruto * (1 - v_descuento / 100), 2);

        UPDATE TICKET
           SET PrecioBruto = v_bruto,
               PrecioNeto = v_neto
         WHERE IDTicket = OLD.IDTicket;
    END IF;

    RETURN NULL;
END;
$$;

DROP TRIGGER IF EXISTS trg_ticket_recalcular_precios ON COMPRAR;

CREATE TRIGGER trg_ticket_recalcular_precios
AFTER INSERT OR UPDATE OR DELETE ON COMPRAR
FOR EACH ROW
EXECUTE FUNCTION fn_ticket_recalcular_precios();


-- Ejemplos de prueba
-- 1) Cuando un proveedor provee, el stock sube:
-- INSERT INTO PROVEER_MEDICAMENTO
--     (IDProveedor, IDMedicamento, IDSucursal,
--      CondicionDeAlmacenamiento, Cantidad,
--      FechaDeRecibo, FechaDeCaducidad)
-- VALUES (1, 10, 1, 'Refrigerado', 50, CURRENT_DATE, CURRENT_DATE + INTERVAL '1 year');

-- 2) Cuando un farmaceutico prepara, el stock sube:
-- INSERT INTO PREPARAR (IDMedicamento, IDPersonal, Cantidad)
-- VALUES (10, 751, 20);

-- 3) Cuando un cliente compra, el stock baja y el ticket recalcula precios:
-- INSERT INTO TICKET (IDTicket, IDSucursal, IDCliente, Fecha, Hora)
-- VALUES (1001, 1, 5, DATE '2026-05-24', TIME '10:00');

-- INSERT INTO COMPRAR (IDTicket, IDMedicamento, Cantidad)
-- VALUES (1001, 10, 3);

-- SELECT IDTicket, Fecha, PrecioBruto, DescuentoAplicado, PrecioNeto
-- FROM TICKET
-- WHERE IDTicket = 1001;



-- Funciones.sql - Funciones solicitadas
-- Farmacia De Otra Mundo
-- Este archivo contiene las dos funciones pedidas:
-- 1) reconoceredad(p_idCliente)
-- Recibe el identificador de un cliente y regresa su edad.
-- 2) calculaganancias(p_nombre_sucursal)
-- Recibe el nombre de una sucursal y calcula sus ganancias
-- durante el anio 2026.
-- Nota de carga:
-- Los ejemplos al final de cada funcion estan comentados para
-- que el archivo pueda ejecutarse sin lanzar consultas de prueba.


-- i. Funcion: reconoceredad
-- Objetivo:
-- Calcular la edad actual de un cliente.
-- Parametro:
-- p_idCliente INT
-- ID del cliente que se buscara en la tabla CLIENTE.
-- Regresa:
-- INT
-- Edad calculada con base en CLIENTE.FechaNacimiento.
-- Si el cliente no existe, o no se encuentra fecha, regresa NULL.
-- Desarrollo:
-- 1. Busca la FechaNacimiento del cliente.
-- 2. Si no se encontro fecha, termina regresando NULL.
-- 3. AGE(CURRENT_DATE, fecha) calcula el intervalo de tiempo.
-- 4. DATE_PART('year', ...) extrae los anios completos.
-- 5. Se convierte el resultado a INT porque DATE_PART regresa DOUBLE.

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


-- ii. Funcion: calculaganancias
-- Objetivo:
-- Calcular las ganancias de una sucursal durante el anio 2026.
-- Parametro:
-- p_nombre_sucursal VARCHAR(120)
-- Nombre exacto de la sucursal, tomado de SUCURSAL.Nombre.
-- Regresa:
-- NUMERIC(12,2)
-- Suma de:
-- _ventas de medicamentos en tickets del anio 2026;
-- _costos de consultas realizadas en el anio 2026.
-- Desarrollo:
-- 1. Calcula ganancia por medicamentos:
-- SUCURSAL, TICKET, COMPRAR y MEDICAMENTO.
-- Se multiplica PrecioPublico * Cantidad para respetar
-- cuantas unidades se vendieron en cada ticket.
-- 2. Calcula ganancia por consultas:
-- SUCURSAL, CLINICA y CONSULTA.
-- Se suma CONSULTA.CostoConsulta.
-- 3. En ambas consultas se filtra por anio 2026.
-- 4. COALESCE evita regresar NULL cuando no hay ventas o consultas.

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
