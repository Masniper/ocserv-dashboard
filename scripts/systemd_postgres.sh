#!/bin/bash
# ===============================
# Script: systemd_postgres.sh
# Description:
#   PostgreSQL 17 installation & initialization script
#   for ocserv_dashboard.
#
#   - Loads logging + helper functions from lib.sh
#   - Detects OS (Debian/Ubuntu supported)
#   - Installs PostgreSQL 17 from official repo
#   - Starts & enables PostgreSQL service
#   - Loads database config from .env file
#   - Creates database, user, and grants privileges
#
# Requirements:
#   - lib.sh must exist and define:
#       log(), ok(), warn(), die()
#   - .env file must contain:
#       POSTGRES_DB
#       POSTGRES_USER
#       POSTGRES_PASSWORD
#
# Exit behavior:
#   Script exits immediately on error (set -e)
#   Any error prints the failing line number
# ===============================

# Load logging + helper utilities
source ./scripts/lib.sh

# ===============================
# Load environment variables
# ===============================
# Validate required vars
#[ -z "$POSTGRES_DB" ] && die "POSTGRES_DB is not set"
#[ -z "$POSTGRES_USER" ] && die "POSTGRES_USER is not set"
#[ -z "$POSTGRES_PASSWORD" ] && die "POSTGRES_PASSWORD is not set"

ok "Environment loaded"

# ===============================
# Install PostgreSQL 17
# ===============================
ok "Installing PostgreSQL 17..."

sudo rm -f /etc/apt/sources.list.d/pgdg.list
sudo rm -f /usr/share/keyrings/postgresql.gpg

sudo apt update -y
sudo apt install -y wget gnupg lsb-release

sudo mkdir -p /usr/share/keyrings

# Add PostgreSQL official repo
if [ ! -f /etc/apt/sources.list.d/pgdg.list ]; then
    log "Adding PostgreSQL repository..."
    wget -qO- https://www.postgresql.org/media/keys/ACCC4CF8.asc \
        | sudo gpg --dearmor -o /usr/share/keyrings/postgresql.gpg

    echo "deb [signed-by=/usr/share/keyrings/postgresql.gpg] \
http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" \
        | sudo tee /etc/apt/sources.list.d/pgdg.list
fi

sudo apt update -y
sudo apt install -y postgresql-17

ok "PostgreSQL installed"

# ===============================
# Start & enable service
# ===============================
ok "Starting PostgreSQL service..."

sudo systemctl enable postgresql
sudo systemctl restart postgresql

ok "PostgreSQL is running"

# ===============================
# Create DB & user
# ===============================
ok "Configuring database..."

sudo -u postgres psql <<EOF
DO \$\$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_roles WHERE rolname = '$POSTGRES_USER'
   ) THEN
      CREATE USER $POSTGRES_USER WITH PASSWORD '$POSTGRES_PASSWORD';
   END IF;
END
\$\$;

-- Create DB if not exists
DO \$\$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_database WHERE datname = '$POSTGRES_DB'
   ) THEN
      CREATE DATABASE $POSTGRES_DB OWNER $POSTGRES_USER;
   END IF;
END
\$\$;

GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO $POSTGRES_USER;
EOF

ok "Database and user configured"

# ===============================
# Final output
# ===============================
ok "PostgreSQL setup complete"

echo "--------------------------------------"
echo "Database : $POSTGRES_DB"
echo "User     : $POSTGRES_USER"
echo "Host     : localhost"
echo "Port     : 5432"
echo "--------------------------------------"

ok "Done ✅"