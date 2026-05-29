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
