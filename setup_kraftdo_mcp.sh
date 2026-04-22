#!/bin/bash
DEV_DIR="/home/cesar/Dev"
VENV_PYTHON="$DEV_DIR/tools/venv/bin/python3"
PYTHON_SERVER="$DEV_DIR/tools/mcp_server.py"

echo "📂 Sincronizando proyectos en ~/Dev..."

# 1. Función para crear el config JSON
create_config() {
    local path=$1
    local is_laravel=$2
    mkdir -p "$path/.gemini"
    
    # Construcción dinámica del JSON
    if [ "$is_laravel" = true ]; then
        cat <<EOF > "$path/.gemini/config.json"
{
  "mcpServers": {
    "laravel-server": { "command": "php", "args": ["artisan", "boost:mcp"] },
    "kraftdo-tools": { "command": "$VENV_PYTHON", "args": ["$PYTHON_SERVER"] }
  }
}
EOF
    else
        cat <<EOF > "$path/.gemini/config.json"
{
  "mcpServers": {
    "kraftdo-tools": { "command": "$VENV_PYTHON", "args": ["$PYTHON_SERVER"] }
  }
}
EOF
    fi
}

# 2. Escaneo de proyectos
find "$DEV_DIR" -maxdepth 2 -type d | while read -r project_path; do
    # Ignorar carpetas ocultas y la carpeta tools
    [[ "$(basename "$project_path")" =~ ^\. ]] && continue
    [[ "$(basename "$project_path")" == "tools" ]] && continue

    # Caso Laravel
    if [ -f "$project_path/artisan" ]; then
        create_config "$project_path" true
        echo "✅ Laravel: $(basename "$project_path")"
    
    # Caso Python (si tiene .py o requirements)
    elif ls "$project_path"/*.py >/dev/null 2>&1 || [ -f "$project_path/requirements.txt" ]; then
        create_config "$project_path" false
        echo "🐍 Python: $(basename "$project_path")"
    fi
done

# Notificación visual (opcional)
notify-send "KraftDo MCP" "Sincronización de proyectos completada" -i terminal