-- Consulta i

SELECT
    C.IDCliente,
    CONCAT(C.Nombre, ' ', C.ApellidoPaterno, ' ', C.ApellidoMaterno) AS NombreCompleto,
    C.Usuario AS NombreUsuario
FROM CLIENTE AS C
ORDER BY C.IDCliente;

-- Consulta ii

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

