# Auth App — Flutter

Aplicación de autenticación con diseño cyberseguridad. Incluye pantalla de **Login** y **Registro** con fondo animado de circuito electrónico y partículas interactivas.

---

## Inicio rápido

```bash
# 1. Clonar el repositorio
git clone https://github.com/Flagelo6482/Arc_facial_Flutter.git
cd Arc_facial_Flutter

# 2. Instalar Flutter y generar archivos de plataforma (solo la primera vez)
setup.bat

# 3. Correr la app
run.bat
```

---

## Flujo de archivos

```
auth_app/
│
├── lib/                          ← Todo el código Dart (lógica + UI)
│   │
│   ├── main.dart                 ← ENTRADA de la app
│   │                               - Inicializa Flutter
│   │                               - Define las rutas: /login y /register
│   │                               - Configura la animación de transición
│   │                                 entre pantallas (slide + fade + scale)
│   │
│   ├── screens/                  ← Pantallas completas (vistas)
│   │   │
│   │   ├── login_screen.dart     ← Pantalla de Inicio de Sesión
│   │   │                           - Campos: Email, Password
│   │   │                           - Checkbox "Remember me"
│   │   │                           - Link "Forgot your password?"
│   │   │                           - Botón Login
│   │   │                           - Navega hacia /register
│   │   │
│   │   └── register_screen.dart  ← Pantalla de Registro
│   │                               - Campos: Name, Email, Password
│   │                               - Botón "Create Account"
│   │                               - Navega hacia /login
│   │
│   └── widgets/                  ← Componentes reutilizables
│       │
│       ├── cyber_background.dart ← CONTENEDOR principal de fondo
│       │                           - Aplica el fondo degradado oscuro
│       │                           - Monta el circuito animado (capa 1)
│       │                           - Monta las partículas (capa 2)
│       │                           - Captura posición del mouse/touch
│       │                           - Contiene el AnimationController (6s loop)
│       │                           - Todas las pantallas lo usan como wrapper
│       │
│       ├── circuit_painter.dart  ← Dibuja el circuito electrónico animado
│       │                           - Usa CustomPainter (sin imágenes)
│       │                           - Genera trazos desde los bordes con
│       │                             ramificación recursiva (profundidad 5)
│       │                           - Señales eléctricas (puntos de luz)
│       │                             viajan por cada trazo
│       │                           - Brillo pulsante individual por trazo
│       │                           - Cachea la geometría para mejor rendimiento
│       │
│       ├── particle_painter.dart ← Sistema de partículas interactivas
│       │                           - 55 partículas flotantes (puntos azules)
│       │                           - Líneas entre partículas cercanas (<115px)
│       │                           - Líneas hacia el cursor del mouse
│       │                           - Repulsión: las partículas se alejan
│       │                             del cursor (radio 110px)
│       │                           - Funciona con mouse (web/desktop)
│       │                             y touch (móvil)
│       │
│       ├── shield_icon.dart      ← Ícono de escudo con efecto glow
│       │                           - Círculo con gradiente azul oscuro
│       │                           - Ícono Icons.security_rounded
│       │                           - BoxShadow para simular brillo externo
│       │
│       ├── cyber_text_field.dart ← Campo de texto estilo cyber
│       │                           - Label superior
│       │                           - Ícono prefijo personalizable
│       │                           - Soporte para modo contraseña
│       │                             (toggle mostrar/ocultar)
│       │                           - Bordes y fondo oscuro con acento azul
│       │
│       └── cyber_button.dart     ← Botón con gradiente azul
│                                   - Gradiente LinearGradient azul
│                                   - BoxShadow con glow
│                                   - Ancho completo (double.infinity)
│
├── setup.bat                     ← Configura el entorno (correr 1 sola vez)
│                                   - Busca Flutter en PATH o en env/
│                                   - Si no existe, lo instala via winget
│                                     o lo descarga en la carpeta env/
│                                   - Ejecuta flutter create para generar
│                                     archivos de plataforma (android/, web/)
│                                   - Ejecuta flutter pub get
│
├── run.bat                       ← Corre la aplicación
│                                   - Detecta Flutter (sistema o env/ local)
│                                   - Menú para elegir dispositivo:
│                                     Chrome, Windows Desktop, Android
│
├── pubspec.yaml                  ← Dependencias del proyecto
│                                   - Solo usa el SDK de Flutter estándar
│                                   - Sin paquetes externos
│
├── analysis_options.yaml         ← Reglas de linting (calidad de código)
│
├── env/                          ← Flutter SDK local (NO se sube al repo)
│                                   - Generado por setup.bat
│                                   - ~700MB, excluido en .gitignore
│
└── .gitignore                    ← Archivos excluidos del repo
                                    - env/, build/, .dart_tool/, etc.
```

---

## Flujo de navegación

```
App inicia
    │
    ▼
/login  (LoginScreen)
    │
    │  tap "Create Account"  →  animación slide desde derecha
    ▼
/register  (RegisterScreen)
    │
    │  tap "Login"  →  animación slide desde izquierda
    ▼
/login  (LoginScreen)
```

---

## Flujo de capas visuales

Cada pantalla está construida en capas apiladas (Stack):

```
┌─────────────────────────────┐
│   SafeArea → Contenido      │  ← Capa 4: UI (formulario, botones)
├─────────────────────────────┤
│   Glow azul superior        │  ← Capa 3: RadialGradient decorativo
├─────────────────────────────┤
│   ParticlePainter           │  ← Capa 2: Partículas + interacción mouse
├─────────────────────────────┤
│   CircuitPainter            │  ← Capa 1: Circuito electrónico animado
├─────────────────────────────┤
│   Fondo degradado oscuro    │  ← Capa 0: Background base (#050510 → #080818)
└─────────────────────────────┘
```

---

## Stack técnico

| Elemento | Tecnología |
|---|---|
| Framework | Flutter 3.24.3 |
| Lenguaje | Dart 3 |
| Animaciones | `AnimationController` + `CustomPainter` |
| Interacción mouse | `MouseRegion` (web/desktop) |
| Interacción touch | `GestureDetector` (móvil) |
| Gráficos | `Canvas` API — sin imágenes ni assets externos |
| Navegación | `Navigator` con `PageRouteBuilder` personalizado |
| Paquetes externos | Ninguno |
