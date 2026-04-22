#!/bin/bash
DEV_DIR="/home/cesar/Dev"
VENV_PYTHON="$DEV_DIR/tools/venv/bin/python3"
PYTHON_TOOLS_SERVER="$DEV_DIR/tools/mcp_server.py"

echo "📂 Escaneando proyectos (Laravel y Python)..."

# --- DETECCIÓN DE LARAVEL ---
find "$DEV_DIR" -maxdepth 3 -name "artisan" | while read -r artisan_path; do
    PROJECT_PATH=$(dirname "$artisan_path")
    mkdir -p "$PROJECT_PATH/.gemini"
    cat <<EOF > "$PROJECT_PATH/.gemini/config.json"
{
  "mcpServers": {
    "laravel-server": { "command": "php", "args": ["artisan", "boost:mcp"] },
    "kraftdo-tools": { "command": "$VENV_PYTHON", "args": ["$PYTHON_TOOLS_SERVER"] }
  }
}
EOF
    echo "✅ Laravel detectado: $(basename "$PROJECT_PATH")"
done

# --- DETECCIÓN DE PYTHON (Ej: sistema-universal) ---
# Buscamos carpetas que tengan requirements.txt o archivos .py y NO sean carpetas de sistema
find "$DEV_DIR" -maxdepth 2 -type d ! -name "tools" ! -name "venv" | while read -r py_path; do
    # Si tiene un archivo .py o requirements.txt, lo tratamos como proyecto Python
    if ls "$py_path"/*.py >/dev/null 2>&1 || [ -f "$py_path/requirements.txt" ]; then
        # Evitar sobreescribir si ya lo hizo Laravel
        if [ ! -f "$py_path/.gemini/config.json" ]; then
            mkdir -p "$py_path/.gemini"
            cat <<EOF > "$py_path/.gemini/config.json"
{
  "mcpServers": {
    "kraftdo-tools": { "command": "$VENV_PYTHON", "args": ["$PYTHON_TOOLS_SERVER"] }
  }
}
EOF
            echo "🐍 Python detectado: $(basename "$py_path")"
        fi
    fi
done