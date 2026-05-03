from django.apps import AppConfig

class SucursalConfig(AppConfig):
    """Clase de configuración para la aplicación sucursal."""

    default_auto_field = 'django.db.models.BigAutoField'
    name = 'sucursal'  # <--- MUY IMPORTANTE: Que coincida con el nombre de la carpeta
    verbose_name = 'Gestión de Sucursales'