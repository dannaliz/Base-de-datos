"""
Módulo de conexión a PostgreSQL mediante Psycopg2.

Provee una función utilitaria para obtener una conexión activa a la base
de datos usando los parámetros definidos en settings.py (y por tanto en
el archivo .env del proyecto).
"""

import psycopg2
from django.conf import settings


def get_connection():
    """
    Crea y retorna una conexión nueva a PostgreSQL usando Psycopg2.

    Lee los parámetros de conexión desde ``django.conf.settings.DATABASES['default']``,
    lo que permite centralizarlos en el archivo ``.env``.
    """
    db = settings.DATABASES['default']
    connection = psycopg2.connect(
        dbname=db['NAME'],
        user=db['USER'],
        password=db['PASSWORD'],
        host=db['HOST'],
        port=db['PORT'],
    )
    return connection
