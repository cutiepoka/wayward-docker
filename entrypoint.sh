#!/bin/bash
set -e

echo ">>> Updating Wayward server..."

# Try anonymous login first, fallback to authenticated if needed
if ! timeout 120 /home/steam/steamcmd/steamcmd.sh \
    +force_install_dir /home/steam/wayward-server \
    +login anonymous \
    +app_update 379210 validate \
    +quit; then
    
    echo ">>> Anonymous update failed, trying with Steam credentials..."
    if [[ -z "${STEAM_USER}" || -z "${STEAM_PASS}" ]]; then
        echo "ERROR: Steam credentials required but STEAM_USER or STEAM_PASS not provided"
        exit 1
    fi
    
    /home/steam/steamcmd/steamcmd.sh \
        +force_install_dir /home/steam/wayward-server \
        +login ${STEAM_USER} ${STEAM_PASS} \
        +app_update 379210 validate \
        +quit
fi

echo ">>> Starting Wayward server..."

# Build command line arguments array
# ARGS=("--no-sandbox")

# Server mode is always enabled for dedicated server
ARGS+=("+server")
 
ARGS+=("+savePath" "/home/steam/save")

# Switch options (boolean flags)
if [[ "${allowHardcoreRespawns:-false}" == "true" ]]; then
    ARGS+=("+allowHardcoreRespawns")
fi

if [[ "${backup:-false}" == "true" ]]; then
    ARGS+=("+backup")
fi

if [[ "${console:-true}" == "true" ]]; then
    ARGS+=("+console")
fi

if [[ "${customMilestoneModifiersAllowed:-false}" == "true" ]]; then
    ARGS+=("+customMilestoneModifiersAllowed")
fi

if [[ "${dev:-false}" == "true" ]]; then
    ARGS+=("+dev")
fi

if [[ "${new:-false}" == "true" ]]; then
    ARGS+=("+new")
fi

if [[ "${private:-false}" == "true" ]]; then
    ARGS+=("+private")
fi

if [[ "${pvp:-false}" == "true" ]]; then
    ARGS+=("+pvp")
fi

if [[ "${ssh:-false}" == "true" ]]; then
    ARGS+=("+ssh")
fi

# Value options (only add if specified)
if [[ -n "${backupInterval}" ]]; then
    ARGS+=("+backupInterval" "${backupInterval}")
fi

if [[ -n "${difficulty}" ]]; then
    ARGS+=("+difficulty" "${difficulty}")
fi

if [[ -n "${hardwareAcceleration}" ]]; then
    ARGS+=("+hardwareAcceleration" "${hardwareAcceleration}")
fi

if [[ -n "${maxBackups}" ]]; then
    ARGS+=("+maxBackups" "${maxBackups}")
fi

if [[ -n "${maxPlayers}" ]]; then
    ARGS+=("+maxPlayers" "${maxPlayers}")
fi

if [[ -n "${name}" ]]; then
    ARGS+=("+name" "${name}")
fi

if [[ -n "${port}" ]]; then
    ARGS+=("+port" "${port}")
fi

if [[ -n "${realTimeTickSpeed}" ]]; then
    ARGS+=("+realTimeTickSpeed" "${realTimeTickSpeed}")
fi

if [[ -n "${turnMode}" ]]; then
    ARGS+=("+turnMode" "${turnMode}")
fi

# Optional value options (only add if specified)
if [[ -n "${load}" ]]; then
    ARGS+=("+load" "${load}")
fi

if [[ -n "${milestones}" ]]; then
    ARGS+=("+milestones" "${milestones}")
fi

if [[ -n "${seed}" ]]; then
    ARGS+=("+seed" "${seed}")
fi

if [[ -n "${sshPassword}" ]]; then
    ARGS+=("+sshPassword" "${sshPassword}")
fi

if [[ -n "${sshPort}" ]]; then
    ARGS+=("+sshPort" "${sshPort}")
fi

if [[ -n "${sshUsername}" ]]; then
    ARGS+=("+sshUsername" "${sshUsername}")
fi

echo ">>> Wayward server arguments: ${ARGS[*]}" 

Xvfb :99 -screen 0 1024x768x24 &
export DISPLAY=:99

exec /home/steam/wayward-server/wayward --no-sandbox "${ARGS[@]}"
