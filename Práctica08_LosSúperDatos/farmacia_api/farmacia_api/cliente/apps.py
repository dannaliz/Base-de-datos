"""
Configuración de la aplicación Django 'cliente'.
"""

from django.apps import AppConfig


class ClienteConfig(AppConfig):
    """Clase de configuración para la aplicación cliente."""

    default_auto_field = 'django.db.models.BigAutoField'
    name = 'cliente'
    verbose_name = 'Gestión de Clientes'
