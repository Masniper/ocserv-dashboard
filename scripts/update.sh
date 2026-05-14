#!/bin/bash
# ==============================================================
# Script: update.sh
# Description:
#   One-shot in-place upgrade for an existing standalone systemd
#   installation of the Ocserv dashboard. This script is not wired into Docker;
#   for Docker deployments use image rebuild and container restart (e.g. compose).
#   Backs up PostgreSQL (pg_dump),
#   pulls the latest code, rebuilds the Go backend services, rebuilds and
#   redeploys the Vite frontend, and restarts the systemd units.
#
# Why this script exists:
#   Running only systemd_backend.sh after a git pull leaves the
#   browser-served frontend bundle stale, so newly added settings
#   fields (e.g. Telegram bot_token, support_username) never
#   appear in the panel even though the API exposes them. This
#   script makes "update" a single, reliable command.
#
# Usage:
#   sudo ./scripts/update.sh
#
# Optional (from .env or environment):
#   DB_BACKUP_DIR   — dump directory (default: /var/backups/ocserv-dashboard)
#   SKIP_DB_BACKUP  — set to 1 to skip pg_dump
# ==============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${ROOT_DIR}"

# lib.sh applies `set -euo pipefail` and provides log/ok/warn/die helpers.
# shellcheck source=/dev/null
source ./scripts/lib.sh

ensure_root() {
    if [[ "$EUID" -ne 0 ]] && ! sudo -n true 2>/dev/null; then
        die "❌ This script needs sudo. Re-run with: sudo $0"
    fi
}

ensure_root

# Load environment so backend/UI scripts pick up POSTGRES_*, LANGUAGES, etc.
if [[ -f "${ROOT_DIR}/.env" ]]; then
    log "Loading environment from .env"
    set -o allexport
    # shellcheck disable=SC1091
    source "${ROOT_DIR}/.env"
    set +o allexport
else
    warn ".env not found at ${ROOT_DIR}/.env — proceeding with system defaults"
fi

backup_database_before_update() {
    if [[ "${SKIP_DB_BACKUP:-}" == "1" ]]; then
        warn "Skipping database backup (SKIP_DB_BACKUP=1)."
        return 0
    fi
    if [[ -z "${POSTGRES_USER:-}" || -z "${POSTGRES_DB:-}" ]]; then
        warn "POSTGRES_USER or POSTGRES_DB not set; skipping database backup."
        return 0
    fi
    if ! command -v pg_dump >/dev/null 2>&1; then
        die "pg_dump not found. Install postgresql-client (e.g. apt install postgresql-client) or set SKIP_DB_BACKUP=1."
    fi

    local host port backup_dir ts outfile
    host="${POSTGRES_HOST:-localhost}"
    port="${POSTGRES_PORT:-5432}"
    backup_dir="${DB_BACKUP_DIR:-/var/backups/ocserv-dashboard}"
    ts="$(date +%Y%m%d-%H%M%S)"
    outfile="${backup_dir}/${POSTGRES_DB}-${ts}.dump"

    log "Backing up PostgreSQL (${POSTGRES_DB} @ ${host}:${port}) → ${outfile}"
    mkdir -p "${backup_dir}"
    PGPASSWORD="${POSTGRES_PASSWORD:-}" pg_dump \
        -h "${host}" \
        -p "${port}" \
        -U "${POSTGRES_USER}" \
        -d "${POSTGRES_DB}" \
        -Fc \
        -f "${outfile}"
    chmod 600 "${outfile}"
    ok "Database backup complete"
}

backup_database_before_update

# 1) Pull the latest source. Try fork/master first (developer setup), then
#    origin/master, then just `git pull` (whatever the current branch tracks).
log "Pulling latest changes..."
if git remote get-url fork >/dev/null 2>&1; then
    git fetch --quiet fork && git pull --ff-only fork master || \
        git pull --ff-only fork "$(git rev-parse --abbrev-ref HEAD)"
elif git remote get-url origin >/dev/null 2>&1; then
    git fetch --quiet origin && git pull --ff-only origin "$(git rev-parse --abbrev-ref HEAD)"
else
    git pull --ff-only
fi
ok "Source up to date"

# 2) Rebuild and (re)install Go services (api, log_stream, user_expiry, telegram_bot)
log "Rebuilding backend services..."
./scripts/systemd_backend.sh
ok "Backend rebuilt"

# 3) Rebuild frontend bundle and deploy to /var/www/site
log "Rebuilding frontend..."
./scripts/systemd_ui.sh
ok "Frontend redeployed"

# 4) Bounce the Go services so they pick up the new binaries. Nginx is already
#    reloaded inside systemd_ui.sh.
SERVICES=(api log_stream user_expiry telegram_bot)
for svc in "${SERVICES[@]}"; do
    if systemctl list-unit-files | grep -q "^${svc}.service"; then
        log "Restarting ${svc}.service"
        sudo systemctl restart "${svc}.service" || warn "failed to restart ${svc}"
    fi
done

ok "Update completed successfully."
HOST_HINT="${HOST:-<your-host>}"
print_message highlight "🌐 Frontend served at https://${HOST_HINT}:3443"
print_message highlight "💡 Hard-refresh the panel (Ctrl+Shift+R) to drop any cached bundle."
