-- i. Clientes cuyo nombre empiece con la letra R
SELECT *
FROM Cliente
WHERE Nombre LIKE 'R%';


-- ii. Medicamentos que hayan caducado después del 20 de abril del 2026 pero antes del 07 de mayo del 2026
SELECT *
FROM Medicamento
WHERE FechaDeCaducidad > '2026-04-20'
  AND FechaDeCaducidad < '2026-05-07';


-- iii. Farmacéuticos que hayan nacido en el mes de noviembre


-- iv. Medicamentos cuya forma física sea gel y vía de administración sea oral
SELECT *
FROM Insumo
WHERE LOWER(FormaFarmaceutica) = 'gel'
  AND LOWER(ViaAdministracion) = 'oral';


-- v. Todos los proveedores registrados
SELECT *
FROM Proveedor;