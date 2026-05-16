# calderon-post1-u12

Laboratorio Post-Contenido 1 — Unidad 12: Despliegue y CI/CD  
**Programación Web · Ingeniería de Sistemas · 2026**

## Descripción

Aplicación Spring Boot contenedorizada con Docker multi-stage y desplegada en Railway con base de datos PostgreSQL. Expone una API REST de gestión de productos.

---

## Requisitos previos

- Docker Desktop instalado y en ejecución
- Java 21 + Maven 3.8+ (solo para ejecución local sin Docker)
- Cuenta en [Railway](https://railway.app) vinculada a GitHub

---

## Estructura del proyecto

```
calderon-post1-u12/
├── src/
│   ├── main/
│   │   ├── java/com/calderon/app/
│   │   │   ├── AppApplication.java
│   │   │   ├── controller/ProductoController.java
│   │   │   ├── model/Producto.java
│   │   │   └── repository/ProductoRepository.java
│   │   └── resources/
│   │       ├── application.properties
│   │       ├── application-dev.properties
│   │       └── application-prod.properties
│   └── test/
├── Dockerfile
├── .dockerignore
├── docker-compose.yml
├── pom.xml
└── README.md
```

---

## Construcción y ejecución local con Docker

### 1. Construir la imagen Docker

```bash
docker build -t calderon-app:local .
```

La imagen usa **multi-stage build**:
- **Etapa 1 (builder):** `eclipse-temurin:21-jdk-alpine` → compila el proyecto con Maven
- **Etapa 2 (producción):** `eclipse-temurin:21-jre-alpine` → ejecuta solo el fat JAR

Verificar tamaño de la imagen (debe ser < 300 MB):
```bash
docker images calderon-app
```

### 2. Levantar el stack completo con Docker Compose

```bash
docker compose up -d --build
```

Verificar que ambos servicios están en ejecución:
```bash
docker compose ps
```

### 3. Verificar el healthcheck

```bash
curl http://localhost:8080/actuator/health
# Respuesta esperada: {"status":"UP"}
```

### 4. Probar los endpoints REST

```bash
# Listar productos
curl http://localhost:8080/api/productos

# Crear un producto
curl -X POST http://localhost:8080/api/productos \
  -H "Content-Type: application/json" \
  -d '{"nombre":"Laptop","precio":1500.00,"descripcion":"Laptop gaming"}'

# Obtener producto por ID
curl http://localhost:8080/api/productos/1

# Actualizar producto
curl -X PUT http://localhost:8080/api/productos/1 \
  -H "Content-Type: application/json" \
  -d '{"nombre":"Laptop Pro","precio":1800.00,"descripcion":"Laptop gaming actualizada"}'

# Eliminar producto
curl -X DELETE http://localhost:8080/api/productos/1
```

### 5. Detener el stack

```bash
docker compose down -v
```

---

## Variables de entorno requeridas

| Variable | Descripción | Ejemplo |
|---|---|---|
| `SPRING_PROFILES_ACTIVE` | Perfil activo de Spring Boot | `prod` |
| `DATABASE_URL` | URL JDBC de PostgreSQL | `jdbc:postgresql://host:5432/db` |
| `DB_USER` | Usuario de la base de datos | `appuser` |
| `DB_PASS` | Contraseña de la base de datos | `apppass` |

---

## Despliegue en Railway

### Pasos realizados

1. Acceder a [railway.app](https://railway.app) e iniciar sesión con GitHub.
2. Crear nuevo proyecto → **Deploy from GitHub repo** → seleccionar `calderon-post1-u12`.
3. Railway detecta el `Dockerfile` automáticamente y ejecuta el build (3-5 min).
4. Agregar servicio de base de datos: **+ New → Database → Add PostgreSQL**.
5. En el servicio de la aplicación → **Variables**, configurar:
   - `SPRING_PROFILES_ACTIVE` = `prod`
   - `DATABASE_URL` = `${{Postgres.DATABASE_URL}}`
   - `DB_USER` = `${{Postgres.PGUSER}}`
   - `DB_PASS` = `${{Postgres.PGPASSWORD}}`
6. Generar dominio público: **Settings → Networking → Generate Domain**.

### URL de la aplicación desplegada

```
https://calderon-post1-u12.up.railway.app
```

### Verificación del despliegue

```bash
curl https://calderon-post1-u12.up.railway.app/actuator/health
# {"status":"UP","components":{"db":{"status":"UP"}}}

curl https://calderon-post1-u12.up.railway.app/api/productos
```

---

## Endpoints disponibles

| Método | Ruta | Descripción |
|---|---|---|
| `GET` | `/api/productos` | Listar todos los productos |
| `GET` | `/api/productos/{id}` | Obtener producto por ID |
| `POST` | `/api/productos` | Crear nuevo producto |
| `PUT` | `/api/productos/{id}` | Actualizar producto |
| `DELETE` | `/api/productos/{id}` | Eliminar producto |
| `GET` | `/actuator/health` | Estado de la aplicación |

---

## Commits del laboratorio

| # | Commit | Descripción |
|---|---|---|
| 1 | `feat: add Dockerfile multi-stage and .dockerignore` | Dockerfile con etapas builder/producción, usuario no root, caché de capas |
| 2 | `feat: add application profiles and docker-compose with PostgreSQL` | Perfiles dev/prod, docker-compose con healthcheck para BD |
| 3 | `feat: configure Railway variables and add deployment README` | Variables de entorno, instrucciones Railway, documentación completa |

---

## Autor

**Mauricio Calderón**  
Ingeniería de Sistemas — Universidad de Santander (UDES)  
2026
