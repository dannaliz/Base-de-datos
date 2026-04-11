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
    CedulaProfesional VARCHAR(40),
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
    CorreoElectronico VARCHAR(120)
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
    CorreoElectronico VARCHAR(120)
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
    NombreCientifico     VARCHAR(150),
    IDPersonal           INT,
    IDProveedor          INT,
    PrecioPublico        DECIMAL(10,2),
    FechaDeCaducidad     DATE,
    PrecioUnitario       DECIMAL(10,2),
    MedicamentosEsteriles BOOLEAN,
    Preparaciones        VARCHAR(100),
    Formulacion          VARCHAR(100),
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
    NombreCientifico         VARCHAR(150),
    IDSucursal               INT,
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


