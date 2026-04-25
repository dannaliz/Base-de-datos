-- ============================================================
--  DDL.sql  -  Esquema de base de datos: Clinica / Farmacia
--  Modelo Relacional - Practica 04
-- ============================================================

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

--Restricciones de Dominio:
ALTER TABLE CLIENTE ALTER COLUMN Nombre 
SET NOT NULL;
ALTER TABLE CLIENTE ALTER COLUMN ApellidoMaterno 
SET NOT NULL;
ALTER TABLE CLIENTE ALTER COLUMN ApellidoPaterno 
SET NOT NULL;
ALTER TABLE CLIENTE
ADD CONSTRAINT chk_vencimiento_tarjeta
CHECK (VencimientoTarjeta >= CURRENT_DATE);
ALTER TABLE PERSONAL ADD CONSTRAINT rfcvalido
CHECK (CHAR_LENGTH(RFC)=13);
ALTER TABLE PERSONAL ALTER COLUMN Nombre 
SET NOT NULL;
ALTER TABLE PERSONAL ALTER COLUMN ApellidoMaterno 
SET NOT NULL;
ALTER TABLE PERSONAL ALTER COLUMN ApellidoPaterno 
SET NOT NULL;
ALTER TABLE PERSONAL ADD CONSTRAINT cedprofvalida
CHECK (CHAR_LENGTH(CedulaProfesional)=8);
ALTER TABLE CLINICA ALTER COLUMN Nombre 
SET NOT NULL;
ALTER TABLE SUCURSAL ALTER COLUMN Nombre 
SET NOT NULL;
ALTER TABLE TENER ALTER COLUMN StockDisponible
SET NOT NULL;
ALTER TABLE TENER
ADD CONSTRAINT chk_stock_nonegativo
CHECK (StockDisponible >= 0);
ALTER TABLE MEDICAMENTO
ADD CONSTRAINT chk_caducidad_med
CHECK (FechaDeCaducidad >= CURRENT_DATE);
ALTER TABLE INSUMO
ADD CONSTRAINT chk_caducidad_insumo
CHECK (FechaCaducidad >= CURRENT_DATE);
ALTER TABLE PROVEER_INSUMO ALTER COLUMN Cantidad
SET NOT NULL;
ALTER TABLE PROVEER_INSUMO
ADD CONSTRAINT cantidad_nonegativa
Check(Cantidad  >= 0);
ALTER TABLE PROVEER_INSUMO
ADD CONSTRAINT caducidad_proveedor
CHECK (FechaDeCaducidad >= CURRENT_DATE);
ALTER TABLE PROVEEDOR ALTER COLUMN RazonSocial
SET NOT NULL;
ALTER TABLE PROVEER_MEDICAMENTO ALTER COLUMN Cantidad
SET NOT NULL;
ALTER TABLE PROVEER_MEDICAMENTO
ADD CONSTRAINT cantidad_nonegativamed
Check(Cantidad  >= 0);
ALTER TABLE PROVEER_MEDICAMENTO
ADD CONSTRAINT caducidad_med
CHECK (FechaDeCaducidad >= CURRENT_DATE);
ALTER TABLE PREPARAR
ADD CONSTRAINT cantidad_prep
CHECK(Cantidad  >= 0);
ALTER TABLE PREPARAR ALTER COLUMN Cantidad
SET NOT NULL;
ALTER TABLE RECETA_MEDICA ALTER COLUMN FechaNacimiento
SET NOT NULL;
ALTER TABLE RECETA_MEDICA ALTER COLUMN Consultorio
SET NOT NULL;
ALTER TABLE PERSONAL 
ADD CONSTRAINT salario_nonegativo
CHECK(Salario  >= 0);
ALTER TABLE MEDICO
ADD CONSTRAINT caducidad_medico
CHECK (VigenciaCertificacion >= CURRENT_DATE);
ALTER TABLE MEDICAMENTO ADD CONSTRAINT CHK_Precio 
    CHECK (PrecioPublico >= 0 AND PrecioUnitario >= 0);
ALTER TABLE CLIENTE ADD CONSTRAINT UQ_Usuario UNIQUE (Usuario);
ALTER TABLE PERSONAL ADD CONSTRAINT UQ_RFC UNIQUE (RFC);







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

-- PERSONAL
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

-- Especializaciones con Personal
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
ADD CONSTRAINT FK_ClinicaSucursal 
FOREIGN KEY (IDSucursal) 
REFERENCES SUCURSAL (IDSucursal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE HORARIO_CLINICA 
ADD CONSTRAINT FK_HC_IDClinica 
FOREIGN KEY (IDClinica) 
REFERENCES CLINICA (IDClinica)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE TELEFONO_SUCURSAL 
ADD CONSTRAINT FK_TS_IDSucursal 
FOREIGN KEY (IDSucursal) 
REFERENCES SUCURSAL (IDSucursal)
ON DELETE CASCADE
ON UPDATE CASCADE;
-- MEDICAMENTO
ALTER TABLE MEDICAMENTO 
ADD CONSTRAINT FK_MedPersonal 
FOREIGN KEY (IDPersonal) 
REFERENCES PERSONAL (IDPersonal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE MEDICAMENTO 
ADD CONSTRAINT FK_MedProveedor 
FOREIGN KEY (IDProveedor) 
REFERENCES PROVEEDOR (IDProveedor)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- RELACIONES
ALTER TABLE TENER 
ADD CONSTRAINT FK_TenerSucursal 
FOREIGN KEY (IDSucursal) 
REFERENCES SUCURSAL (IDSucursal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE TENER 
ADD CONSTRAINT FK_TenerMedicamento 
FOREIGN KEY (IDMedicamento) 
REFERENCES MEDICAMENTO (IDMedicamento)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE PROVEER_MEDICAMENTO 
ADD CONSTRAINT FK_PM_Proveedor 
FOREIGN KEY (IDProveedor) 
REFERENCES PROVEEDOR (IDProveedor)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE PROVEER_MEDICAMENTO 
ADD CONSTRAINT FK_PM_Medicamento 
FOREIGN KEY (IDMedicamento) 
REFERENCES MEDICAMENTO (IDMedicamento)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE PROVEER_MEDICAMENTO 
ADD CONSTRAINT FK_PM_Sucursal 
FOREIGN KEY (IDSucursal) 
REFERENCES SUCURSAL (IDSucursal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE PROVEER_INSUMO 
ADD CONSTRAINT FK_PI_Proveedor 
FOREIGN KEY (IDProveedor) 
REFERENCES PROVEEDOR (IDProveedor)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE PROVEER_INSUMO 
ADD CONSTRAINT FK_PI_Insumo 
FOREIGN KEY (NombreCientifico) 
REFERENCES INSUMO (NombreCientifico)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE PROVEER_INSUMO 
ADD CONSTRAINT FK_PI_Sucursal 
FOREIGN KEY (IDSucursal) 
REFERENCES SUCURSAL (IDSucursal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE PREPARAR 
ADD CONSTRAINT FK_PrepararMed 
FOREIGN KEY (IDMedicamento) 
REFERENCES MEDICAMENTO (IDMedicamento)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE PREPARAR 
ADD CONSTRAINT FK_PrepararPer 
FOREIGN KEY (IDPersonal) 
REFERENCES PERSONAL (IDPersonal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE USAR 
ADD CONSTRAINT FK_UsarPer 
FOREIGN KEY (IDPersonal) 
REFERENCES PERSONAL (IDPersonal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE USAR 
ADD CONSTRAINT FK_UsarIns 
FOREIGN KEY (NombreCientifico) 
REFERENCES INSUMO (NombreCientifico)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- TICKET
ALTER TABLE TICKET 
ADD CONSTRAINT FK_TicketSucursal 
FOREIGN KEY (IDSucursal) 
REFERENCES SUCURSAL (IDSucursal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE TICKET 
ADD CONSTRAINT FK_TicketCliente 
FOREIGN KEY (IDCliente) 
REFERENCES CLIENTE (IDCliente)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE TICKET 
ADD CONSTRAINT FK_TicketConsulta 
FOREIGN KEY (IDConsulta) 
REFERENCES CONSULTA (IDConsulta)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- COMPRA
ALTER TABLE COMPRAR 
ADD CONSTRAINT FK_CompraTicket 
FOREIGN KEY (IDTicket) 
REFERENCES TICKET (IDTicket)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE COMPRAR 
ADD CONSTRAINT FK_CompraMedicamento 
FOREIGN KEY (IDMedicamento) 
REFERENCES MEDICAMENTO (IDMedicamento)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- CONSULTA
ALTER TABLE CONSULTA 
ADD CONSTRAINT FK_ConsultaCliente 
FOREIGN KEY (IDCliente) 
REFERENCES CLIENTE (IDCliente)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE CONSULTA 
ADD CONSTRAINT FK_ConsultaMedico 
FOREIGN KEY (IDMedico) 
REFERENCES PERSONAL (IDPersonal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE CONSULTA 
ADD CONSTRAINT FK_ConsultaEnfermera 
FOREIGN KEY (IDEnfermera) 
REFERENCES PERSONAL (IDPersonal)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE CONSULTA 
ADD CONSTRAINT FK_ConsultaClinica 
FOREIGN KEY (IDClinica) 
REFERENCES CLINICA (IDClinica)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE CONSULTA 
ADD CONSTRAINT FK_ConsultaTicket 
FOREIGN KEY (IDTicket) 
REFERENCES TICKET (IDTicket)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE CONSULTA 
ADD CONSTRAINT FK_ConsultaMedicamento 
FOREIGN KEY (IDMedicamento) 
REFERENCES MEDICAMENTO (IDMedicamento)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- GENERAR
ALTER TABLE GENERAR 
ADD CONSTRAINT FK_GenerarTicket 
FOREIGN KEY (IDTicket) 
REFERENCES TICKET (IDTicket)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE GENERAR 
ADD CONSTRAINT FK_GenerarConsulta 
FOREIGN KEY (IDConsulta) 
REFERENCES CONSULTA (IDConsulta)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- RECETA
ALTER TABLE RECETA_MEDICA 
ADD CONSTRAINT FK_RecetaCliente 
FOREIGN KEY (IDCliente) 
REFERENCES CLIENTE (IDCliente)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE RECETA_MEDICA 
ADD CONSTRAINT FK_RecetaConsulta 
FOREIGN KEY (IDConsulta) 
REFERENCES CONSULTA (IDConsulta)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE PEDIR 
ADD CONSTRAINT FK_PedirReceta 
FOREIGN KEY (NumeroReceta) 
REFERENCES RECETA_MEDICA (NumeroReceta)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE PEDIR 
ADD CONSTRAINT FK_PedirMedicamento 
FOREIGN KEY (IDMedicamento) 
REFERENCES MEDICAMENTO (IDMedicamento)
ON DELETE RESTRICT
ON UPDATE CASCADE;

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
COMMENT ON COLUMN SUCURSAL.Calle IS 'Dato de dirección correspondiente a Calle.';
COMMENT ON COLUMN SUCURSAL.NumExterior IS 'Dato de dirección correspondiente a NumExterior.';
COMMENT ON COLUMN SUCURSAL.NumInterior IS 'Dato de dirección correspondiente a NumInterior.';
COMMENT ON COLUMN SUCURSAL.Colonia IS 'Dato de dirección correspondiente a Colonia.';
COMMENT ON COLUMN SUCURSAL.Estado IS 'Dato de dirección correspondiente a Estado.';
COMMENT ON TABLE PROVEEDOR IS 'Almacena la información de los proveedores del sistema.';
COMMENT ON COLUMN PROVEEDOR.IDProveedor IS 'Identificador único del proveedor.';
COMMENT ON COLUMN PROVEEDOR.RazonSocial IS 'Columna RazonSocial de la tabla PROVEEDOR.';
COMMENT ON COLUMN PROVEEDOR.Calle IS 'Dato de dirección correspondiente a Calle.';
COMMENT ON COLUMN PROVEEDOR.NumExterior IS 'Dato de dirección correspondiente a NumExterior.';
COMMENT ON COLUMN PROVEEDOR.NumInterior IS 'Dato de dirección correspondiente a NumInterior.';
COMMENT ON COLUMN PROVEEDOR.Colonia IS 'Dato de dirección correspondiente a Colonia.';
COMMENT ON COLUMN PROVEEDOR.Estado IS 'Dato de dirección correspondiente a Estado.';
COMMENT ON TABLE PERSONAL IS 'Almacena la información del personal que labora en una sucursal.';
COMMENT ON COLUMN PERSONAL.IDPersonal IS 'Identificador único del integrante del personal.';
COMMENT ON COLUMN PERSONAL.IDSucursal IS 'Sucursal a la que pertenece el integrante del personal.';
COMMENT ON COLUMN PERSONAL.Nombre IS 'Nombre o denominación de la entidad.';
COMMENT ON COLUMN PERSONAL.ApellidoPaterno IS 'Apellido Paterno de la persona registrada.';
COMMENT ON COLUMN PERSONAL.ApellidoMaterno IS 'Apellido Materno de la persona registrada.';
COMMENT ON COLUMN PERSONAL.CedulaProfesional IS 'Cédula profesional del integrante del personal.';
COMMENT ON COLUMN PERSONAL.RFC IS 'Registro Federal de Contribuyentes del integrante del personal.';
COMMENT ON COLUMN PERSONAL.Calle IS 'Dato de dirección correspondiente a Calle.';
COMMENT ON COLUMN PERSONAL.NumExterior IS 'Dato de dirección correspondiente a NumExterior.';
COMMENT ON COLUMN PERSONAL.NumInterior IS 'Dato de dirección correspondiente a NumInterior.';
COMMENT ON COLUMN PERSONAL.Colonia IS 'Dato de dirección correspondiente a Colonia.';
COMMENT ON COLUMN PERSONAL.Estado IS 'Dato de dirección correspondiente a Estado.';
COMMENT ON COLUMN PERSONAL.Salario IS 'Salario del integrante del personal.';
COMMENT ON TABLE CORREO_CLIENTE IS 'Almacena los correos electrónicos asociados a cada cliente.';
COMMENT ON COLUMN CORREO_CLIENTE.IDCliente IS 'Llave de referencia o identificador asociado a cliente.';
COMMENT ON COLUMN CORREO_CLIENTE.CorreoElectronico IS 'Dirección de correo electrónico.';
COMMENT ON TABLE TELEFONO_CLIENTE IS 'Almacena los teléfonos asociados a cada cliente.';
COMMENT ON COLUMN TELEFONO_CLIENTE.idCliente IS 'Columna idCliente de la tabla TELEFONO_CLIENTE.';
COMMENT ON COLUMN TELEFONO_CLIENTE.Telefono IS 'Número telefónico de contacto.';
COMMENT ON TABLE TELEFONO_PROVEEDOR IS 'Almacena los teléfonos asociados a cada proveedor.';
COMMENT ON COLUMN TELEFONO_PROVEEDOR.IDProveedor IS 'Llave de referencia o identificador asociado a proveedor.';
COMMENT ON COLUMN TELEFONO_PROVEEDOR.Telefono IS 'Número telefónico de contacto.';
COMMENT ON TABLE INSUMO IS 'Almacena los insumos utilizados en la clínica o farmacia.';
COMMENT ON COLUMN INSUMO.NombreCientifico IS 'Nombre científico que identifica al insumo.';
COMMENT ON COLUMN INSUMO.Presentacion IS 'Dato correspondiente a Presentacion.';
COMMENT ON COLUMN INSUMO.FormaFarmaceutica IS 'Dato correspondiente a FormaFarmaceutica.';
COMMENT ON COLUMN INSUMO.Concentracion IS 'Dato correspondiente a Concentracion.';
COMMENT ON COLUMN INSUMO.ViaAdministracion IS 'Dato correspondiente a ViaAdministracion.';
COMMENT ON COLUMN INSUMO.Clasificacion IS 'Dato correspondiente a Clasificacion.';
COMMENT ON COLUMN INSUMO.Descripcion IS 'Información descriptiva correspondiente a Descripcion.';
COMMENT ON COLUMN INSUMO.LaboratorioFabricante IS 'Dato correspondiente a LaboratorioFabricante.';
COMMENT ON COLUMN INSUMO.NombreComercial IS 'Nombre o denominación de comercial.';
COMMENT ON COLUMN INSUMO.TipoDeControl IS 'Dato correspondiente a TipoDeControl.';
COMMENT ON COLUMN INSUMO.PrecioPublico IS 'Valor monetario correspondiente a PrecioPublico.';
COMMENT ON COLUMN INSUMO.PrecioUnitario IS 'Valor monetario correspondiente a PrecioUnitario.';
COMMENT ON COLUMN INSUMO.FechaCaducidad IS 'Fecha correspondiente al atributo FechaCaducidad.';
COMMENT ON TABLE HORARIO_PERSONAL IS 'Almacena los horarios asignados al personal.';
COMMENT ON COLUMN HORARIO_PERSONAL.IDPersonal IS 'Llave de referencia o identificador asociado a personal.';
COMMENT ON COLUMN HORARIO_PERSONAL.Horario IS 'Dato correspondiente a Horario.';
COMMENT ON TABLE CORREO_PERSONAL IS 'Almacena los correos electrónicos del personal.';
COMMENT ON COLUMN CORREO_PERSONAL.IDPersonal IS 'Llave de referencia o identificador asociado a personal.';
COMMENT ON COLUMN CORREO_PERSONAL.CorreoElectronico IS 'Dirección de correo electrónico.';
COMMENT ON TABLE TELEFONO_PERSONAL IS 'Almacena los teléfonos del personal.';
COMMENT ON COLUMN TELEFONO_PERSONAL.IDPersonal IS 'Llave de referencia o identificador asociado a personal.';
COMMENT ON COLUMN TELEFONO_PERSONAL.Telefono IS 'Número telefónico de contacto.';
COMMENT ON TABLE MEDICO IS 'Especialización del personal que desempeña el rol de médico.';
COMMENT ON COLUMN MEDICO.idPersonal IS 'Columna idPersonal de la tabla MEDICO.';
COMMENT ON COLUMN MEDICO.Especialidad IS 'Dato correspondiente a Especialidad.';
COMMENT ON COLUMN MEDICO.InstitucionEgreso IS 'Dato correspondiente a InstitucionEgreso.';
COMMENT ON COLUMN MEDICO.VigenciaCertificacion IS 'Columna VigenciaCertificacion de la tabla MEDICO.';
COMMENT ON TABLE ENFERMERA IS 'Especialización del personal que desempeña el rol de enfermera.';
COMMENT ON COLUMN ENFERMERA.idPersonal IS 'Columna idPersonal de la tabla ENFERMERA.';
COMMENT ON COLUMN ENFERMERA.CertificadoReanimacion IS 'Dato correspondiente a CertificadoReanimacion.';
COMMENT ON COLUMN ENFERMERA.TipoProcedimiento IS 'Dato correspondiente a TipoProcedimiento.';
COMMENT ON TABLE CAJERO IS 'Especialización del personal que desempeña el rol de cajero.';
COMMENT ON COLUMN CAJERO.IDPersonal IS 'Llave de referencia o identificador asociado a personal.';
COMMENT ON TABLE LIMPIEZA IS 'Especialización del personal que desempeña el rol de limpieza.';
COMMENT ON COLUMN LIMPIEZA.IDPersonal IS 'Llave de referencia o identificador asociado a personal.';
COMMENT ON TABLE CUIDADOR IS 'Especialización del personal que desempeña el rol de cuidador.';
COMMENT ON COLUMN CUIDADOR.IDPersonal IS 'Llave de referencia o identificador asociado a personal.';
COMMENT ON TABLE FARMACEUTICO IS 'Especialización del personal que desempeña el rol de farmacéutico.';
COMMENT ON COLUMN FARMACEUTICO.idPersonal IS 'Columna idPersonal de la tabla FARMACEUTICO.';
COMMENT ON TABLE CLINICA IS 'Almacena la información de la clínica o consultorio dentro de una sucursal.';
COMMENT ON COLUMN CLINICA.IDClinica IS 'Identificador único de la clínica.';
COMMENT ON COLUMN CLINICA.idSucursal IS 'Columna idSucursal de la tabla CLINICA.';
COMMENT ON COLUMN CLINICA.Nombre IS 'Nombre o denominación de la entidad.';
COMMENT ON COLUMN CLINICA.NumCuartos IS 'Número de cuartos disponibles en la clínica.';
COMMENT ON TABLE HORARIO_CLINICA IS 'Almacena los horarios de atención de cada clínica.';
COMMENT ON COLUMN HORARIO_CLINICA.IDClinica IS 'Llave de referencia o identificador asociado a clinica.';
COMMENT ON COLUMN HORARIO_CLINICA.Horario IS 'Dato correspondiente a Horario.';
COMMENT ON TABLE TELEFONO_SUCURSAL IS 'Almacena los teléfonos asociados a cada sucursal.';
COMMENT ON COLUMN TELEFONO_SUCURSAL.idSucursal IS 'Columna idSucursal de la tabla TELEFONO_SUCURSAL.';
COMMENT ON COLUMN TELEFONO_SUCURSAL.Telefono IS 'Número telefónico de contacto.';
COMMENT ON TABLE MEDICAMENTO IS 'Almacena los medicamentos manejados por la farmacia o clínica.';
COMMENT ON COLUMN MEDICAMENTO.IDMedicamento IS 'Identificador único del medicamento.';
COMMENT ON COLUMN MEDICAMENTO.IDPersonal IS 'Llave de referencia o identificador asociado a personal.';
COMMENT ON COLUMN MEDICAMENTO.IDProveedor IS 'Llave de referencia o identificador asociado a proveedor.';
COMMENT ON COLUMN MEDICAMENTO.NombreCientifico IS 'Nombre o denominación de cientifico.';
COMMENT ON COLUMN MEDICAMENTO.PrecioPublico IS 'Valor monetario correspondiente a PrecioPublico.';
COMMENT ON COLUMN MEDICAMENTO.FechaDeCaducidad IS 'Fecha correspondiente al atributo FechaDeCaducidad.';
COMMENT ON COLUMN MEDICAMENTO.PrecioUnitario IS 'Valor monetario correspondiente a PrecioUnitario.';
COMMENT ON COLUMN MEDICAMENTO.MedicamentosEsteriles IS 'Indicador booleano correspondiente a MedicamentosEsteriles.';
COMMENT ON COLUMN MEDICAMENTO.Preparaciones IS 'Información descriptiva correspondiente a Preparaciones.';
COMMENT ON COLUMN MEDICAMENTO.Formulacion IS 'Información descriptiva correspondiente a Formulacion.';
COMMENT ON COLUMN MEDICAMENTO.PreparadosOficiales IS 'Indicador booleano correspondiente a PreparadosOficiales.';
COMMENT ON COLUMN MEDICAMENTO.Pediatrica IS 'Indicador booleano correspondiente a Pediatrica.';
COMMENT ON COLUMN MEDICAMENTO.Dermatologica IS 'Indicador booleano correspondiente a Dermatologica.';
COMMENT ON TABLE TENER IS 'Representa el inventario disponible de medicamentos por sucursal.';
COMMENT ON COLUMN TENER.IDSucursal IS 'Llave de referencia o identificador asociado a sucursal.';
COMMENT ON COLUMN TENER.IDMedicamento IS 'Llave de referencia o identificador asociado a medicamento.';
COMMENT ON COLUMN TENER.StockDisponible IS 'Cantidad de medicamento disponible en la sucursal.';
COMMENT ON TABLE PROVEER_MEDICAMENTO IS 'Registra el suministro de medicamentos por proveedor a una sucursal.';
COMMENT ON COLUMN PROVEER_MEDICAMENTO.IDProveedor IS 'Llave de referencia o identificador asociado a proveedor.';
COMMENT ON COLUMN PROVEER_MEDICAMENTO.IDMedicamento IS 'Llave de referencia o identificador asociado a medicamento.';
COMMENT ON COLUMN PROVEER_MEDICAMENTO.IDSucursal IS 'Llave de referencia o identificador asociado a sucursal.';
COMMENT ON COLUMN PROVEER_MEDICAMENTO.CondicionDeAlmacenamiento IS 'Dato correspondiente a CondicionDeAlmacenamiento.';
COMMENT ON COLUMN PROVEER_MEDICAMENTO.Cantidad IS 'Cantidad registrada para la relación correspondiente.';
COMMENT ON COLUMN PROVEER_MEDICAMENTO.FechaDeRecibo IS 'Fecha correspondiente al atributo FechaDeRecibo.';
COMMENT ON COLUMN PROVEER_MEDICAMENTO.FechaDeCaducidad IS 'Fecha correspondiente al atributo FechaDeCaducidad.';
COMMENT ON TABLE PROVEER_INSUMO IS 'Registra el suministro de insumos por proveedor a una sucursal.';
COMMENT ON COLUMN PROVEER_INSUMO.IDProveedor IS 'Llave de referencia o identificador asociado a proveedor.';
COMMENT ON COLUMN PROVEER_INSUMO.IDSucursal IS 'Llave de referencia o identificador asociado a sucursal.';
COMMENT ON COLUMN PROVEER_INSUMO.NombreCientifico IS 'Nombre o denominación de cientifico.';
COMMENT ON COLUMN PROVEER_INSUMO.CondicionDeAlmacenamiento IS 'Dato correspondiente a CondicionDeAlmacenamiento.';
COMMENT ON COLUMN PROVEER_INSUMO.Cantidad IS 'Cantidad registrada para la relación correspondiente.';
COMMENT ON COLUMN PROVEER_INSUMO.FechaDeRecibo IS 'Fecha correspondiente al atributo FechaDeRecibo.';
COMMENT ON COLUMN PROVEER_INSUMO.FechaDeCaducidad IS 'Fecha correspondiente al atributo FechaDeCaducidad.';
COMMENT ON TABLE PREPARAR IS 'Registra qué personal prepara determinados medicamentos y en qué cantidad.';
COMMENT ON COLUMN PREPARAR.IDMedicamento IS 'Llave de referencia o identificador asociado a medicamento.';
COMMENT ON COLUMN PREPARAR.IDPersonal IS 'Llave de referencia o identificador asociado a personal.';
COMMENT ON COLUMN PREPARAR.Cantidad IS 'Cantidad registrada para la relación correspondiente.';
COMMENT ON TABLE USAR IS 'Registra qué personal utiliza determinados insumos.';
COMMENT ON COLUMN USAR.IDPersonal IS 'Llave de referencia o identificador asociado a personal.';
COMMENT ON COLUMN USAR.NombreCientifico IS 'Nombre o denominación de cientifico.';
COMMENT ON TABLE TICKET IS 'Almacena los tickets generados por compras o servicios.';
COMMENT ON COLUMN TICKET.IDTicket IS 'Identificador único del ticket.';
COMMENT ON COLUMN TICKET.IDSucursal IS 'Llave de referencia o identificador asociado a sucursal.';
COMMENT ON COLUMN TICKET.IDCliente IS 'Llave de referencia o identificador asociado a cliente.';
COMMENT ON COLUMN TICKET.IDConsulta IS 'Llave de referencia o identificador asociado a consulta.';
COMMENT ON TABLE COMPRAR IS 'Registra los medicamentos incluidos dentro de un ticket.';
COMMENT ON COLUMN COMPRAR.IDTicket IS 'Llave de referencia o identificador asociado a ticket.';
COMMENT ON COLUMN COMPRAR.IDMedicamento IS 'Llave de referencia o identificador asociado a medicamento.';
COMMENT ON TABLE CONSULTA IS 'Almacena la información de las consultas médicas realizadas.';
COMMENT ON COLUMN CONSULTA.IDConsulta IS 'Identificador único de la consulta.';
COMMENT ON COLUMN CONSULTA.IDCliente IS 'Llave de referencia o identificador asociado a cliente.';
COMMENT ON COLUMN CONSULTA.IDMedicamento IS 'Llave de referencia o identificador asociado a medicamento.';
COMMENT ON COLUMN CONSULTA.IDMedico IS 'Llave de referencia o identificador asociado a medico.';
COMMENT ON COLUMN CONSULTA.IDEnfermera IS 'Enfermera asignada a la consulta; puede quedar nula si se elimina la referencia.';
COMMENT ON COLUMN CONSULTA.IDClinica IS 'Llave de referencia o identificador asociado a clinica.';
COMMENT ON COLUMN CONSULTA.IDTicket IS 'Llave de referencia o identificador asociado a ticket.';
COMMENT ON COLUMN CONSULTA.Fecha IS 'Fecha correspondiente al atributo Fecha.';
COMMENT ON COLUMN CONSULTA.Hora IS 'Hora correspondiente al registro.';
COMMENT ON COLUMN CONSULTA.Diagnostico IS 'Información descriptiva correspondiente a Diagnostico.';
COMMENT ON COLUMN CONSULTA.CostoConsulta IS 'Columna CostoConsulta de la tabla CONSULTA.';
COMMENT ON TABLE GENERAR IS 'Relaciona tickets con consultas generadas en el sistema.';
COMMENT ON COLUMN GENERAR.IDTicket IS 'Llave de referencia o identificador asociado a ticket.';
COMMENT ON COLUMN GENERAR.IDConsulta IS 'Llave de referencia o identificador asociado a consulta.';
COMMENT ON TABLE RECETA_MEDICA IS 'Almacena la información de las recetas médicas emitidas.';
COMMENT ON COLUMN RECETA_MEDICA.NumeroReceta IS 'Identificador único de la receta médica.';
COMMENT ON COLUMN RECETA_MEDICA.IDCliente IS 'Llave de referencia o identificador asociado a cliente.';
COMMENT ON COLUMN RECETA_MEDICA.IDConsulta IS 'Llave de referencia o identificador asociado a consulta.';
COMMENT ON COLUMN RECETA_MEDICA.FechaNacimiento IS 'Fecha correspondiente al atributo FechaNacimiento.';
COMMENT ON COLUMN RECETA_MEDICA.Peso IS 'Peso del paciente registrado en la receta médica.';
COMMENT ON COLUMN RECETA_MEDICA.Talla IS 'Talla del paciente registrado en la receta médica.';
COMMENT ON COLUMN RECETA_MEDICA.Alergias IS 'Información descriptiva correspondiente a Alergias.';
COMMENT ON COLUMN RECETA_MEDICA.Diagnostico IS 'Información descriptiva correspondiente a Diagnostico.';
COMMENT ON COLUMN RECETA_MEDICA.Consultorio IS 'Dato correspondiente a Consultorio.';
COMMENT ON COLUMN RECETA_MEDICA.Turno IS 'Dato correspondiente a Turno.';
COMMENT ON TABLE PEDIR IS 'Registra los medicamentos solicitados en una receta médica.';
COMMENT ON COLUMN PEDIR.NumeroReceta IS 'Columna NumeroReceta de la tabla PEDIR.';
COMMENT ON COLUMN PEDIR.IDMedicamento IS 'Llave de referencia o identificador asociado a medicamento.';
COMMENT ON COLUMN PEDIR.Dosis IS 'Dato correspondiente a Dosis.';
COMMENT ON COLUMN PEDIR.Frecuencia IS 'Dato correspondiente a Frecuencia.';
COMMENT ON CONSTRAINT chk_vencimiento_tarjeta ON CLIENTE IS 'Restricción CHECK definida en la tabla CLIENTE.';
COMMENT ON CONSTRAINT rfcvalido ON PERSONAL IS 'Restricción CHECK definida en la tabla PERSONAL.';
COMMENT ON CONSTRAINT cedprofvalida ON PERSONAL IS 'Restricción CHECK definida en la tabla PERSONAL.';
COMMENT ON CONSTRAINT chk_stock_nonegativo ON TENER IS 'Restricción CHECK definida en la tabla TENER.';
COMMENT ON CONSTRAINT chk_caducidad_med ON MEDICAMENTO IS 'Restricción CHECK definida en la tabla MEDICAMENTO.';
COMMENT ON CONSTRAINT chk_caducidad_insumo ON INSUMO IS 'Restricción CHECK definida en la tabla INSUMO.';
COMMENT ON CONSTRAINT cantidad_nonegativa ON PROVEER_INSUMO IS 'Restricción CHECK definida en la tabla PROVEER_INSUMO.';
COMMENT ON CONSTRAINT caducidad_proveedor ON PROVEER_INSUMO IS 'Restricción CHECK definida en la tabla PROVEER_INSUMO.';
COMMENT ON CONSTRAINT cantidad_nonegativamed ON PROVEER_MEDICAMENTO IS 'Restricción CHECK definida en la tabla PROVEER_MEDICAMENTO.';
COMMENT ON CONSTRAINT caducidad_med ON PROVEER_MEDICAMENTO IS 'Restricción CHECK definida en la tabla PROVEER_MEDICAMENTO.';
COMMENT ON CONSTRAINT cantidad_prep ON PREPARAR IS 'Restricción CHECK definida en la tabla PREPARAR.';
COMMENT ON CONSTRAINT salario_nonegativo ON PERSONAL IS 'Restricción CHECK definida en la tabla PERSONAL.';
COMMENT ON CONSTRAINT caducidad_medico ON MEDICO IS 'Restricción CHECK definida en la tabla MEDICO.';
COMMENT ON CONSTRAINT CHK_Precio ON MEDICAMENTO IS 'Restricción CHECK definida en la tabla MEDICAMENTO.';
COMMENT ON CONSTRAINT UQ_Usuario ON CLIENTE IS 'Restricción de unicidad sobre CLIENTE (Usuario).';
COMMENT ON CONSTRAINT UQ_RFC ON PERSONAL IS 'Restricción de unicidad sobre PERSONAL (RFC).';
COMMENT ON CONSTRAINT PK_IDCliente ON CLIENTE IS 'Llave primaria de la tabla CLIENTE (IDCliente).';
COMMENT ON CONSTRAINT PK_IDSucursal ON SUCURSAL IS 'Llave primaria de la tabla SUCURSAL (IDSucursal).';
COMMENT ON CONSTRAINT PK_IDProveedor ON PROVEEDOR IS 'Llave primaria de la tabla PROVEEDOR (IDProveedor).';
COMMENT ON CONSTRAINT PK_IDPersonal ON PERSONAL IS 'Llave primaria de la tabla PERSONAL (IDPersonal).';
COMMENT ON CONSTRAINT PK_NombreCientifico ON INSUMO IS 'Llave primaria de la tabla INSUMO (NombreCientifico).';
COMMENT ON CONSTRAINT PK_IDMedicamento ON MEDICAMENTO IS 'Llave primaria de la tabla MEDICAMENTO (IDMedicamento).';
COMMENT ON CONSTRAINT PK_IDClinica ON CLINICA IS 'Llave primaria de la tabla CLINICA (IDClinica).';
COMMENT ON CONSTRAINT PK_IDTicket ON TICKET IS 'Llave primaria de la tabla TICKET (IDTicket).';
COMMENT ON CONSTRAINT PK_IDConsulta ON CONSULTA IS 'Llave primaria de la tabla CONSULTA (IDConsulta).';
COMMENT ON CONSTRAINT PK_NumeroReceta ON RECETA_MEDICA IS 'Llave primaria de la tabla RECETA_MEDICA (NumeroReceta).';
COMMENT ON CONSTRAINT PK_CorreoCliente ON CORREO_CLIENTE IS 'Llave primaria de la tabla CORREO_CLIENTE (IDCliente, CorreoElectronico).';
COMMENT ON CONSTRAINT PK_TelCliente ON TELEFONO_CLIENTE IS 'Llave primaria de la tabla TELEFONO_CLIENTE (IDCliente, Telefono).';
COMMENT ON CONSTRAINT PK_TelProveedor ON TELEFONO_PROVEEDOR IS 'Llave primaria de la tabla TELEFONO_PROVEEDOR (IDProveedor, Telefono).';
COMMENT ON CONSTRAINT PK_HorarioPersonal ON HORARIO_PERSONAL IS 'Llave primaria de la tabla HORARIO_PERSONAL (IDPersonal, Horario).';
COMMENT ON CONSTRAINT PK_CorreoPersonal ON CORREO_PERSONAL IS 'Llave primaria de la tabla CORREO_PERSONAL (IDPersonal, CorreoElectronico).';
COMMENT ON CONSTRAINT PK_TelPersonal ON TELEFONO_PERSONAL IS 'Llave primaria de la tabla TELEFONO_PERSONAL (IDPersonal, Telefono).';
COMMENT ON CONSTRAINT PK_HorarioClinica ON HORARIO_CLINICA IS 'Llave primaria de la tabla HORARIO_CLINICA (IDClinica, Horario).';
COMMENT ON CONSTRAINT PK_TelSucursal ON TELEFONO_SUCURSAL IS 'Llave primaria de la tabla TELEFONO_SUCURSAL (IDSucursal, Telefono).';
COMMENT ON CONSTRAINT PK_Tener ON TENER IS 'Llave primaria de la tabla TENER (IDSucursal, IDMedicamento).';
COMMENT ON CONSTRAINT PK_ProvMed ON PROVEER_MEDICAMENTO IS 'Llave primaria de la tabla PROVEER_MEDICAMENTO (IDProveedor, IDMedicamento, IDSucursal).';
COMMENT ON CONSTRAINT PK_ProvIns ON PROVEER_INSUMO IS 'Llave primaria de la tabla PROVEER_INSUMO (IDProveedor, NombreCientifico, IDSucursal).';
COMMENT ON CONSTRAINT PK_Preparar ON PREPARAR IS 'Llave primaria de la tabla PREPARAR (IDMedicamento, IDPersonal).';
COMMENT ON CONSTRAINT PK_Usar ON USAR IS 'Llave primaria de la tabla USAR (IDPersonal, NombreCientifico).';
COMMENT ON CONSTRAINT PK_Comprar ON COMPRAR IS 'Llave primaria de la tabla COMPRAR (IDTicket, IDMedicamento).';
COMMENT ON CONSTRAINT PK_Generar ON GENERAR IS 'Llave primaria de la tabla GENERAR (IDTicket, IDConsulta).';
COMMENT ON CONSTRAINT PK_Pedir ON PEDIR IS 'Llave primaria de la tabla PEDIR (NumeroReceta, IDMedicamento).';
COMMENT ON CONSTRAINT FK_IDSucursal ON PERSONAL IS 'Llave foránea que relaciona PERSONAL.IDSucursal con SUCURSAL.IDSucursal. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_CC_IDCliente ON CORREO_CLIENTE IS 'Llave foránea que relaciona CORREO_CLIENTE.IDCliente con CLIENTE.IDCliente. Política de mantenimiento: ON DELETE CASCADE; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_TC_IDCliente ON TELEFONO_CLIENTE IS 'Llave foránea que relaciona TELEFONO_CLIENTE.IDCliente con CLIENTE.IDCliente. Política de mantenimiento: ON DELETE CASCADE; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_TP_IDProveedor ON TELEFONO_PROVEEDOR IS 'Llave foránea que relaciona TELEFONO_PROVEEDOR.IDProveedor con PROVEEDOR.IDProveedor. Política de mantenimiento: ON DELETE CASCADE; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_HP_IDPersonal ON HORARIO_PERSONAL IS 'Llave foránea que relaciona HORARIO_PERSONAL.IDPersonal con PERSONAL.IDPersonal. Política de mantenimiento: ON DELETE CASCADE; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_CP_IDPersonal ON CORREO_PERSONAL IS 'Llave foránea que relaciona CORREO_PERSONAL.IDPersonal con PERSONAL.IDPersonal. Política de mantenimiento: ON DELETE CASCADE; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_TP2_IDPersonal ON TELEFONO_PERSONAL IS 'Llave foránea que relaciona TELEFONO_PERSONAL.IDPersonal con PERSONAL.IDPersonal. Política de mantenimiento: ON DELETE CASCADE; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_Medico ON MEDICO IS 'Llave foránea que relaciona MEDICO.IDPersonal con PERSONAL.IDPersonal. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_Enfermera ON ENFERMERA IS 'Llave foránea que relaciona ENFERMERA.IDPersonal con PERSONAL.IDPersonal. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_Cajero ON CAJERO IS 'Llave foránea que relaciona CAJERO.IDPersonal con PERSONAL.IDPersonal. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_Limpieza ON LIMPIEZA IS 'Llave foránea que relaciona LIMPIEZA.IDPersonal con PERSONAL.IDPersonal. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_Cuidador ON CUIDADOR IS 'Llave foránea que relaciona CUIDADOR.IDPersonal con PERSONAL.IDPersonal. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_Farmaceutico ON FARMACEUTICO IS 'Llave foránea que relaciona FARMACEUTICO.IDPersonal con PERSONAL.IDPersonal. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_ClinicaSucursal ON CLINICA IS 'Llave foránea que relaciona CLINICA.IDSucursal con SUCURSAL.IDSucursal. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_HC_IDClinica ON HORARIO_CLINICA IS 'Llave foránea que relaciona HORARIO_CLINICA.IDClinica con CLINICA.IDClinica. Política de mantenimiento: ON DELETE CASCADE; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_TS_IDSucursal ON TELEFONO_SUCURSAL IS 'Llave foránea que relaciona TELEFONO_SUCURSAL.IDSucursal con SUCURSAL.IDSucursal. Política de mantenimiento: ON DELETE CASCADE; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_MedPersonal ON MEDICAMENTO IS 'Llave foránea que relaciona MEDICAMENTO.IDPersonal con PERSONAL.IDPersonal. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_MedProveedor ON MEDICAMENTO IS 'Llave foránea que relaciona MEDICAMENTO.IDProveedor con PROVEEDOR.IDProveedor. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_TenerSucursal ON TENER IS 'Llave foránea que relaciona TENER.IDSucursal con SUCURSAL.IDSucursal. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_TenerMedicamento ON TENER IS 'Llave foránea que relaciona TENER.IDMedicamento con MEDICAMENTO.IDMedicamento. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_PM_Proveedor ON PROVEER_MEDICAMENTO IS 'Llave foránea que relaciona PROVEER_MEDICAMENTO.IDProveedor con PROVEEDOR.IDProveedor. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_PM_Medicamento ON PROVEER_MEDICAMENTO IS 'Llave foránea que relaciona PROVEER_MEDICAMENTO.IDMedicamento con MEDICAMENTO.IDMedicamento. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_PM_Sucursal ON PROVEER_MEDICAMENTO IS 'Llave foránea que relaciona PROVEER_MEDICAMENTO.IDSucursal con SUCURSAL.IDSucursal. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_PI_Proveedor ON PROVEER_INSUMO IS 'Llave foránea que relaciona PROVEER_INSUMO.IDProveedor con PROVEEDOR.IDProveedor. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_PI_Insumo ON PROVEER_INSUMO IS 'Llave foránea que relaciona PROVEER_INSUMO.NombreCientifico con INSUMO.NombreCientifico. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_PI_Sucursal ON PROVEER_INSUMO IS 'Llave foránea que relaciona PROVEER_INSUMO.IDSucursal con SUCURSAL.IDSucursal. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_PrepararMed ON PREPARAR IS 'Llave foránea que relaciona PREPARAR.IDMedicamento con MEDICAMENTO.IDMedicamento. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_PrepararPer ON PREPARAR IS 'Llave foránea que relaciona PREPARAR.IDPersonal con PERSONAL.IDPersonal. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_UsarPer ON USAR IS 'Llave foránea que relaciona USAR.IDPersonal con PERSONAL.IDPersonal. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_UsarIns ON USAR IS 'Llave foránea que relaciona USAR.NombreCientifico con INSUMO.NombreCientifico. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_TicketSucursal ON TICKET IS 'Llave foránea que relaciona TICKET.IDSucursal con SUCURSAL.IDSucursal. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_TicketCliente ON TICKET IS 'Llave foránea que relaciona TICKET.IDCliente con CLIENTE.IDCliente. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_TicketConsulta ON TICKET IS 'Llave foránea que relaciona TICKET.IDConsulta con CONSULTA.IDConsulta. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_CompraTicket ON COMPRAR IS 'Llave foránea que relaciona COMPRAR.IDTicket con TICKET.IDTicket. Política de mantenimiento: ON DELETE CASCADE; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_CompraMedicamento ON COMPRAR IS 'Llave foránea que relaciona COMPRAR.IDMedicamento con MEDICAMENTO.IDMedicamento. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_ConsultaCliente ON CONSULTA IS 'Llave foránea que relaciona CONSULTA.IDCliente con CLIENTE.IDCliente. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_ConsultaMedico ON CONSULTA IS 'Llave foránea que relaciona CONSULTA.IDMedico con PERSONAL.IDPersonal. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_ConsultaEnfermera ON CONSULTA IS 'Llave foránea que relaciona CONSULTA.IDEnfermera con PERSONAL.IDPersonal. Política de mantenimiento: ON DELETE SET NULL; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_ConsultaClinica ON CONSULTA IS 'Llave foránea que relaciona CONSULTA.IDClinica con CLINICA.IDClinica. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_ConsultaTicket ON CONSULTA IS 'Llave foránea que relaciona CONSULTA.IDTicket con TICKET.IDTicket. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_ConsultaMedicamento ON CONSULTA IS 'Llave foránea que relaciona CONSULTA.IDMedicamento con MEDICAMENTO.IDMedicamento. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_GenerarTicket ON GENERAR IS 'Llave foránea que relaciona GENERAR.IDTicket con TICKET.IDTicket. Política de mantenimiento: ON DELETE CASCADE; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_GenerarConsulta ON GENERAR IS 'Llave foránea que relaciona GENERAR.IDConsulta con CONSULTA.IDConsulta. Política de mantenimiento: ON DELETE CASCADE; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_RecetaCliente ON RECETA_MEDICA IS 'Llave foránea que relaciona RECETA_MEDICA.IDCliente con CLIENTE.IDCliente. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_RecetaConsulta ON RECETA_MEDICA IS 'Llave foránea que relaciona RECETA_MEDICA.IDConsulta con CONSULTA.IDConsulta. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_PedirReceta ON PEDIR IS 'Llave foránea que relaciona PEDIR.NumeroReceta con RECETA_MEDICA.NumeroReceta. Política de mantenimiento: ON DELETE CASCADE; ON UPDATE CASCADE.';
COMMENT ON CONSTRAINT FK_PedirMedicamento ON PEDIR IS 'Llave foránea que relaciona PEDIR.IDMedicamento con MEDICAMENTO.IDMedicamento. Política de mantenimiento: ON DELETE RESTRICT; ON UPDATE CASCADE.';