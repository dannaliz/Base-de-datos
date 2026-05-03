from django.urls import path
from .views import SucursalListView, SucursalDetailView

urlpatterns = [
    path('', SucursalListView.as_view(), name='sucursal-list'),
    path('<int:id_sucursal>/', SucursalDetailView.as_view(), name='sucursal-detail'),
]