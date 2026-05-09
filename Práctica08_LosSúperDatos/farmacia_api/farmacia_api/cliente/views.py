"""
Vistas REST para la app 'cliente'.

Implementa los endpoints CRUD sobre la tabla CLIENTE utilizando
Django REST Framework (APIView) y Psycopg2 (a través del módulo
``cliente.queries``) para la comunicación directa con PostgreSQL.

Endpoints expuestos (ver urls.py):
    GET    /api/clientes/           → lista todos los clientes
    POST   /api/clientes/           → crea un nuevo cliente
    GET    /api/clientes/<id>/      → obtiene un cliente por ID
    PUT    /api/clientes/<id>/      → actualiza un cliente existente
    DELETE /api/clientes/<id>/      → elimina un cliente
"""

import psycopg2
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

from . import queries


class ClienteListView(APIView):
    """
    Vista para listar todos los clientes y crear un nuevo cliente.

    """

    def get(self, request):
        """
        Retorna todos los registros de la tabla CLIENTE.
        """
        try:
            clientes = queries.get_all_clientes()
            return Response(clientes, status=status.HTTP_200_OK)
        except psycopg2.Error as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )

    def post(self, request):
        """
        Inserta un nuevo cliente con los datos enviados en el cuerpo JSON.

        El cuerpo de la petición debe incluir al menos:
            - ``idcliente`` (int)
            - ``nombre`` (str)
            - ``apellidopaterno`` (str)
            - ``apellidomaterno`` (str)

        """
        try:
            nuevo = queries.create_cliente(request.data)
            return Response(nuevo, status=status.HTTP_201_CREATED)
        except psycopg2.IntegrityError as e:
            return Response(
                {'error': 'El IDCliente ya existe o viola una restricción.', 'detalle': str(e)},
                status=status.HTTP_409_CONFLICT,
            )
        except psycopg2.Error as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )


class ClienteDetailView(APIView):
    """
    Vista para obtener, actualizar o eliminar un cliente específico.

    """

    def get(self, request, id_cliente):
        """
        Retorna el cliente cuyo IDCliente coincide con el parámetro de URL.

        """
        try:
            cliente = queries.get_cliente_by_id(id_cliente)
            if cliente is None:
                return Response(
                    {'error': f'Cliente con ID {id_cliente} no encontrado.'},
                    status=status.HTTP_404_NOT_FOUND,
                )
            return Response(cliente, status=status.HTTP_200_OK)
        except psycopg2.Error as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )

    def put(self, request, id_cliente):
        """
        Actualiza el registro del cliente con el IDCliente indicado.

        El cuerpo de la petición debe contener todos los campos
        actualizables del cliente en formato JSON.

        """
        try:
            actualizado = queries.update_cliente(id_cliente, request.data)
            if not actualizado:
                return Response(
                    {'error': f'Cliente con ID {id_cliente} no encontrado.'},
                    status=status.HTTP_404_NOT_FOUND,
                )
            return Response(
                {'mensaje': f'Cliente {id_cliente} actualizado correctamente.'},
                status=status.HTTP_200_OK,
            )
        except psycopg2.Error as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )

    def delete(self, request, id_cliente):
        """
        Elimina el registro del cliente con el IDCliente indicado.

        """
        try:
            eliminado = queries.delete_cliente(id_cliente)
            if not eliminado:
                return Response(
                    {'error': f'Cliente con ID {id_cliente} no encontrado.'},
                    status=status.HTTP_404_NOT_FOUND,
                )
            return Response(status=status.HTTP_204_NO_CONTENT)
        except psycopg2.Error as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )
