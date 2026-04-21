# KraftDo Dev Tools

Scripts utiles para devs que trabajan con IAs (Claude, Gemini, etc).

## init_context.sh

Inicializa el contexto de un proyecto para trabajar con Claude Code o Gemini CLI.

Crea un CONTEXT.md con estructura base y genera symlinks automaticamente:
- CLAUDE.md -> CONTEXT.md
- GEMINI.md -> CONTEXT.md

Asi un solo archivo sirve para todas las IAs sin duplicar contenido.

### Uso

    # En el proyecto actual
    ./init_context.sh

    # En otro directorio
    ./init_context.sh ~/Dev/mi-proyecto

### Que hace

Si no existe CONTEXT.md ni CLAUDE.md:
- Crea CONTEXT.md con template base
- Te pide que lo edites antes de continuar

Si ya existe CLAUDE.md (sin symlink):
- Lo copia a CONTEXT.md
- Crea los symlinks

Si ya existe CONTEXT.md:
- Solo crea/actualiza los symlinks

### Instalacion global

    sudo cp init_context.sh /usr/local/bin/init_context
    sudo chmod +x /usr/local/bin/init_context

    # Desde cualquier carpeta:
    init_context
    init_context ~/Dev/mi-proyecto

### Template generado

    # Contexto del Proyecto
    ## Quien soy
    ## Proyecto
    ## Stack
    ## Estado actual
    ## Reglas

---

Parte del ecosistema KraftDo SpA — kraftdo.cl
