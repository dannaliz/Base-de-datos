"""
Definición de URLs para la app 'cliente'.

Mapea las rutas HTTP a las vistas REST correspondientes:

    /api/clientes/         →  ClienteListView   (GET, POST)
    /api/clientes/<id>/    →  ClienteDetailView  (GET, PUT, DELETE)
"""

from django.urls import path
from .views import ClienteListView, ClienteDetailView

urlpatterns = [
    path('', ClienteListView.as_view(), name='cliente-list'),
    path('<int:id_cliente>/', ClienteDetailView.as_view(), name='cliente-detail'),
]
