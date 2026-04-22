import os
import subprocess
from mcp.server.fastmcp import FastMCP

# 1. Crear el servidor
mcp = FastMCP("kraftdo-tools")

# 2. Skill: Búsqueda Global
@mcp.tool()
def search_code(query: str, path: str = "~/Dev"):
    """Busca una palabra o función en todos los proyectos de la carpeta Dev."""
    expanded_path = os.path.expanduser(path)
    try:
        result = subprocess.run(
            ["grep", "-rniI", query, expanded_path, "--exclude-dir={node_modules,venv,.git,storage}"],
            capture_output=True, text=True, timeout=10
        )
        return result.stdout if result.stdout else "No se encontraron coincidencias."
    except Exception as e:
        return f"Error en la búsqueda: {str(e)}"

# 3. Skill: Stats del ThinkPad
@mcp.tool()
def get_system_stats():
    """Obtiene el estado de carga y memoria del ThinkPad E490."""
    try:
        cpu = subprocess.check_output("top -bn1 | grep 'Cpu(s)'", shell=True).decode()
        mem = subprocess.check_output("free -h", shell=True).decode()
        return f"--- CPU ---\n{cpu}\n--- MEMORIA ---\n{mem}"
    except:
        return "No se pudo obtener la info del sistema."

# 4. Skill: Rutas Laravel
@mcp.tool()
def get_laravel_info(project_path: str):
    """Analiza rutas y modelos de un proyecto Laravel."""
    try:
        routes = subprocess.check_output(f"php {project_path}/artisan route:list --json", shell=True).decode()
        return routes
    except Exception as e:
        return f"Error leyendo proyecto Laravel: {str(e)}"

# 5. Skill: Analizador de Logs
@mcp.tool()
def read_laravel_logs(project_name: str, lines: int = 20):
    """Lee las últimas líneas del log de error de un proyecto Laravel."""
    log_path = f"/home/cesar/Dev/{project_name}/storage/logs/laravel.log"
    try:
        if os.path.exists(log_path):
            result = subprocess.check_output(["tail", "-n", str(lines), log_path]).decode()
            return result
        return f"No se encontró log en {log_path}"
    except Exception as e:
        return f"Error al leer log: {str(e)}"

# --- SIEMPRE AL FINAL ---
if __name__ == "__main__":
    mcp.run()