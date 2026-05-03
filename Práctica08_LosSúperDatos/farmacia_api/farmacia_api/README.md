# farmacia_api — Práctica 08: Psycopg2 + Django REST Framework

API REST para operaciones CRUD sobre las tablas **CLIENTE** y **MEDICAMENTO**
de la base de datos Clínica/Farmacia, construida con Django y Psycopg2.

---

## Requisitos previos

- Python 3.10+
- PostgreSQL corriendo con la base de datos ya creada (DDL.sql aplicado)
- pip

---

## Instalación

```bash
# 1. Clona o descomprime el proyecto y entra a la carpeta
cd farmacia_api

# 2. Crea y activa el entorno virtual
python -m venv venv
source venv/bin/activate          # Linux/macOS
venv\Scripts\activate             # Windows

# 3. Instala las dependencias
pip install -r requirements.txt

# 4. Configura las variables de entorno
cp .env.example .env
# Edita .env con tu nombre de BD, usuario y contraseña de PostgreSQL

# 5. Verifica la configuración
python manage.py check

# 6. Inicia el servidor
python manage.py runserver
```

#Pegar tablas en pgAdmin4 y probar con postman

La API estará disponible en: **http://127.0.0.1:8000/**

---

## Endpoints disponibles

### CLIENTE

| Método | URL | Descripción |
|--------|-----|-------------|
| GET | `/api/clientes/` | Lista todos los clientes |
| POST | `/api/clientes/` | Crea un nuevo cliente |
| GET | `/api/clientes/<id>/` | Obtiene un cliente por ID |
| PUT | `/api/clientes/<id>/` | Actualiza un cliente |
| DELETE | `/api/clientes/<id>/` | Elimina un cliente |

### sucursal

| Método | URL | Descripción |
|--------|-----|-------------|
| GET | `/api/sucursal/` | Lista todos los sucursal |
| POST | `/api/sucursal/` | Crea una nueva sucursal |
| GET | `/api/sucursal/<id>/` | Obtiene una sucursal por ID |
| PUT | `/api/sucursal/<id>/` | Actualiza una sucursal |
| DELETE | `/api/sucursal/<id>/` | Elimina una sucursal |

---

## Ejemplos de cuerpos JSON para Postman

### POST /api/clientes/
```json
{
  "idcliente": 100,
  "nombre": "Ana",
  "apellidopaterno": "García",
  "apellidomaterno": "López",
  "fechanacimiento": "1990-05-15",
  "calle": "Insurgentes",
  "numexterior": "42",
  "numinterior": null,
  "colonia": "Roma Norte",
  "estado": "CDMX",
  "metodopago": "Tarjeta",
  "numerotarjeta": "4111111111111111",
  "vencimientotarjeta": "2027-12-01",
  "usuario": "ana.garcia",
  "contrasena": "hashed_password",
  "esclienteenlinea": true,
  "esclientefisico": false,
  "espaciente": false
}
```

### PUT /api/clientes/100/
```json
{
  "nombre": "Ana",
  "apellidopaterno": "García",
  "apellidomaterno": "Martínez",
  "estado": "Jalisco",
  "esclienteenlinea": true,
  "esclientefisico": true,
  "espaciente": true
}
```

### POST /api/sucursal/
```json
{
    "idsucursal": 999,
    "nombre": "Sucursal Central",
    "calle": "Av. Reforma",
    "numexterior": "123",
    "numinterior": null,
    "colonia": "Juárez",
    "estado": "CDMX"
}
```


## Estructura del proyecto

```
farmacia_api/
├── manage.py
├── requirements.txt
├── .env.example
├── db.py                        # Conexión Psycopg2 centralizada
├── farmacia_api/
│   ├── __init__.py
│   ├── settings.py              # Configuración Django + BD
│   ├── urls.py                  # URLs raíz
│   └── wsgi.py
├── cliente/
│   ├── __init__.py
│   ├── apps.py
│   ├── queries.py               # SQL con Psycopg2 (CRUD CLIENTE)
│   ├── views.py                 # Vistas REST (APIView)
│   └── urls.py
└── sucursal/
    ├── __init__.py
    ├── apps.py
    ├── queries.py               # SQL con Psycopg2 (CRUD MEDICAMENTO)
    ├── views.py                 # Vistas REST (APIView)
    └── urls.py
  
```
