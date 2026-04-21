#!/bin/bash
# ~/Dev/init_context.sh

PROJECT_DIR="${1:-.}"
cd "$PROJECT_DIR"

if [ ! -f "CLAUDE.md" ] && [ ! -f "CONTEXT.md" ]; then
  echo "No existe CLAUDE.md ni CONTEXT.md"
  echo "Creando CONTEXT.md vacío..."
  cat > CONTEXT.md << 'EOF'
# Contexto del Proyecto

## Quién soy
César, founder de KraftDo SpA (Machalí, VI Región, Chile).

## Proyecto
Nombre: 
Descripción: 

## Stack
- 

## Estado actual
- 

## Reglas
- Responder siempre en español
EOF
  echo "✓ Edita CONTEXT.md y vuelve a correr el script"
  exit 0
fi

# Si existe CLAUDE.md pero no CONTEXT.md
if [ -f "CLAUDE.md" ] && [ ! -L "CLAUDE.md" ]; then
  cp CLAUDE.md CONTEXT.md
fi

# Crear symlinks
ln -sf CONTEXT.md CLAUDE.md
ln -sf CONTEXT.md GEMINI.md

echo "✓ Listo en $(pwd)"
ls -la CLAUDE.md CONTEXT.md GEMINI.md