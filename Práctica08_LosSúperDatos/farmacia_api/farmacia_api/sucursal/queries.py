from db import get_connection

COLUMNS = ['idsucursal', 'nombre', 'calle', 'numexterior', 'numinterior', 'colonia', 'estado']

def _row_to_dict(row):
    result = {}
    for key, value in zip(COLUMNS, row):
        result[key] = value
    return result

def get_all_sucursales():
    conn = get_connection()
    try:
        cur = conn.cursor()
        cur.execute('SELECT idsucursal, nombre, calle, numexterior, numinterior, colonia, estado FROM sucursal ORDER BY idsucursal;')
        rows = cur.fetchall()
        return [_row_to_dict(row) for row in rows]
    finally:
        conn.close()

# ---------------------------------------------------------------------------
# READ — obtener una sucursal por ID
# ---------------------------------------------------------------------------
def get_sucursal_by_id(id_sucursal):
    conn = get_connection()
    try:
        cur = conn.cursor()
        # CORREGIDO: Todo en minúsculas y sin comillas
        cur.execute('SELECT * FROM sucursal WHERE idsucursal = %s;', (id_sucursal,))
        row = cur.fetchone()
        return _row_to_dict(row) if row else None
    finally:
        conn.close()

# ---------------------------------------------------------------------------
# CREATE — insertar una nueva sucursal
# ---------------------------------------------------------------------------
def create_sucursal(data):
    conn = get_connection()
    try:
        cur = conn.cursor()
        # CORREGIDO: Quitamos "SUCURSAL" y ponemos sucursal
        cur.execute('''
            INSERT INTO sucursal (
                idsucursal, nombre, calle, numexterior, 
                numinterior, colonia, estado
            ) VALUES (%s, %s, %s, %s, %s, %s, %s);
        ''', (
            data.get('idsucursal'),
            data.get('nombre'),
            data.get('calle'),
            data.get('numexterior'),
            data.get('numinterior'),
            data.get('colonia'),
            data.get('estado'),
        ))
        conn.commit()
        return data
    except Exception as e:
        print(f"Error en CREATE: {e}") # Esto nos ayudará a ver el error en la terminal
        conn.rollback()
        raise
    finally:
        conn.close()

# ---------------------------------------------------------------------------
# UPDATE — actualizar una sucursal
# ---------------------------------------------------------------------------
def update_sucursal(id_sucursal, data):
    conn = get_connection()
    try:
        cur = conn.cursor()
        # CORREGIDO: Nombres de columnas en minúsculas
        cur.execute('''
            UPDATE sucursal 
            SET nombre=%s, calle=%s, numexterior=%s, numinterior=%s, 
                colonia=%s, estado=%s
            WHERE idsucursal=%s;
        ''', (
            data.get('nombre'),
            data.get('calle'),
            data.get('numexterior'),
            data.get('numinterior'),
            data.get('colonia'),
            data.get('estado'),
            id_sucursal
        ))
        conn.commit()
        return cur.rowcount > 0
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()

# ---------------------------------------------------------------------------
# DELETE — eliminar sucursal
# ---------------------------------------------------------------------------
def delete_sucursal(id_sucursal):
    conn = get_connection()
    try:
        cur = conn.cursor()
        # CORREGIDO: sucursal en minúsculas
        cur.execute('DELETE FROM sucursal WHERE idsucursal = %s;', (id_sucursal,))
        conn.commit()
        return cur.rowcount > 0
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()