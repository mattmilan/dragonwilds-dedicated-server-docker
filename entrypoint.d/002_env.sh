# --- ENVIRONMENT VARIABLES ---
APPID=4019830
SERVERDIR="${SERVERDIR:-/home/ubuntu/Steam}"
CONFIGFILE="$SERVERDIR/RSDragonwilds/Saved/Config/LinuxServer/DedicatedServer.ini"
BACKUPDIR="$SERVERDIR/backup"
LOGFILE="$SERVERDIR/RSDragonwilds/Saved/Logs/entrypoint.log"
LAST_ACTIVITY_FILE="$SERVERDIR/.last_activity"
PLAYER_COUNT_FILE="$SERVERDIR/.player_count"
SERVER_RESTART_FILE="$SERVERDIR/.server_restart"
LAST_BACKUP_DATE_FILE="$SERVERDIR/.last_backup_date"
LAST_APPLIED_BUILD_FILE="$SERVERDIR/.last_applied_build"
UPDATE_IN_PROGRESS_FILE="$SERVERDIR/.update_in_progress"
BACKUP_IN_PROGRESS_FILE="$SERVERDIR/.backup_in_progress"
SERVER_PORT="${SERVER_PORT:-7777}"
ENABLE_AUTO_UPDATE="${ENABLE_AUTO_UPDATE:-true}"
UPDATE_TIME="${UPDATE_TIME:-3600}"              # How often (seconds) to check for updates (e.g. 3600 = every hour)
ENABLE_DISCORD_NOTIF="${ENABLE_DISCORD_NOTIF:-false}"
DISCORD_WEBHOOK_URL="${DISCORD_WEBHOOK_URL:-}"
IDLE_WAIT="${IDLE_WAIT:-360}"
BACKUP_RETENTION_DAYS="${BACKUP_RETENTION_DAYS:-30}"
PLAYER_CHECK_INTERVAL=5
BACKUP_AFTER_UPDATE="${BACKUP_AFTER_UPDATE:-true}"
BACKUP_DAILY="${BACKUP_DAILY:-true}"
BACKUP_TIME="${BACKUP_TIME:-3:00 AM}"           # Time-of-day to run daily backup (12-hour format)
POLL_INTERVAL="${POLL_INTERVAL:-60}"            # How often (seconds) the backup loop checks the schedule

# --- DEDICATEDSERVER.INI CONFIGURATION ---
# ADMIN_PASSWORD="${ADMIN_PASSWORD}"              # Provided
# OWNER_ID="${OWNER_ID}"                          # Required
# SERVER_GUID="${SERVER_GUID}"                    # Provided
# SERVER_NAME="${SERVER_NAME}"                    # Provided
# WORLD_PASSWORD="${WORLD_PASSWORD}"              # Optional
# DEFAULT_WORLD_NAME="${DEFAULT_WORLD_NAME}"      # Provided
