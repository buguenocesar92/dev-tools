#!/bin/bash
DEV_DIR="/home/cesar/Dev"
VENV_PYTHON="$DEV_DIR/tools/venv/bin/python3"
PYTHON_SERVER="$DEV_DIR/tools/mcp_server.py"

echo "🧹 Limpiando registros antiguos..."
# Borramos registros globales para evitar duplicados
/home/cesar/.npm-global/bin/gemini mcp remove kraftdo-tools --scope user > /dev/null 2>&1

echo "📂 Escaneando y configurando proyectos..."

# 1. Buscar proyectos Laravel
find "$DEV_DIR" -maxdepth 3 -name "artisan" | while read -r artisan_path; do
    PROJECT_PATH=$(dirname "$artisan_path")
    PROJECT_NAME=$(basename "$PROJECT_PATH")
    
    mkdir -p "$PROJECT_PATH/.gemini"
    
    # Creamos el config LOCAL. Gemini leerá esto SOLO cuando estés en esta carpeta.
    cat <<EOF > "$PROJECT_PATH/.gemini/config.json"
{
  "mcpServers": {
    "laravel-server": {
      "command": "php",
      "args": ["artisan", "boost:mcp"]
    },
    "kraftdo-tools": {
      "command": "$VENV_PYTHON",
      "args": ["$PYTHON_SERVER"]
    }
  }
}
EOF
    echo "✅ Configurado localmente: $PROJECT_NAME"
done