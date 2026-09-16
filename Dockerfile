# Stage 1: Build-Vorbereitung und Optimierung
FROM quay.io/keycloak/keycloak:26.0 AS builder

# Eigene Extensions (SPIs) und Themes ins Image kopieren
COPY ./providers/ /opt/keycloak/providers/
COPY ./themes/ /opt/keycloak/themes/

# Build-Time Konfiguration
ENV KC_DB=postgres
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Optimierten Build anstoßen
RUN /opt/keycloak/bin/kc.sh build

# Stage 2: Bereinigtes Runtime-Image
FROM quay.io/keycloak/keycloak:26.0
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Startbefehl fest auf den optimierten Modus setzen
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start", "--optimized"]
