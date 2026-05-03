"""
Configuración de la aplicación Django 'cliente'.

Esta app gestiona todas las operaciones CRUD sobre la tabla CLIENTE
de la base de datos de la Clínica/Farmacia, utilizando Psycopg2
directamente para la comunicación con PostgreSQL.
"""

from django.apps import AppConfig


class ClienteConfig(AppConfig):
    """Clase de configuración para la aplicación cliente."""

    default_auto_field = 'django.db.models.BigAutoField'
    name = 'cliente'
    verbose_name = 'Gestión de Clientes'
