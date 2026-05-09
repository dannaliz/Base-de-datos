"""
Capa de acceso a datos para la tabla CLIENTE.

Este módulo implementa directamente las consultas SQL sobre la tabla CLIENTE
usando Psycopg2, sin pasar por el ORM de Django. Cada función representa
una de las operaciones CRUD requeridas por la práctica.

Queries implementadas:
    - ``get_all_clientes``  → SELECT todos los registros  (READ - todos)
    - ``get_cliente_by_id`` → SELECT por IDCliente         (READ - uno)
    - ``create_cliente``    → INSERT nuevo registro        (CREATE)
    - ``update_cliente``    → UPDATE registro existente    (UPDATE)
    - ``delete_cliente``    → DELETE registro por ID       (DELETE)
"""

from db import get_connection



# Columnas que se manejan en las queries (mantiene consistencia)
COLUMNS = [
    'idcliente', 'nombre', 'apellidopaterno', 'apellidomaterno',
    'fechanacimiento', 'calle', 'numexterior', 'numinterior',
    'colonia', 'estado', 'metodopago', 'numerotarjeta',
    'vencimientotarjeta', 'usuario', 'contrasena',
    'esclienteenlinea', 'esclientefisico', 'espaciente',
]


def _row_to_dict(row):
    """
    Convierte una tupla retornada por Psycopg2 en un diccionario.
    """
    result = {}
    for key, value in zip(COLUMNS, row):
        # Las fechas no son serializables a JSON directamente
        if hasattr(value, 'isoformat'):
            value = value.isoformat()
        result[key] = value
    return result



# READ — obtener todos los clientes

def get_all_clientes():
    """
    Recupera todos los registros de la tabla CLIENTE.
    """
    conn = get_connection()
    try:
        cur = conn.cursor()
        cur.execute("""
            SELECT IDCliente, Nombre, ApellidoPaterno, ApellidoMaterno,
                   FechaNacimiento, Calle, NumExterior, NumInterior,
                   Colonia, Estado, MetodoPago, NumeroTarjeta,
                   VencimientoTarjeta, Usuario, Contrasena,
                   EsClienteEnLinea, EsClienteFisico, EsPaciente
            FROM CLIENTE
            ORDER BY IDCliente;
        """)
        rows = cur.fetchall()
        return [_row_to_dict(row) for row in rows]
    finally:
        conn.close()



# READ — obtener un cliente por ID

def get_cliente_by_id(id_cliente):
    """
    Recupera un único registro de CLIENTE dado su identificador.

    """
    conn = get_connection()
    try:
        cur = conn.cursor()
        cur.execute("""
            SELECT IDCliente, Nombre, ApellidoPaterno, ApellidoMaterno,
                   FechaNacimiento, Calle, NumExterior, NumInterior,
                   Colonia, Estado, MetodoPago, NumeroTarjeta,
                   VencimientoTarjeta, Usuario, Contrasena,
                   EsClienteEnLinea, EsClienteFisico, EsPaciente
            FROM CLIENTE
            WHERE IDCliente = %s;
        """, (id_cliente,))
        row = cur.fetchone()
        return _row_to_dict(row) if row else None
    finally:
        conn.close()



# CREATE — insertar un nuevo cliente
def create_cliente(data):
    """
    Inserta un nuevo registro en la tabla CLIENTE.
    """
    conn = get_connection()
    try:
        cur = conn.cursor()
        cur.execute("""
            INSERT INTO CLIENTE (
                IDCliente, Nombre, ApellidoPaterno, ApellidoMaterno,
                FechaNacimiento, Calle, NumExterior, NumInterior,
                Colonia, Estado, MetodoPago, NumeroTarjeta,
                VencimientoTarjeta, Usuario, Contrasena,
                EsClienteEnLinea, EsClienteFisico, EsPaciente
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s,
                      %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
        """, (
            data.get('idcliente'),
            data.get('nombre'),
            data.get('apellidopaterno'),
            data.get('apellidomaterno'),
            data.get('fechanacimiento'),
            data.get('calle'),
            data.get('numexterior'),
            data.get('numinterior'),
            data.get('colonia'),
            data.get('estado'),
            data.get('metodopago'),
            data.get('numerotarjeta'),
            data.get('vencimientotarjeta'),
            data.get('usuario'),
            data.get('contrasena'),
            data.get('esclienteenlinea', False),
            data.get('esclientefisico', False),
            data.get('espaciente', False),
        ))
        conn.commit()
        return data
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()



# UPDATE — actualizar un cliente existente
def update_cliente(id_cliente, data):
    """
    Actualiza los campos de un registro existente en CLIENTE.

    """
    conn = get_connection()
    try:
        cur = conn.cursor()
        cur.execute("""
            UPDATE CLIENTE
            SET Nombre             = %s,
                ApellidoPaterno    = %s,
                ApellidoMaterno    = %s,
                FechaNacimiento    = %s,
                Calle              = %s,
                NumExterior        = %s,
                NumInterior        = %s,
                Colonia            = %s,
                Estado             = %s,
                MetodoPago         = %s,
                NumeroTarjeta      = %s,
                VencimientoTarjeta = %s,
                Usuario            = %s,
                Contrasena         = %s,
                EsClienteEnLinea   = %s,
                EsClienteFisico    = %s,
                EsPaciente         = %s
            WHERE IDCliente = %s;
        """, (
            data.get('nombre'),
            data.get('apellidopaterno'),
            data.get('apellidomaterno'),
            data.get('fechanacimiento'),
            data.get('calle'),
            data.get('numexterior'),
            data.get('numinterior'),
            data.get('colonia'),
            data.get('estado'),
            data.get('metodopago'),
            data.get('numerotarjeta'),
            data.get('vencimientotarjeta'),
            data.get('usuario'),
            data.get('contrasena'),
            data.get('esclienteenlinea'),
            data.get('esclientefisico'),
            data.get('espaciente'),
            id_cliente,
        ))
        conn.commit()
        return cur.rowcount > 0
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()



# DELETE — eliminar un cliente por ID
def delete_cliente(id_cliente):
    """
    Elimina un registro de la tabla CLIENTE dado su identificador.
    """
    conn = get_connection()
    try:
        cur = conn.cursor()
        cur.execute("DELETE FROM CLIENTE WHERE IDCliente = %s;", (id_cliente,))
        conn.commit()
        return cur.rowcount > 0
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()
