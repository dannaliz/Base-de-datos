"""
URL raíz del proyecto farmacia_api.

Incluye las rutas de las aplicaciones 'cliente' y 'medicamento'.
Todas las rutas de la API están bajo el prefijo /api/.
"""

from django.urls import path, include

urlpatterns = [
    path('api/clientes/',     include('cliente.urls')),
    path('api/sucursal/', include('sucursal.urls')),
]
