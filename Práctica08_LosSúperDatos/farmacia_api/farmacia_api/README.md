# farmacia_api — Práctica 08: Psycopg2 + Django REST Framework

API REST para operaciones CRUD sobre las tablas **CLIENTE** y **SUCURSAL**
de la base de datos Clínica/Farmacia, construida con Django, Django REST Framework y Psycopg2.
Incluye una interfaz gráfica web para interactuar con la API sin necesidad de Postman.

---

## Stack tecnológico

| Capa | Tecnología |
|------|-----------|
| Backend | Django 4.2 + Django REST Framework |
| Conexión BD | Psycopg2 (SQL directo, sin ORM) |
| Base de datos | PostgreSQL (vía Docker) |
| Frontend | HTML + CSS + JavaScript vanilla |

---

## Requisitos previos

- Python 3.10+
- Docker (para correr PostgreSQL)
- pip

---

## Configuración inicial (solo la primera vez)

### 1. Levantar la base de datos con Docker

```bash
# Crear e iniciar el contenedor de PostgreSQL
docker run --name postgres \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=tu_contraseña \
  -e POSTGRES_DB=farmacia \
  -p 5432:5432 \
  -d postgres:15

# Verificar que esté corriendo
docker ps
```

### 2. Crear las tablas e insertar datos

Ejecuta los archivos SQL en este orden desde DBeaver, pgAdmin o psql:

```
SQL/DDL.sql   →  crea todas las tablas
SQL/DML.sql   →  inserta los datos de prueba
```

### 3. Instalar dependencias del proyecto

```bash
# Entrar a la carpeta del proyecto
cd farmacia_api/farmacia_api

# Crear y activar entorno virtual
python -m venv venv
source venv/bin/activate        # Linux/macOS
venv\Scripts\activate           # Windows

# Instalar dependencias
pip install -r requirements.txt
pip install django-cors-headers
```

### 4. Configurar variables de entorno

```bash
cp .env.example .env
```

Edita el archivo `.env` con tus credenciales reales:

```env
SECRET_KEY=django-insecure-cambia-esto
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1

DB_NAME=farmacia
DB_USER=postgres
DB_PASSWORD=tu_contraseña_real
DB_HOST=localhost
DB_PORT=5432
```

---

## Uso diario (cada vez que quieras trabajar)

```bash
# 1. Iniciar PostgreSQL
docker start postgres

# 2. Activar entorno virtual
source venv/bin/activate        # Linux/macOS
venv\Scripts\activate           # Windows

# 3. Verificar configuración (opcional)
python manage.py check

# 4. Iniciar el servidor
python manage.py runserver
```

La API estará disponible en: **http://127.0.0.1:8000/**

---

## Interfaz gráfica

El proyecto incluye una interfaz web en `interfaz/farmacia_ui.html`.

Para usarla:
1. Asegúrate de que el servidor Django esté corriendo
2. Abre el archivo `farmacia_ui.html` directamente en tu navegador

La interfaz permite realizar todas las operaciones CRUD de Clientes y Sucursales
sin necesidad de Postman ni línea de comandos.

---

## Endpoints disponibles

### Clientes — `/api/clientes/`

| Método | URL | Descripción |
|--------|-----|-------------|
| GET | `/api/clientes/` | Lista todos los clientes |
| POST | `/api/clientes/` | Crea un nuevo cliente |
| GET | `/api/clientes/<id>/` | Obtiene un cliente por ID |
| PUT | `/api/clientes/<id>/` | Actualiza un cliente |
| DELETE | `/api/clientes/<id>/` | Elimina un cliente |

### Sucursales — `/api/sucursal/`

| Método | URL | Descripción |
|--------|-----|-------------|
| GET | `/api/sucursal/` | Lista todas las sucursales |
| POST | `/api/sucursal/` | Crea una nueva sucursal |
| GET | `/api/sucursal/<id>/` | Obtiene una sucursal por ID |
| PUT | `/api/sucursal/<id>/` | Actualiza una sucursal |
| DELETE | `/api/sucursal/<id>/` | Elimina una sucursal |

---

## Ejemplos de cuerpos JSON

### POST `/api/clientes/`
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

### PUT `/api/clientes/100/`
```json
{
  "nombre": "Ana",
  "apellidopaterno": "García",
  "apellidomaterno": "Martínez",
  "fechanacimiento": "1990-05-15",
  "calle": "Insurgentes",
  "numexterior": "42",
  "numinterior": null,
  "colonia": "Roma Norte",
  "estado": "Jalisco",
  "metodopago": "Tarjeta",
  "numerotarjeta": "4111111111111111",
  "vencimientotarjeta": "2027-12-01",
  "usuario": "ana.garcia",
  "contrasena": "hashed_password",
  "esclienteenlinea": true,
  "esclientefisico": true,
  "espaciente": true
}
```

### POST `/api/sucursal/`
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

### PUT `/api/sucursal/999/`
```json
{
  "nombre": "Sucursal Central Actualizada",
  "calle": "Av. Reforma",
  "numexterior": "123",
  "numinterior": "2B",
  "colonia": "Juárez",
  "estado": "CDMX"
}
```

---

## Estructura del proyecto

```
farmacia_api/
├── manage.py
├── requirements.txt
├── .env.example                 # Plantilla de variables de entorno
├── .env                         # Variables reales (no subir a git)
├── db.py                        # Conexión Psycopg2 centralizada
├── farmacia_api/
│   ├── settings.py              # Configuración Django + BD
│   ├── urls.py                  # URLs raíz del proyecto
│   └── wsgi.py
├── cliente/
│   ├── queries.py               # SQL con Psycopg2 (CRUD CLIENTE)
│   ├── views.py                 # Vistas REST (APIView)
│   └── urls.py                  # Rutas de la app cliente
├── sucursal/
│   ├── queries.py               # SQL con Psycopg2 (CRUD SUCURSAL)
│   ├── views.py                 # Vistas REST (APIView)
│   └── urls.py                  # Rutas de la app sucursal
└── interfaz/
    └── farmacia_ui.html         # Interfaz gráfica web
```

---

## Flujo de una petición

```
Interfaz / Postman
      ↓  HTTP Request
   urls.py  →  views.py (APIView)
                   ↓
              queries.py
                   ↓
           Psycopg2 → PostgreSQL
                   ↓
              JSON Response
      ↑  HTTP Response
Interfaz / Postman
```