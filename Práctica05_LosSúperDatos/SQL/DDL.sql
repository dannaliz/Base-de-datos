-- ============================================================
--  DDL.sql  -  Esquema de base de datos: Clinica / Farmacia
--  Modelo Relacional - Practica 04
-- ============================================================

CREATE TABLE CLIENTE (
    IDCliente       INT,
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
    CedulaProfesional INT(8),
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
    idCliente INT,
    Telefono  VARCHAR(20)
);



-- 7
CREATE TABLE TELEFONO_PROVEEDOR (
    IDProveedor INT,
    Telefono    VARCHAR(20)
);

-- 8
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
    PrecioUnitario       DECIMAL(10,2),
    FechaCaducidad       DATE
);



-- 9
CREATE TABLE HORARIO_PERSONAL (
    IDPersonal INT,
    Horario    VARCHAR(60)
);

-- 10
CREATE TABLE CORREO_PERSONAl (
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
    idPersonal           INT,
    Especialidad         VARCHAR(100),
    InstitucionEgreso    VARCHAR(150),
    VigenciaCertificacion DATE
);

-- 13
CREATE TABLE ENFERMERA (
    idPersonal              INT,
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
    idPersonal INT
);

-- 18
CREATE TABLE CLINICA (
    IDClinica  INT,
    idSucursal INT,
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
    idSucursal INT,
    Telefono   VARCHAR(20)
);

-- 21
CREATE TABLE MEDICAMENTO (
    IDMedicamento        INT,
    IDPersonal           INT,
    IDProveedor          INT,
    NombreCientifico     VARCHAR(150),
    PrecioPublico        DECIMAL(10,2),
    FechaDeCaducidad     DATE,
    PrecioUnitario       DECIMAL(10,2),
    MedicamentosEsteriles BOOLEAN,
    Preparaciones        TEXT,
    Formulacion          TEXT,
    PreparadosOficiales  BOOLEAN,
    Pediatrica           BOOLEAN,
    Dermatologica        BOOLEAN
);

-- 22
CREATE TABLE TENER (
    IDSucursal    INT,
    IDMedicamento INT,
    StockDisponible INT
);

-- 23
CREATE TABLE PROVEER_MEDICAMENTO (
    IDProveedor              INT,
    IDMedicamento            INT,
    IDSucursal               INT,
    CondicionDeAlmacenamiento VARCHAR(200),
    Cantidad                 INT,
    FechaDeRecibo            DATE,
    FechaDeCaducidad         DATE
);

-- 24
CREATE TABLE PROVEER_INSUMO (
    IDProveedor              INT,
    IDSucursal               INT,
    NombreCientifico         VARCHAR(150),
    CondicionDeAlmacenamiento VARCHAR(200),
    Cantidad                 INT,
    FechaDeRecibo            DATE,
    FechaDeCaducidad         DATE
);

-- 25
CREATE TABLE PREPARAR (
    IDMedicamento INT,
    IDPersonal    INT,
    Cantidad      INT
);

-- 26
CREATE TABLE USAR (
    IDPersonal       INT,
    NombreCientifico VARCHAR(150)
);

-- 27
CREATE TABLE TICKET (
    IDTicket   INT,
    IDSucursal INT,
    IDCliente  INT,
    IDConsulta INT
);

-- 28
CREATE TABLE COMPRAR (
    IDTicket      INT,
    IDMedicamento INT
);

-- 29
CREATE TABLE CONSULTA (
    IDConsulta    INT,
    IDCliente     INT,
    IDMedicamento INT,
    IDMedico      INT,
    IDEnfermera   INT,
    IDClinica     INT,
    IDTicket      INT,
    Fecha         DATE,
    Hora          TIME,
    Diagnostico   TEXT,
    CostoConsulta DECIMAL(10,2)
);

-- 30
CREATE TABLE GENERAR (
    IDTicket   INT,
    IDConsulta INT
);

-- 31
CREATE TABLE RECETA_MEDICA (
    NumeroReceta    INT,
    IDCliente       INT,
    IDConsulta      INT,
    FechaNacimiento DATE,
    Peso            DECIMAL(5,2),
    Talla           DECIMAL(4,2),
    Alergias        TEXT,
    Diagnostico     TEXT,
    Consultorio     VARCHAR(60),
    Turno           VARCHAR(30)
);

-- 32
CREATE TABLE PEDIR (
    NumeroReceta  INT,
    IDMedicamento INT,
    Dosis         VARCHAR(100),
    Frecuencia    VARCHAR(80)
);

-- Llaves Primarias:
ALTER TABLE CLIENTE ADD CONSTRAINT PK_IDCliente PRIMARY KEY (IDCliente);
ALTER TABLE SUCURSAL ADD CONSTRAINT PK_IDSucursal PRIMARY KEY (IDSucursal);
ALTER TABLE PROVEEDOR ADD CONSTRAINT PK_IDProveedor PRIMARY KEY (IDProveedor);
ALTER TABLE PERSONAL ADD CONSTRAINT PK_IDPersonal PRIMARY KEY (IDPersonal);
ALTER TABLE INSUMO ADD CONSTRAINT PK_NombreCientifico PRIMARY KEY (NombreCientifico);
ALTER TABLE MEDICAMENTO ADD CONSTRAINT PK_IDMedicamento PRIMARY KEY (IDMedicamento);
ALTER TABLE CLINICA ADD CONSTRAINT PK_IDClinica PRIMARY KEY (IDClinica);
ALTER TABLE TICKET ADD CONSTRAINT PK_IDTicket PRIMARY KEY (IDTicket);
ALTER TABLE CONSULTA ADD CONSTRAINT PK_IDConsulta PRIMARY KEY (IDConsulta);
ALTER TABLE RECETA_MEDICA ADD CONSTRAINT PK_NumeroReceta PRIMARY KEY (NumeroReceta);

-- Llaves Compuestas:
ALTER TABLE CORREO_CLIENTE ADD CONSTRAINT PK_CorreoCliente PRIMARY KEY (IDCliente, CorreoElectronico);
ALTER TABLE TELEFONO_CLIENTE ADD CONSTRAINT PK_TelCliente PRIMARY KEY (IDCliente, Telefono);
ALTER TABLE TELEFONO_PROVEEDOR ADD CONSTRAINT PK_TelProveedor PRIMARY KEY (IDProveedor, Telefono);
ALTER TABLE HORARIO_PERSONAL ADD CONSTRAINT PK_HorarioPersonal PRIMARY KEY (IDPersonal, Horario);
ALTER TABLE CORREO_PERSONAL ADD CONSTRAINT PK_CorreoPersonal PRIMARY KEY (IDPersonal, CorreoElectronico);
ALTER TABLE TELEFONO_PERSONAL ADD CONSTRAINT PK_TelPersonal PRIMARY KEY (IDPersonal, Telefono);
ALTER TABLE HORARIO_CLINICA ADD CONSTRAINT PK_HorarioClinica PRIMARY KEY (IDClinica, Horario);
ALTER TABLE TELEFONO_SUCURSAL ADD CONSTRAINT PK_TelSucursal PRIMARY KEY (IDSucursal, Telefono);
ALTER TABLE TENER ADD CONSTRAINT PK_Tener PRIMARY KEY (IDSucursal, IDMedicamento);
ALTER TABLE PROVEER_MEDICAMENTO ADD CONSTRAINT PK_ProvMed PRIMARY KEY (IDProveedor, IDMedicamento, IDSucursal);
ALTER TABLE PROVEER_INSUMO ADD CONSTRAINT PK_ProvIns PRIMARY KEY (IDProveedor, NombreCientifico, IDSucursal);
ALTER TABLE PREPARAR ADD CONSTRAINT PK_Preparar PRIMARY KEY (IDMedicamento, IDPersonal);
ALTER TABLE USAR ADD CONSTRAINT PK_Usar PRIMARY KEY (IDPersonal, NombreCientifico);
ALTER TABLE COMPRAR ADD CONSTRAINT PK_Comprar PRIMARY KEY (IDTicket, IDMedicamento);
ALTER TABLE GENERAR ADD CONSTRAINT PK_Generar PRIMARY KEY (IDTicket, IDConsulta);
ALTER TABLE PEDIR ADD CONSTRAINT PK_Pedir PRIMARY KEY (NumeroReceta, IDMedicamento);

-- Llaves Foraneas:

-- PERSONAL con SUCURSAL
ALTER TABLE PERSONAL ADD CONSTRAINT FK_IDSucursal FOREIGN KEY (IDSucursal) REFERENCES SUCURSAL (IDSucursal);

-- CORREO_CLIENTE, TELEFONO_CLIENTE con CLIENTE
ALTER TABLE CORREO_CLIENTE ADD CONSTRAINT FK_CC_IDCliente FOREIGN KEY (IDCliente) REFERENCES CLIENTE (IDCliente);
ALTER TABLE TELEFONO_CLIENTE ADD CONSTRAINT FK_TC_IDCliente FOREIGN KEY (IDCliente) REFERENCES CLIENTE (IDCliente);

-- TELEFONO_PROVEEDOR con PROVEEDOR
ALTER TABLE TELEFONO_PROVEEDOR ADD CONSTRAINT FK_TP_IDProveedor FOREIGN KEY (IDProveedor) REFERENCES PROVEEDOR (IDProveedor);

-- PERSONAL
ALTER TABLE HORARIO_PERSONAL ADD CONSTRAINT FK_HP_IDPersonal FOREIGN KEY (IDPersonal) REFERENCES PERSONAL (IDPersonal);
ALTER TABLE CORREO_PERSONAL ADD CONSTRAINT FK_CP_IDPersonal FOREIGN KEY (IDPersonal) REFERENCES PERSONAL (IDPersonal);
ALTER TABLE TELEFONO_PERSONAL ADD CONSTRAINT FK_TP2_IDPersonal FOREIGN KEY (IDPersonal) REFERENCES PERSONAL (IDPersonal);

-- Especializaciones con Personal
ALTER TABLE MEDICO ADD CONSTRAINT FK_Medico FOREIGN KEY (IDPersonal) REFERENCES PERSONAL (IDPersonal);
ALTER TABLE ENFERMERA ADD CONSTRAINT FK_Enfermera FOREIGN KEY (IDPersonal) REFERENCES PERSONAL (IDPersonal);
ALTER TABLE CAJERO ADD CONSTRAINT FK_Cajero FOREIGN KEY (IDPersonal) REFERENCES PERSONAL (IDPersonal);
ALTER TABLE LIMPIEZA ADD CONSTRAINT FK_Limpieza FOREIGN KEY (IDPersonal) REFERENCES PERSONAL (IDPersonal);
ALTER TABLE CUIDADOR ADD CONSTRAINT FK_Cuidador FOREIGN KEY (IDPersonal) REFERENCES PERSONAL (IDPersonal);
ALTER TABLE FARMACEUTICO ADD CONSTRAINT FK_Farmaceutico FOREIGN KEY (IDPersonal) REFERENCES PERSONAL (IDPersonal);

-- CLINICA con SUCURSAL
ALTER TABLE CLINICA ADD CONSTRAINT FK_ClinicaSucursal FOREIGN KEY (IDSucursal) REFERENCES SUCURSAL (IDSucursal);
ALTER TABLE HORARIO_CLINICA ADD CONSTRAINT FK_HC_IDClinica FOREIGN KEY (IDClinica) REFERENCES CLINICA (IDClinica);
ALTER TABLE TELEFONO_SUCURSAL ADD CONSTRAINT FK_TS_IDSucursal FOREIGN KEY (IDSucursal) REFERENCES SUCURSAL (IDSucursal);

-- MEDICAMENTO
ALTER TABLE MEDICAMENTO ADD CONSTRAINT FK_MedPersonal FOREIGN KEY (IDPersonal) REFERENCES PERSONAL (IDPersonal);
ALTER TABLE MEDICAMENTO ADD CONSTRAINT FK_MedProveedor FOREIGN KEY (IDProveedor) REFERENCES PROVEEDOR (IDProveedor);

-- RELACOINES
ALTER TABLE TENER ADD CONSTRAINT FK_TenerSucursal FOREIGN KEY (IDSucursal) REFERENCES SUCURSAL (IDSucursal);
ALTER TABLE TENER ADD CONSTRAINT FK_TenerMedicamento FOREIGN KEY (IDMedicamento) REFERENCES MEDICAMENTO (IDMedicamento);

ALTER TABLE PROVEER_MEDICAMENTO ADD CONSTRAINT FK_PM_Proveedor FOREIGN KEY (IDProveedor) REFERENCES PROVEEDOR (IDProveedor);
ALTER TABLE PROVEER_MEDICAMENTO ADD CONSTRAINT FK_PM_Medicamento FOREIGN KEY (IDMedicamento) REFERENCES MEDICAMENTO (IDMedicamento);
ALTER TABLE PROVEER_MEDICAMENTO ADD CONSTRAINT FK_PM_Sucursal FOREIGN KEY (IDSucursal) REFERENCES SUCURSAL (IDSucursal);

ALTER TABLE PROVEER_INSUMO ADD CONSTRAINT FK_PI_Proveedor FOREIGN KEY (IDProveedor) REFERENCES PROVEEDOR (IDProveedor);
ALTER TABLE PROVEER_INSUMO ADD CONSTRAINT FK_PI_Insumo FOREIGN KEY (NombreCientifico) REFERENCES INSUMO (NombreCientifico);
ALTER TABLE PROVEER_INSUMO ADD CONSTRAINT FK_PI_Sucursal FOREIGN KEY (IDSucursal) REFERENCES SUCURSAL (IDSucursal);

ALTER TABLE PREPARAR ADD CONSTRAINT FK_PrepararMed FOREIGN KEY (IDMedicamento) REFERENCES MEDICAMENTO (IDMedicamento);
ALTER TABLE PREPARAR ADD CONSTRAINT FK_PrepararPer FOREIGN KEY (IDPersonal) REFERENCES PERSONAL (IDPersonal);

ALTER TABLE USAR ADD CONSTRAINT FK_UsarPer FOREIGN KEY (IDPersonal) REFERENCES PERSONAL (IDPersonal);
ALTER TABLE USAR ADD CONSTRAINT FK_UsarIns FOREIGN KEY (NombreCientifico) REFERENCES INSUMO (NombreCientifico);

-- TICKET
ALTER TABLE TICKET ADD CONSTRAINT FK_TicketSucursal FOREIGN KEY (IDSucursal) REFERENCES SUCURSAL (IDSucursal);
ALTER TABLE TICKET ADD CONSTRAINT FK_TicketCliente FOREIGN KEY (IDCliente) REFERENCES CLIENTE (IDCliente);

-- COMPRA
ALTER TABLE COMPRAR ADD CONSTRAINT FK_CompraTicket FOREIGN KEY (IDTicket) REFERENCES TICKET (IDTicket);
ALTER TABLE COMPRAR ADD CONSTRAINT FK_CompraMedicamento FOREIGN KEY (IDMedicamento) REFERENCES MEDICAMENTO (IDMedicamento);

-- CONSULTA
ALTER TABLE CONSULTA ADD CONSTRAINT FK_ConsultaCliente FOREIGN KEY (IDCliente) REFERENCES CLIENTE (IDCliente);
ALTER TABLE CONSULTA ADD CONSTRAINT FK_ConsultaMedico FOREIGN KEY (IDMedico) REFERENCES PERSONAL (IDPersonal);
ALTER TABLE CONSULTA ADD CONSTRAINT FK_ConsultaEnfermera FOREIGN KEY (IDEnfermera) REFERENCES PERSONAL (IDPersonal);
ALTER TABLE CONSULTA ADD CONSTRAINT FK_ConsultaClinica FOREIGN KEY (IDClinica) REFERENCES CLINICA (IDClinica);
ALTER TABLE CONSULTA ADD CONSTRAINT FK_ConsultaTicket FOREIGN KEY (IDTicket) REFERENCES TICKET (IDTicket);

-- GENERAR
ALTER TABLE GENERAR ADD CONSTRAINT FK_GenerarTicket FOREIGN KEY (IDTicket) REFERENCES TICKET (IDTicket);
ALTER TABLE GENERAR ADD CONSTRAINT FK_GenerarConsulta FOREIGN KEY (IDConsulta) REFERENCES CONSULTA (IDConsulta);

-- RECETA
ALTER TABLE RECETA_MEDICA ADD CONSTRAINT FK_RecetaCliente FOREIGN KEY (IDCliente) REFERENCES CLIENTE (IDCliente);
ALTER TABLE RECETA_MEDICA ADD CONSTRAINT FK_RecetaConsulta FOREIGN KEY (IDConsulta) REFERENCES CONSULTA (IDConsulta);

ALTER TABLE PEDIR ADD CONSTRAINT FK_PedirReceta FOREIGN KEY (NumeroReceta) REFERENCES RECETA_MEDICA (NumeroReceta);
ALTER TABLE PEDIR ADD CONSTRAINT FK_PedirMedicamento FOREIGN KEY (IDMedicamento) REFERENCES MEDICAMENTO (IDMedicamento);
