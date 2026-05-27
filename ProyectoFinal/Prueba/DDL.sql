-- ============================================================
--  DDL.sql  -  Esquema de base de datos: Clinica / Farmacia
--  Modelo Relacional - Practica 04 (versión corregida)
--
--  Cambios aplicados respecto a la versión anterior:
--    * Se elimina la tabla TENER (no proviene de ninguna relación
--      en el modelo ER).
--    * Se elimina la tabla GENERAR (la relación 1-parcial a 1-total
--      entre TICKET y CONSULTA se representa únicamente con la FK
--      IDTicket dentro de CONSULTA).
--    * Se agrega la tabla UTILIZAR (M:N entre MEDICAMENTO e INSUMO)
--      en sustitución de la FK NombreCientifico dentro de MEDICAMENTO.
--    * Se agrega la tabla GENERAR_CONSULTA_RECETA (1:1 total-total
--      entre CONSULTA y RECETA_MEDICA).
--    * INSUMO ya no incluye FechaCaducidad (esa información se
--      registra al momento de la entrega, en PROVEER_INSUMO).
--    * MEDICAMENTO ya no incluye FechaDeCaducidad, IDPersonal,
--      IDProveedor ni NombreCientifico (esa información proviene
--      de PROVEER_MEDICAMENTO, PREPARAR y UTILIZAR respectivamente).
--    * TICKET ya no incluye IDConsulta (la relación se cierra
--      desde CONSULTA.IDTicket).
--    * CONSULTA ya no incluye IDMedicamento (no existe relación
--      directa que lo justifique).
--    * RECETA_MEDICA ya no incluye IDCliente ni IDConsulta
--      (la relación con CONSULTA se modela mediante GENERAR_CONSULTA_RECETA).
--    * COMPRAR ahora incluye el atributo Cantidad.
--    * Las tablas que provienen de relaciones M:N o ternarias ya
--      no llevan PRIMARY KEY (solo FOREIGN KEYS); las tablas que
--      provienen de entidades o atributos multivaluados sí
--      conservan llave primaria.
--    * CAJERO, LIMPIEZA, CUIDADOR y FARMACEUTICO ahora declaran
--      PRIMARY KEY (IDPersonal).
--    * Se añadieron restricciones de dominio adicionales
--      (NOT NULL y CHECK) en varias tablas.
-- ============================================================

-- ============================================================
--  Limpieza del esquema
--  Permite ejecutar este DDL desde cero aunque ya existan tablas.
-- ============================================================
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
    CLIENTE,
    GENERAR,
    TENER
CASCADE;

CREATE TABLE CLIENTE (
    IDCliente       INT,
    Nombre          VARCHAR(80),
    ApellidoPaterno VARCHAR(80),
    ApellidoMaterno VARCHAR(80),
    FechaNacimiento DATE,
    Calle           VARCHAR(100),
    NumExterior     VARCHAR(10),
    NumInterior     VARCHAR(10),
    Colonia         VARCHAR(100),
    Estado          VARCHAR(80),
    MetodoPago      VARCHAR(50),
    NumeroTarjeta   VARCHAR(20),
    VencimientoTarjeta DATE,
    Usuario         VARCHAR(60),
    Contrasena      VARCHAR(255),
    EsClienteEnLinea BOOLEAN,
    EsClienteFisico  BOOLEAN,
    EsPaciente       BOOLEAN
);

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

-- 8  (se eliminó FechaCaducidad: esta dato se registra en PROVEER_INSUMO)
CREATE TABLE INSUMO (
    NombreCientifico     VARCHAR(150),
    Presentacion         VARCHAR(100),
    FormaFarmaceutica    VARCHAR(80),
    Concentracion        VARCHAR(60),
    ViaAdministracion    VARCHAR(80),
    Clasificacion        VARCHAR(60),
    Descripcion          TEXT,
    LaboratorioFabricante VARCHAR(150),
    NombreComercial      VARCHAR(150),
    TipoDeControl        VARCHAR(60),
    PrecioPublico        DECIMAL(10,2),
    PrecioUnitario       DECIMAL(10,2)
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
    IDPersonal              INT,
    CertificadoReanimacion  VARCHAR(60),
    TipoProcedimiento       VARCHAR(100)
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

-- 21  (se eliminaron IDPersonal, IDProveedor, NombreCientifico y FechaDeCaducidad)
CREATE TABLE MEDICAMENTO (
    IDMedicamento         INT,
    PrecioPublico         DECIMAL(10,2),
    PrecioUnitario        DECIMAL(10,2),
    MedicamentosEsteriles BOOLEAN,
    Preparaciones         TEXT,
    Formulacion           TEXT,
    PreparadosOficiales   BOOLEAN,
    Pediatrica            BOOLEAN,
    Dermatologica         BOOLEAN,
    Stock                 INT DEFAULT 100
);

-- 22  PROVEER_MEDICAMENTO (relación ternaria)
CREATE TABLE PROVEER_MEDICAMENTO (
    IDProveedor               INT,
    IDMedicamento             INT,
    IDSucursal                INT,
    CondicionDeAlmacenamiento VARCHAR(200),
    Cantidad                  INT,
    FechaDeRecibo             DATE,
    FechaDeCaducidad          DATE
);

-- 23  PROVEER_INSUMO (relación ternaria)
CREATE TABLE PROVEER_INSUMO (
    IDProveedor               INT,
    IDSucursal                INT,
    NombreCientifico          VARCHAR(150),
    CondicionDeAlmacenamiento VARCHAR(200),
    Cantidad                  INT,
    FechaDeRecibo             DATE,
    FechaDeCaducidad          DATE
);

-- 24  PREPARAR (relación M:N entre PERSONAL/Farmacéutico y MEDICAMENTO)
CREATE TABLE PREPARAR (
    IDMedicamento INT,
    IDPersonal    INT,
    Cantidad      INT
);

-- 25  USAR (relación M:N entre PERSONAL/Farmacéutico e INSUMO)
CREATE TABLE USAR (
    IDPersonal       INT,
    NombreCientifico VARCHAR(150)
);

-- 26  UTILIZAR (nueva tabla, M:N entre MEDICAMENTO e INSUMO)
CREATE TABLE UTILIZAR (
    IDMedicamento    INT,
    NombreCientifico VARCHAR(150)
);

-- 27  TICKET  (se eliminó IDConsulta; la relación se cierra desde CONSULTA.IDTicket)
CREATE TABLE TICKET (
    IDTicket          INT,
    IDSucursal        INT,
    IDCliente         INT,
    Fecha             DATE DEFAULT CURRENT_DATE,
    Hora              TIME,
    PrecioBruto       DECIMAL(12,2) DEFAULT 0,
    PrecioNeto        DECIMAL(12,2) DEFAULT 0,
    DescuentoAplicado DECIMAL(5,2) DEFAULT 0
);

-- 28  COMPRAR (relación M:N entre TICKET y MEDICAMENTO, ahora con Cantidad)
CREATE TABLE COMPRAR (
    IDTicket      INT,
    IDMedicamento INT,
    Cantidad      INT
);

-- 29  CONSULTA  (se eliminó IDMedicamento; CONSULTA.IDTicket cierra la relación con TICKET)
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

-- 30  RECETA_MEDICA (se eliminaron IDCliente e IDConsulta)
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

-- 31  PEDIR (relación M:N entre RECETA_MEDICA y MEDICAMENTO)
CREATE TABLE PEDIR (
    NumeroReceta  INT,
    IDMedicamento INT,
    Dosis         VARCHAR(100),
    Frecuencia    VARCHAR(80)
);

-- 32  GENERAR_CONSULTA_RECETA (nueva tabla, 1:1 total-total entre CONSULTA y RECETA_MEDICA)
CREATE TABLE GENERAR_CONSULTA_RECETA (
    IDConsulta   INT,
    NumeroReceta INT
);


-- ============================================================
--  Restricciones de dominio (NOT NULL, CHECK, UNIQUE)
-- ============================================================
ALTER TABLE CLIENTE ALTER COLUMN Nombre SET NOT NULL;
ALTER TABLE CLIENTE ALTER COLUMN ApellidoMaterno SET NOT NULL;
ALTER TABLE CLIENTE ALTER COLUMN ApellidoPaterno SET NOT NULL;
ALTER TABLE CLIENTE ALTER COLUMN FechaNacimiento SET NOT NULL;
ALTER TABLE CLIENTE
ADD CONSTRAINT chk_vencimiento_tarjeta
CHECK (VencimientoTarjeta >= CURRENT_DATE);

ALTER TABLE PERSONAL ADD CONSTRAINT rfcvalido CHECK (CHAR_LENGTH(RFC)=13);
ALTER TABLE PERSONAL ALTER COLUMN Nombre SET NOT NULL;
ALTER TABLE PERSONAL ALTER COLUMN ApellidoMaterno SET NOT NULL;
ALTER TABLE PERSONAL ALTER COLUMN ApellidoPaterno SET NOT NULL;
ALTER TABLE PERSONAL ADD CONSTRAINT cedprofvalida CHECK (CHAR_LENGTH(CedulaProfesional)=8);
ALTER TABLE PERSONAL ADD CONSTRAINT salario_nonegativo CHECK (Salario >= 0);

ALTER TABLE CLINICA ALTER COLUMN Nombre SET NOT NULL;
ALTER TABLE CLINICA ADD CONSTRAINT chk_numcuartos CHECK (NumCuartos > 0);

ALTER TABLE SUCURSAL ALTER COLUMN Nombre SET NOT NULL;

ALTER TABLE PROVEEDOR ALTER COLUMN RazonSocial SET NOT NULL;

ALTER TABLE INSUMO ADD CONSTRAINT chk_precio_insumo
CHECK (PrecioPublico >= 0 AND PrecioUnitario >= 0);

ALTER TABLE PROVEER_INSUMO ALTER COLUMN Cantidad SET NOT NULL;
ALTER TABLE PROVEER_INSUMO ALTER COLUMN FechaDeRecibo SET NOT NULL;
ALTER TABLE PROVEER_INSUMO ADD CONSTRAINT cantidad_nonegativa CHECK (Cantidad >= 0);
ALTER TABLE PROVEER_INSUMO ADD CONSTRAINT caducidad_proveedor
CHECK (FechaDeCaducidad >= CURRENT_DATE);

ALTER TABLE PROVEER_MEDICAMENTO ALTER COLUMN Cantidad SET NOT NULL;
ALTER TABLE PROVEER_MEDICAMENTO ALTER COLUMN FechaDeRecibo SET NOT NULL;
ALTER TABLE PROVEER_MEDICAMENTO ADD CONSTRAINT cantidad_nonegativamed CHECK (Cantidad >= 0);
ALTER TABLE PROVEER_MEDICAMENTO ADD CONSTRAINT caducidad_med
CHECK (FechaDeCaducidad >= CURRENT_DATE);

ALTER TABLE PREPARAR ALTER COLUMN Cantidad SET NOT NULL;
ALTER TABLE PREPARAR ADD CONSTRAINT cantidad_prep CHECK (Cantidad >= 0);

ALTER TABLE COMPRAR ALTER COLUMN Cantidad SET NOT NULL;
ALTER TABLE COMPRAR ADD CONSTRAINT chk_cantidad_compra CHECK (Cantidad > 0);

ALTER TABLE MEDICO ADD CONSTRAINT caducidad_medico
CHECK (VigenciaCertificacion >= CURRENT_DATE);

ALTER TABLE MEDICAMENTO ADD CONSTRAINT CHK_Precio
CHECK (PrecioPublico >= 0 AND PrecioUnitario >= 0);
ALTER TABLE MEDICAMENTO ALTER COLUMN Stock SET NOT NULL;

ALTER TABLE TICKET ALTER COLUMN Fecha SET NOT NULL;
ALTER TABLE TICKET ALTER COLUMN PrecioBruto SET NOT NULL;
ALTER TABLE TICKET ALTER COLUMN PrecioNeto SET NOT NULL;
ALTER TABLE TICKET ALTER COLUMN DescuentoAplicado SET NOT NULL;
ALTER TABLE TICKET ADD CONSTRAINT chk_ticket_precios
CHECK (PrecioBruto >= 0 AND PrecioNeto >= 0);
ALTER TABLE TICKET ADD CONSTRAINT chk_ticket_descuento
CHECK (DescuentoAplicado >= 0 AND DescuentoAplicado <= 100);

ALTER TABLE CONSULTA ALTER COLUMN Fecha SET NOT NULL;
ALTER TABLE CONSULTA ALTER COLUMN Hora SET NOT NULL;
ALTER TABLE CONSULTA ADD CONSTRAINT chk_costo_consulta CHECK (CostoConsulta >= 0);

ALTER TABLE RECETA_MEDICA ALTER COLUMN FechaNacimiento SET NOT NULL;
ALTER TABLE RECETA_MEDICA ALTER COLUMN Consultorio SET NOT NULL;
ALTER TABLE RECETA_MEDICA ADD CONSTRAINT chk_peso CHECK (Peso > 0);
ALTER TABLE RECETA_MEDICA ADD CONSTRAINT chk_talla CHECK (Talla > 0);

ALTER TABLE CLIENTE ADD CONSTRAINT UQ_Usuario UNIQUE (Usuario);
ALTER TABLE PERSONAL ADD CONSTRAINT UQ_RFC UNIQUE (RFC);


-- ============================================================
--  Llaves primarias (solo entidades, especializaciones y
--  atributos multivaluados; las tablas de relación M:N solo
--  llevan llaves foráneas).
-- ============================================================
ALTER TABLE CLIENTE       ADD CONSTRAINT PK_IDCliente        PRIMARY KEY (IDCliente);
ALTER TABLE SUCURSAL      ADD CONSTRAINT PK_IDSucursal       PRIMARY KEY (IDSucursal);
ALTER TABLE PROVEEDOR     ADD CONSTRAINT PK_IDProveedor      PRIMARY KEY (IDProveedor);
ALTER TABLE PERSONAL      ADD CONSTRAINT PK_IDPersonal       PRIMARY KEY (IDPersonal);
ALTER TABLE INSUMO        ADD CONSTRAINT PK_NombreCientifico PRIMARY KEY (NombreCientifico);
ALTER TABLE MEDICAMENTO   ADD CONSTRAINT PK_IDMedicamento    PRIMARY KEY (IDMedicamento);
ALTER TABLE CLINICA       ADD CONSTRAINT PK_IDClinica        PRIMARY KEY (IDClinica);
ALTER TABLE TICKET        ADD CONSTRAINT PK_IDTicket         PRIMARY KEY (IDTicket);
ALTER TABLE CONSULTA      ADD CONSTRAINT PK_IDConsulta       PRIMARY KEY (IDConsulta);
ALTER TABLE RECETA_MEDICA ADD CONSTRAINT PK_NumeroReceta     PRIMARY KEY (NumeroReceta);

-- Especializaciones (1:1 con PERSONAL): cada una tiene su propia PK.
ALTER TABLE MEDICO       ADD CONSTRAINT PK_Medico       PRIMARY KEY (IDPersonal);
ALTER TABLE ENFERMERA    ADD CONSTRAINT PK_Enfermera    PRIMARY KEY (IDPersonal);
ALTER TABLE CAJERO       ADD CONSTRAINT PK_Cajero       PRIMARY KEY (IDPersonal);
ALTER TABLE LIMPIEZA     ADD CONSTRAINT PK_Limpieza     PRIMARY KEY (IDPersonal);
ALTER TABLE CUIDADOR     ADD CONSTRAINT PK_Cuidador     PRIMARY KEY (IDPersonal);
ALTER TABLE FARMACEUTICO ADD CONSTRAINT PK_Farmaceutico PRIMARY KEY (IDPersonal);

-- Atributos multivaluados: PK compuesta (entidad + valor)
ALTER TABLE CORREO_CLIENTE     ADD CONSTRAINT PK_CorreoCliente   PRIMARY KEY (IDCliente, CorreoElectronico);
ALTER TABLE TELEFONO_CLIENTE   ADD CONSTRAINT PK_TelCliente      PRIMARY KEY (IDCliente, Telefono);
ALTER TABLE TELEFONO_PROVEEDOR ADD CONSTRAINT PK_TelProveedor    PRIMARY KEY (IDProveedor, Telefono);
ALTER TABLE HORARIO_PERSONAL   ADD CONSTRAINT PK_HorarioPersonal PRIMARY KEY (IDPersonal, Horario);
ALTER TABLE CORREO_PERSONAL    ADD CONSTRAINT PK_CorreoPersonal  PRIMARY KEY (IDPersonal, CorreoElectronico);
ALTER TABLE TELEFONO_PERSONAL  ADD CONSTRAINT PK_TelPersonal     PRIMARY KEY (IDPersonal, Telefono);
ALTER TABLE HORARIO_CLINICA    ADD CONSTRAINT PK_HorarioClinica  PRIMARY KEY (IDClinica, Horario);
ALTER TABLE TELEFONO_SUCURSAL  ADD CONSTRAINT PK_TelSucursal     PRIMARY KEY (IDSucursal, Telefono);


-- ============================================================
--  Llaves foráneas
-- ============================================================

-- PERSONAL con SUCURSAL
ALTER TABLE PERSONAL
ADD CONSTRAINT FK_IDSucursal FOREIGN KEY (IDSucursal)
REFERENCES SUCURSAL (IDSucursal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- CORREO_CLIENTE, TELEFONO_CLIENTE con CLIENTE
ALTER TABLE CORREO_CLIENTE
ADD CONSTRAINT FK_CC_IDCliente FOREIGN KEY (IDCliente)
REFERENCES CLIENTE (IDCliente)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE TELEFONO_CLIENTE
ADD CONSTRAINT FK_TC_IDCliente FOREIGN KEY (IDCliente)
REFERENCES CLIENTE (IDCliente)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- TELEFONO_PROVEEDOR con PROVEEDOR
ALTER TABLE TELEFONO_PROVEEDOR
ADD CONSTRAINT FK_TP_IDProveedor FOREIGN KEY (IDProveedor)
REFERENCES PROVEEDOR (IDProveedor)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Multivaluados de PERSONAL
ALTER TABLE HORARIO_PERSONAL
ADD CONSTRAINT FK_HP_IDPersonal FOREIGN KEY (IDPersonal)
REFERENCES PERSONAL (IDPersonal)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE CORREO_PERSONAL
ADD CONSTRAINT FK_CP_IDPersonal FOREIGN KEY (IDPersonal)
REFERENCES PERSONAL (IDPersonal)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE TELEFONO_PERSONAL
ADD CONSTRAINT FK_TP2_IDPersonal FOREIGN KEY (IDPersonal)
REFERENCES PERSONAL (IDPersonal)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Especializaciones con PERSONAL
ALTER TABLE MEDICO
ADD CONSTRAINT FK_Medico FOREIGN KEY (IDPersonal)
REFERENCES PERSONAL (IDPersonal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE ENFERMERA
ADD CONSTRAINT FK_Enfermera FOREIGN KEY (IDPersonal)
REFERENCES PERSONAL (IDPersonal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE CAJERO
ADD CONSTRAINT FK_Cajero FOREIGN KEY (IDPersonal)
REFERENCES PERSONAL (IDPersonal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE LIMPIEZA
ADD CONSTRAINT FK_Limpieza FOREIGN KEY (IDPersonal)
REFERENCES PERSONAL (IDPersonal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE CUIDADOR
ADD CONSTRAINT FK_Cuidador FOREIGN KEY (IDPersonal)
REFERENCES PERSONAL (IDPersonal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE FARMACEUTICO
ADD CONSTRAINT FK_Farmaceutico FOREIGN KEY (IDPersonal)
REFERENCES PERSONAL (IDPersonal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- CLINICA con SUCURSAL
ALTER TABLE CLINICA
ADD CONSTRAINT FK_ClinicaSucursal FOREIGN KEY (IDSucursal)
REFERENCES SUCURSAL (IDSucursal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE HORARIO_CLINICA
ADD CONSTRAINT FK_HC_IDClinica FOREIGN KEY (IDClinica)
REFERENCES CLINICA (IDClinica)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE TELEFONO_SUCURSAL
ADD CONSTRAINT FK_TS_IDSucursal FOREIGN KEY (IDSucursal)
REFERENCES SUCURSAL (IDSucursal)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Relación ternaria PROVEER_MEDICAMENTO
ALTER TABLE PROVEER_MEDICAMENTO
ADD CONSTRAINT FK_PM_Proveedor FOREIGN KEY (IDProveedor)
REFERENCES PROVEEDOR (IDProveedor)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE PROVEER_MEDICAMENTO
ADD CONSTRAINT FK_PM_Medicamento FOREIGN KEY (IDMedicamento)
REFERENCES MEDICAMENTO (IDMedicamento)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE PROVEER_MEDICAMENTO
ADD CONSTRAINT FK_PM_Sucursal FOREIGN KEY (IDSucursal)
REFERENCES SUCURSAL (IDSucursal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- Relación ternaria PROVEER_INSUMO
ALTER TABLE PROVEER_INSUMO
ADD CONSTRAINT FK_PI_Proveedor FOREIGN KEY (IDProveedor)
REFERENCES PROVEEDOR (IDProveedor)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE PROVEER_INSUMO
ADD CONSTRAINT FK_PI_Insumo FOREIGN KEY (NombreCientifico)
REFERENCES INSUMO (NombreCientifico)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE PROVEER_INSUMO
ADD CONSTRAINT FK_PI_Sucursal FOREIGN KEY (IDSucursal)
REFERENCES SUCURSAL (IDSucursal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- PREPARAR (M:N Farmacéutico/Personal-Medicamento)
ALTER TABLE PREPARAR
ADD CONSTRAINT FK_PrepararMed FOREIGN KEY (IDMedicamento)
REFERENCES MEDICAMENTO (IDMedicamento)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE PREPARAR
ADD CONSTRAINT FK_PrepararPer FOREIGN KEY (IDPersonal)
REFERENCES PERSONAL (IDPersonal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- USAR (M:N Farmacéutico/Personal-Insumo)
ALTER TABLE USAR
ADD CONSTRAINT FK_UsarPer FOREIGN KEY (IDPersonal)
REFERENCES PERSONAL (IDPersonal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE USAR
ADD CONSTRAINT FK_UsarIns FOREIGN KEY (NombreCientifico)
REFERENCES INSUMO (NombreCientifico)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- UTILIZAR (M:N Medicamento-Insumo, NUEVA tabla)
ALTER TABLE UTILIZAR
ADD CONSTRAINT FK_UtilizarMed FOREIGN KEY (IDMedicamento)
REFERENCES MEDICAMENTO (IDMedicamento)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE UTILIZAR
ADD CONSTRAINT FK_UtilizarIns FOREIGN KEY (NombreCientifico)
REFERENCES INSUMO (NombreCientifico)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- TICKET (ya no incluye IDConsulta)
ALTER TABLE TICKET
ADD CONSTRAINT FK_TicketSucursal FOREIGN KEY (IDSucursal)
REFERENCES SUCURSAL (IDSucursal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE TICKET
ADD CONSTRAINT FK_TicketCliente FOREIGN KEY (IDCliente)
REFERENCES CLIENTE (IDCliente)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- COMPRAR (M:N Ticket-Medicamento)
ALTER TABLE COMPRAR
ADD CONSTRAINT FK_CompraTicket FOREIGN KEY (IDTicket)
REFERENCES TICKET (IDTicket)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE COMPRAR
ADD CONSTRAINT FK_CompraMedicamento FOREIGN KEY (IDMedicamento)
REFERENCES MEDICAMENTO (IDMedicamento)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- CONSULTA (sin IDMedicamento; IDTicket cierra la relación con TICKET)
ALTER TABLE CONSULTA
ADD CONSTRAINT FK_ConsultaCliente FOREIGN KEY (IDCliente)
REFERENCES CLIENTE (IDCliente)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE CONSULTA
ADD CONSTRAINT FK_ConsultaMedico FOREIGN KEY (IDMedico)
REFERENCES PERSONAL (IDPersonal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE CONSULTA
ADD CONSTRAINT FK_ConsultaEnfermera FOREIGN KEY (IDEnfermera)
REFERENCES PERSONAL (IDPersonal)
ON DELETE SET NULL
ON UPDATE CASCADE;

ALTER TABLE CONSULTA
ADD CONSTRAINT FK_ConsultaClinica FOREIGN KEY (IDClinica)
REFERENCES CLINICA (IDClinica)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE CONSULTA
ADD CONSTRAINT FK_ConsultaTicket FOREIGN KEY (IDTicket)
REFERENCES TICKET (IDTicket)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- GENERAR_CONSULTA_RECETA (nueva, 1:1 total-total)
ALTER TABLE GENERAR_CONSULTA_RECETA
ADD CONSTRAINT FK_GCR_Consulta FOREIGN KEY (IDConsulta)
REFERENCES CONSULTA (IDConsulta)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE GENERAR_CONSULTA_RECETA
ADD CONSTRAINT FK_GCR_Receta FOREIGN KEY (NumeroReceta)
REFERENCES RECETA_MEDICA (NumeroReceta)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Para asegurar la cardinalidad 1:1 en GENERAR_CONSULTA_RECETA,
-- cada IDConsulta y cada NumeroReceta debe aparecer como máximo
-- una vez (unicidad).
ALTER TABLE GENERAR_CONSULTA_RECETA
ADD CONSTRAINT UQ_GCR_Consulta UNIQUE (IDConsulta);

ALTER TABLE GENERAR_CONSULTA_RECETA
ADD CONSTRAINT UQ_GCR_Receta UNIQUE (NumeroReceta);

-- PEDIR (M:N Receta-Medicamento)
ALTER TABLE PEDIR
ADD CONSTRAINT FK_PedirReceta FOREIGN KEY (NumeroReceta)
REFERENCES RECETA_MEDICA (NumeroReceta)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE PEDIR
ADD CONSTRAINT FK_PedirMedicamento FOREIGN KEY (IDMedicamento)
REFERENCES MEDICAMENTO (IDMedicamento)
ON DELETE RESTRICT
ON UPDATE CASCADE;


-- ============================================================
--  Comentarios (documentación del esquema)
-- ============================================================
COMMENT ON TABLE CLIENTE IS 'Almacena la información general del cliente de la clínica o farmacia.';
COMMENT ON COLUMN CLIENTE.IDCliente IS 'Identificador único del cliente.';
COMMENT ON COLUMN CLIENTE.Nombre IS 'Nombre o denominación de la entidad.';
COMMENT ON COLUMN CLIENTE.ApellidoPaterno IS 'Apellido Paterno de la persona registrada.';
COMMENT ON COLUMN CLIENTE.ApellidoMaterno IS 'Apellido Materno de la persona registrada.';
COMMENT ON COLUMN CLIENTE.FechaNacimiento IS 'Fecha correspondiente al atributo FechaNacimiento.';
COMMENT ON COLUMN CLIENTE.Calle IS 'Dato de dirección correspondiente a Calle.';
COMMENT ON COLUMN CLIENTE.NumExterior IS 'Dato de dirección correspondiente a NumExterior.';
COMMENT ON COLUMN CLIENTE.NumInterior IS 'Dato de dirección correspondiente a NumInterior.';
COMMENT ON COLUMN CLIENTE.Colonia IS 'Dato de dirección correspondiente a Colonia.';
COMMENT ON COLUMN CLIENTE.Estado IS 'Dato de dirección correspondiente a Estado.';
COMMENT ON COLUMN CLIENTE.MetodoPago IS 'Dato correspondiente a MetodoPago.';
COMMENT ON COLUMN CLIENTE.NumeroTarjeta IS 'Número de tarjeta asociado al método de pago del cliente.';
COMMENT ON COLUMN CLIENTE.VencimientoTarjeta IS 'Fecha de vencimiento de la tarjeta del cliente.';
COMMENT ON COLUMN CLIENTE.Usuario IS 'Nombre de usuario único del cliente en el sistema.';
COMMENT ON COLUMN CLIENTE.Contrasena IS 'Contraseña cifrada o protegida del cliente.';
COMMENT ON COLUMN CLIENTE.EsClienteEnLinea IS 'Indicador booleano correspondiente a EsClienteEnLinea.';
COMMENT ON COLUMN CLIENTE.EsClienteFisico IS 'Indicador booleano correspondiente a EsClienteFisico.';
COMMENT ON COLUMN CLIENTE.EsPaciente IS 'Indicador booleano correspondiente a EsPaciente.';

COMMENT ON TABLE SUCURSAL IS 'Almacena la información de cada sucursal de la clínica/farmacia.';
COMMENT ON COLUMN SUCURSAL.IDSucursal IS 'Identificador único de la sucursal.';
COMMENT ON COLUMN SUCURSAL.Nombre IS 'Nombre o denominación de la entidad.';

COMMENT ON TABLE PROVEEDOR IS 'Almacena la información de los proveedores del sistema.';
COMMENT ON COLUMN PROVEEDOR.IDProveedor IS 'Identificador único del proveedor.';
COMMENT ON COLUMN PROVEEDOR.RazonSocial IS 'Razón social del proveedor.';

COMMENT ON TABLE PERSONAL IS 'Almacena la información del personal que labora en una sucursal.';
COMMENT ON COLUMN PERSONAL.IDPersonal IS 'Identificador único del integrante del personal.';
COMMENT ON COLUMN PERSONAL.IDSucursal IS 'Sucursal a la que pertenece el integrante del personal.';
COMMENT ON COLUMN PERSONAL.CedulaProfesional IS 'Cédula profesional del integrante del personal.';
COMMENT ON COLUMN PERSONAL.RFC IS 'Registro Federal de Contribuyentes del integrante del personal.';
COMMENT ON COLUMN PERSONAL.Salario IS 'Salario del integrante del personal.';

COMMENT ON TABLE CORREO_CLIENTE IS 'Atributo multivaluado: correos electrónicos asociados a cada cliente.';
COMMENT ON TABLE TELEFONO_CLIENTE IS 'Atributo multivaluado: teléfonos asociados a cada cliente.';
COMMENT ON TABLE TELEFONO_PROVEEDOR IS 'Atributo multivaluado: teléfonos asociados a cada proveedor.';
COMMENT ON TABLE HORARIO_PERSONAL IS 'Atributo multivaluado: horarios asignados al personal.';
COMMENT ON TABLE CORREO_PERSONAL IS 'Atributo multivaluado: correos electrónicos del personal.';
COMMENT ON TABLE TELEFONO_PERSONAL IS 'Atributo multivaluado: teléfonos del personal.';
COMMENT ON TABLE HORARIO_CLINICA IS 'Atributo multivaluado: horarios de cada clínica.';
COMMENT ON TABLE TELEFONO_SUCURSAL IS 'Atributo multivaluado: teléfonos asociados a cada sucursal.';

COMMENT ON TABLE INSUMO IS 'Almacena los insumos utilizados en la clínica o farmacia. La fecha de caducidad se registra en PROVEER_INSUMO.';
COMMENT ON TABLE MEDICAMENTO IS 'Almacena los medicamentos manejados por la farmacia o clínica. La fecha de caducidad, el proveedor, el preparador y los insumos asociados se gestionan en sus tablas de relación.';
COMMENT ON COLUMN MEDICAMENTO.Stock IS 'Inventario disponible del medicamento; se actualiza mediante triggers.';

COMMENT ON TABLE MEDICO IS 'Especialización del personal que desempeña el rol de médico.';
COMMENT ON COLUMN MEDICO.InstitucionEgreso IS 'Institución educativa de la cual egresó el médico.';
COMMENT ON COLUMN MEDICO.VigenciaCertificacion IS 'Vigencia de la certificación médica.';

COMMENT ON TABLE ENFERMERA IS 'Especialización del personal que desempeña el rol de enfermera.';
COMMENT ON COLUMN ENFERMERA.CertificadoReanimacion IS 'Certificación de reanimación cardiopulmonar de la enfermera.';
COMMENT ON COLUMN ENFERMERA.TipoProcedimiento IS 'Tipo de procedimientos que la enfermera puede ejecutar.';

COMMENT ON TABLE CAJERO IS 'Especialización del personal que desempeña el rol de cajero.';
COMMENT ON TABLE LIMPIEZA IS 'Especialización del personal que desempeña el rol de limpieza.';
COMMENT ON TABLE CUIDADOR IS 'Especialización del personal que desempeña el rol de cuidador.';
COMMENT ON TABLE FARMACEUTICO IS 'Especialización del personal que desempeña el rol de farmacéutico.';

COMMENT ON TABLE CLINICA IS 'Almacena la información de la clínica o consultorio dentro de una sucursal.';
COMMENT ON TABLE PROVEER_MEDICAMENTO IS 'Relación ternaria: registra el suministro de medicamentos de un proveedor a una sucursal, con cantidad, fecha de recibo y fecha de caducidad de cada lote.';
COMMENT ON TABLE PROVEER_INSUMO IS 'Relación ternaria: registra el suministro de insumos de un proveedor a una sucursal, con cantidad, fecha de recibo y fecha de caducidad de cada lote.';
COMMENT ON TABLE PREPARAR IS 'Relación M:N: registra qué personal (farmacéutico) prepara qué medicamentos y en qué cantidad.';
COMMENT ON TABLE USAR IS 'Relación M:N: registra qué personal (farmacéutico) utiliza qué insumos.';
COMMENT ON TABLE UTILIZAR IS 'Relación M:N: registra qué insumos (sustancia activa) compone cada medicamento.';
COMMENT ON TABLE TICKET IS 'Almacena los tickets generados por compras o servicios.';
COMMENT ON COLUMN TICKET.PrecioBruto IS 'Total del ticket antes de aplicar descuento; se recalcula mediante triggers.';
COMMENT ON COLUMN TICKET.PrecioNeto IS 'Total del ticket despues de aplicar descuento; se recalcula mediante triggers.';
COMMENT ON COLUMN TICKET.DescuentoAplicado IS 'Porcentaje de descuento aplicado al ticket segun tickets previos del mismo anio.';
COMMENT ON TABLE COMPRAR IS 'Relación M:N: registra los medicamentos incluidos dentro de un ticket, con la cantidad adquirida.';
COMMENT ON COLUMN COMPRAR.Cantidad IS 'Cantidad de unidades del medicamento adquiridas en el ticket.';
COMMENT ON TABLE CONSULTA IS 'Almacena la información de las consultas médicas realizadas.';
COMMENT ON TABLE RECETA_MEDICA IS 'Almacena la información de las recetas médicas emitidas.';
COMMENT ON TABLE GENERAR_CONSULTA_RECETA IS 'Relación 1:1 total-total entre CONSULTA y RECETA_MEDICA.';
COMMENT ON TABLE PEDIR IS 'Relación M:N: registra los medicamentos solicitados en una receta médica.';
