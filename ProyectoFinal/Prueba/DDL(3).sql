--  DDL.sql  —  Esquema Farmacia De Otro Mundo
--  POLITICAS APLICADAS
--  1) INTEGRIDAD DE ENTIDAD
--       Toda entidad fuerte declara PRIMARY KEY simple (NOT NULL
--       y UNIQUE implicitos).
--
--       Toda especializacion (MEDICO, ENFERMERA, CAJERO, LIMPIEZA,
--       CUIDADOR, FARMACEUTICO) declara PRIMARY KEY = IDPersonal
--       (1:1 con PERSONAL).
-- 
--       Toda tabla derivada de relacion M:N o ternaria declara
--       PRIMARY KEY compuesta — sin esto el motor permitiria
--       tuplas duplicadas y se perderia la integridad de entidad.
--       Los atributos multivaluados declaran PK compuesta
--       (entidad + valor del atributo).
--
--  2) INTEGRIDAD DE DOMINIO
--     NOT NULL en todo atributo obligatorio.
--      CHECK con lista blanca (IN) para los atributos cuyo
--       dominio es enumerado: MetodoPago, ViaAdministracion,
--       TipoDeControl, Clasificacion, Turno, TipoProcedimiento.
--      CHECK con patron (operador ~ / ~*) para RFC, Cedula
--       Profesional, correo, telefono, numero de tarjeta, horario.
--      CHECK de rango para precios, cantidades, porcentajes,
--       stock, numero de cuartos, fechas.
--     DEFAULT para booleanos y campos de bitacora.
--      UNIQUE en atributos con unicidad natural (Usuario, RFC).
--      Las reglas se verifican automaticamente en INSERT y en
--       UPDATE (comportamiento estandar de PostgreSQL).
--
--  3) INTEGRIDAD REFERENCIAL
--      Toda llave foranea declara politica explicita
--       ON DELETE … ON UPDATE … (ninguna queda en el default
--       NO ACTION para evitar ambiguedad).
--      CONSULTA.IDMedico referencia MEDICO (no PERSONAL): la
--       propia FK garantiza que solo un medico puede aparecer
--       como medico.  Lo mismo aplica para CONSULTA.IDEnfermera
--       ENFERMERA, PREPARAR.IDPersonal  FARMACEUTICO y
--       USAR.IDPersonal  FARMACEUTICO.
--      Reglas generales:
--         ON UPDATE CASCADE:  las PKs deberian ser estables,
--                                pero si llegan a cambiar se
--                                propagan a los hijos.
--         ON DELETE RESTRICT:  no se permite eliminar entidades
--                                que aun tienen historial
--                                (TICKET, CONSULTA, MEDICAMENTO,
--                                INSUMO, PERSONAL, SUCURSAL, …).
--         ON DELETE CASCADE:   para atributos multivaluados,
--                                especializaciones y tablas que
--                                solo tienen sentido si el padre
--                                existe (CORREO_*, TELEFONO_*,
--                                HORARIO_*, COMPRAR  TICKET,
--                                PEDIR  RECETA, GENERAR_CONSULTA_RECETA).
--         ON DELETE SET NULL:  solo para FKs opcionales
--                                (CONSULTA.IDEnfermera).

--  Limpieza del esquema
DROP TABLE IF EXISTS
    GENERAR_CONSULTA_RECETA,
    PEDIR,
    RECETA_MEDICA,
    CONSULTA,
    COMPRAR,
    TICKET,
    UTILIZAR,
    USAR,
    PREPARAR,
    PROVEER_INSUMO,
    PROVEER_MEDICAMENTO,
    MEDICAMENTO,
    TELEFONO_SUCURSAL,
    HORARIO_CLINICA,
    CLINICA,
    FARMACEUTICO,
    CUIDADOR,
    LIMPIEZA,
    CAJERO,
    ENFERMERA,
    MEDICO,
    TELEFONO_PERSONAL,
    CORREO_PERSONAL,
    HORARIO_PERSONAL,
    INSUMO,
    TELEFONO_PROVEEDOR,
    CORREO_CLIENTE,
    TELEFONO_CLIENTE,
    PERSONAL,
    PROVEEDOR,
    SUCURSAL,
    CLIENTE
CASCADE;

-- 1
CREATE TABLE CLIENTE (
    IDCliente          INT,
    Nombre             VARCHAR(80),
    ApellidoPaterno    VARCHAR(80),
    ApellidoMaterno    VARCHAR(80),
    FechaNacimiento    DATE,
    Calle              VARCHAR(100),
    NumExterior        VARCHAR(10),
    NumInterior        VARCHAR(10),
    Colonia            VARCHAR(100),
    Estado             VARCHAR(80),
    MetodoPago         VARCHAR(50),
    NumeroTarjeta      VARCHAR(20),
    VencimientoTarjeta DATE,
    Usuario            VARCHAR(60),
    Contrasena         VARCHAR(255),
    EsClienteEnLinea   BOOLEAN DEFAULT FALSE,
    EsClienteFisico    BOOLEAN DEFAULT FALSE,
    EsPaciente         BOOLEAN DEFAULT FALSE
);

-- 2
CREATE TABLE SUCURSAL (
    IDSucursal  INT,
    Nombre      VARCHAR(120),
    Calle       VARCHAR(100),
    NumExterior VARCHAR(10),
    NumInterior VARCHAR(10),
    Colonia     VARCHAR(100),
    Estado      VARCHAR(80)
);

-- 3
CREATE TABLE PROVEEDOR (
    IDProveedor INT,
    RazonSocial VARCHAR(150),
    Calle       VARCHAR(100),
    NumExterior VARCHAR(10),
    NumInterior VARCHAR(10),
    Colonia     VARCHAR(100),
    Estado      VARCHAR(80)
);

-- 4
CREATE TABLE PERSONAL (
    IDPersonal        INT,
    IDSucursal        INT,
    Nombre            VARCHAR(80),
    ApellidoPaterno   VARCHAR(80),
    ApellidoMaterno   VARCHAR(80),
    CedulaProfesional VARCHAR(8),
    RFC               VARCHAR(13),
    Calle             VARCHAR(100),
    NumExterior       VARCHAR(10),
    NumInterior       VARCHAR(10),
    Colonia           VARCHAR(100),
    Estado            VARCHAR(80),
    Salario           DECIMAL(10,2)
);

-- 5
CREATE TABLE CORREO_CLIENTE (
    IDCliente         INT,
    CorreoElectronico VARCHAR(255)
);

-- 6
CREATE TABLE TELEFONO_CLIENTE (
    IDCliente INT,
    Telefono  VARCHAR(20)
);

-- 7
CREATE TABLE TELEFONO_PROVEEDOR (
    IDProveedor INT,
    Telefono    VARCHAR(20)
);

-- 8  (FechaCaducidad vive en PROVEER_INSUMO)
CREATE TABLE INSUMO (
    NombreCientifico      VARCHAR(150),
    Presentacion          VARCHAR(100),
    FormaFarmaceutica     VARCHAR(80),
    Concentracion         VARCHAR(60),
    ViaAdministracion     VARCHAR(80),
    Clasificacion         VARCHAR(60),
    Descripcion           TEXT,
    LaboratorioFabricante VARCHAR(150),
    NombreComercial       VARCHAR(150),
    TipoDeControl         VARCHAR(60),
    PrecioPublico         DECIMAL(10,2),
    PrecioUnitario        DECIMAL(10,2)
);

-- 9
CREATE TABLE HORARIO_PERSONAL (
    IDPersonal INT,
    Horario    VARCHAR(60)
);

-- 10
CREATE TABLE CORREO_PERSONAL (
    IDPersonal        INT,
    CorreoElectronico VARCHAR(255)
);

-- 11
CREATE TABLE TELEFONO_PERSONAL (
    IDPersonal INT,
    Telefono   VARCHAR(20)
);

-- 12
CREATE TABLE MEDICO (
    IDPersonal            INT,
    Especialidad          VARCHAR(100),
    InstitucionEgreso     VARCHAR(150),
    VigenciaCertificacion DATE
);

-- 13
CREATE TABLE ENFERMERA (
    IDPersonal             INT,
    CertificadoReanimacion VARCHAR(60),
    TipoProcedimiento      VARCHAR(100)
);

-- 14
CREATE TABLE CAJERO (
    IDPersonal INT
);

-- 15
CREATE TABLE LIMPIEZA (
    IDPersonal INT
);

-- 16
CREATE TABLE CUIDADOR (
    IDPersonal INT
);

-- 17
CREATE TABLE FARMACEUTICO (
    IDPersonal INT
);

-- 18
CREATE TABLE CLINICA (
    IDClinica  INT,
    IDSucursal INT,
    Nombre     VARCHAR(150),
    NumCuartos INT
);

-- 19
CREATE TABLE HORARIO_CLINICA (
    IDClinica INT,
    Horario   VARCHAR(60)
);

-- 20
CREATE TABLE TELEFONO_SUCURSAL (
    IDSucursal INT,
    Telefono   VARCHAR(20)
);

-- 21
CREATE TABLE MEDICAMENTO (
    IDMedicamento         INT,
    PrecioPublico         DECIMAL(10,2),
    PrecioUnitario        DECIMAL(10,2),
    MedicamentosEsteriles BOOLEAN DEFAULT FALSE,
    Preparaciones         TEXT,
    Formulacion           TEXT,
    PreparadosOficiales   BOOLEAN DEFAULT FALSE,
    Pediatrica            BOOLEAN DEFAULT FALSE,
    Dermatologica         BOOLEAN DEFAULT FALSE,
    Stock                 INT     DEFAULT 100
);

-- 22  PROVEER_MEDICAMENTO (ternaria)
CREATE TABLE PROVEER_MEDICAMENTO (
    IDProveedor               INT,
    IDMedicamento             INT,
    IDSucursal                INT,
    CondicionDeAlmacenamiento VARCHAR(200),
    Cantidad                  INT,
    FechaDeRecibo             DATE,
    FechaDeCaducidad          DATE
);

-- 23  PROVEER_INSUMO (ternaria)
CREATE TABLE PROVEER_INSUMO (
    IDProveedor               INT,
    IDSucursal                INT,
    NombreCientifico          VARCHAR(150),
    CondicionDeAlmacenamiento VARCHAR(200),
    Cantidad                  INT,
    FechaDeRecibo             DATE,
    FechaDeCaducidad          DATE
);

-- 24  PREPARAR (M:N FARMACEUTICO ↔ MEDICAMENTO)
CREATE TABLE PREPARAR (
    IDMedicamento INT,
    IDPersonal    INT,
    Cantidad      INT
);

-- 25  USAR (M:N FARMACEUTICO ↔ INSUMO)
CREATE TABLE USAR (
    IDPersonal       INT,
    NombreCientifico VARCHAR(150)
);

-- 26  UTILIZAR (M:N MEDICAMENTO ↔ INSUMO)
CREATE TABLE UTILIZAR (
    IDMedicamento    INT,
    NombreCientifico VARCHAR(150)
);

-- 27  TICKET
CREATE TABLE TICKET (
    IDTicket          INT,
    IDSucursal        INT,
    IDCliente         INT,
    Fecha             DATE          DEFAULT CURRENT_DATE,
    Hora              TIME          DEFAULT CURRENT_TIME,
    PrecioBruto       DECIMAL(12,2) DEFAULT 0,
    PrecioNeto        DECIMAL(12,2) DEFAULT 0,
    DescuentoAplicado DECIMAL(5,2)  DEFAULT 0
);

-- 28  COMPRAR (M:N TICKET ↔ MEDICAMENTO)
CREATE TABLE COMPRAR (
    IDTicket      INT,
    IDMedicamento INT,
    Cantidad      INT
);

-- 29  CONSULTA
CREATE TABLE CONSULTA (
    IDConsulta    INT,
    IDCliente     INT,
    IDMedico      INT,
    IDEnfermera   INT,
    IDClinica     INT,
    IDTicket      INT,
    Fecha         DATE,
    Hora          TIME,
    Diagnostico   TEXT,
    CostoConsulta DECIMAL(10,2)
);

-- 30  RECETA_MEDICA
CREATE TABLE RECETA_MEDICA (
    NumeroReceta    INT,
    FechaNacimiento DATE,
    Peso            DECIMAL(5,2),
    Talla           DECIMAL(4,2),
    Alergias        TEXT,
    Diagnostico     TEXT,
    Consultorio     VARCHAR(60),
    Turno           VARCHAR(30)
);

-- 31  PEDIR (M:N RECETA ↔ MEDICAMENTO)
CREATE TABLE PEDIR (
    NumeroReceta  INT,
    IDMedicamento INT,
    Dosis         VARCHAR(100),
    Frecuencia    VARCHAR(80)
);

-- 32  GENERAR_CONSULTA_RECETA (1:1 total-total)
CREATE TABLE GENERAR_CONSULTA_RECETA (
    IDConsulta   INT,
    NumeroReceta INT
);

--  INTEGRIDAD DE ENTIDAD — PRIMARY KEYs

-- Entidades fuertes
ALTER TABLE CLIENTE       ADD CONSTRAINT PK_Cliente       PRIMARY KEY (IDCliente);
ALTER TABLE SUCURSAL      ADD CONSTRAINT PK_Sucursal      PRIMARY KEY (IDSucursal);
ALTER TABLE PROVEEDOR     ADD CONSTRAINT PK_Proveedor     PRIMARY KEY (IDProveedor);
ALTER TABLE PERSONAL      ADD CONSTRAINT PK_Personal      PRIMARY KEY (IDPersonal);
ALTER TABLE INSUMO        ADD CONSTRAINT PK_Insumo        PRIMARY KEY (NombreCientifico);
ALTER TABLE MEDICAMENTO   ADD CONSTRAINT PK_Medicamento   PRIMARY KEY (IDMedicamento);
ALTER TABLE CLINICA       ADD CONSTRAINT PK_Clinica       PRIMARY KEY (IDClinica);
ALTER TABLE TICKET        ADD CONSTRAINT PK_Ticket        PRIMARY KEY (IDTicket);
ALTER TABLE CONSULTA      ADD CONSTRAINT PK_Consulta      PRIMARY KEY (IDConsulta);
ALTER TABLE RECETA_MEDICA ADD CONSTRAINT PK_Receta        PRIMARY KEY (NumeroReceta);

-- Especializaciones (1:1 con PERSONAL)
ALTER TABLE MEDICO       ADD CONSTRAINT PK_Medico       PRIMARY KEY (IDPersonal);
ALTER TABLE ENFERMERA    ADD CONSTRAINT PK_Enfermera    PRIMARY KEY (IDPersonal);
ALTER TABLE CAJERO       ADD CONSTRAINT PK_Cajero       PRIMARY KEY (IDPersonal);
ALTER TABLE LIMPIEZA     ADD CONSTRAINT PK_Limpieza     PRIMARY KEY (IDPersonal);
ALTER TABLE CUIDADOR     ADD CONSTRAINT PK_Cuidador     PRIMARY KEY (IDPersonal);
ALTER TABLE FARMACEUTICO ADD CONSTRAINT PK_Farmaceutico PRIMARY KEY (IDPersonal);

-- Atributos multivaluados (entidad + valor)
ALTER TABLE CORREO_CLIENTE     ADD CONSTRAINT PK_CorreoCliente   PRIMARY KEY (IDCliente, CorreoElectronico);
ALTER TABLE TELEFONO_CLIENTE   ADD CONSTRAINT PK_TelCliente      PRIMARY KEY (IDCliente, Telefono);
ALTER TABLE TELEFONO_PROVEEDOR ADD CONSTRAINT PK_TelProveedor    PRIMARY KEY (IDProveedor, Telefono);
ALTER TABLE HORARIO_PERSONAL   ADD CONSTRAINT PK_HorarioPersonal PRIMARY KEY (IDPersonal, Horario);
ALTER TABLE CORREO_PERSONAL    ADD CONSTRAINT PK_CorreoPersonal  PRIMARY KEY (IDPersonal, CorreoElectronico);
ALTER TABLE TELEFONO_PERSONAL  ADD CONSTRAINT PK_TelPersonal     PRIMARY KEY (IDPersonal, Telefono);
ALTER TABLE HORARIO_CLINICA    ADD CONSTRAINT PK_HorarioClinica  PRIMARY KEY (IDClinica, Horario);
ALTER TABLE TELEFONO_SUCURSAL  ADD CONSTRAINT PK_TelSucursal     PRIMARY KEY (IDSucursal, Telefono);

-- Relaciones M:N — PK compuesta sobre los participantes
ALTER TABLE COMPRAR  ADD CONSTRAINT PK_Comprar  PRIMARY KEY (IDTicket, IDMedicamento);
ALTER TABLE PEDIR    ADD CONSTRAINT PK_Pedir    PRIMARY KEY (NumeroReceta, IDMedicamento);
ALTER TABLE PREPARAR ADD CONSTRAINT PK_Preparar PRIMARY KEY (IDMedicamento, IDPersonal);
ALTER TABLE USAR     ADD CONSTRAINT PK_Usar     PRIMARY KEY (IDPersonal, NombreCientifico);
ALTER TABLE UTILIZAR ADD CONSTRAINT PK_Utilizar PRIMARY KEY (IDMedicamento, NombreCientifico);

-- Relaciones ternarias — la fecha de recibo distingue lotes
ALTER TABLE PROVEER_MEDICAMENTO
    ADD CONSTRAINT PK_ProveerMed
    PRIMARY KEY (IDProveedor, IDMedicamento, IDSucursal, FechaDeRecibo);

ALTER TABLE PROVEER_INSUMO
    ADD CONSTRAINT PK_ProveerIns
    PRIMARY KEY (IDProveedor, IDSucursal, NombreCientifico, FechaDeRecibo);

-- 1:1 total-total — PK compuesta + UNIQUE en cada lado para
-- forzar cardinalidad uno-a-uno
ALTER TABLE GENERAR_CONSULTA_RECETA
    ADD CONSTRAINT PK_GCR PRIMARY KEY (IDConsulta, NumeroReceta);
ALTER TABLE GENERAR_CONSULTA_RECETA
    ADD CONSTRAINT UQ_GCR_Consulta UNIQUE (IDConsulta);
ALTER TABLE GENERAR_CONSULTA_RECETA
    ADD CONSTRAINT UQ_GCR_Receta   UNIQUE (NumeroReceta);

-- Unicidad de TICKET en CONSULTA — la relacion TICKET–CONSULTA
-- es 1:1 via CONSULTA.IDTicket
ALTER TABLE CONSULTA ADD CONSTRAINT UQ_ConsultaTicket UNIQUE (IDTicket);


--  INTEGRIDAD DE DOMINIO — NOT NULL, UNIQUE, CHECK

-- --------- CLIENTE ----------
ALTER TABLE CLIENTE ALTER COLUMN Nombre           SET NOT NULL;
ALTER TABLE CLIENTE ALTER COLUMN ApellidoPaterno  SET NOT NULL;
ALTER TABLE CLIENTE ALTER COLUMN ApellidoMaterno  SET NOT NULL;
ALTER TABLE CLIENTE ALTER COLUMN FechaNacimiento  SET NOT NULL;
ALTER TABLE CLIENTE ALTER COLUMN EsClienteEnLinea SET NOT NULL;
ALTER TABLE CLIENTE ALTER COLUMN EsClienteFisico  SET NOT NULL;
ALTER TABLE CLIENTE ALTER COLUMN EsPaciente       SET NOT NULL;

-- Unicidad de usuario
ALTER TABLE CLIENTE ADD CONSTRAINT UQ_Usuario UNIQUE (Usuario);

-- FechaNacimiento debe estar en el pasado
ALTER TABLE CLIENTE ADD CONSTRAINT chk_cli_nacimiento
    CHECK (FechaNacimiento <= CURRENT_DATE);

-- MetodoPago: dominio enumerado (NULL permitido si el cliente
-- no ha registrado metodo)
ALTER TABLE CLIENTE ADD CONSTRAINT chk_cli_metodopago
    CHECK (MetodoPago IS NULL OR MetodoPago IN
        ('Efectivo', 'Tarjeta de Credito', 'Tarjeta de Debito',
         'Transferencia', 'Vales'));

-- NumeroTarjeta: 13 a 19 digitos (Visa, MasterCard, AmEx, …)
ALTER TABLE CLIENTE ADD CONSTRAINT chk_cli_tarjeta
    CHECK (NumeroTarjeta IS NULL OR NumeroTarjeta ~ '^[0-9]{13,19}$');

-- Vencimiento de tarjeta no puede ser pasado
ALTER TABLE CLIENTE ADD CONSTRAINT chk_cli_vencimiento
    CHECK (VencimientoTarjeta IS NULL OR VencimientoTarjeta >= CURRENT_DATE);

-- Coherencia: si declara MetodoPago Tarjeta… debe tener numero
-- y vencimiento
ALTER TABLE CLIENTE ADD CONSTRAINT chk_cli_tarjeta_requerida
    CHECK (
        MetodoPago NOT IN ('Tarjeta de Credito', 'Tarjeta de Debito')
        OR (NumeroTarjeta IS NOT NULL AND VencimientoTarjeta IS NOT NULL)
    );

-- Al menos uno de los tres roles de cliente debe ser TRUE
ALTER TABLE CLIENTE ADD CONSTRAINT chk_cli_tipo
    CHECK (EsClienteEnLinea OR EsClienteFisico OR EsPaciente);

-- --------- SUCURSAL ----------
ALTER TABLE SUCURSAL ALTER COLUMN Nombre SET NOT NULL;
ALTER TABLE SUCURSAL ALTER COLUMN Calle  SET NOT NULL;
ALTER TABLE SUCURSAL ALTER COLUMN Estado SET NOT NULL;

-- --------- PROVEEDOR ----------
ALTER TABLE PROVEEDOR ALTER COLUMN RazonSocial SET NOT NULL;
ALTER TABLE PROVEEDOR ALTER COLUMN Estado      SET NOT NULL;

-- --------- PERSONAL ----------
ALTER TABLE PERSONAL ALTER COLUMN Nombre          SET NOT NULL;
ALTER TABLE PERSONAL ALTER COLUMN ApellidoPaterno SET NOT NULL;
ALTER TABLE PERSONAL ALTER COLUMN ApellidoMaterno SET NOT NULL;
ALTER TABLE PERSONAL ALTER COLUMN IDSucursal      SET NOT NULL;
ALTER TABLE PERSONAL ALTER COLUMN RFC             SET NOT NULL;
ALTER TABLE PERSONAL ALTER COLUMN Salario         SET NOT NULL;

ALTER TABLE PERSONAL ADD CONSTRAINT UQ_RFC UNIQUE (RFC);

-- RFC: 13 caracteres con el formato oficial mexicano (persona
-- fisica: 4 letras + 6 digitos + 3 alfanum; persona moral: 3
-- letras + 6 digitos + 3 alfanum). Aceptamos ambas variantes.
ALTER TABLE PERSONAL ADD CONSTRAINT chk_per_rfc
    CHECK (RFC ~ '^[A-ZÑ&]{3,4}[0-9]{6}[A-Z0-9]{3}$');

-- Cedula profesional: 7 u 8 digitos
ALTER TABLE PERSONAL ADD CONSTRAINT chk_per_cedula
    CHECK (CedulaProfesional IS NULL OR CedulaProfesional ~ '^[0-9]{7,8}$');

ALTER TABLE PERSONAL ADD CONSTRAINT chk_per_salario
    CHECK (Salario >= 0);

-- --------- CORREO_CLIENTE / CORREO_PERSONAL ----------
ALTER TABLE CORREO_CLIENTE ADD CONSTRAINT chk_corcli_formato
    CHECK (CorreoElectronico ~* '^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$');
ALTER TABLE CORREO_PERSONAL ADD CONSTRAINT chk_corper_formato
    CHECK (CorreoElectronico ~* '^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$');

-- --------- TELEFONO_* ----------
-- Telefono mexicano: 10 digitos numericos (sin formato).
ALTER TABLE TELEFONO_CLIENTE   ADD CONSTRAINT chk_telcli_formato
    CHECK (Telefono ~ '^[0-9]{10}$');
ALTER TABLE TELEFONO_PROVEEDOR ADD CONSTRAINT chk_telprov_formato
    CHECK (Telefono ~ '^[0-9]{10}$');
ALTER TABLE TELEFONO_PERSONAL  ADD CONSTRAINT chk_telper_formato
    CHECK (Telefono ~ '^[0-9]{10}$');
ALTER TABLE TELEFONO_SUCURSAL  ADD CONSTRAINT chk_telsuc_formato
    CHECK (Telefono ~ '^[0-9]{10}$');

-- --------- HORARIO_* ----------
-- Formato HH:MM-HH:MM (24 h)
ALTER TABLE HORARIO_PERSONAL ADD CONSTRAINT chk_horper_formato
    CHECK (Horario ~ '^([01][0-9]|2[0-3]):[0-5][0-9]-([01][0-9]|2[0-3]):[0-5][0-9]$');
ALTER TABLE HORARIO_CLINICA  ADD CONSTRAINT chk_horcli_formato
    CHECK (Horario ~ '^([01][0-9]|2[0-3]):[0-5][0-9]-([01][0-9]|2[0-3]):[0-5][0-9]$');

-- --------- INSUMO ----------
ALTER TABLE INSUMO ALTER COLUMN Presentacion      SET NOT NULL;
ALTER TABLE INSUMO ALTER COLUMN FormaFarmaceutica SET NOT NULL;
ALTER TABLE INSUMO ALTER COLUMN PrecioPublico     SET NOT NULL;
ALTER TABLE INSUMO ALTER COLUMN PrecioUnitario    SET NOT NULL;

ALTER TABLE INSUMO ADD CONSTRAINT chk_ins_precios
    CHECK (PrecioPublico >= 0 AND PrecioUnitario >= 0);

-- ViaAdministracion: dominio enumerado (NOM-072-SSA1)
ALTER TABLE INSUMO ADD CONSTRAINT chk_ins_via
    CHECK (ViaAdministracion IS NULL OR ViaAdministracion IN
        ('Oral', 'Sublingual', 'Bucal', 'Topica', 'Oftalmica',
         'Otica', 'Nasal', 'Inhalada', 'Rectal', 'Vaginal',
         'Intravenosa', 'Intramuscular', 'Subcutanea',
         'Intradermica', 'Intratecal', 'Intraarticular',
         'Transdermica', 'Otra'));

-- Clasificacion: principio activo / excipiente / otro
ALTER TABLE INSUMO ADD CONSTRAINT chk_ins_clasif
    CHECK (Clasificacion IS NULL OR Clasificacion IN
        ('Activo', 'Excipiente', 'Vehiculo', 'Otro'));

-- TipoDeControl: clasificacion COFEPRIS de sustancias
ALTER TABLE INSUMO ADD CONSTRAINT chk_ins_control
    CHECK (TipoDeControl IS NULL OR TipoDeControl IN
        ('Grupo I', 'Grupo II', 'Grupo III', 'Grupo IV',
         'Grupo V', 'Grupo VI', 'Libre venta'));

-- --------- MEDICAMENTO ----------
ALTER TABLE MEDICAMENTO ALTER COLUMN PrecioPublico         SET NOT NULL;
ALTER TABLE MEDICAMENTO ALTER COLUMN PrecioUnitario        SET NOT NULL;
ALTER TABLE MEDICAMENTO ALTER COLUMN Stock                 SET NOT NULL;
ALTER TABLE MEDICAMENTO ALTER COLUMN MedicamentosEsteriles SET NOT NULL;
ALTER TABLE MEDICAMENTO ALTER COLUMN PreparadosOficiales   SET NOT NULL;
ALTER TABLE MEDICAMENTO ALTER COLUMN Pediatrica            SET NOT NULL;
ALTER TABLE MEDICAMENTO ALTER COLUMN Dermatologica         SET NOT NULL;

ALTER TABLE MEDICAMENTO ADD CONSTRAINT chk_med_precios
    CHECK (PrecioPublico >= 0 AND PrecioUnitario >= 0);
ALTER TABLE MEDICAMENTO ADD CONSTRAINT chk_med_publico_ge_unit
    CHECK (PrecioPublico >= PrecioUnitario);
ALTER TABLE MEDICAMENTO ADD CONSTRAINT chk_med_stock
    CHECK (Stock >= 0);

-- --------- MEDICO ----------
ALTER TABLE MEDICO ALTER COLUMN Especialidad          SET NOT NULL;
ALTER TABLE MEDICO ALTER COLUMN InstitucionEgreso     SET NOT NULL;
ALTER TABLE MEDICO ALTER COLUMN VigenciaCertificacion SET NOT NULL;
ALTER TABLE MEDICO ADD CONSTRAINT chk_med_vigencia
    CHECK (VigenciaCertificacion >= CURRENT_DATE);

-- --------- ENFERMERA ----------
ALTER TABLE ENFERMERA ALTER COLUMN TipoProcedimiento SET NOT NULL;
ALTER TABLE ENFERMERA ADD CONSTRAINT chk_enf_procedimiento
    CHECK (TipoProcedimiento IN
        ('Quirurgico', 'No quirurgico', 'Especializado',
         'General', 'Pediatrico', 'Geriatrico', 'Urgencias'));

-- --------- CLINICA ----------
ALTER TABLE CLINICA ALTER COLUMN Nombre     SET NOT NULL;
ALTER TABLE CLINICA ALTER COLUMN IDSucursal SET NOT NULL;
ALTER TABLE CLINICA ALTER COLUMN NumCuartos SET NOT NULL;
ALTER TABLE CLINICA ADD CONSTRAINT chk_cli_numcuartos
    CHECK (NumCuartos > 0);

-- --------- PROVEER_INSUMO ----------
ALTER TABLE PROVEER_INSUMO ALTER COLUMN Cantidad         SET NOT NULL;
ALTER TABLE PROVEER_INSUMO ALTER COLUMN FechaDeRecibo    SET NOT NULL;
ALTER TABLE PROVEER_INSUMO ALTER COLUMN FechaDeCaducidad SET NOT NULL;
ALTER TABLE PROVEER_INSUMO ADD CONSTRAINT chk_pi_cantidad
    CHECK (Cantidad > 0);
ALTER TABLE PROVEER_INSUMO ADD CONSTRAINT chk_pi_fechas
    CHECK (FechaDeCaducidad > FechaDeRecibo);
ALTER TABLE PROVEER_INSUMO ADD CONSTRAINT chk_pi_caducidad
    CHECK (FechaDeCaducidad >= CURRENT_DATE);

-- --------- PROVEER_MEDICAMENTO ----------
ALTER TABLE PROVEER_MEDICAMENTO ALTER COLUMN Cantidad         SET NOT NULL;
ALTER TABLE PROVEER_MEDICAMENTO ALTER COLUMN FechaDeRecibo    SET NOT NULL;
ALTER TABLE PROVEER_MEDICAMENTO ALTER COLUMN FechaDeCaducidad SET NOT NULL;
ALTER TABLE PROVEER_MEDICAMENTO ADD CONSTRAINT chk_pm_cantidad
    CHECK (Cantidad > 0);
ALTER TABLE PROVEER_MEDICAMENTO ADD CONSTRAINT chk_pm_fechas
    CHECK (FechaDeCaducidad > FechaDeRecibo);
ALTER TABLE PROVEER_MEDICAMENTO ADD CONSTRAINT chk_pm_caducidad
    CHECK (FechaDeCaducidad >= CURRENT_DATE);

-- --------- PREPARAR ----------
ALTER TABLE PREPARAR ALTER COLUMN Cantidad SET NOT NULL;
ALTER TABLE PREPARAR ADD CONSTRAINT chk_prep_cantidad
    CHECK (Cantidad > 0);

-- --------- COMPRAR ----------
ALTER TABLE COMPRAR ALTER COLUMN Cantidad SET NOT NULL;
ALTER TABLE COMPRAR ADD CONSTRAINT chk_comp_cantidad
    CHECK (Cantidad > 0);

-- --------- TICKET ----------
ALTER TABLE TICKET ALTER COLUMN IDSucursal        SET NOT NULL;
ALTER TABLE TICKET ALTER COLUMN IDCliente         SET NOT NULL;
ALTER TABLE TICKET ALTER COLUMN Fecha             SET NOT NULL;
ALTER TABLE TICKET ALTER COLUMN Hora              SET NOT NULL;
ALTER TABLE TICKET ALTER COLUMN PrecioBruto       SET NOT NULL;
ALTER TABLE TICKET ALTER COLUMN PrecioNeto        SET NOT NULL;
ALTER TABLE TICKET ALTER COLUMN DescuentoAplicado SET NOT NULL;

ALTER TABLE TICKET ADD CONSTRAINT chk_tic_precios
    CHECK (PrecioBruto >= 0 AND PrecioNeto >= 0);
ALTER TABLE TICKET ADD CONSTRAINT chk_tic_neto_le_bruto
    CHECK (PrecioNeto <= PrecioBruto);
ALTER TABLE TICKET ADD CONSTRAINT chk_tic_descuento
    CHECK (DescuentoAplicado >= 0 AND DescuentoAplicado <= 100);
ALTER TABLE TICKET ADD CONSTRAINT chk_tic_fecha
    CHECK (Fecha <= CURRENT_DATE);

-- --------- CONSULTA ----------
ALTER TABLE CONSULTA ALTER COLUMN IDCliente SET NOT NULL;
ALTER TABLE CONSULTA ALTER COLUMN IDMedico  SET NOT NULL;
ALTER TABLE CONSULTA ALTER COLUMN IDClinica SET NOT NULL;
ALTER TABLE CONSULTA ALTER COLUMN IDTicket  SET NOT NULL;
ALTER TABLE CONSULTA ALTER COLUMN Fecha     SET NOT NULL;
ALTER TABLE CONSULTA ALTER COLUMN Hora      SET NOT NULL;
ALTER TABLE CONSULTA ADD CONSTRAINT chk_con_costo
    CHECK (CostoConsulta IS NULL OR CostoConsulta >= 0);

-- --------- RECETA_MEDICA ----------
ALTER TABLE RECETA_MEDICA ALTER COLUMN FechaNacimiento SET NOT NULL;
ALTER TABLE RECETA_MEDICA ALTER COLUMN Consultorio     SET NOT NULL;
ALTER TABLE RECETA_MEDICA ALTER COLUMN Turno           SET NOT NULL;
ALTER TABLE RECETA_MEDICA ADD CONSTRAINT chk_rec_peso  CHECK (Peso  > 0);
ALTER TABLE RECETA_MEDICA ADD CONSTRAINT chk_rec_talla CHECK (Talla > 0);
ALTER TABLE RECETA_MEDICA ADD CONSTRAINT chk_rec_turno
    CHECK (Turno IN ('Matutino', 'Vespertino', 'Nocturno', 'Mixto'));
ALTER TABLE RECETA_MEDICA ADD CONSTRAINT chk_rec_nacimiento
    CHECK (FechaNacimiento <= CURRENT_DATE);

-- --------- PEDIR ----------
ALTER TABLE PEDIR ALTER COLUMN Dosis      SET NOT NULL;
ALTER TABLE PEDIR ALTER COLUMN Frecuencia SET NOT NULL;


--  INTEGRIDAD REFERENCIAL — FOREIGN KEYs

-- PERSONAL → SUCURSAL
ALTER TABLE PERSONAL
    ADD CONSTRAINT FK_PersonalSucursal FOREIGN KEY (IDSucursal)
    REFERENCES SUCURSAL (IDSucursal)
    ON DELETE RESTRICT ON UPDATE CASCADE;

-- Multivaluados de CLIENTE
ALTER TABLE CORREO_CLIENTE
    ADD CONSTRAINT FK_CorreoCliente FOREIGN KEY (IDCliente)
    REFERENCES CLIENTE (IDCliente)
    ON DELETE CASCADE  ON UPDATE CASCADE;

ALTER TABLE TELEFONO_CLIENTE
    ADD CONSTRAINT FK_TelCliente FOREIGN KEY (IDCliente)
    REFERENCES CLIENTE (IDCliente)
    ON DELETE CASCADE  ON UPDATE CASCADE;

-- Multivaluado de PROVEEDOR
ALTER TABLE TELEFONO_PROVEEDOR
    ADD CONSTRAINT FK_TelProveedor FOREIGN KEY (IDProveedor)
    REFERENCES PROVEEDOR (IDProveedor)
    ON DELETE CASCADE  ON UPDATE CASCADE;

-- Multivaluados de PERSONAL
ALTER TABLE HORARIO_PERSONAL
    ADD CONSTRAINT FK_HorPersonal FOREIGN KEY (IDPersonal)
    REFERENCES PERSONAL (IDPersonal)
    ON DELETE CASCADE  ON UPDATE CASCADE;

ALTER TABLE CORREO_PERSONAL
    ADD CONSTRAINT FK_CorPersonal FOREIGN KEY (IDPersonal)
    REFERENCES PERSONAL (IDPersonal)
    ON DELETE CASCADE  ON UPDATE CASCADE;

ALTER TABLE TELEFONO_PERSONAL
    ADD CONSTRAINT FK_TelPersonal FOREIGN KEY (IDPersonal)
    REFERENCES PERSONAL (IDPersonal)
    ON DELETE CASCADE  ON UPDATE CASCADE;

-- Especializaciones de PERSONAL (1:1)
ALTER TABLE MEDICO
    ADD CONSTRAINT FK_Medico FOREIGN KEY (IDPersonal)
    REFERENCES PERSONAL (IDPersonal)
    ON DELETE CASCADE  ON UPDATE CASCADE;

ALTER TABLE ENFERMERA
    ADD CONSTRAINT FK_Enfermera FOREIGN KEY (IDPersonal)
    REFERENCES PERSONAL (IDPersonal)
    ON DELETE CASCADE  ON UPDATE CASCADE;

ALTER TABLE CAJERO
    ADD CONSTRAINT FK_Cajero FOREIGN KEY (IDPersonal)
    REFERENCES PERSONAL (IDPersonal)
    ON DELETE CASCADE  ON UPDATE CASCADE;

ALTER TABLE LIMPIEZA
    ADD CONSTRAINT FK_Limpieza FOREIGN KEY (IDPersonal)
    REFERENCES PERSONAL (IDPersonal)
    ON DELETE CASCADE  ON UPDATE CASCADE;

ALTER TABLE CUIDADOR
    ADD CONSTRAINT FK_Cuidador FOREIGN KEY (IDPersonal)
    REFERENCES PERSONAL (IDPersonal)
    ON DELETE CASCADE  ON UPDATE CASCADE;

ALTER TABLE FARMACEUTICO
    ADD CONSTRAINT FK_Farmaceutico FOREIGN KEY (IDPersonal)
    REFERENCES PERSONAL (IDPersonal)
    ON DELETE CASCADE  ON UPDATE CASCADE;

-- CLINICA → SUCURSAL y multivaluado HORARIO_CLINICA
ALTER TABLE CLINICA
    ADD CONSTRAINT FK_ClinicaSucursal FOREIGN KEY (IDSucursal)
    REFERENCES SUCURSAL (IDSucursal)
    ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE HORARIO_CLINICA
    ADD CONSTRAINT FK_HorClinica FOREIGN KEY (IDClinica)
    REFERENCES CLINICA (IDClinica)
    ON DELETE CASCADE  ON UPDATE CASCADE;

ALTER TABLE TELEFONO_SUCURSAL
    ADD CONSTRAINT FK_TelSucursal FOREIGN KEY (IDSucursal)
    REFERENCES SUCURSAL (IDSucursal)
    ON DELETE CASCADE  ON UPDATE CASCADE;

-- PROVEER_MEDICAMENTO (ternaria)
ALTER TABLE PROVEER_MEDICAMENTO
    ADD CONSTRAINT FK_PM_Proveedor FOREIGN KEY (IDProveedor)
    REFERENCES PROVEEDOR (IDProveedor)
    ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE PROVEER_MEDICAMENTO
    ADD CONSTRAINT FK_PM_Medicamento FOREIGN KEY (IDMedicamento)
    REFERENCES MEDICAMENTO (IDMedicamento)
    ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE PROVEER_MEDICAMENTO
    ADD CONSTRAINT FK_PM_Sucursal FOREIGN KEY (IDSucursal)
    REFERENCES SUCURSAL (IDSucursal)
    ON DELETE RESTRICT ON UPDATE CASCADE;

-- PROVEER_INSUMO (ternaria)
ALTER TABLE PROVEER_INSUMO
    ADD CONSTRAINT FK_PI_Proveedor FOREIGN KEY (IDProveedor)
    REFERENCES PROVEEDOR (IDProveedor)
    ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE PROVEER_INSUMO
    ADD CONSTRAINT FK_PI_Insumo FOREIGN KEY (NombreCientifico)
    REFERENCES INSUMO (NombreCientifico)
    ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE PROVEER_INSUMO
    ADD CONSTRAINT FK_PI_Sucursal FOREIGN KEY (IDSucursal)
    REFERENCES SUCURSAL (IDSucursal)
    ON DELETE RESTRICT ON UPDATE CASCADE;

-- PREPARAR (M:N) — IDPersonal apunta a FARMACEUTICO para
-- garantizar el rol sin necesidad de logica adicional.
ALTER TABLE PREPARAR
    ADD CONSTRAINT FK_PrepMed FOREIGN KEY (IDMedicamento)
    REFERENCES MEDICAMENTO (IDMedicamento)
    ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE PREPARAR
    ADD CONSTRAINT FK_PrepFarm FOREIGN KEY (IDPersonal)
    REFERENCES FARMACEUTICO (IDPersonal)
    ON DELETE RESTRICT ON UPDATE CASCADE;

-- USAR (M:N) — IDPersonal apunta a FARMACEUTICO por la misma
-- razon que PREPARAR.
ALTER TABLE USAR
    ADD CONSTRAINT FK_UsarFarm FOREIGN KEY (IDPersonal)
    REFERENCES FARMACEUTICO (IDPersonal)
    ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE USAR
    ADD CONSTRAINT FK_UsarIns FOREIGN KEY (NombreCientifico)
    REFERENCES INSUMO (NombreCientifico)
    ON DELETE RESTRICT ON UPDATE CASCADE;

-- UTILIZAR (M:N)
ALTER TABLE UTILIZAR
    ADD CONSTRAINT FK_UtilMed FOREIGN KEY (IDMedicamento)
    REFERENCES MEDICAMENTO (IDMedicamento)
    ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE UTILIZAR
    ADD CONSTRAINT FK_UtilIns FOREIGN KEY (NombreCientifico)
    REFERENCES INSUMO (NombreCientifico)
    ON DELETE RESTRICT ON UPDATE CASCADE;

-- TICKET
ALTER TABLE TICKET
    ADD CONSTRAINT FK_TicketSucursal FOREIGN KEY (IDSucursal)
    REFERENCES SUCURSAL (IDSucursal)
    ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE TICKET
    ADD CONSTRAINT FK_TicketCliente FOREIGN KEY (IDCliente)
    REFERENCES CLIENTE (IDCliente)
    ON DELETE RESTRICT ON UPDATE CASCADE;

-- COMPRAR (M:N TICKET ↔ MEDICAMENTO)
-- ON DELETE CASCADE en TICKET: si se borra el ticket, sus
--   lineas no tienen sentido. RESTRICT en MEDICAMENTO para
--   proteger el historial.
ALTER TABLE COMPRAR
    ADD CONSTRAINT FK_CompTicket FOREIGN KEY (IDTicket)
    REFERENCES TICKET (IDTicket)
    ON DELETE CASCADE  ON UPDATE CASCADE;

ALTER TABLE COMPRAR
    ADD CONSTRAINT FK_CompMed FOREIGN KEY (IDMedicamento)
    REFERENCES MEDICAMENTO (IDMedicamento)
    ON DELETE RESTRICT ON UPDATE CASCADE;

-- CONSULTA
ALTER TABLE CONSULTA
    ADD CONSTRAINT FK_ConCliente FOREIGN KEY (IDCliente)
    REFERENCES CLIENTE (IDCliente)
    ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE CONSULTA
    ADD CONSTRAINT FK_ConMedico FOREIGN KEY (IDMedico)
    REFERENCES MEDICO (IDPersonal)
    ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE CONSULTA
    ADD CONSTRAINT FK_ConEnfermera FOREIGN KEY (IDEnfermera)
    REFERENCES ENFERMERA (IDPersonal)
    ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE CONSULTA
    ADD CONSTRAINT FK_ConClinica FOREIGN KEY (IDClinica)
    REFERENCES CLINICA (IDClinica)
    ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE CONSULTA
    ADD CONSTRAINT FK_ConTicket FOREIGN KEY (IDTicket)
    REFERENCES TICKET (IDTicket)
    ON DELETE RESTRICT ON UPDATE CASCADE;

-- GENERAR_CONSULTA_RECETA (1:1)
ALTER TABLE GENERAR_CONSULTA_RECETA
    ADD CONSTRAINT FK_GCR_Consulta FOREIGN KEY (IDConsulta)
    REFERENCES CONSULTA (IDConsulta)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE GENERAR_CONSULTA_RECETA
    ADD CONSTRAINT FK_GCR_Receta FOREIGN KEY (NumeroReceta)
    REFERENCES RECETA_MEDICA (NumeroReceta)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- PEDIR (M:N RECETA ↔ MEDICAMENTO)
ALTER TABLE PEDIR
    ADD CONSTRAINT FK_PedReceta FOREIGN KEY (NumeroReceta)
    REFERENCES RECETA_MEDICA (NumeroReceta)
    ON DELETE CASCADE  ON UPDATE CASCADE;

ALTER TABLE PEDIR
    ADD CONSTRAINT FK_PedMed FOREIGN KEY (IDMedicamento)
    REFERENCES MEDICAMENTO (IDMedicamento)
    ON DELETE RESTRICT ON UPDATE CASCADE;


--  Comentarios (documentacion del esquema)
COMMENT ON TABLE CLIENTE IS
    'Informacion general del cliente. Restricciones: al menos uno de '
    'EsClienteEnLinea/EsClienteFisico/EsPaciente debe ser TRUE; '
    'MetodoPago en dominio enumerado; NumeroTarjeta valida 13-19 digitos; '
    'VencimientoTarjeta no puede ser fecha pasada.';

COMMENT ON TABLE SUCURSAL IS
    'Sucursales de la clinica/farmacia. ON DELETE RESTRICT impide '
    'eliminar una sucursal con personal, ticket o clinica asociados.';

COMMENT ON TABLE PROVEEDOR IS 'Proveedores. RazonSocial obligatorio.';

COMMENT ON TABLE PERSONAL IS
    'Personal de la sucursal. RFC unico y validado con patron NOM. '
    'CedulaProfesional 7-8 digitos.';

COMMENT ON TABLE CORREO_CLIENTE     IS 'Multivaluado. Formato de correo validado.';
COMMENT ON TABLE TELEFONO_CLIENTE   IS 'Multivaluado. 10 digitos numericos.';
COMMENT ON TABLE TELEFONO_PROVEEDOR IS 'Multivaluado. 10 digitos numericos.';
COMMENT ON TABLE HORARIO_PERSONAL   IS 'Multivaluado. Formato HH:MM-HH:MM (24h).';
COMMENT ON TABLE CORREO_PERSONAL    IS 'Multivaluado. Formato de correo validado.';
COMMENT ON TABLE TELEFONO_PERSONAL  IS 'Multivaluado. 10 digitos numericos.';
COMMENT ON TABLE HORARIO_CLINICA    IS 'Multivaluado. Formato HH:MM-HH:MM (24h).';
COMMENT ON TABLE TELEFONO_SUCURSAL  IS 'Multivaluado. 10 digitos numericos.';

COMMENT ON TABLE INSUMO IS
    'Insumos (sustancias activas/excipientes). FechaCaducidad por lote '
    'en PROVEER_INSUMO. ViaAdministracion, Clasificacion y TipoDeControl '
    'restringidos a dominio enumerado.';

COMMENT ON TABLE MEDICAMENTO IS
    'Medicamentos manejados por la farmacia. PrecioPublico >= PrecioUnitario '
    'y Stock >= 0 garantizados por CHECK.';

COMMENT ON TABLE MEDICO       IS 'Especializacion de PERSONAL. Referenciada por CONSULTA.IDMedico.';
COMMENT ON TABLE ENFERMERA    IS 'Especializacion de PERSONAL. TipoProcedimiento enumerado. Referenciada por CONSULTA.IDEnfermera.';
COMMENT ON TABLE CAJERO       IS 'Especializacion de PERSONAL.';
COMMENT ON TABLE LIMPIEZA     IS 'Especializacion de PERSONAL.';
COMMENT ON TABLE CUIDADOR     IS 'Especializacion de PERSONAL.';
COMMENT ON TABLE FARMACEUTICO IS 'Especializacion de PERSONAL. Referenciada por PREPARAR.IDPersonal y USAR.IDPersonal.';

COMMENT ON TABLE CLINICA IS 'Clinicas dentro de cada sucursal.';

COMMENT ON TABLE PROVEER_MEDICAMENTO IS
    'Relacion ternaria. PK compuesta incluye FechaDeRecibo para permitir '
    'multiples lotes. CHECK FechaDeCaducidad > FechaDeRecibo y '
    'FechaDeCaducidad >= CURRENT_DATE.';

COMMENT ON TABLE PROVEER_INSUMO IS
    'Relacion ternaria. PK compuesta incluye FechaDeRecibo para permitir '
    'multiples lotes. Mismas reglas de fecha que PROVEER_MEDICAMENTO.';

COMMENT ON TABLE PREPARAR IS
    'M:N FARMACEUTICO - MEDICAMENTO. IDPersonal referencia FARMACEUTICO '
    'directamente, lo cual garantiza el rol por integridad referencial.';
COMMENT ON TABLE USAR IS
    'M:N FARMACEUTICO - INSUMO. IDPersonal referencia FARMACEUTICO '
    'directamente, lo cual garantiza el rol por integridad referencial.';
COMMENT ON TABLE UTILIZAR IS 'M:N MEDICAMENTO - INSUMO (composicion).';

COMMENT ON TABLE TICKET IS
    'Tickets de venta. PrecioNeto <= PrecioBruto y DescuentoAplicado '
    'entre 0 y 100 garantizados por CHECK.';
COMMENT ON TABLE COMPRAR  IS 'M:N TICKET - MEDICAMENTO con Cantidad > 0.';
COMMENT ON TABLE CONSULTA IS
    'Consultas medicas. UNIQUE(IDTicket) garantiza relacion 1:1 con TICKET. '
    'IDMedico referencia MEDICO e IDEnfermera referencia ENFERMERA, lo cual '
    'garantiza por integridad referencial que el rol es correcto.';
COMMENT ON TABLE RECETA_MEDICA IS
    'Recetas medicas. Turno en dominio enumerado.';
COMMENT ON TABLE GENERAR_CONSULTA_RECETA IS
    'Relacion 1:1 total-total entre CONSULTA y RECETA_MEDICA. '
    'UNIQUE en ambos lados fuerza la cardinalidad.';
COMMENT ON TABLE PEDIR IS 'M:N RECETA - MEDICAMENTO con Dosis y Frecuencia.';
