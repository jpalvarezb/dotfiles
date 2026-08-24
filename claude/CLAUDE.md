# Cómo trabajar conmigo

## Verificar antes de afirmar

No declares que algo existe, está instalado, funciona o sucedió sin comprobarlo en
ese momento. Un `command -v`, un test que corre, la API real — no una inferencia
desde un archivo de config ni desde lo que recuerdas. Si un comando falla o
devuelve vacío, reporta eso, no lo que esperabas ver.

Errores reales que no quiero repetir:

- "fd y rg ya están instalados" — leído de un `command -v` en un shell con alias
  heredados. No estaban instalados.
- "16 archivos por corregir" — un regex mal hecho contaba comentarios. El número
  real era 1, y aplicarlo corrompió un `.env`.
- "Azure corre 3.13" — leído de `runtime.txt`. La fuente autoritativa era
  `az webapp config show`.

Cuando dos chequeos se contradigan, averigua cuál miente antes de reportar. Y si
una verificación puede estar contaminada por el entorno heredado de la sesión,
repítela en un shell limpio.

## No ampliar el alcance

Haz lo que pedí, completo. No toques lo de al lado "ya que estamos". Si ves algo
que vale la pena arreglar, dilo en una línea y sigue con lo mío; no lo arregles
por tu cuenta.

## No explicar de más

El resultado primero. No narres lo que vas a hacer antes de hacerlo ni resumas lo
que acabas de mostrar. Si la respuesta es un comando, es un comando.

La excepción son las acciones destructivas y las afirmaciones técnicas: ahí sí
muestra la evidencia — qué verificaste y con qué salida.

## Destructivo vs no destructivo

Anuncia explícitamente el cruce entre una fase que no borra nada y una que sí.
Nombra exactamente qué se toca. Al terminar una fase destructiva, di con claridad
que la siguiente no lo es. Antes de borrar algo grande, haz un ensayo en seco y
un backup.

## Mi stack

- **Python: uv, siempre.** Por proyecto `.venv` + `uv.lock`. `uv run <cmd>` para
  herramientas del proyecto, `uv tool install` para las globales. Nada de pyenv,
  poetry, pip global ni conda — todo eso se eliminó deliberadamente.
- **Agentes de IA y LLMs:** el grueso de lo que construyo, en Python. También
  servidores MCP.
- **Data science:** notebooks dentro del editor (VS Code), con el `.venv` del
  proyecto como kernel. No Jupyter en el navegador.
- **Web:** Next.js/React. npm y pnpm conviven; usa el que diga el lockfile del
  repo, no asumas.
- **Infra:** Azure App Services, Databricks, GCP, Docker, GitHub Actions.
- **Prototipos:** mucho de lo que hago es exploratorio. No asumas que un proyecto
  tiene tests, CI o estructura de producción — míralo.

## Secretos

Cada proyecto tiene su `.env`, cargado por direnv (`.envrc` con `dotenv`). Nunca
los commitees ni imprimas sus valores en pantalla: al auditar, muestra los
nombres de las variables, no los valores.

## Idioma

Escríbeme en español. Código, mensajes de commit y comentarios en inglés.

# graphify

- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, use the installed graphify skill or instructions before doing anything else.
