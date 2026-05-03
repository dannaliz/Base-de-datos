import psycopg2
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from . import queries

class SucursalListView(APIView):
    def get(self, request):
        try:
            sucursales = queries.get_all_sucursales()
            return Response(sucursales, status=status.HTTP_200_OK)
        except psycopg2.Error as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def post(self, request):
        try:
            nuevo = queries.create_sucursal(request.data)
            return Response(nuevo, status=status.HTTP_201_CREATED)
        except psycopg2.IntegrityError:
            return Response({'error': 'El ID de sucursal ya existe.'}, status=status.HTTP_409_CONFLICT)
        except psycopg2.Error as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class SucursalDetailView(APIView):
    def get(self, request, id_sucursal):
        try:
            sucursal = queries.get_sucursal_by_id(id_sucursal)
            if not sucursal:
                return Response({'error': 'No encontrada'}, status=status.HTTP_404_NOT_FOUND)
            return Response(sucursal, status=status.HTTP_200_OK)
        except psycopg2.Error as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def put(self, request, id_sucursal):
        try:
            actualizado = queries.update_sucursal(id_sucursal, request.data)
            if not actualizado:
                return Response({'error': 'No encontrada'}, status=status.HTTP_404_NOT_FOUND)
            return Response({'mensaje': 'Actualizado correctamente'}, status=status.HTTP_200_OK)
        except psycopg2.Error as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def delete(self, request, id_sucursal):
        try:
            eliminado = queries.delete_sucursal(id_sucursal)
            if not eliminado:
                return Response({'error': 'No encontrada'}, status=status.HTTP_404_NOT_FOUND)
            return Response(status=status.HTTP_204_NO_CONTENT)
        except psycopg2.Error as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)