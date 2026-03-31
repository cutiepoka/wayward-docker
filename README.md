# Wayward Dedicated Server Docker

A Docker container for running a Wayward dedicated server with full configuration support.

## Quick Start

```bash
docker run -d -p 38740:38740 \
  -v wayward_data:/home/steam/data \
  -e STEAM_USER="your_steam_username" \
  -e STEAM_PASS="your_steam_password" \
  samuelt1/wayward:latest
```

## Configuration

All Wayward server options can be configured through environment variables. Variable names match the exact command-line parameter names found here: https://www.waywardgame.com/multiplayer

### Steam Authentication

- `STEAM_USER` - Steam username (optional - tries anonymous first)
- `STEAM_PASS` - Steam password (optional - tries anonymous first)

### Switch Options (Boolean)

Set to `"true"` to enable, `"false"` or unset to use the default provided by wayward server:

| Variable | Description | Default |
|----------|-------------|---------|
| `allowHardcoreRespawns` | Allows players to respawn in hardcore mode as a new character | `false` |
| `backup` | Enable automated backups to the servers /backups folder | `false` |
| `console` | Starts dedicated server in console only mode (no GUI) | `true` |
| `customMilestoneModifiersAllowed` | Allows players to set their own milestone modifiers when joining | `false` |
| `dev` | Opens Developer Tools on launch | `false` |
| `new` | Creates a new game every launch | `false` |
| `private` | Prevents the server from showing up in the server browser | `false` |
| `pvp` | Enables PVP | `false` |
| `ssh` | Enables SSH | `false` |

### Value Options

These options accept specific values. If not set, Wayward uses its built-in defaults:

| Variable | Description | Example |
|----------|-------------|---------|
| `backupInterval` | Backup interval in minutes | `10` |
| `difficulty` | Game difficulty: `hardcore`, `casual`, `challenge`, `dailychallenge` | `hardcore` |
| `hardwareAcceleration` | Hardware acceleration (0=disabled, 1=enabled) | `1` |
| `maxBackups` | Maximum backups to keep | `24` |
| `maxPlayers` | Maximum players | `32` |
| `name` | Server name | `"My Server"` |
| `port` | Server port | `38740` |
| `realTimeTickSpeed` | Real time tick speed (normal range: 10-80) | `50` |
| `turnMode` | Turn mode: `realtime`, `simulated` | `simulated` |

### Optional Parameters

Only added if the environment variable is set:

| Variable | Description | Example |
|----------|-------------|---------|
| `load` | Game name to load on startup - creates if doesn't exist | `"My World"` |
| `milestones` | Comma-separated string of milestones to load | `"milestone1,milestone2"` |
| `savePath` | Custom save path (defaults to `/home/steam/data/saves`) | `"/custom/path"` |
| `seed` | World generation seed | `123456` |
| `sshPassword` | SSH password | `"secure_password"` |
| `sshPort` | SSH port | `22` |
| `sshUsername` | SSH username | `"admin"` |

## Docker Compose Example

```yaml
version: '3.8'
services:
  wayward:
    image: samuelt1/wayward:latest
    ports:
      - "38740:38740"
    environment:
      - maxPlayers=16
      - difficulty=hardcore
      - pvp=true
      - backup=true
      - backupInterval=15
      - port=38740
    volumes:
      - wayward_data:/home/steam/data
    restart: unless-stopped

volumes:
  wayward_data:
```

## Advanced Configuration

### PVP Server Example
```yaml
environment:
  - pvp=true
  - difficulty=hardcore
  - maxPlayers=32
  - private=false
```

### Private Development Server
```yaml
environment:
  - private=true
  - dev=true
  - maxPlayers=4
  - customMilestoneModifiersAllowed=true
```

### Backup-Enabled Server
```yaml
environment:
  - backup=true
  - backupInterval=10
  - maxBackups=48
```

## Data Persistence

All server data is consolidated into a single volume at `/home/steam/data` which contains:

- `server/` - Wayward server installation files
- `saves/` - Game saves and world data
- `steamcache/` - Steam cache and authentication data

Mount this single volume to persist all your data:

```bash
-v wayward_data:/home/steam/data
```

## Pulling the Image

```bash
docker pull samuelt1/wayward:latest
```

## Troubleshooting

### Common Issues

1. **Server won't start**: Check that the Steam update completed successfully in the logs
2. **Authentication failures**: Verify Steam credentials or try without them (anonymous)
3. **Connection issues**: Ensure the port is properly exposed and not blocked by firewalls

### Logs

View container logs to see server startup and any errors:
```bash
docker logs <container_name>
```

## References

- [Wayward Multiplayer Guide](https://www.waywardgame.com/multiplayer)
- [Wayward Steam Page](https://store.steampowered.com/app/379210/Wayward/)

## License

This Docker configuration is provided as-is. Wayward is a commercial game - you must own it to use this server.
