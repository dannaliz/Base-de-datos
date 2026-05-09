import psycopg2
import os

def ejecutar_sql(cursor, nombre_archivo):
    if not os.path.exists(nombre_archivo):
        print(f"ERROR: No encuentro {nombre_archivo}")
        return
    print(f"Instalando: {nombre_archivo}...")
    
    with open(nombre_archivo, 'r', encoding='utf-8') as f:
        # Esto separa el archivo por cada ';' (punto y coma)
        comandos = f.read().split(';')
        
        for comando in comandos:
            comando = comando.strip()
            if comando: # Si no es una línea vacía
                try:
                    cursor.execute(comando + ';')
                except Exception as e:
                    # Si un insert falla (por ejemplo, un duplicado), 
                    # lo saltamos y seguimos con el resto
                    print(f"Aviso en {nombre_archivo}: {e}")

try:

    conn = psycopg2.connect(
        dbname="farmacia",
        user="postgres",
        password="0130",  
        host="localhost",
        port="5432"
    )
    conn.autocommit = True
    cur = conn.cursor()

    print("Conexión exitosa. Preparando tablas...")
    
    # 1. Desactivar llaves foráneas para que el DML no rebote
    cur.execute("SET session_replication_role = 'replica';")

    # 2. Ejecutar DDL (Asegúrate de que el nombre sea exacto)
    #ejecutar_sql(cur, 'DDL(1).sql')
    
    # 3. Ejecutar DML
    ejecutar_sql(cur, 'DML.sql')

    # 4. Reactivar seguridad
    cur.execute("SET session_replication_role = 'origin';")

    print("¡TODO LISTO! Ya puedes cerrar esto y correr el servidor.")
    cur.close()
    conn.close()

except Exception as e:
    print(f"ERROR: {e}")