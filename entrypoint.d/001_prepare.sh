# --- DROP PRIVILEGES ---
# If running as root, match the ubuntu user's UID/GID to the volume owner
# so the server process can read/write the mounted directory without the
# host user needing to chmod or chown anything.
if [ "$(id -u)" = "0" ]; then
    VOLUME_UID=$(stat -c '%u' "${SERVERDIR:-/home/ubuntu/Steam}" 2>/dev/null || echo "1000")
    VOLUME_GID=$(stat -c '%g' "${SERVERDIR:-/home/ubuntu/Steam}" 2>/dev/null || echo "1000")
    # If the volume is owned by root (e.g. not yet mounted / empty), fall back to 1000
    if [ "$VOLUME_UID" = "0" ]; then
        VOLUME_UID=1000
        VOLUME_GID=1000
    fi
    groupmod -g "$VOLUME_GID" ubuntu 2>/dev/null || true
    usermod  -u "$VOLUME_UID" ubuntu 2>/dev/null || true
    # Only chown internal dirs — do NOT recurse into the bind-mounted volume
    chown ubuntu:ubuntu /home/ubuntu
    chown -R ubuntu:ubuntu /home/ubuntu/steamcmd
    exec gosu ubuntu "$0" "$@"
fi
