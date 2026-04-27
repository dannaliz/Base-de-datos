-- i. Clientes cuyo nombre empiece con la letra R
SELECT *
FROM CLIENTE
WHERE Nombre ILIKE 'R%';


-- ii. Medicamentos que hayan caducado después del 20 de abril del 2026 pero antes del 07 de mayo del 2026
SELECT *
FROM MEDICAMENTO
WHERE FechaDeCaducidad > '2026-04-20'
  AND FechaDeCaducidad < '2026-05-07';


-- iii. Farmacéuticos que hayan nacido en el mes de noviembre
SELECT p.*
FROM FARMACEUTICO AS f
JOIN PERSONAL AS p
  ON p.IDPersonal = f.IDPersonal
WHERE SUBSTRING(p.RFC FROM 7 FOR 2) = '11';


-- iv. Medicamentos cuya forma física sea gel y vía de administración sea oral
SELECT m.*
FROM MEDICAMENTO AS m
JOIN INSUMO AS i
  ON i.NombreCientifico = m.NombreCientifico
WHERE i.FormaFarmaceutica ILIKE 'gel'
  AND i.ViaAdministracion ILIKE 'oral';


-- v. Todos los proveedores registrados
SELECT *
FROM PROVEEDOR;
