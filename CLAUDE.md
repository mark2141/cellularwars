# Contexto del proyecto: shooter de bio-infiltración (Godot 4, itch.io)

Este archivo resume todo lo decidido hasta el 2026-11-16. Colócalo en la raíz del repositorio como `CLAUDE.md` para que Claude Code lo lea al iniciar.

Cada punto está marcado como **[Decidido]** (lo definió el equipo) o **[Propuesto]** (sugerencia técnica aún sin confirmar). No trates lo propuesto como definitivo: pregunta antes de construir sobre ello.

## Tu rol

Actúa como arquitecto técnico y asistente de desarrollo. Prioriza soluciones limpias, modulares y reutilizables, sobre todo para las 36 variantes de enemigos y las fases de los jefes. Evita duplicar código y escenas: los datos van en recursos, no en copias.

## 1. Concepto [Decidido]

- **Género:** híbrido entre *Space Invaders* (oleadas descendentes en formación, barreras destructibles, ritmo táctico) y *bullet hell* accesible (patrones geométricos que siempre dejan pasillos visibles; sin saturación extrema).
- **Modo Precisión (*Focus*):** reduce la velocidad de la nave y muestra su *hitbox* central exacta.
- **Sistema de *Graze*:** pasar cerca de proyectiles sin recibir daño carga una barra de habilidad especial (bomba limpia-pantalla o láser cargado; falta elegir).
- **Temática:** invasión microscópica. El jugador controla un nanobot médico (o leucocito modificado) que recorre el torrente sanguíneo y los órganos de un organismo infectado.
- **Estética:** tonos biológicos profundos (rojos venosos, púrpuras, azules oscuros) con proyectiles bioluminiscentes (esporas, espinas celulares, descargas nerviosas).
- **Plataforma de lanzamiento:** itch.io.

## 2. Tecnología [Decidido]

- **Motor:** Godot 4.x con el renderizador **Compatibility**, para exportar a web (HTML5).
- **Datos:** escenas base heredables (`.tscn`) y recursos personalizados (`.tres`) que inyectan estadísticas y patrones.
- **Equipo:** 2 personas, con **Git**. Trabajo dividido por escenas y scripts independientes para evitar conflictos de fusión.
- **Lenguaje:** GDScript **[Propuesto]** (es la opción segura para exportar a web).

## 3. Reparto de trabajo [Decidido]

Objetivo: cero gastos extra en servicios.

**Lo genera el equipo con Gemini Pro y Flow:**

- Ilustraciones de los 4 jefes y sus segundas fases.
- Diseños base de los 12 enemigos.
- Fondos de los 7 niveles.
- Cinemáticas y tráiler.

**Lo hace Claude:**

1. **Procesamiento de assets:** scripts (Python) para quitar fondos sólidos, recortar, escalar y empaquetar sprite sheets.
2. **Gráficos vectoriales (SVG):** toda la interfaz (HUD, barras de vida, iconos, menús) y los proyectiles.
3. **Código y animación procedural:** lógica del juego, partículas (explosiones, propulsores), shaders de impacto y escudo, y animaciones por código para evitar dibujar fotogramas.

## 4. Campaña [Decidido]

7 niveles y 4 jefes. Los tres primeros jefes se enfrentan dos veces.

| Nivel | Tramo | Jefe |
|---|---|---|
| 1 | Infiltración inicial | El Centinela Linfático |
| 2 | Infiltración inicial | El Pulmón Necrótico |
| 3 | Infiltración inicial | La Neurona Corrupta |
| 4 | Shock séptico | El Centinela Linfático (mutado) |
| 5 | Shock séptico | El Pulmón Necrótico (mutado) |
| 6 | Shock séptico | La Neurona Corrupta (mutada) |
| 7 | El Núcleo / Corazón Cero | El Parásito Primordial (3 fases) |

En los niveles 4 a 6 los jefes regresan con patrones evolucionados y mayor densidad de balas.

### Jefes

1. **El Centinela Linfático:** nódulo con placas óseas y escudos retráctiles. Dispara abanicos en cruz y ondas expansivas.
2. **El Pulmón Necrótico:** estructura alveolar que inhala (succiona al jugador) y exhala muros de esporas tóxicas con huecos exactos.
3. **La Neurona Corrupta:** núcleo con dendritas eléctricas. Lanza pulsos circulares, rayos en zigzag y muros de balas con ranuras.
4. **El Parásito Primordial:** jefe final con anclajes mecánicos y mutación libre. Combina las mecánicas de los tres anteriores.

## 5. Bestiario [Decidido]

12 arquetipos × 3 rangos = 36 variantes.

- **Regular:** básico.
- **Reforzada:** blindaje extra y abanicos estrechos.
- **Élite:** bioluminiscencia agresiva y patrones danmaku moderados.

| # | Arquetipo | Categoría | Rol táctico de la categoría |
|---|---|---|---|
| 1 | Bacteriófago Menor | Enjambre base | Formaciones clásicas, movimiento oscilante, disparos guiados lentos |
| 2 | Espora Cíclica | Enjambre base | |
| 3 | Leucocito Zombi | Enjambre base | |
| 4 | Gusano Capilar | Asalto e intermedios | Cuerpos segmentados, escudos temporales, tanques con ondas circulares |
| 5 | Mitocondria Parásita | Asalto e intermedios | |
| 6 | Ameba Acorazada | Asalto e intermedios | |
| 7 | Cangrejo Plaquetario | Artillería y tácticos | Morteros parabólicos, kamikazes con ácido, láseres verticales |
| 8 | Vesícula Explosiva | Artillería y tácticos | |
| 9 | Medusa Venenosa | Artillería y tácticos | |
| 10 | Flagelado de Asalto | Épicos y cierre | Estelas de proyectiles, invocación de refuerzos, torretas de espirales |
| 11 | Célula Nodriza | Épicos y cierre | |
| 12 | Núcleo de Fibrosis | Épicos y cierre | |

### Aparición por nivel [Propuesto]

Solo el nivel 1 está decidido (arquetipos 1 a 3, rango Regular). El resto es una propuesta.

| Nivel | Arquetipos nuevos | Rangos presentes |
|---|---|---|
| 1 | 1–3 | Regular |
| 2 | 4–5 | Regular |
| 3 | 6–7 | Regular, primeras reforzadas |
| 4 | 8–9 | Regular y reforzada |
| 5 | 10–11 | Reforzada, primeras élite |
| 6 | 12 | Reforzada y élite |
| 7 | Ninguno | Élite, mezcla de todo |

## 6. Nivel 1 [Decidido]

Curva introductoria de unos 8 minutos. Enemigos: Bacteriófago Menor, Espora Cíclica y Leucocito Zombi, en rango Regular.

| Tiempo | Contenido |
|---|---|
| 0:00 – 1:30 | Calentamiento sin disparos enemigos, para aprender el movimiento y la *hitbox* |
| 1:30 – 3:00 | Entran las Esporas Cíclicas y los primeros proyectiles lentos y espaciados |
| 3:00 – 5:00 | Leucocitos Zombis por los flancos, zigzag clásico y primeros *power-ups* |
| 5:00 – 6:30 | Oleada de desgaste en cascada diagonal |
| 6:30 – 8:00 | Combate de dos fases contra El Centinela Linfático (encuentro 1) |

## 7. Arquitectura [Propuesto]

### Enemigos

Una sola escena `Enemy.tscn` configurada con dos recursos. El spawner llama a `enemy.setup(data, tier)`.

```gdscript
# enemy_data.gd — uno por arquetipo (12 archivos .tres)
class_name EnemyData extends Resource
@export var sprite: Texture2D
@export var max_hp: int
@export var speed: float
@export var movement: MovementPattern
@export var pattern_regular: BulletPattern
@export var pattern_reforzada: BulletPattern
@export var pattern_elite: BulletPattern

# tier_data.gd — 3 archivos: regular, reforzada, elite
class_name TierData extends Resource
@export var hp_mult := 1.0
@export var speed_mult := 1.0
@export var palette: Gradient      # recoloreado por shader
@export var glow_strength := 0.0
```

- El rango cambia el patrón de disparo, no solo los multiplicadores: por eso `EnemyData` tiene tres ranuras de patrón.
- El color del rango se aplica con un **shader de paleta** en tiempo real. No se generan 36 PNG recoloreados.
- Los 12 arquetipos tienen comportamientos distintos (cuerpos segmentados, morteros, kamikazes, láseres, invocación). Los comportamientos especiales van como scripts o componentes aparte, no dentro de `Enemy.gd`.

### Balas

- Un `BulletManager` central mueve y dibuja los proyectiles desde arrays. No se usa una escena `Area2D` por bala: habrá cientos a la vez y el objetivo es web.
- El *graze* es una segunda comprobación de distancia con un radio mayor que el de la *hitbox*.
- Los patrones son recursos `BulletPattern` (abanico, anillo, espiral, muro con huecos) reutilizables por enemigos y jefes.

### Jefes

- Un `Boss.tscn` base con una lista de recursos `BossPhase` (umbral de vida, patrones, sprite).
- La revancha es el mismo jefe con fases añadidas, no un jefe rehecho.
- Los efectos especiales son módulos reutilizables. Ejemplo: la succión del Pulmón Necrótico es un campo de fuerza sobre el jugador, que el jefe final también usa.

### Niveles

- Una única `Level.tscn`. Cada nivel es un recurso con su fondo, su jefe y una lista de eventos de oleada por marca de tiempo (qué arquetipo, qué rango, qué formación, en qué segundo).
- Las formaciones tipo Space Invaders son un recurso `FormationData` (rejilla, oscilación, descenso), separado del movimiento individual.
- Las barreras destructibles son una escena propia con daño por celdas.

### Componentes compartidos

`HealthComponent`, `HitboxComponent` y `WeaponComponent`, usados por jugador, enemigos y jefes.

### Ajustes por el renderizador Compatibility

- Partículas con `CPUParticles2D`.
- Brillo bioluminiscente con mezcla aditiva y halo en el propio sprite, sin posprocesado.
- Los SVG se rasterizan al importarlos; hay que fijar la escala de importación según la resolución base.

### Resolución [Propuesto, sin confirmar]

Campo de juego vertical de 720×960 centrado en una ventana de 1280×960, con el HUD en los laterales.

## 8. Especificación de assets generados [Propuesto]

- Fondo sólido **verde puro** (no magenta: choca con la paleta de rojos y púrpuras).
- Vista cenital y misma orientación en todos los enemigos.
- Una criatura por imagen, centrada y con margen.
- Colores de detalle en una zona definida, para que el shader de paleta tenga qué recolorear.
- Fondos de nivel repetibles en vertical, o más altos que la pantalla.
- Un prompt de estilo fijo, reutilizado en todas las imágenes, para mantener coherencia.

## 9. Hoja de ruta [Propuesto]

| Fase | Semanas | Resultado |
|---|---|---|
| 0. Preproducción | 1–2 | Documento de diseño, estilo visual, controles y lista de arquetipos |
| 1. Prototipo | 2–3 | Jugador, disparo, 3 enemigos y un nivel con gráficos provisionales |
| 2. Nivel de muestra | 4–6 | Nivel 1 terminado con jefe, rangos, interfaz, sonido y menús; demo en itch.io |
| 3. Producción | 12–16 | Niveles 2–7 en tres tandas (2–3, 4–5, 6–7) |
| 4. Pulido y beta | 4–6 | Balance, pruebas externas, corrección de errores, accesibilidad |
| 5. Lanzamiento | 2 | Página de itch.io con tráiler y capturas; parche de la primera semana |

Total: 25–35 semanas. Es una estimación para un equipo pequeño a tiempo parcial; las horas reales del equipo no están definidas.

### Riesgos de alcance

- Los 12 arquetipos son el mayor costo del proyecto, más que los jefes. Construirlos en el orden del bestiario y dejar los cuatro «Épicos» para el final.
- Siete niveles de 8 minutos son casi una hora de oleadas diseñadas a mano. Si el plazo aprieta, acortar los niveles 4–6 a 5–6 minutos.
- Orden de recorte: primero el comportamiento extra de élite, luego reducir arquetipos, y solo al final tocar los jefes.

## 10. Orden de trabajo [Propuesto]

1. Esqueleto del proyecto: carpetas, `.gitignore` para Godot, resolución, capas de colisión y componentes compartidos.
2. Jugador (con *Focus* y *graze*), `BulletManager` y un enemigo con `EnemyData` + `TierData`, con formas provisionales.
3. Script de procesamiento de assets, cuando exista la primera imagen generada.
4. Shader de paleta e impacto, partículas de explosión y propulsor.
5. HUD en SVG.
6. El Centinela Linfático con el sistema de fases.

## 11. Decisiones pendientes

Pregunta al equipo antes de asumir cualquiera de estas.

**Bloquean el esqueleto**

1. Resolución y formato (confirmar la propuesta de 720×960 en ventana de 1280×960).
2. Plataformas: ¿solo navegador, también Windows, también móvil con control táctil?
3. Controles: ¿teclado, mando? ¿Disparo automático o manteniendo un botón?
4. Lenguaje: confirmar GDScript.

**Sistemas del jugador**

5. Vida y fallo: ¿vidas, barra de salud o un golpe? ¿Continuaciones?
6. Habilidad del *graze*: ¿bomba, láser o a elección?
7. *Power-ups*: tipos y si se conservan entre niveles.
8. Progresión: ¿mejoras permanentes o tienda entre niveles?
9. Puntuación: ¿multiplicador y tabla de récords?
10. Dificultad: ¿una o varias?

**Contenido**

11. Barreras destructibles: ¿en todos los niveles o en tramos concretos?
12. Confirmar la tabla de aparición de arquetipos y rangos.
13. Historia: ¿diálogos o texto entre niveles?
14. Audio: origen de la música y los efectos (no está asignado a nadie).
15. Idioma: ¿español, inglés o ambos?

**Plan**

16. Horas semanales de cada persona y fecha objetivo.
17. Reparto de tareas entre las dos personas.
18. Modelo de venta (gratis, de pago, «paga lo que quieras») y revisión de los términos de uso comercial de Gemini y Flow.
19. ¿Se publica el nivel 1 como demo?

## 12. Forma de trabajar

- Ejecuta Godot desde la terminal para importar, correr escenas y leer errores antes de dar algo por terminado.
- No puedes juzgar si el juego «se siente bien»: pide al equipo que pruebe el movimiento y los patrones, y ajusta con sus comentarios.
- Mantén los valores de balance en archivos `.tres`, no escritos en el código.
- Commits pequeños y por sistema, para facilitar el trabajo de dos personas en Git.
