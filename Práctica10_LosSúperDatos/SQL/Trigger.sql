-- ============================================================
--  Trigger.sql - Disparadores
--  Esquema: Clinica / Farmacia (PostgreSQL / PL-pgSQL)
-- ============================================================
--  Este archivo contiene los disparadores solicitados:
--
--  1) Triggers de stock de MEDICAMENTO.
--     Actualizan el inventario cuando:
--       - un proveedor provee medicamento;
--       - un farmaceutico prepara medicamento;
--       - un cliente compra medicamento.
--
--  2) Triggers de calculo del TICKET.
--     Calculan:
--       - PrecioBruto;
--       - DescuentoAplicado;
--       - PrecioNeto.
--
--  Nota:
--  El DDL base no incluye todas las columnas necesarias para
--  estos triggers. Por eso este script agrega columnas auxiliares
--  con ALTER TABLE ... ADD COLUMN IF NOT EXISTS.
-- ============================================================


-- ============================================================
--  0) Columnas auxiliares
-- ============================================================
--  MEDICAMENTO.Stock:
--      Guarda el inventario disponible por medicamento.
--
--  TICKET.PrecioBruto:
--      Suma de todos los renglones del ticket antes de descuento.
--
--  TICKET.DescuentoAplicado:
--      Porcentaje de descuento aplicado al ticket.
--
--  TICKET.PrecioNeto:
--      Total final despues de aplicar el descuento.
--
--  TICKET.Fecha:
--      Ya existe en el DDL actual, pero se deja IF NOT EXISTS para
--      que el script siga funcionando si se ejecuta sobre una version
--      anterior del esquema.
-- ============================================================

ALTER TABLE MEDICAMENTO
    ADD COLUMN IF NOT EXISTS Stock INT NOT NULL DEFAULT 0;

ALTER TABLE TICKET
    ADD COLUMN IF NOT EXISTS Fecha DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE TICKET
    ADD COLUMN IF NOT EXISTS PrecioBruto DECIMAL(12,2) NOT NULL DEFAULT 0;

ALTER TABLE TICKET
    ADD COLUMN IF NOT EXISTS PrecioNeto DECIMAL(12,2) NOT NULL DEFAULT 0;

ALTER TABLE TICKET
    ADD COLUMN IF NOT EXISTS DescuentoAplicado DECIMAL(5,2) NOT NULL DEFAULT 0;


-- ============================================================
--  i. Trigger de stock cuando un proveedor provee medicamento
-- ============================================================
--  Tabla observada:
--      PROVEER_MEDICAMENTO
--
--  Momento:
--      AFTER INSERT OR UPDATE OR DELETE
--
--  Desarrollo:
--      INSERT:
--          Suma NEW.Cantidad al stock del medicamento recibido.
--
--      UPDATE:
--          Resta OLD.Cantidad del medicamento anterior y suma
--          NEW.Cantidad al medicamento nuevo. Esto cubre tanto
--          cambios de cantidad como cambios de IDMedicamento.
--
--      DELETE:
--          Resta OLD.Cantidad porque ese suministro ya no existe.
--
--  Motivo de AFTER:
--      La fila ya paso las validaciones y llaves foraneas, por lo que
--      el cambio en inventario se hace solo cuando la operacion existe.
-- ============================================================

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

    -- En triggers AFTER se regresa NULL porque la fila ya fue procesada.
    RETURN NULL;
END;
$$;

DROP TRIGGER IF EXISTS trg_stock_proveer_medicamento ON PROVEER_MEDICAMENTO;

CREATE TRIGGER trg_stock_proveer_medicamento
AFTER INSERT OR UPDATE OR DELETE ON PROVEER_MEDICAMENTO
FOR EACH ROW
EXECUTE FUNCTION fn_stock_proveer_medicamento();


-- ============================================================
--  ii. Trigger de stock cuando un farmaceutico prepara medicamento
-- ============================================================
--  Tabla observada:
--      PREPARAR
--
--  Momento:
--      AFTER INSERT OR UPDATE OR DELETE
--
--  Desarrollo:
--      INSERT:
--          Suma al stock porque se preparo medicamento nuevo.
--
--      UPDATE:
--          Deshace el efecto de la fila anterior y aplica el nuevo.
--
--      DELETE:
--          Resta del stock porque se elimina una preparacion registrada.
-- ============================================================

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


-- ============================================================
--  iii. Trigger de stock cuando un cliente compra medicamento
-- ============================================================
--  Tabla observada:
--      COMPRAR
--
--  Momento:
--      AFTER INSERT OR UPDATE OR DELETE
--
--  Desarrollo:
--      INSERT:
--          Verifica que exista stock suficiente y descuenta la cantidad.
--
--      UPDATE:
--          Devuelve al stock la cantidad anterior y despues intenta
--          descontar la cantidad nueva.
--
--      DELETE:
--          Devuelve al inventario la cantidad que se habia vendido.
--
--  Validacion:
--      Si no hay suficiente stock, se lanza EXCEPTION para cancelar
--      la operacion de compra.
-- ============================================================

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


-- ============================================================
--  iv. Funcion auxiliar: fn_calcular_descuento
-- ============================================================
--  Objetivo:
--      Calcular el porcentaje de descuento de un ticket segun
--      cuantos tickets previos existen en el mismo anio.
--
--  Regla usada:
--      tickets previos        descuento
--      0 a 99                 0%
--      100 a 499              5%
--      500 a 1999             10%
--      2000 o mas             15%
--
--  Se declara IMMUTABLE porque para el mismo numero de tickets
--  previos siempre regresa el mismo descuento.
-- ============================================================

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


-- ============================================================
--  v. Trigger para fijar descuento inicial del ticket
-- ============================================================
--  Tabla observada:
--      TICKET
--
--  Momento:
--      BEFORE INSERT
--
--  Desarrollo:
--      1. Si NEW.Fecha viene NULL, usa CURRENT_DATE.
--      2. Cuenta cuantos tickets ya existen en el mismo anio.
--      3. Calcula DescuentoAplicado con fn_calcular_descuento.
--      4. Inicializa PrecioBruto y PrecioNeto en 0 si vienen NULL.
--
--  Motivo de BEFORE:
--      El descuento debe quedar guardado en la fila antes de insertarla.
-- ============================================================

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


-- ============================================================
--  vi. Trigger para recalcular precios del ticket
-- ============================================================
--  Tabla observada:
--      COMPRAR
--
--  Momento:
--      AFTER INSERT OR UPDATE OR DELETE
--
--  Desarrollo:
--      1. Identifica que ticket fue afectado.
--      2. Calcula PrecioBruto con:
--             SUM(COMPRAR.Cantidad * MEDICAMENTO.PrecioPublico)
--      3. Lee el DescuentoAplicado ya guardado en TICKET.
--      4. Calcula PrecioNeto:
--             PrecioBruto * (1 - DescuentoAplicado / 100)
--      5. Actualiza TICKET.
--      6. Si un UPDATE movio un renglon de un ticket a otro, tambien
--         recalcula el ticket anterior.
--
--  Motivo de AFTER:
--      El calculo necesita que la fila de COMPRAR ya exista, cambie o
--      desaparezca para sumar correctamente los renglones actuales.
-- ============================================================

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


-- ============================================================
--  Ejemplos de prueba
-- ============================================================

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
