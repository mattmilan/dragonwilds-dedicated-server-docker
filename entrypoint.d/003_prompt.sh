SERVER_ENV_VARS=("OWNER_ID" "ADMIN_PASSWORD" "SERVER_NAME" "DEFAULT_WORLD_NAME" "WORLD_PASSWORD")
PROTECTED_VARS="PASS|TOKEN|SECRET"
SERVER_ENV_FILE="/config/server.env"
SERVER_KEY_FILE="/config/.envkey"

# Generate encryption key if missing
if [ ! -f "$SERVER_KEY_FILE" ]; then
    echo "🔑 Generating encryption key..."
    openssl rand -base64 32 > "$SERVER_KEY_FILE"
    chmod 600 "$SERVER_KEY_FILE"
fi
ENCRYPTION_KEY=$(cat "$SERVER_KEY_FILE")

# Function to encrypt sensitive values
encrypt_value() {
    echo -n "$1" | openssl enc -aes-256-cbc -a -salt -pbkdf2 -pass pass:"$ENCRYPTION_KEY"
}

# Function to decrypt sensitive values
decrypt_value() {
    echo -n "$1" | openssl enc -aes-256-cbc -a -d -pbkdf2 -pass pass:"$ENCRYPTION_KEY"
}


# Auto-load existing env file if present
if [ -f "$SERVER_ENV_FILE" ]; then
    echo "📄 Loading environment variables from $SERVER_ENV_FILE"
    while IFS='=' read -r key value; do
        # if [[ "$key" =~ PASS|SECRET|TOKEN ]]; then # Regex Comparison
        if [[ "$key" =~ PASS|SECRET|TOKEN ]]; then   # Blacklist
            export "$key"="$(decrypt_value "$value")"
        else
            export "$key"="$value"
        fi
    done < "$SERVER_ENV_FILE"
fi

# If running detached and missing vars → fail fast
if [ ! -t 0 ]; then
    for VAR in "${SERVER_ENV_VARS[@]}"; do
        if [ -z "${!VAR}" ]; then
            echo "❌ Missing required environment variables."
            echo "Please run without '-d' and provide variables interactively first."
            exit 1
        fi
    done
fi

# Interactive mode: prompt for missing vars
for VAR in "${SERVER_ENV_VARS[@]}"; do
    if [ -z "${!VAR}" ]; then
        if [[ "$VAR" =~ PASS|SECRET|TOKEN ]]; then
            read -s -p "Enter value for $VAR (hidden): " VALUE
            echo
        else
            read -p "Enter value for $VAR: " VALUE
        fi
        export "$VAR"="$VALUE"
    fi
done

# Save all vars to server.env (overwrite each time)
mkdir -p "$(dirname "$SERVER_ENV_FILE")"
> "$SERVER_ENV_FILE"
for VAR in "${SERVER_ENV_VARS[@]}"; do
    if [[ "$VAR" =~ PASS|SECRET|TOKEN ]]; then
        echo "$VAR=$(encrypt_value "${!VAR}")" >> "$SERVER_ENV_FILE"
    else
        echo "$VAR=${!VAR}" >> "$SERVER_ENV_FILE"
    fi
done

echo "✅ Environment variables saved (sensitive values encrypted) to $SERVER_ENV_FILE"
# exec "$@"
