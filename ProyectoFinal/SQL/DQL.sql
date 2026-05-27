-- Consulta i
-- Mostrar el nombre completo de todos los clientes, junto con su nombre de usuario (en dado caso que se tenga
-- una cuenta).
SELECT
    C.IDCliente,
    CONCAT(C.Nombre, ' ', C.ApellidoPaterno, ' ', C.ApellidoMaterno) AS NombreCompleto,
    C.Usuario AS NombreUsuario
FROM CLIENTE AS C
ORDER BY C.IDCliente;

-- Consulta ii
-- Calcular cuántos medicamentos ha comprado cada cliente.
SELECT
    C.IDCliente,
    CONCAT(C.Nombre, ' ', C.ApellidoPaterno, ' ', C.ApellidoMaterno) AS NombreCompleto,
    COUNT(CO.IDMedicamento) AS TotalMedicamentosComprados
FROM CLIENTE AS C
LEFT JOIN TICKET AS T
    ON C.IDCliente = T.IDCliente
LEFT JOIN COMPRAR AS CO
    ON T.IDTicket = CO.IDTicket
GROUP BY
    C.IDCliente,
    C.Nombre,
    C.ApellidoPaterno,
    C.ApellidoMaterno
ORDER BY TotalMedicamentosComprados DESC;

-- Consulta iii
-- Listar todos las enfermeras cuyo apellido materno contenga llo.
SELECT
    P.IDPersonal,
    CONCAT(P.Nombre, ' ', P.ApellidoPaterno, ' ', P.ApellidoMaterno) AS NombreCompleto,
    P.ApellidoMaterno,
    E.CertificadoReanimacion,
    E.TipoProcedimiento
FROM ENFERMERA AS E
INNER JOIN PERSONAL AS P
    ON E.IDPersonal = P.IDPersonal
WHERE P.ApellidoMaterno ILIKE '%llo%'
ORDER BY P.ApellidoMaterno;

-- Consulta iv
-- Obtener la lista de los clientes que hayan comprado en alguna sucursal pero que no hayan recibido alguna
-- consulta.
SELECT DISTINCT
    C.IDCliente,
    CONCAT(C.Nombre, ' ', C.ApellidoPaterno, ' ', C.ApellidoMaterno) AS NombreCompleto,
    S.IDSucursal,
    S.Nombre AS NombreSucursal
FROM CLIENTE AS C
INNER JOIN TICKET AS T
    ON C.IDCliente = T.IDCliente
INNER JOIN SUCURSAL AS S
    ON T.IDSucursal = S.IDSucursal
INNER JOIN COMPRAR AS CO
    ON T.IDTicket = CO.IDTicket
WHERE NOT EXISTS (
    SELECT 1
    FROM CONSULTA AS CON
    WHERE CON.IDCliente = C.IDCliente
)
ORDER BY C.IDCliente;

-- Consulta v
-- Calcular el precio bruto por ticket.

SELECT
    T.IDTicket,
    T.IDCliente,
    SUM(CO.Cantidad * M.PrecioPublico) AS PrecioBruto
FROM TICKET AS T
INNER JOIN COMPRAR AS CO
    ON T.IDTicket = CO.IDTicket
INNER JOIN MEDICAMENTO AS M
    ON CO.IDMedicamento = M.IDMedicamento
GROUP BY
    T.IDTicket,
    T.IDCliente
ORDER BY T.IDTicket;


-- Consulta vi
-- Calcular el precio neto por ticket.
-- Se considera IVA del 16% sobre el precio bruto.

SELECT
    T.IDTicket,
    T.IDCliente,
    SUM(CO.Cantidad * M.PrecioPublico) AS PrecioBruto,
    ROUND((SUM(CO.Cantidad * M.PrecioPublico) * 1.16)::numeric, 2) AS PrecioNeto
FROM TICKET AS T
INNER JOIN COMPRAR AS CO
    ON T.IDTicket = CO.IDTicket
INNER JOIN MEDICAMENTO AS M
    ON CO.IDMedicamento = M.IDMedicamento
GROUP BY
    T.IDTicket,
    T.IDCliente
ORDER BY T.IDTicket;


-- Consulta vii
-- Calcular el precio total que ha pagado cada cliente.
-- Se suma el precio neto de todos sus tickets.

WITH PrecioTicket AS (
    SELECT
        T.IDTicket,
        T.IDCliente,
        ROUND((SUM(CO.Cantidad * M.PrecioPublico) * 1.16)::numeric, 2) AS PrecioNeto
    FROM TICKET AS T
    INNER JOIN COMPRAR AS CO
        ON T.IDTicket = CO.IDTicket
    INNER JOIN MEDICAMENTO AS M
        ON CO.IDMedicamento = M.IDMedicamento
    GROUP BY
        T.IDTicket,
        T.IDCliente
)
SELECT
    C.IDCliente,
    CONCAT(C.Nombre, ' ', C.ApellidoPaterno, ' ', C.ApellidoMaterno) AS NombreCompleto,
    COALESCE(SUM(PT.PrecioNeto), 0) AS TotalPagado
FROM CLIENTE AS C
LEFT JOIN PrecioTicket AS PT
    ON C.IDCliente = PT.IDCliente
GROUP BY
    C.IDCliente,
    C.Nombre,
    C.ApellidoPaterno,
    C.ApellidoMaterno
ORDER BY TotalPagado DESC;


-- Consulta viii
-- Listar a los enfermeros que atendieron alguna consulta durante el
-- 7 de mayo de 2026, de 12:00 hrs a 16:00 hrs.

SELECT DISTINCT
    P.IDPersonal,
    CONCAT(P.Nombre, ' ', P.ApellidoPaterno, ' ', P.ApellidoMaterno) AS NombreCompleto,
    E.CertificadoReanimacion,
    E.TipoProcedimiento,
    CON.IDConsulta,
    CON.Fecha,
    CON.Hora
FROM CONSULTA AS CON
INNER JOIN ENFERMERA AS E
    ON CON.IDEnfermera = E.IDPersonal
INNER JOIN PERSONAL AS P
    ON E.IDPersonal = P.IDPersonal
WHERE CON.Fecha = DATE '2026-05-07'
  AND CON.Hora BETWEEN TIME '12:00' AND TIME '16:00'
ORDER BY
    CON.Hora,
    P.IDPersonal;


-- Consulta ix
-- Mostrar a todos los proveedores junto con los productos que proveen,
-- indicando el precio unitario por producto.

WITH ProductosProveedor AS (
    SELECT
        PM.IDProveedor,
        'Medicamento' AS TipoProducto,
        PM.IDMedicamento::text AS Producto,
        M.PrecioUnitario
    FROM PROVEER_MEDICAMENTO AS PM
    INNER JOIN MEDICAMENTO AS M
        ON PM.IDMedicamento = M.IDMedicamento

    UNION ALL

    SELECT
        PI.IDProveedor,
        'Insumo' AS TipoProducto,
        PI.NombreCientifico AS Producto,
        I.PrecioUnitario
    FROM PROVEER_INSUMO AS PI
    INNER JOIN INSUMO AS I
        ON PI.NombreCientifico = I.NombreCientifico
)
SELECT
    PR.IDProveedor,
    PR.RazonSocial,
    PP.TipoProducto,
    PP.Producto,
    PP.PrecioUnitario
FROM PROVEEDOR AS PR
LEFT JOIN ProductosProveedor AS PP
    ON PR.IDProveedor = PP.IDProveedor
ORDER BY
    PR.IDProveedor,
    PP.TipoProducto,
    PP.Producto;


-- Consulta x
-- Mostrar las sucursales que posean al menos 5 medicos.

SELECT
    S.IDSucursal,
    S.Nombre AS NombreSucursal,
    COUNT(ME.IDPersonal) AS TotalMedicos
FROM SUCURSAL AS S
INNER JOIN PERSONAL AS P
    ON S.IDSucursal = P.IDSucursal
INNER JOIN MEDICO AS ME
    ON P.IDPersonal = ME.IDPersonal
GROUP BY
    S.IDSucursal,
    S.Nombre
HAVING COUNT(ME.IDPersonal) >= 5
ORDER BY TotalMedicos DESC;


--- Consulta xi
-- Listar a los vendedores cuyo total de productos distintos vendidos sea mayor a 3.
-- En este modelo se interpreta "vendedores" como sucursales.

SELECT
    S.IDSucursal,
    S.Nombre AS NombreSucursal,
    COUNT(DISTINCT CO.IDMedicamento) AS ProductosDistintosVendidos
FROM SUCURSAL AS S
INNER JOIN TICKET AS T
    ON S.IDSucursal = T.IDSucursal
INNER JOIN COMPRAR AS CO
    ON T.IDTicket = CO.IDTicket
GROUP BY
    S.IDSucursal,
    S.Nombre
HAVING COUNT(DISTINCT CO.IDMedicamento) > 3
ORDER BY ProductosDistintosVendidos DESC;


-- Consulta xii
-- Listar a los proveedores cuyo total de productos distintos que proveen
-- sea mayor a 3.

WITH ProductosProveedor AS (
    SELECT
        IDProveedor,
        'MED-' || IDMedicamento::text AS Producto
    FROM PROVEER_MEDICAMENTO

    UNION

    SELECT
        IDProveedor,
        'INS-' || NombreCientifico AS Producto
    FROM PROVEER_INSUMO
)
SELECT
    PR.IDProveedor,
    PR.RazonSocial,
    COUNT(DISTINCT PP.Producto) AS ProductosDistintosProvistos
FROM PROVEEDOR AS PR
INNER JOIN ProductosProveedor AS PP
    ON PR.IDProveedor = PP.IDProveedor
GROUP BY
    PR.IDProveedor,
    PR.RazonSocial
HAVING COUNT(DISTINCT PP.Producto) > 3
ORDER BY ProductosDistintosProvistos DESC;


-- Consulta xiii
-- Obtener ganancias y perdidas totales por cada sucursal.
-- Ganancia: venta de medicamentos por ticket.
-- Perdida: costo de productos suministrados por proveedores.

WITH Ganancias AS (
    SELECT
        T.IDSucursal,
        SUM(CO.Cantidad * M.PrecioPublico) AS GananciaBruta
    FROM TICKET AS T
    INNER JOIN COMPRAR AS CO
        ON T.IDTicket = CO.IDTicket
    INNER JOIN MEDICAMENTO AS M
        ON CO.IDMedicamento = M.IDMedicamento
    GROUP BY T.IDSucursal
),
PerdidasMedicamento AS (
    SELECT
        PM.IDSucursal,
        SUM(PM.Cantidad * M.PrecioUnitario) AS PerdidaMedicamentos
    FROM PROVEER_MEDICAMENTO AS PM
    INNER JOIN MEDICAMENTO AS M
        ON PM.IDMedicamento = M.IDMedicamento
    GROUP BY PM.IDSucursal
),
PerdidasInsumo AS (
    SELECT
        PI.IDSucursal,
        SUM(PI.Cantidad * I.PrecioUnitario) AS PerdidaInsumos
    FROM PROVEER_INSUMO AS PI
    INNER JOIN INSUMO AS I
        ON PI.NombreCientifico = I.NombreCientifico
    GROUP BY PI.IDSucursal
)
SELECT
    S.IDSucursal,
    S.Nombre AS NombreSucursal,
    COALESCE(G.GananciaBruta, 0) AS GananciasTotales,
    COALESCE(PM.PerdidaMedicamentos, 0) + COALESCE(PI.PerdidaInsumos, 0) AS PerdidasTotales,
    COALESCE(G.GananciaBruta, 0)
        - (COALESCE(PM.PerdidaMedicamentos, 0) + COALESCE(PI.PerdidaInsumos, 0)) AS UtilidadNeta
FROM SUCURSAL AS S
LEFT JOIN Ganancias AS G
    ON S.IDSucursal = G.IDSucursal
LEFT JOIN PerdidasMedicamento AS PM
    ON S.IDSucursal = PM.IDSucursal
LEFT JOIN PerdidasInsumo AS PI
    ON S.IDSucursal = PI.IDSucursal
ORDER BY UtilidadNeta DESC;


-- ============================================================
--  CONSULTAS ADICIONALES (xiv - xxviii)
--  Información administrativa de las sucursales de
--  Una Farmacia de Otro Mundo.
-- ============================================================


-- Consulta xiv
-- Distribución geográfica de las sucursales: cuántas existen
-- y en qué estados se encuentran, con porcentaje del total
-- nacional.

SELECT
    S.Estado,
    COUNT(*) AS TotalSucursales,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS PorcentajeDelTotal
FROM SUCURSAL AS S
GROUP BY S.Estado
ORDER BY
    TotalSucursales DESC,
    S.Estado;


-- Consulta xv
-- Sucursales que cuentan con clínica médica integrada,
-- mostrando el nombre de la clínica, número de cuartos
-- y los horarios de atención (agrupados).

SELECT
    S.IDSucursal,
    S.Nombre        AS NombreSucursal,
    S.Estado,
    CL.IDClinica,
    CL.Nombre       AS NombreClinica,
    CL.NumCuartos,
    STRING_AGG(DISTINCT HC.Horario, '; ' ORDER BY HC.Horario) AS HorariosClinica
FROM SUCURSAL AS S
INNER JOIN CLINICA AS CL
    ON S.IDSucursal = CL.IDSucursal
LEFT JOIN HORARIO_CLINICA AS HC
    ON CL.IDClinica = HC.IDClinica
GROUP BY
    S.IDSucursal,
    S.Nombre,
    S.Estado,
    CL.IDClinica,
    CL.Nombre,
    CL.NumCuartos
ORDER BY S.IDSucursal;


-- Consulta xvi
-- Número total de empleados por sucursal y por tipo de puesto.
-- Se realiza una pivot manual sobre las especializaciones
-- (médico, enfermera, farmacéutico, cajero, limpieza, cuidador).

SELECT
    S.IDSucursal,
    S.Nombre AS NombreSucursal,
    COUNT(DISTINCT P.IDPersonal)  AS TotalEmpleados,
    COUNT(DISTINCT ME.IDPersonal) AS TotalMedicos,
    COUNT(DISTINCT EN.IDPersonal) AS TotalEnfermeras,
    COUNT(DISTINCT FA.IDPersonal) AS TotalFarmaceuticos,
    COUNT(DISTINCT CA.IDPersonal) AS TotalCajeros,
    COUNT(DISTINCT LI.IDPersonal) AS TotalLimpieza,
    COUNT(DISTINCT CU.IDPersonal) AS TotalCuidadores
FROM SUCURSAL AS S
LEFT JOIN PERSONAL      AS P  ON S.IDSucursal = P.IDSucursal
LEFT JOIN MEDICO        AS ME ON P.IDPersonal = ME.IDPersonal
LEFT JOIN ENFERMERA     AS EN ON P.IDPersonal = EN.IDPersonal
LEFT JOIN FARMACEUTICO  AS FA ON P.IDPersonal = FA.IDPersonal
LEFT JOIN CAJERO        AS CA ON P.IDPersonal = CA.IDPersonal
LEFT JOIN LIMPIEZA      AS LI ON P.IDPersonal = LI.IDPersonal
LEFT JOIN CUIDADOR      AS CU ON P.IDPersonal = CU.IDPersonal
GROUP BY
    S.IDSucursal,
    S.Nombre
ORDER BY
    TotalEmpleados DESC,
    S.IDSucursal;


-- Consulta xvii
-- Salario promedio del personal por sucursal y por categoría
-- de puesto, incluyendo salario mínimo y máximo por grupo.

WITH PersonalCategorizado AS (
    SELECT
        P.IDPersonal,
        P.IDSucursal,
        P.Salario,
        CASE
            WHEN ME.IDPersonal IS NOT NULL THEN 'Medico'
            WHEN EN.IDPersonal IS NOT NULL THEN 'Enfermera'
            WHEN FA.IDPersonal IS NOT NULL THEN 'Farmaceutico'
            WHEN CA.IDPersonal IS NOT NULL THEN 'Cajero'
            WHEN LI.IDPersonal IS NOT NULL THEN 'Limpieza'
            WHEN CU.IDPersonal IS NOT NULL THEN 'Cuidador'
            ELSE 'Sin categoria'
        END AS Categoria
    FROM PERSONAL AS P
    LEFT JOIN MEDICO       AS ME ON P.IDPersonal = ME.IDPersonal
    LEFT JOIN ENFERMERA    AS EN ON P.IDPersonal = EN.IDPersonal
    LEFT JOIN FARMACEUTICO AS FA ON P.IDPersonal = FA.IDPersonal
    LEFT JOIN CAJERO       AS CA ON P.IDPersonal = CA.IDPersonal
    LEFT JOIN LIMPIEZA     AS LI ON P.IDPersonal = LI.IDPersonal
    LEFT JOIN CUIDADOR     AS CU ON P.IDPersonal = CU.IDPersonal
)
SELECT
    S.IDSucursal,
    S.Nombre   AS NombreSucursal,
    PC.Categoria,
    COUNT(PC.IDPersonal)         AS TotalPersonas,
    ROUND(AVG(PC.Salario), 2)    AS SalarioPromedio,
    ROUND(MIN(PC.Salario), 2)    AS SalarioMinimo,
    ROUND(MAX(PC.Salario), 2)    AS SalarioMaximo
FROM SUCURSAL AS S
INNER JOIN PersonalCategorizado AS PC
    ON S.IDSucursal = PC.IDSucursal
GROUP BY
    S.IDSucursal,
    S.Nombre,
    PC.Categoria
ORDER BY
    S.IDSucursal,
    PC.Categoria;


-- Consulta xviii
-- Farmacéuticos que preparan medicamentos especiales,
-- detallando cuántos preparan de cada tipo: estériles,
-- pediátricos, dermatológicos y preparados oficiales.

SELECT
    P.IDPersonal,
    CONCAT(P.Nombre, ' ', P.ApellidoPaterno, ' ', P.ApellidoMaterno) AS NombreFarmaceutico,
    P.IDSucursal,
    COUNT(DISTINCT CASE WHEN M.MedicamentosEsteriles THEN M.IDMedicamento END) AS EsterilesPreparados,
    COUNT(DISTINCT CASE WHEN M.Pediatrica            THEN M.IDMedicamento END) AS PediatricosPreparados,
    COUNT(DISTINCT CASE WHEN M.Dermatologica         THEN M.IDMedicamento END) AS DermatologicosPreparados,
    COUNT(DISTINCT CASE WHEN M.PreparadosOficiales   THEN M.IDMedicamento END) AS PreparadosOficiales,
    COUNT(DISTINCT M.IDMedicamento) AS TotalMedicamentosPreparados
FROM FARMACEUTICO AS F
INNER JOIN PERSONAL    AS P  ON F.IDPersonal = P.IDPersonal
INNER JOIN PREPARAR    AS PR ON F.IDPersonal = PR.IDPersonal
INNER JOIN MEDICAMENTO AS M  ON PR.IDMedicamento = M.IDMedicamento
GROUP BY
    P.IDPersonal,
    P.Nombre,
    P.ApellidoPaterno,
    P.ApellidoMaterno,
    P.IDSucursal
HAVING
       COUNT(DISTINCT CASE WHEN M.MedicamentosEsteriles THEN M.IDMedicamento END) > 0
    OR COUNT(DISTINCT CASE WHEN M.Pediatrica            THEN M.IDMedicamento END) > 0
    OR COUNT(DISTINCT CASE WHEN M.Dermatologica         THEN M.IDMedicamento END) > 0
    OR COUNT(DISTINCT CASE WHEN M.PreparadosOficiales   THEN M.IDMedicamento END) > 0
ORDER BY TotalMedicamentosPreparados DESC;


-- Consulta xix
-- Distribución de clientes registrados según el método de pago
-- que utilizan, separando además a clientes en línea, físicos
-- y pacientes.

SELECT
    COALESCE(C.MetodoPago, 'Sin metodo registrado') AS MetodoPago,
    COUNT(*) AS TotalClientes,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS PorcentajeDelTotal,
    SUM(CASE WHEN C.EsClienteEnLinea THEN 1 ELSE 0 END) AS ClientesEnLinea,
    SUM(CASE WHEN C.EsClienteFisico  THEN 1 ELSE 0 END) AS ClientesFisicos,
    SUM(CASE WHEN C.EsPaciente       THEN 1 ELSE 0 END) AS ClientesPacientes
FROM CLIENTE AS C
GROUP BY C.MetodoPago
ORDER BY TotalClientes DESC;


-- Consulta xx
-- Clientes que califican para descuento según el número
-- de tickets emitidos durante el año en curso.
-- Reglas de clasificación:
--   5 a 9   tickets en el año -> 5%
--   10 a 19 tickets en el año -> 10%
--   20 o más tickets en el año -> 25%
-- Solo se listan clientes que califican para algún descuento.

WITH TicketsCliente AS (
    SELECT
        C.IDCliente,
        CONCAT(C.Nombre, ' ', C.ApellidoPaterno, ' ', C.ApellidoMaterno) AS NombreCompleto,
        COUNT(T.IDTicket) FILTER (
            WHERE EXTRACT(YEAR FROM T.Fecha) = EXTRACT(YEAR FROM CURRENT_DATE)
        ) AS TicketsAnioActual
    FROM CLIENTE AS C
    LEFT JOIN TICKET AS T
        ON C.IDCliente = T.IDCliente
    GROUP BY
        C.IDCliente,
        C.Nombre,
        C.ApellidoPaterno,
        C.ApellidoMaterno
)
SELECT
    IDCliente,
    NombreCompleto,
    TicketsAnioActual,
    CASE
        WHEN TicketsAnioActual >= 20 THEN '25%'
        WHEN TicketsAnioActual >= 10 THEN '10%'
        WHEN TicketsAnioActual >= 5  THEN '5%'
    END AS DescuentoQueCalifica
FROM TicketsCliente
WHERE TicketsAnioActual >= 5
ORDER BY
    TicketsAnioActual DESC,
    IDCliente;


-- Consulta xxi
-- Número de consultas médicas realizadas por mes,
-- mostrando además clientes distintos atendidos,
-- médicos activos, costo promedio e ingresos totales
-- por mes.

SELECT
    EXTRACT(YEAR  FROM CON.Fecha) AS Anio,
    EXTRACT(MONTH FROM CON.Fecha) AS Mes,
    TO_CHAR(CON.Fecha, 'YYYY-MM') AS PeriodoYM,
    COUNT(*)                        AS TotalConsultas,
    COUNT(DISTINCT CON.IDCliente)   AS ClientesDistintos,
    COUNT(DISTINCT CON.IDMedico)    AS MedicosActivos,
    ROUND(AVG(CON.CostoConsulta), 2) AS CostoPromedio,
    COALESCE(SUM(CON.CostoConsulta), 0) AS IngresosTotalesPorConsultas
FROM CONSULTA AS CON
GROUP BY
    EXTRACT(YEAR  FROM CON.Fecha),
    EXTRACT(MONTH FROM CON.Fecha),
    TO_CHAR(CON.Fecha, 'YYYY-MM')
ORDER BY
    Anio DESC,
    Mes  DESC;


-- Consulta xxii
-- Top 10 medicamentos más recetados en todo el sistema,
-- con el número de recetas distintas en las que aparecen
-- y un resumen de las dosis prescritas.

SELECT
    M.IDMedicamento,
    COUNT(PE.NumeroReceta)             AS VecesRecetado,
    COUNT(DISTINCT PE.NumeroReceta)    AS RecetasDistintas,
    STRING_AGG(DISTINCT PE.Dosis, '; ' ORDER BY PE.Dosis) AS DosisFrecuentes,
    M.PrecioPublico,
    M.Stock                             AS StockActual
FROM MEDICAMENTO AS M
INNER JOIN PEDIR AS PE
    ON M.IDMedicamento = PE.IDMedicamento
GROUP BY
    M.IDMedicamento,
    M.PrecioPublico,
    M.Stock
ORDER BY VecesRecetado DESC
LIMIT 10;


-- Consulta xxiii
-- Pacientes con alergias registradas en alguna receta médica,
-- mostrando el diagnóstico asociado y los medicamentos que se
-- les recetaron pese a la alergia. Útil para auditoría clínica.

SELECT
    C.IDCliente,
    CONCAT(C.Nombre, ' ', C.ApellidoPaterno, ' ', C.ApellidoMaterno) AS NombrePaciente,
    R.NumeroReceta,
    R.Alergias,
    R.Diagnostico,
    STRING_AGG(DISTINCT PE.IDMedicamento::text, ', ' ORDER BY PE.IDMedicamento::text) AS MedicamentosRecetados,
    CON.Fecha AS FechaConsulta
FROM CLIENTE AS C
INNER JOIN CONSULTA AS CON
    ON C.IDCliente = CON.IDCliente
INNER JOIN GENERAR_CONSULTA_RECETA AS GCR
    ON CON.IDConsulta = GCR.IDConsulta
INNER JOIN RECETA_MEDICA AS R
    ON GCR.NumeroReceta = R.NumeroReceta
LEFT JOIN PEDIR AS PE
    ON R.NumeroReceta = PE.NumeroReceta
WHERE R.Alergias IS NOT NULL
  AND TRIM(R.Alergias) <> ''
  AND LOWER(TRIM(R.Alergias)) NOT IN ('ninguna', 'ninguno', 'n/a', 'no', 'na', 'sin alergias')
GROUP BY
    C.IDCliente,
    C.Nombre,
    C.ApellidoPaterno,
    C.ApellidoMaterno,
    R.NumeroReceta,
    R.Alergias,
    R.Diagnostico,
    CON.Fecha
ORDER BY
    C.IDCliente,
    R.NumeroReceta;


-- Consulta xxiv
-- Stock estimado de medicamentos por sucursal.
-- Se calcula como (total suministrado a la sucursal) - (total vendido en ella),
-- considerando todos los lotes de PROVEER_MEDICAMENTO y las ventas de COMPRAR.

WITH SuministrosPorSucursal AS (
    SELECT
        IDSucursal,
        IDMedicamento,
        SUM(Cantidad) AS TotalSuministrado
    FROM PROVEER_MEDICAMENTO
    GROUP BY
        IDSucursal,
        IDMedicamento
),
VentasPorSucursal AS (
    SELECT
        T.IDSucursal,
        CO.IDMedicamento,
        SUM(CO.Cantidad) AS TotalVendido
    FROM TICKET  AS T
    INNER JOIN COMPRAR AS CO
        ON T.IDTicket = CO.IDTicket
    GROUP BY
        T.IDSucursal,
        CO.IDMedicamento
)
SELECT
    S.IDSucursal,
    S.Nombre AS NombreSucursal,
    SS.IDMedicamento,
    SS.TotalSuministrado,
    COALESCE(VS.TotalVendido, 0) AS TotalVendido,
    SS.TotalSuministrado - COALESCE(VS.TotalVendido, 0) AS StockEstimadoSucursal
FROM SUCURSAL AS S
INNER JOIN SuministrosPorSucursal AS SS
    ON S.IDSucursal = SS.IDSucursal
LEFT JOIN VentasPorSucursal AS VS
    ON SS.IDSucursal    = VS.IDSucursal
   AND SS.IDMedicamento = VS.IDMedicamento
ORDER BY
    S.IDSucursal,
    StockEstimadoSucursal ASC;


-- Consulta xxv
-- Medicamentos próximos a caducar (en los siguientes 90 días)
-- por sucursal, lote y proveedor, con la cantidad en inventario
-- y los días que faltan para el vencimiento.

SELECT
    PM.IDSucursal,
    S.Nombre  AS NombreSucursal,
    PM.IDMedicamento,
    PM.IDProveedor,
    PR.RazonSocial AS Proveedor,
    PM.Cantidad,
    PM.FechaDeRecibo,
    PM.FechaDeCaducidad,
    (PM.FechaDeCaducidad - CURRENT_DATE) AS DiasParaCaducar
FROM PROVEER_MEDICAMENTO AS PM
INNER JOIN SUCURSAL  AS S  ON PM.IDSucursal = S.IDSucursal
INNER JOIN PROVEEDOR AS PR ON PM.IDProveedor = PR.IDProveedor
WHERE PM.FechaDeCaducidad BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '90 days'
ORDER BY
    PM.FechaDeCaducidad ASC,
    PM.IDSucursal,
    PM.IDMedicamento;


-- Consulta xxvi
-- Medicamentos que son suministrados por más de un proveedor
-- (proveedores que compiten por el mismo producto), incluyendo
-- la cantidad total suministrada por cada proveedor y el
-- precio unitario promedio del medicamento.

WITH MedicamentosConMultiplesProveedores AS (
    SELECT
        IDMedicamento,
        COUNT(DISTINCT IDProveedor) AS NumProveedores
    FROM PROVEER_MEDICAMENTO
    GROUP BY IDMedicamento
    HAVING COUNT(DISTINCT IDProveedor) >= 2
)
SELECT
    PM.IDMedicamento,
    MCMP.NumProveedores,
    PR.IDProveedor,
    PR.RazonSocial,
    SUM(PM.Cantidad)              AS CantidadTotalSuministrada,
    ROUND(AVG(M.PrecioUnitario), 2) AS PrecioUnitarioPromedio
FROM PROVEER_MEDICAMENTO AS PM
INNER JOIN MedicamentosConMultiplesProveedores AS MCMP
    ON PM.IDMedicamento = MCMP.IDMedicamento
INNER JOIN PROVEEDOR    AS PR ON PM.IDProveedor   = PR.IDProveedor
INNER JOIN MEDICAMENTO  AS M  ON PM.IDMedicamento = M.IDMedicamento
GROUP BY
    PM.IDMedicamento,
    MCMP.NumProveedores,
    PR.IDProveedor,
    PR.RazonSocial
ORDER BY
    PM.IDMedicamento,
    CantidadTotalSuministrada DESC;


-- Consulta xxvii
-- Ventas presenciales contra ventas en línea por sucursal.
-- Se utiliza la naturaleza del cliente (EsClienteEnLinea /
-- EsClienteFisico) para clasificar cada ticket. Si un cliente
-- es ambos, el ticket se reporta en la categoría "Mixto".

SELECT
    S.IDSucursal,
    S.Nombre AS NombreSucursal,
    COUNT(CASE
            WHEN C.EsClienteEnLinea AND NOT C.EsClienteFisico THEN T.IDTicket
          END) AS TicketsEnLinea,
    COUNT(CASE
            WHEN C.EsClienteFisico AND NOT C.EsClienteEnLinea THEN T.IDTicket
          END) AS TicketsPresenciales,
    COUNT(CASE
            WHEN C.EsClienteEnLinea AND C.EsClienteFisico THEN T.IDTicket
          END) AS TicketsMixtos,
    ROUND(SUM(CASE
            WHEN C.EsClienteEnLinea AND NOT C.EsClienteFisico THEN T.PrecioNeto
            ELSE 0
          END), 2) AS MontoEnLinea,
    ROUND(SUM(CASE
            WHEN C.EsClienteFisico AND NOT C.EsClienteEnLinea THEN T.PrecioNeto
            ELSE 0
          END), 2) AS MontoPresencial,
    ROUND(SUM(CASE
            WHEN C.EsClienteEnLinea AND C.EsClienteFisico THEN T.PrecioNeto
            ELSE 0
          END), 2) AS MontoMixto
FROM SUCURSAL AS S
LEFT JOIN TICKET  AS T ON S.IDSucursal = T.IDSucursal
LEFT JOIN CLIENTE AS C ON T.IDCliente  = C.IDCliente
GROUP BY
    S.IDSucursal,
    S.Nombre
HAVING COUNT(T.IDTicket) > 0
ORDER BY
    (COUNT(T.IDTicket)) DESC,
    S.IDSucursal;


-- Consulta xxviii
-- Comparación de ingresos por venta de medicamentos vs ingresos
-- por consultas médicas, agrupado por sucursal. Muestra el
-- porcentaje del ingreso total que proviene de ventas para
-- identificar el modelo de negocio dominante de cada sucursal.

WITH IngresosVentas AS (
    SELECT
        T.IDSucursal,
        SUM(T.PrecioNeto)          AS IngresosPorVentas,
        COUNT(DISTINCT T.IDTicket) AS NumeroTickets
    FROM TICKET AS T
    GROUP BY T.IDSucursal
),
IngresosConsultas AS (
    SELECT
        CL.IDSucursal,
        SUM(CON.CostoConsulta) AS IngresosPorConsultas,
        COUNT(CON.IDConsulta)  AS NumeroConsultas
    FROM CONSULTA AS CON
    INNER JOIN CLINICA AS CL
        ON CON.IDClinica = CL.IDClinica
    GROUP BY CL.IDSucursal
)
SELECT
    S.IDSucursal,
    S.Nombre AS NombreSucursal,
    COALESCE(IV.IngresosPorVentas, 0)    AS IngresosPorVentas,
    COALESCE(IV.NumeroTickets, 0)        AS NumeroTickets,
    COALESCE(IC.IngresosPorConsultas, 0) AS IngresosPorConsultas,
    COALESCE(IC.NumeroConsultas, 0)      AS NumeroConsultas,
    COALESCE(IV.IngresosPorVentas, 0)
        + COALESCE(IC.IngresosPorConsultas, 0) AS IngresosTotales,
    CASE
        WHEN (COALESCE(IV.IngresosPorVentas, 0)
              + COALESCE(IC.IngresosPorConsultas, 0)) > 0
        THEN ROUND(
            COALESCE(IV.IngresosPorVentas, 0) * 100.0
            / (COALESCE(IV.IngresosPorVentas, 0)
               + COALESCE(IC.IngresosPorConsultas, 0)),
            2)
        ELSE 0
    END AS PorcentajeIngresoVentas
FROM SUCURSAL AS S
LEFT JOIN IngresosVentas    AS IV ON S.IDSucursal = IV.IDSucursal
LEFT JOIN IngresosConsultas AS IC ON S.IDSucursal = IC.IDSucursal
ORDER BY IngresosTotales DESC;