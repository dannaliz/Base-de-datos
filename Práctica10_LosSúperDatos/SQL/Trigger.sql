-- ============================================================
--  Trigger.sql  -  Disparadores (Triggers)
--  Esquema: Clínica / Farmacia  (PostgreSQL / PL-pgSQL)
-- ============================================================
--  Contenido:
--    i.  Triggers de stock de MEDICAMENTO
--        - Suman stock cuando un proveedor provee un medicamento
--          (INSERT en PROVEER_MEDICAMENTO).
--        - Suman stock cuando un farmacéutico prepara/crea un
--          medicamento (INSERT en PREPARAR).
--        - Restan stock cuando un cliente compra un medicamento
--          (INSERT en COMPRAR).
--
--    ii. Trigger de cálculo de precios del TICKET
--        - Calcula PrecioBruto y PrecioNeto.
--        - El descuento aplicado depende de cuántos tickets se
--          han generado antes en el mismo año.
--
--  NOTA: El DDL original no contempla las columnas que estos
--  disparadores necesitan, así que primero las agregamos:
--      MEDICAMENTO.Stock
--      TICKET.Fecha, TICKET.PrecioBruto, TICKET.PrecioNeto,
--      TICKET.DescuentoAplicado
-- ============================================================


-- ============================================================
--  0)  Columnas auxiliares (se agregan si no existen)
-- ============================================================

ALTER TABLE MEDICAMENTO
    ADD COLUMN IF NOT EXISTS Stock INT NOT NULL DEFAULT 0;

--  NOTA: No se agrega un CHECK (Stock >= 0) porque sp_eliminar_medicamento
--  borra renglones de PREPARAR/COMPRAR/PROVEER_MEDICAMENTO y los triggers
--  de stock se disparan en cascada, lo que podría dejar al stock
--  temporalmente en negativo antes de que el medicamento desaparezca.
--  La validación real ("no se puede vender más de lo que hay") la hace
--  fn_stock_comprar al momento de la compra.

ALTER TABLE TICKET
    ADD COLUMN IF NOT EXISTS Fecha              DATE          NOT NULL DEFAULT CURRENT_DATE;
ALTER TABLE TICKET
    ADD COLUMN IF NOT EXISTS PrecioBruto        DECIMAL(12,2) NOT NULL DEFAULT 0;
ALTER TABLE TICKET
    ADD COLUMN IF NOT EXISTS PrecioNeto         DECIMAL(12,2) NOT NULL DEFAULT 0;
ALTER TABLE TICKET
    ADD COLUMN IF NOT EXISTS DescuentoAplicado  DECIMAL(5,2)  NOT NULL DEFAULT 0;
        -- Descuento como porcentaje: 0.00, 5.00, 10.00, etc.


-- ============================================================
--  i. Triggers para el STOCK de MEDICAMENTO
-- ============================================================
--
--  El stock de un medicamento se incrementa cuando un proveedor
--  lo provee (PROVEER_MEDICAMENTO) o cuando un farmacéutico lo
--  prepara (PREPARAR), y se decrementa cuando un cliente lo
--  compra (COMPRAR).
--
--  Se manejan también las operaciones UPDATE y DELETE para que
--  el stock siempre permanezca consistente con la suma real
--  registrada en las tablas.
-- ============================================================

-- ------------------------------------------------------------
--  Función: trg_stock_proveer_medicamento
-- ------------------------------------------------------------
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
        --  Si cambia el medicamento o la cantidad, ajustamos
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

    RETURN NULL;  -- AFTER trigger, no necesita devolver fila
END;
$$;

DROP TRIGGER IF EXISTS trg_stock_proveer_medicamento ON PROVEER_MEDICAMENTO;

CREATE TRIGGER trg_stock_proveer_medicamento
AFTER INSERT OR UPDATE OR DELETE ON PROVEER_MEDICAMENTO
FOR EACH ROW
EXECUTE FUNCTION fn_stock_proveer_medicamento();


-- ------------------------------------------------------------
--  Función: trg_stock_preparar
-- ------------------------------------------------------------
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


-- ------------------------------------------------------------
--  Función: trg_stock_comprar
-- ------------------------------------------------------------
--  Cuando un cliente compra, el stock disminuye. Antes de
--  permitir la compra verificamos que haya suficiente stock.
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_stock_comprar()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_stock_actual INT;
BEGIN
    IF TG_OP = 'INSERT' THEN
        SELECT Stock INTO v_stock_actual
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
        --  Regresamos lo que tenía la fila vieja...
        UPDATE MEDICAMENTO
           SET Stock = Stock + OLD.Cantidad
         WHERE IDMedicamento = OLD.IDMedicamento;

        --  ...y descontamos lo nuevo, verificando que alcance.
        SELECT Stock INTO v_stock_actual
          FROM MEDICAMENTO
         WHERE IDMedicamento = NEW.IDMedicamento;

        IF v_stock_actual < NEW.Cantidad THEN
            RAISE EXCEPTION
                'Stock insuficiente para el medicamento %. Disponible: %, solicitado: %.',
                NEW.IDMedicamento, v_stock_actual, NEW.Cantidad;
        END IF;

        UPDATE MEDICAMENTO
           SET Stock = Stock - NEW.Cantidad
         WHERE IDMedicamento = NEW.IDMedicamento;

    ELSIF TG_OP = 'DELETE' THEN
        --  Devolvemos al stock lo que se había comprado
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
--  ii. Trigger para el cálculo de PrecioBruto y PrecioNeto
--      del TICKET
-- ============================================================
--
--  Lógica:
--    * PrecioBruto = SUMA( COMPRAR.Cantidad * MEDICAMENTO.PrecioPublico )
--      sobre todos los renglones del ticket.
--
--    * El descuento aplicado al ticket depende de cuántos
--      tickets se generaron antes en el mismo año:
--
--          tickets_previos      descuento
--          --------------       ---------
--          0   ..   99           0 %
--          100 ..  499           5 %
--          500 .. 1999          10 %
--          2000 en adelante     15 %
--
--    * PrecioNeto = PrecioBruto * (1 - DescuentoAplicado/100)
--
--  Implementación: usamos un trigger AFTER INSERT/UPDATE/DELETE
--  sobre COMPRAR (que es donde están los renglones del ticket)
--  más un trigger BEFORE INSERT sobre TICKET para fijar
--  la fecha y el descuento desde el momento en que se genera.
-- ============================================================


-- ------------------------------------------------------------
--  Función auxiliar: fn_calcular_descuento
--  Calcula el porcentaje de descuento dado el número de
--  tickets previos generados en el mismo año.
-- ------------------------------------------------------------
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
        RETURN  5.00;
    ELSE
        RETURN  0.00;
    END IF;
END;
$$;


-- ------------------------------------------------------------
--  Trigger BEFORE INSERT sobre TICKET:
--  fija Fecha (si viene NULL) y calcula el descuento aplicable
--  con base en los tickets previos del mismo año.
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_ticket_set_descuento()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_tickets_previos INT;
BEGIN
    --  Si no se proporciona la fecha, usamos la actual.
    IF NEW.Fecha IS NULL THEN
        NEW.Fecha := CURRENT_DATE;
    END IF;

    --  Contar cuántos tickets se han generado en el mismo año
    --  ANTES de éste (excluyéndolo).
    SELECT COUNT(*)
      INTO v_tickets_previos
      FROM TICKET
     WHERE EXTRACT(YEAR FROM Fecha) = EXTRACT(YEAR FROM NEW.Fecha)
       AND IDTicket <> NEW.IDTicket;

    NEW.DescuentoAplicado := fn_calcular_descuento(v_tickets_previos);

    --  El precio bruto y el neto inician en 0; se actualizan
    --  cuando se agreguen renglones en COMPRAR.
    IF NEW.PrecioBruto IS NULL THEN NEW.PrecioBruto := 0; END IF;
    IF NEW.PrecioNeto  IS NULL THEN NEW.PrecioNeto  := 0; END IF;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_ticket_set_descuento ON TICKET;

CREATE TRIGGER trg_ticket_set_descuento
BEFORE INSERT ON TICKET
FOR EACH ROW
EXECUTE FUNCTION fn_ticket_set_descuento();


-- ------------------------------------------------------------
--  Trigger AFTER INSERT/UPDATE/DELETE sobre COMPRAR:
--  recalcula PrecioBruto y PrecioNeto del ticket afectado.
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_ticket_recalcular_precios()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_ticket   INT;
    v_bruto       DECIMAL(12,2);
    v_descuento   DECIMAL(5,2);
    v_neto        DECIMAL(12,2);
BEGIN
    --  Determinar el ticket afectado según la operación.
    IF TG_OP = 'DELETE' THEN
        v_id_ticket := OLD.IDTicket;
    ELSE
        v_id_ticket := NEW.IDTicket;
    END IF;

    --  Calcular el precio bruto sumando (cantidad * precio público)
    --  de cada renglón del ticket.
    SELECT COALESCE(SUM(c.Cantidad * m.PrecioPublico), 0)
      INTO v_bruto
      FROM COMPRAR c
      JOIN MEDICAMENTO m ON m.IDMedicamento = c.IDMedicamento
     WHERE c.IDTicket = v_id_ticket;

    --  Tomar el descuento previamente fijado al generar el ticket.
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
           PrecioNeto  = v_neto
     WHERE IDTicket    = v_id_ticket;

    --  Si la operación es UPDATE y el renglón cambió de ticket,
    --  también hay que recalcular el ticket anterior.
    IF TG_OP = 'UPDATE' AND OLD.IDTicket <> NEW.IDTicket THEN
        SELECT COALESCE(SUM(c.Cantidad * m.PrecioPublico), 0)
          INTO v_bruto
          FROM COMPRAR c
          JOIN MEDICAMENTO m ON m.IDMedicamento = c.IDMedicamento
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
               PrecioNeto  = v_neto
         WHERE IDTicket    = OLD.IDTicket;
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
--  Ejemplos de prueba (comentados)
-- ============================================================
--
--  -- 1) Cuando un proveedor provee, el stock sube:
--  INSERT INTO PROVEER_MEDICAMENTO
--      (IDProveedor, IDMedicamento, IDSucursal,
--       CondicionDeAlmacenamiento, Cantidad,
--       FechaDeRecibo, FechaDeCaducidad)
--  VALUES (1, 10, 1, 'Refrigerado', 50, CURRENT_DATE, CURRENT_DATE + INTERVAL '1 year');
--
--  -- 2) Cuando un farmacéutico prepara, el stock sube:
--  INSERT INTO PREPARAR (IDMedicamento, IDPersonal, Cantidad)
--  VALUES (10, 3, 20);
--
--  -- 3) Cuando un cliente compra, el stock baja y el ticket
--  --    recalcula sus precios:
--  INSERT INTO TICKET (IDTicket, IDSucursal, IDCliente)
--  VALUES (1001, 1, 5);
--
--  INSERT INTO COMPRAR (IDTicket, IDMedicamento, Cantidad)
--  VALUES (1001, 10, 3);
--
--  SELECT IDTicket, Fecha, PrecioBruto, DescuentoAplicado, PrecioNeto
--    FROM TICKET WHERE IDTicket = 1001;
-- ============================================================
