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
WHERE P.ApellidoMaterno ILIKE '%lo%'
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