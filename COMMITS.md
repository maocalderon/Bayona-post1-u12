# Instrucciones para los 3 commits requeridos

Nombre del repositorio: **calderon-post1-u12**

Ejecuta estos comandos en orden después de subir el proyecto a GitHub:

```bash
# 1. Inicializar repositorio y primer commit
git init
git remote add origin https://github.com/TU_USUARIO/calderon-post1-u12.git
git add Dockerfile .dockerignore
git commit -m "feat: add Dockerfile multi-stage and .dockerignore"

# 2. Segundo commit
git add src/main/resources/application-prod.properties \
        src/main/resources/application-dev.properties \
        docker-compose.yml
git commit -m "feat: add application profiles and docker-compose with PostgreSQL"

# 3. Tercer commit (todo lo demás)
git add .
git commit -m "feat: configure Railway variables and add deployment README"

# Subir todo a GitHub
git push -u origin main
```

## Resumen de los 3 commits

| # | Mensaje | Archivos incluidos |
|---|---|---|
| 1 | `feat: add Dockerfile multi-stage and .dockerignore` | `Dockerfile`, `.dockerignore` |
| 2 | `feat: add application profiles and docker-compose with PostgreSQL` | `application-prod.properties`, `application-dev.properties`, `docker-compose.yml` |
| 3 | `feat: configure Railway variables and add deployment README` | Todo lo demás (código Java, pom.xml, README.md, tests) |
