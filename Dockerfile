# ── Etapa 1: compilación con Maven + JDK ─────────────────────────────
FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /app

# Copiar pom.xml primero para aprovechar caché de capas de Docker.
# Si las dependencias no cambian entre builds, Maven no las descarga de nuevo.
COPY pom.xml .
RUN mvn dependency:go-offline -q 2>/dev/null || true

# Copiar código fuente y compilar omitiendo tests (se ejecutan en CI)
COPY src ./src
RUN mvn clean package -DskipTests -q

# ── Etapa 2: imagen de producción (solo JRE) ─────────────────────────
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Buena práctica de seguridad: ejecutar con usuario no root
RUN addgroup -S spring && adduser -S spring -G spring
USER spring

# Copiar únicamente el JAR compilado desde la etapa de builder
COPY --from=builder /app/target/*.jar app.jar

# Exponer el puerto que usa Spring Boot
EXPOSE 8080

# Comando de arranque del contenedor
ENTRYPOINT ["java", "-jar", "app.jar"]
