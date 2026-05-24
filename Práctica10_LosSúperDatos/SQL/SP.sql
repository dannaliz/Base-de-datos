-- ============================================================
--  SP.sql  -  Procedimientos almacenados
--  Esquema: Clínica / Farmacia  (PostgreSQL / PL-pgSQL)
-- ============================================================
--  Contenido:
--    i.  sp_registrar_farmaceutico
--        Registra un nuevo farmacéutico en la tabla PERSONAL
--        y en la especialización FARMACEUTICO. Valida que los
--        campos de nombre y apellidos no contengan números ni
--        símbolos.
--
--    ii. sp_eliminar_medicamento
--        Elimina un medicamento dado su ID, removiendo primero
--        todas las referencias en las tablas que lo apuntan
--        (PROVEER_MEDICAMENTO, PREPARAR, UTILIZAR, COMPRAR,
--        PEDIR) ya que las FKs son ON DELETE RESTRICT.
-- ============================================================


-- ============================================================
--  i. SP: Registrar un farmacéutico
-- ============================================================
--
--  Parámetros de entrada:
--      p_nombre, p_apellido_paterno, p_apellido_materno
--      p_cedula              (8 caracteres, según restricción del DDL)
--      p_rfc                 (13 caracteres, según restricción del DDL)
--      p_calle, p_num_ext, p_num_int, p_colonia, p_estado
--      p_salario             (>= 0)
--      p_id_sucursal         (sucursal a la que pertenece)
--
--  Reglas:
--      * Nombre, ApellidoPaterno y ApellidoMaterno solo pueden
--        contener letras (incluye acentos, ñ y espacios). No se
--        permiten dígitos ni símbolos.
--      * Se calcula un nuevo IDPersonal a partir de MAX(IDPersonal)+1.
--      * Se inserta primero en PERSONAL y luego en FARMACEUTICO.
--
--  Salida:
--      Imprime el IDPersonal recién asignado vía RAISE NOTICE.
--      Si se requiere capturarlo programáticamente, llamar al SP
--      dentro de un bloque DO con una variable, o consultar
--      MAX(IDPersonal) de la tabla PERSONAL.
-- ============================================================

DROP PROCEDURE IF EXISTS sp_registrar_farmaceutico(
    VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR,
    VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR,
    DECIMAL, INT
);

CREATE OR REPLACE PROCEDURE sp_registrar_farmaceutico(
    IN  p_nombre            VARCHAR,
    IN  p_apellido_paterno  VARCHAR,
    IN  p_apellido_materno  VARCHAR,
    IN  p_cedula            VARCHAR,
    IN  p_rfc               VARCHAR,
    IN  p_calle             VARCHAR,
    IN  p_num_ext           VARCHAR,
    IN  p_num_int           VARCHAR,
    IN  p_colonia           VARCHAR,
    IN  p_estado            VARCHAR,
    IN  p_salario           DECIMAL,
    IN  p_id_sucursal       INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_personal  INT;
    --  Expresión regular que solo admite letras (mayúsculas y
    --  minúsculas), acentos del español, la letra ñ/Ñ y espacios.
    --  Cualquier dígito o símbolo provoca un error.
    c_regex_nombre CONSTANT TEXT := '^[A-Za-zÁÉÍÓÚáéíóúÑñÜü ]+$';
BEGIN
    -- ------------------------------------------------------------
    -- 1)  Validar campos de nombre (sin números ni símbolos)
    -- ------------------------------------------------------------
    IF p_nombre IS NULL OR TRIM(p_nombre) = '' THEN
        RAISE EXCEPTION 'El nombre no puede estar vacío.';
    END IF;
    IF p_apellido_paterno IS NULL OR TRIM(p_apellido_paterno) = '' THEN
        RAISE EXCEPTION 'El apellido paterno no puede estar vacío.';
    END IF;
    IF p_apellido_materno IS NULL OR TRIM(p_apellido_materno) = '' THEN
        RAISE EXCEPTION 'El apellido materno no puede estar vacío.';
    END IF;

    IF p_nombre !~ c_regex_nombre THEN
        RAISE EXCEPTION
            'El nombre "%" contiene caracteres inválidos. Solo se permiten letras y espacios.',
            p_nombre;
    END IF;
    IF p_apellido_paterno !~ c_regex_nombre THEN
        RAISE EXCEPTION
            'El apellido paterno "%" contiene caracteres inválidos. Solo se permiten letras y espacios.',
            p_apellido_paterno;
    END IF;
    IF p_apellido_materno !~ c_regex_nombre THEN
        RAISE EXCEPTION
            'El apellido materno "%" contiene caracteres inválidos. Solo se permiten letras y espacios.',
            p_apellido_materno;
    END IF;

    -- ------------------------------------------------------------
    -- 2)  Validaciones adicionales que coinciden con los CHECK
    --     del DDL (para fallar temprano con mensajes claros).
    -- ------------------------------------------------------------
    IF p_cedula IS NULL OR CHAR_LENGTH(p_cedula) <> 8 THEN
        RAISE EXCEPTION 'La cédula profesional debe tener exactamente 8 caracteres.';
    END IF;
    IF p_rfc IS NULL OR CHAR_LENGTH(p_rfc) <> 13 THEN
        RAISE EXCEPTION 'El RFC debe tener exactamente 13 caracteres.';
    END IF;
    IF p_salario IS NULL OR p_salario < 0 THEN
        RAISE EXCEPTION 'El salario no puede ser negativo ni NULL.';
    END IF;

    --  La sucursal debe existir (la FK lo verifica, pero damos
    --  un mensaje más legible).
    IF NOT EXISTS (SELECT 1 FROM SUCURSAL WHERE IDSucursal = p_id_sucursal) THEN
        RAISE EXCEPTION 'La sucursal con IDSucursal = % no existe.', p_id_sucursal;
    END IF;

    -- ------------------------------------------------------------
    -- 3)  Calcular el nuevo IDPersonal
    --     Usamos un bloqueo ligero para evitar carreras al
    --     calcular MAX+1 si varias sesiones registran a la vez.
    -- ------------------------------------------------------------
    LOCK TABLE PERSONAL IN SHARE ROW EXCLUSIVE MODE;

    SELECT COALESCE(MAX(IDPersonal), 0) + 1
      INTO v_id_personal
      FROM PERSONAL;

    -- ------------------------------------------------------------
    -- 4)  Insertar en PERSONAL
    -- ------------------------------------------------------------
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

    -- ------------------------------------------------------------
    -- 5)  Insertar en la especialización FARMACEUTICO
    -- ------------------------------------------------------------
    INSERT INTO FARMACEUTICO (IDPersonal) VALUES (v_id_personal);

    RAISE NOTICE 'Farmacéutico registrado con IDPersonal = %.', v_id_personal;
END;
$$;


-- ============================================================
--  ii. SP: Eliminar un medicamento por su ID
-- ============================================================
--
--  Las llaves foráneas sobre MEDICAMENTO están declaradas como
--  ON DELETE RESTRICT, así que primero debemos limpiar las
--  tablas que lo referencian:
--      PROVEER_MEDICAMENTO  (suministro del proveedor)
--      PREPARAR             (qué farmacéutico lo prepara)
--      UTILIZAR             (qué insumos lo componen)
--      COMPRAR              (qué tickets lo incluyen)
--      PEDIR                (qué recetas lo solicitan)
--
--  Después se borra de MEDICAMENTO. Todo se hace en una sola
--  transacción implícita del procedimiento, de modo que si algo
--  falla, no queda el medicamento a medio borrar.
-- ============================================================

DROP PROCEDURE IF EXISTS sp_eliminar_medicamento(INT);

CREATE OR REPLACE PROCEDURE sp_eliminar_medicamento(
    IN p_id_medicamento INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_existe         BOOLEAN;
    v_filas_borradas INT;
BEGIN
    -- ------------------------------------------------------------
    -- 1)  Verificar que el medicamento exista
    -- ------------------------------------------------------------
    SELECT EXISTS (
        SELECT 1 FROM MEDICAMENTO WHERE IDMedicamento = p_id_medicamento
    ) INTO v_existe;

    IF NOT v_existe THEN
        RAISE EXCEPTION 'No existe un medicamento con IDMedicamento = %.', p_id_medicamento;
    END IF;

    -- ------------------------------------------------------------
    -- 2)  Borrar referencias en tablas relacionadas
    -- ------------------------------------------------------------

    DELETE FROM PROVEER_MEDICAMENTO WHERE IDMedicamento = p_id_medicamento;
    GET DIAGNOSTICS v_filas_borradas = ROW_COUNT;
    RAISE NOTICE 'PROVEER_MEDICAMENTO: % fila(s) eliminada(s).', v_filas_borradas;

    DELETE FROM PREPARAR WHERE IDMedicamento = p_id_medicamento;
    GET DIAGNOSTICS v_filas_borradas = ROW_COUNT;
    RAISE NOTICE 'PREPARAR: % fila(s) eliminada(s).', v_filas_borradas;

    DELETE FROM UTILIZAR WHERE IDMedicamento = p_id_medicamento;
    GET DIAGNOSTICS v_filas_borradas = ROW_COUNT;
    RAISE NOTICE 'UTILIZAR: % fila(s) eliminada(s).', v_filas_borradas;

    DELETE FROM COMPRAR WHERE IDMedicamento = p_id_medicamento;
    GET DIAGNOSTICS v_filas_borradas = ROW_COUNT;
    RAISE NOTICE 'COMPRAR: % fila(s) eliminada(s).', v_filas_borradas;

    DELETE FROM PEDIR WHERE IDMedicamento = p_id_medicamento;
    GET DIAGNOSTICS v_filas_borradas = ROW_COUNT;
    RAISE NOTICE 'PEDIR: % fila(s) eliminada(s).', v_filas_borradas;

    -- ------------------------------------------------------------
    -- 3)  Borrar el medicamento
    -- ------------------------------------------------------------
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


-- ============================================================
--  Ejemplos de uso (comentados)
-- ============================================================
--
--  -- Registrar un farmacéutico:
--  CALL sp_registrar_farmaceutico(
--      'María',          -- nombre
--      'Hernández',      -- apellido paterno
--      'López',          -- apellido materno
--      'AB123456',       -- cédula (8 caracteres)
--      'HELM900101AB1',  -- RFC (13 caracteres)
--      'Av. Insurgentes',
--      '123', NULL, 'Centro', 'Ciudad de México',
--      12500.50,         -- salario
--      1                 -- IDSucursal
--  );
--  -- El nuevo IDPersonal aparece en el NOTICE; también se puede
--  -- recuperar con:  SELECT MAX(IDPersonal) FROM PERSONAL;
--
--  -- Eliminar un medicamento:
--  CALL sp_eliminar_medicamento(42);
-- ============================================================
