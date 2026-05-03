"""
Punto de entrada WSGI para el proyecto farmacia_api.

Django usa este módulo para servir la aplicación en entornos de producción
compatibles con WSGI (p. ej. Gunicorn, uWSGI).
"""

import os
from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'farmacia_api.settings')
application = get_wsgi_application()
