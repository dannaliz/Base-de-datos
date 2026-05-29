-- DDL.sql  -  Esquema de base de datos: Famacia De Otro Mundo
-- Proyecto final - Modelo relacional
-- Politicas aplicadas:
-- 1) Integridad de entidad
-- Cada entidad fuerte declara PRIMARY KEY simple. Las
-- especializaciones de PERSONAL usan IDPersonal como PRIMARY KEY.
-- Los atributos multivaluados, relaciones M:N y relaciones ternarias
-- declaran PRIMARY KEY compuesta para evitar duplicados.
-- 2) Integridad de dominio
-- Se definen NOT NULL en atributos obligatorios, DEFAULT en campos
-- booleanos y de fecha/hora, UNIQUE en atributos con unicidad natural
-- y CHECK para rangos de fechas, precios, cantidades, porcentajes,
-- inventario y datos numericos del expediente medico.
-- 3) Integridad referencial
-- Todas las llaves foraneas tienen acciones explicitas ON DELETE y
-- ON UPDATE. Las referencias a roles usan las tablas especializadas
-- correspondientes: CONSULTA apunta a MEDICO y ENFERMERA; PREPARAR
-- y USAR apuntan a FARMACEUTICO.

--  Limpieza del esquema
--  Permite ejecutar este DDL desde cero aunque ya existan tablas.

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
    EsClienteEnLinea BOOLEAN DEFAULT FALSE,
    EsClienteFisico  BOOLEAN DEFAULT FALSE,
    EsPaciente       BOOLEAN DEFAULT FALSE
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

-- 8  INSUMO
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

-- 21  MEDICAMENTO
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
    Stock                 INT DEFAULT 100
);

-- 22  PROVEER_MEDICAMENTO (relacion ternaria)
CREATE TABLE PROVEER_MEDICAMENTO (
    IDProveedor               INT,
    IDMedicamento             INT,
    IDSucursal                INT,
    CondicionDeAlmacenamiento VARCHAR(200),
    Cantidad                  INT,
    FechaDeRecibo             DATE,
    FechaDeCaducidad          DATE
);

-- 23  PROVEER_INSUMO (relacion ternaria)
CREATE TABLE PROVEER_INSUMO (
    IDProveedor               INT,
    IDSucursal                INT,
    NombreCientifico          VARCHAR(150),
    CondicionDeAlmacenamiento VARCHAR(200),
    Cantidad                  INT,
    FechaDeRecibo             DATE,
    FechaDeCaducidad          DATE
);

-- 24  PREPARAR (relacion M:N entre FARMACEUTICO y MEDICAMENTO)
CREATE TABLE PREPARAR (
    IDMedicamento INT,
    IDPersonal    INT,
    Cantidad      INT
);

-- 25  USAR (relacion M:N entre FARMACEUTICO e INSUMO)
CREATE TABLE USAR (
    IDPersonal       INT,
    NombreCientifico VARCHAR(150)
);

-- 26  UTILIZAR (relacion M:N entre MEDICAMENTO e INSUMO)
CREATE TABLE UTILIZAR (
    IDMedicamento    INT,
    NombreCientifico VARCHAR(150)
);

-- 27  TICKET
CREATE TABLE TICKET (
    IDTicket          INT,
    IDSucursal        INT,
    IDCliente         INT,
    Fecha             DATE DEFAULT CURRENT_DATE,
    Hora              TIME DEFAULT CURRENT_TIME,
    PrecioBruto       DECIMAL(12,2) DEFAULT 0,
    PrecioNeto        DECIMAL(12,2) DEFAULT 0,
    DescuentoAplicado DECIMAL(5,2) DEFAULT 0
);

-- 28  COMPRAR (relacion M:N entre TICKET y MEDICAMENTO)
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

-- 31  PEDIR (relacion M:N entre RECETA_MEDICA y MEDICAMENTO)
CREATE TABLE PEDIR (
    NumeroReceta  INT,
    IDMedicamento INT,
    Dosis         VARCHAR(100),
    Frecuencia    VARCHAR(80)
);

-- 32  GENERAR_CONSULTA_RECETA (relacion 1:1 entre CONSULTA y RECETA_MEDICA)
CREATE TABLE GENERAR_CONSULTA_RECETA (
    IDConsulta   INT,
    NumeroReceta INT
);


--  Restricciones de dominio (NOT NULL, CHECK, UNIQUE)

ALTER TABLE CLIENTE ALTER COLUMN Nombre SET NOT NULL;
ALTER TABLE CLIENTE ALTER COLUMN ApellidoMaterno SET NOT NULL;
ALTER TABLE CLIENTE ALTER COLUMN ApellidoPaterno SET NOT NULL;
ALTER TABLE CLIENTE ALTER COLUMN FechaNacimiento SET NOT NULL;
ALTER TABLE CLIENTE ALTER COLUMN EsClienteEnLinea SET NOT NULL;
ALTER TABLE CLIENTE ALTER COLUMN EsClienteFisico SET NOT NULL;
ALTER TABLE CLIENTE ALTER COLUMN EsPaciente SET NOT NULL;
ALTER TABLE CLIENTE ADD CONSTRAINT chk_cli_nacimiento
CHECK (FechaNacimiento <= CURRENT_DATE);
ALTER TABLE CLIENTE ADD CONSTRAINT chk_vencimiento_tarjeta
CHECK (VencimientoTarjeta IS NULL OR VencimientoTarjeta >= CURRENT_DATE);
ALTER TABLE CLIENTE ADD CONSTRAINT chk_cli_tarjeta_requerida
CHECK (
    MetodoPago NOT IN ('Tarjeta de Credito', 'Tarjeta de Debito', 'Tarjeta')
    OR (NumeroTarjeta IS NOT NULL AND VencimientoTarjeta IS NOT NULL)
);

ALTER TABLE PERSONAL ALTER COLUMN IDSucursal SET NOT NULL;
ALTER TABLE PERSONAL ALTER COLUMN Nombre SET NOT NULL;
ALTER TABLE PERSONAL ALTER COLUMN ApellidoMaterno SET NOT NULL;
ALTER TABLE PERSONAL ALTER COLUMN ApellidoPaterno SET NOT NULL;
ALTER TABLE PERSONAL ALTER COLUMN RFC SET NOT NULL;
ALTER TABLE PERSONAL ALTER COLUMN Salario SET NOT NULL;
ALTER TABLE PERSONAL ADD CONSTRAINT rfcvalido CHECK (CHAR_LENGTH(RFC) = 13);
ALTER TABLE PERSONAL ADD CONSTRAINT cedprofvalida
CHECK (CedulaProfesional IS NULL OR CHAR_LENGTH(CedulaProfesional) BETWEEN 7 AND 8);
ALTER TABLE PERSONAL ADD CONSTRAINT salario_nonegativo CHECK (Salario >= 0);

ALTER TABLE CLINICA ALTER COLUMN IDSucursal SET NOT NULL;
ALTER TABLE CLINICA ALTER COLUMN Nombre SET NOT NULL;
ALTER TABLE CLINICA ALTER COLUMN NumCuartos SET NOT NULL;
ALTER TABLE CLINICA ADD CONSTRAINT chk_numcuartos CHECK (NumCuartos > 0);

ALTER TABLE SUCURSAL ALTER COLUMN Nombre SET NOT NULL;

ALTER TABLE PROVEEDOR ALTER COLUMN RazonSocial SET NOT NULL;

ALTER TABLE INSUMO ALTER COLUMN Presentacion SET NOT NULL;
ALTER TABLE INSUMO ALTER COLUMN FormaFarmaceutica SET NOT NULL;
ALTER TABLE INSUMO ALTER COLUMN PrecioPublico SET NOT NULL;
ALTER TABLE INSUMO ALTER COLUMN PrecioUnitario SET NOT NULL;
ALTER TABLE INSUMO ADD CONSTRAINT chk_precio_insumo
CHECK (PrecioPublico >= 0 AND PrecioUnitario >= 0);

ALTER TABLE PROVEER_INSUMO ALTER COLUMN Cantidad SET NOT NULL;
ALTER TABLE PROVEER_INSUMO ALTER COLUMN FechaDeRecibo SET NOT NULL;
ALTER TABLE PROVEER_INSUMO ALTER COLUMN FechaDeCaducidad SET NOT NULL;
ALTER TABLE PROVEER_INSUMO ADD CONSTRAINT cantidad_nonegativa CHECK (Cantidad > 0);
ALTER TABLE PROVEER_INSUMO ADD CONSTRAINT chk_pi_fechas
CHECK (FechaDeCaducidad > FechaDeRecibo);
ALTER TABLE PROVEER_INSUMO ADD CONSTRAINT caducidad_proveedor
CHECK (FechaDeCaducidad >= CURRENT_DATE);

ALTER TABLE PROVEER_MEDICAMENTO ALTER COLUMN Cantidad SET NOT NULL;
ALTER TABLE PROVEER_MEDICAMENTO ALTER COLUMN FechaDeRecibo SET NOT NULL;
ALTER TABLE PROVEER_MEDICAMENTO ALTER COLUMN FechaDeCaducidad SET NOT NULL;
ALTER TABLE PROVEER_MEDICAMENTO ADD CONSTRAINT cantidad_nonegativamed CHECK (Cantidad > 0);
ALTER TABLE PROVEER_MEDICAMENTO ADD CONSTRAINT chk_pm_fechas
CHECK (FechaDeCaducidad > FechaDeRecibo);
ALTER TABLE PROVEER_MEDICAMENTO ADD CONSTRAINT caducidad_med
CHECK (FechaDeCaducidad >= CURRENT_DATE);

ALTER TABLE PREPARAR ALTER COLUMN Cantidad SET NOT NULL;
ALTER TABLE PREPARAR ADD CONSTRAINT cantidad_prep CHECK (Cantidad > 0);

ALTER TABLE COMPRAR ALTER COLUMN Cantidad SET NOT NULL;
ALTER TABLE COMPRAR ADD CONSTRAINT chk_cantidad_compra CHECK (Cantidad > 0);

ALTER TABLE MEDICO ALTER COLUMN Especialidad SET NOT NULL;
ALTER TABLE MEDICO ALTER COLUMN InstitucionEgreso SET NOT NULL;
ALTER TABLE MEDICO ALTER COLUMN VigenciaCertificacion SET NOT NULL;
ALTER TABLE MEDICO ADD CONSTRAINT caducidad_medico
CHECK (VigenciaCertificacion >= CURRENT_DATE);

ALTER TABLE MEDICAMENTO ALTER COLUMN PrecioPublico SET NOT NULL;
ALTER TABLE MEDICAMENTO ALTER COLUMN PrecioUnitario SET NOT NULL;
ALTER TABLE MEDICAMENTO ALTER COLUMN MedicamentosEsteriles SET NOT NULL;
ALTER TABLE MEDICAMENTO ALTER COLUMN PreparadosOficiales SET NOT NULL;
ALTER TABLE MEDICAMENTO ALTER COLUMN Pediatrica SET NOT NULL;
ALTER TABLE MEDICAMENTO ALTER COLUMN Dermatologica SET NOT NULL;
ALTER TABLE MEDICAMENTO ADD CONSTRAINT CHK_Precio
CHECK (PrecioPublico >= 0 AND PrecioUnitario >= 0);
ALTER TABLE MEDICAMENTO ALTER COLUMN Stock SET NOT NULL;
ALTER TABLE MEDICAMENTO ADD CONSTRAINT chk_med_stock CHECK (Stock >= 0);

ALTER TABLE TICKET ALTER COLUMN IDSucursal SET NOT NULL;
ALTER TABLE TICKET ALTER COLUMN IDCliente SET NOT NULL;
ALTER TABLE TICKET ALTER COLUMN Fecha SET NOT NULL;
ALTER TABLE TICKET ALTER COLUMN Hora SET NOT NULL;
ALTER TABLE TICKET ALTER COLUMN PrecioBruto SET NOT NULL;
ALTER TABLE TICKET ALTER COLUMN PrecioNeto SET NOT NULL;
ALTER TABLE TICKET ALTER COLUMN DescuentoAplicado SET NOT NULL;
ALTER TABLE TICKET ADD CONSTRAINT chk_ticket_precios
CHECK (PrecioBruto >= 0 AND PrecioNeto >= 0);
ALTER TABLE TICKET ADD CONSTRAINT chk_ticket_neto_le_bruto
CHECK (PrecioNeto <= PrecioBruto);
ALTER TABLE TICKET ADD CONSTRAINT chk_ticket_descuento
CHECK (DescuentoAplicado >= 0 AND DescuentoAplicado <= 100);

ALTER TABLE CONSULTA ALTER COLUMN IDCliente SET NOT NULL;
ALTER TABLE CONSULTA ALTER COLUMN IDMedico SET NOT NULL;
ALTER TABLE CONSULTA ALTER COLUMN IDClinica SET NOT NULL;
ALTER TABLE CONSULTA ALTER COLUMN IDTicket SET NOT NULL;
ALTER TABLE CONSULTA ALTER COLUMN Fecha SET NOT NULL;
ALTER TABLE CONSULTA ALTER COLUMN Hora SET NOT NULL;
ALTER TABLE CONSULTA ADD CONSTRAINT chk_costo_consulta
CHECK (CostoConsulta IS NULL OR CostoConsulta >= 0);

ALTER TABLE RECETA_MEDICA ALTER COLUMN FechaNacimiento SET NOT NULL;
ALTER TABLE RECETA_MEDICA ALTER COLUMN Consultorio SET NOT NULL;
ALTER TABLE RECETA_MEDICA ALTER COLUMN Turno SET NOT NULL;
ALTER TABLE RECETA_MEDICA ADD CONSTRAINT chk_peso CHECK (Peso > 0);
ALTER TABLE RECETA_MEDICA ADD CONSTRAINT chk_talla CHECK (Talla > 0);
ALTER TABLE RECETA_MEDICA ADD CONSTRAINT chk_rec_nacimiento
CHECK (FechaNacimiento <= CURRENT_DATE);

ALTER TABLE PEDIR ALTER COLUMN Dosis SET NOT NULL;
ALTER TABLE PEDIR ALTER COLUMN Frecuencia SET NOT NULL;

ALTER TABLE CLIENTE ADD CONSTRAINT UQ_Usuario UNIQUE (Usuario);
ALTER TABLE PERSONAL ADD CONSTRAINT UQ_RFC UNIQUE (RFC);


--  Llaves primarias (entidades, especializaciones, atributos
--  multivaluados y relaciones con llave compuesta).

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

-- Relaciones M:N: PK compuesta sobre los participantes.
ALTER TABLE COMPRAR  ADD CONSTRAINT PK_Comprar  PRIMARY KEY (IDTicket, IDMedicamento);
ALTER TABLE PEDIR    ADD CONSTRAINT PK_Pedir    PRIMARY KEY (NumeroReceta, IDMedicamento);
ALTER TABLE PREPARAR ADD CONSTRAINT PK_Preparar PRIMARY KEY (IDMedicamento, IDPersonal);
ALTER TABLE USAR     ADD CONSTRAINT PK_Usar     PRIMARY KEY (IDPersonal, NombreCientifico);
ALTER TABLE UTILIZAR ADD CONSTRAINT PK_Utilizar PRIMARY KEY (IDMedicamento, NombreCientifico);

-- Relaciones ternarias: la fecha de recibo distingue lotes.
ALTER TABLE PROVEER_MEDICAMENTO
ADD CONSTRAINT PK_ProveerMed
PRIMARY KEY (IDProveedor, IDMedicamento, IDSucursal, FechaDeRecibo);

ALTER TABLE PROVEER_INSUMO
ADD CONSTRAINT PK_ProveerIns
PRIMARY KEY (IDProveedor, IDSucursal, NombreCientifico, FechaDeRecibo);

-- Relacion 1:1 entre consulta y receta.
ALTER TABLE GENERAR_CONSULTA_RECETA
ADD CONSTRAINT PK_GCR PRIMARY KEY (IDConsulta, NumeroReceta);

-- Relacion 1:1 entre ticket y consulta.
ALTER TABLE CONSULTA
ADD CONSTRAINT UQ_ConsultaTicket UNIQUE (IDTicket);


--  Llaves foráneas

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
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE ENFERMERA
ADD CONSTRAINT FK_Enfermera FOREIGN KEY (IDPersonal)
REFERENCES PERSONAL (IDPersonal)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE CAJERO
ADD CONSTRAINT FK_Cajero FOREIGN KEY (IDPersonal)
REFERENCES PERSONAL (IDPersonal)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE LIMPIEZA
ADD CONSTRAINT FK_Limpieza FOREIGN KEY (IDPersonal)
REFERENCES PERSONAL (IDPersonal)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE CUIDADOR
ADD CONSTRAINT FK_Cuidador FOREIGN KEY (IDPersonal)
REFERENCES PERSONAL (IDPersonal)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE FARMACEUTICO
ADD CONSTRAINT FK_Farmaceutico FOREIGN KEY (IDPersonal)
REFERENCES PERSONAL (IDPersonal)
ON DELETE CASCADE
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
REFERENCES FARMACEUTICO (IDPersonal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- USAR (M:N Farmacéutico/Personal-Insumo)
ALTER TABLE USAR
ADD CONSTRAINT FK_UsarPer FOREIGN KEY (IDPersonal)
REFERENCES FARMACEUTICO (IDPersonal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE USAR
ADD CONSTRAINT FK_UsarIns FOREIGN KEY (NombreCientifico)
REFERENCES INSUMO (NombreCientifico)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- UTILIZAR (M:N Medicamento-Insumo)
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

-- TICKET
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

-- CONSULTA
ALTER TABLE CONSULTA
ADD CONSTRAINT FK_ConsultaCliente FOREIGN KEY (IDCliente)
REFERENCES CLIENTE (IDCliente)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE CONSULTA
ADD CONSTRAINT FK_ConsultaMedico FOREIGN KEY (IDMedico)
REFERENCES MEDICO (IDPersonal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE CONSULTA
ADD CONSTRAINT FK_ConsultaEnfermera FOREIGN KEY (IDEnfermera)
REFERENCES ENFERMERA (IDPersonal)
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

-- GENERAR_CONSULTA_RECETA (1:1 total-total)
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


--  Comentarios de documentacion del esquema

COMMENT ON TABLE CLIENTE IS 'Clientes y pacientes registrados en la clinica/farmacia. Los indicadores booleanos distinguen clientes en linea, fisicos y pacientes.';
COMMENT ON COLUMN CLIENTE.IDCliente IS 'Identificador unico del cliente.';
COMMENT ON COLUMN CLIENTE.FechaNacimiento IS 'Fecha de nacimiento del cliente; debe ser una fecha pasada o actual.';
COMMENT ON COLUMN CLIENTE.MetodoPago IS 'Metodo de pago registrado por el cliente, cuando aplica.';
COMMENT ON COLUMN CLIENTE.NumeroTarjeta IS 'Numero de tarjeta asociado al metodo de pago, cuando aplica.';
COMMENT ON COLUMN CLIENTE.VencimientoTarjeta IS 'Fecha de vencimiento de la tarjeta; no debe estar vencida.';
COMMENT ON COLUMN CLIENTE.Usuario IS 'Nombre de usuario unico para acceso al sistema.';
COMMENT ON COLUMN CLIENTE.Contrasena IS 'Contrasena almacenada para autenticacion del cliente.';

COMMENT ON TABLE SUCURSAL IS 'Sucursales donde operan la farmacia y los servicios clinicos.';
COMMENT ON COLUMN SUCURSAL.IDSucursal IS 'Identificador unico de la sucursal.';
COMMENT ON COLUMN SUCURSAL.Nombre IS 'Nombre comercial o administrativo de la sucursal.';

COMMENT ON TABLE PROVEEDOR IS 'Proveedores que suministran medicamentos o insumos.';
COMMENT ON COLUMN PROVEEDOR.IDProveedor IS 'Identificador unico del proveedor.';
COMMENT ON COLUMN PROVEEDOR.RazonSocial IS 'Razon social del proveedor.';

COMMENT ON TABLE PERSONAL IS 'Personal que labora en una sucursal.';
COMMENT ON COLUMN PERSONAL.IDPersonal IS 'Identificador unico del trabajador.';
COMMENT ON COLUMN PERSONAL.IDSucursal IS 'Sucursal a la que pertenece el trabajador.';
COMMENT ON COLUMN PERSONAL.CedulaProfesional IS 'Cedula profesional del trabajador, cuando aplica.';
COMMENT ON COLUMN PERSONAL.RFC IS 'Registro fiscal unico del trabajador.';
COMMENT ON COLUMN PERSONAL.Salario IS 'Salario del trabajador; no puede ser negativo.';

COMMENT ON TABLE CORREO_CLIENTE IS 'Atributo multivaluado: correos electronicos asociados a cada cliente.';
COMMENT ON TABLE TELEFONO_CLIENTE IS 'Atributo multivaluado: telefonos asociados a cada cliente.';
COMMENT ON TABLE TELEFONO_PROVEEDOR IS 'Atributo multivaluado: telefonos asociados a cada proveedor.';
COMMENT ON TABLE HORARIO_PERSONAL IS 'Atributo multivaluado: horarios asignados al personal.';
COMMENT ON TABLE CORREO_PERSONAL IS 'Atributo multivaluado: correos electronicos del personal.';
COMMENT ON TABLE TELEFONO_PERSONAL IS 'Atributo multivaluado: telefonos del personal.';
COMMENT ON TABLE HORARIO_CLINICA IS 'Atributo multivaluado: horarios de atencion de cada clinica.';
COMMENT ON TABLE TELEFONO_SUCURSAL IS 'Atributo multivaluado: telefonos asociados a cada sucursal.';

COMMENT ON TABLE INSUMO IS 'Insumos utilizados en farmacia o clinica. La caducidad se controla por lote en PROVEER_INSUMO.';
COMMENT ON TABLE MEDICAMENTO IS 'Medicamentos manejados por la farmacia. El inventario, precios y preparacion se controlan mediante restricciones, relaciones y triggers.';
COMMENT ON COLUMN MEDICAMENTO.Stock IS 'Inventario disponible del medicamento; no puede ser negativo.';
COMMENT ON COLUMN MEDICAMENTO.PrecioPublico IS 'Precio de venta al publico.';
COMMENT ON COLUMN MEDICAMENTO.PrecioUnitario IS 'Costo unitario del medicamento.';

COMMENT ON TABLE MEDICO IS 'Especializacion de PERSONAL para trabajadores con rol de medico.';
COMMENT ON COLUMN MEDICO.Especialidad IS 'Especialidad medica registrada.';
COMMENT ON COLUMN MEDICO.InstitucionEgreso IS 'Institucion educativa de egreso del medico.';
COMMENT ON COLUMN MEDICO.VigenciaCertificacion IS 'Fecha hasta la cual se considera vigente su certificacion.';

COMMENT ON TABLE ENFERMERA IS 'Especializacion de PERSONAL para trabajadores con rol de enfermeria.';
COMMENT ON COLUMN ENFERMERA.CertificadoReanimacion IS 'Nivel o tipo de certificado de reanimacion.';
COMMENT ON COLUMN ENFERMERA.TipoProcedimiento IS 'Tipo de procedimiento que puede realizar.';

COMMENT ON TABLE CAJERO IS 'Especializacion de PERSONAL para trabajadores con rol de cajero.';
COMMENT ON TABLE LIMPIEZA IS 'Especializacion de PERSONAL para trabajadores con rol de limpieza.';
COMMENT ON TABLE CUIDADOR IS 'Especializacion de PERSONAL para trabajadores con rol de cuidador.';
COMMENT ON TABLE FARMACEUTICO IS 'Especializacion de PERSONAL para trabajadores con rol farmaceutico.';

COMMENT ON TABLE CLINICA IS 'Clinicas o consultorios ubicados dentro de una sucursal.';
COMMENT ON COLUMN CLINICA.NumCuartos IS 'Numero de cuartos disponibles en la clinica; debe ser mayor que cero.';

COMMENT ON TABLE PROVEER_MEDICAMENTO IS 'Relacion ternaria que registra lotes de medicamentos entregados por proveedores a sucursales.';
COMMENT ON TABLE PROVEER_INSUMO IS 'Relacion ternaria que registra lotes de insumos entregados por proveedores a sucursales.';
COMMENT ON COLUMN PROVEER_MEDICAMENTO.FechaDeCaducidad IS 'Fecha de caducidad del lote de medicamento.';
COMMENT ON COLUMN PROVEER_INSUMO.FechaDeCaducidad IS 'Fecha de caducidad del lote de insumo.';

COMMENT ON TABLE PREPARAR IS 'Relacion M:N entre FARMACEUTICO y MEDICAMENTO; registra medicamentos preparados y su cantidad.';
COMMENT ON TABLE USAR IS 'Relacion M:N entre FARMACEUTICO e INSUMO; registra los insumos utilizados por personal farmaceutico.';
COMMENT ON TABLE UTILIZAR IS 'Relacion M:N entre MEDICAMENTO e INSUMO; representa la composicion del medicamento.';

COMMENT ON TABLE TICKET IS 'Tickets generados por compras o servicios.';
COMMENT ON COLUMN TICKET.PrecioBruto IS 'Total del ticket antes de aplicar descuento.';
COMMENT ON COLUMN TICKET.PrecioNeto IS 'Total del ticket despues de aplicar descuento.';
COMMENT ON COLUMN TICKET.DescuentoAplicado IS 'Porcentaje de descuento aplicado al ticket.';

COMMENT ON TABLE COMPRAR IS 'Relacion M:N entre TICKET y MEDICAMENTO; registra los productos comprados y su cantidad.';
COMMENT ON COLUMN COMPRAR.Cantidad IS 'Cantidad de unidades del medicamento incluidas en el ticket.';

COMMENT ON TABLE CONSULTA IS 'Consultas medicas realizadas en una clinica. IDTicket es unico para mantener la relacion 1:1 con TICKET.';
COMMENT ON COLUMN CONSULTA.IDMedico IS 'Medico responsable de la consulta.';
COMMENT ON COLUMN CONSULTA.IDEnfermera IS 'Enfermera asociada a la consulta, cuando aplica.';
COMMENT ON COLUMN CONSULTA.CostoConsulta IS 'Costo de la consulta; no puede ser negativo.';

COMMENT ON TABLE RECETA_MEDICA IS 'Recetas medicas emitidas a partir de una consulta.';
COMMENT ON COLUMN RECETA_MEDICA.NumeroReceta IS 'Identificador unico de la receta.';
COMMENT ON COLUMN RECETA_MEDICA.Peso IS 'Peso del paciente al momento de registrar la receta.';
COMMENT ON COLUMN RECETA_MEDICA.Talla IS 'Talla del paciente al momento de registrar la receta.';
COMMENT ON COLUMN RECETA_MEDICA.Turno IS 'Turno en el que se emite la receta.';

COMMENT ON TABLE GENERAR_CONSULTA_RECETA IS 'Relacion 1:1 entre CONSULTA y RECETA_MEDICA.';
COMMENT ON TABLE PEDIR IS 'Relacion M:N entre RECETA_MEDICA y MEDICAMENTO; registra dosis y frecuencia indicadas.';
