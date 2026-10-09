#!/bin/bash
# Neat Structured Standalone Database GUI for Render PostgreSQL

H2_JAR=$(find "$HOME/.m2/repository/com/h2database/h2" -name "h2-*.jar" | head -n 1)
PG_JAR=$(find "$HOME/.m2/repository/org/postgresql/postgresql" -name "postgresql-*.jar" | head -n 1)

RENDER_URL="jdbc:postgresql://dpg-dapc9qvf3r2c73c7hqjg-a.ohio-postgres.render.com/communityconnect_dsmj?sslmode=require"
RENDER_USER="postgres1"
RENDER_PASS="EljZjmzjoxtOHgJt9WFhTxYoCgtvtfld"

echo "========================================================"
echo " 🗄️ Launching Neat Structured Render DB GUI..."
echo "========================================================"
echo " Driver: PostgreSQL Driver"
echo " Host: dpg-dapc9qvf3r2c73c7hqjg-a.ohio-postgres.render.com"
echo "========================================================"
echo ""

java -cp "${H2_JAR}:${PG_JAR}" org.h2.tools.Console \
  -url "${RENDER_URL}" \
  -driver "org.postgresql.Driver" \
  -user "${RENDER_USER}" \
  -password "${RENDER_PASS}"
