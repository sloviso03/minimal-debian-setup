# argentOs-script

Script de post-instalación para dejar Debian configurado con sway como entorno de escritorio (window manager), con un set de configuraciones y aplicaciones predefinidas (alacritty, waybar, ranger, micro, fastfetch, entre otras).

---

## Español

### 1. Requisitos previos

- Un pendrive USB
- Descargar la imagen ISO de Debian desde https://www.debian.org/

### 2. Grabar la ISO en el pendrive

Grabar la ISO descargada en el pendrive usando la herramienta de tu preferencia (balenaEtcher, Rufus, dd, etc).

### 3. Instalación de Debian

Bootear desde el pendrive y seguir los pasos normales del instalador de Debian.

Cuando llegue el paso de selección de software (desktop environment), es importante:

1. Desmarcar todas las opciones que vienen tildadas por defecto (esto incluye GNOME y "Debian desktop environment").
2. Dejar marcadas únicamente esta opción:
   - Standard system utilities

Esto evita instalar un entorno gráfico que no se va a usar, ya que el entorno gráfico (sway) lo instala el script más adelante.

Continuar con la instalación hasta que finalice y reiniciar el equipo.

### 4. Primer arranque

Al reiniciar, vas a tener una terminal sin entorno gráfico. Seguir estos pasos:

```
# Iniciar sesión con el usuario creado durante la instalación
login: tu-usuario

# Pasar a usuario root
su -

# Instalar sudo y git
apt install sudo git

# Agregar tu usuario al grupo sudo
sudo usermod -aG sudo tu-usuario

# Salir de la sesión de root
exit

# Cerrar la sesión para que el cambio de grupo tome efecto
exit
```

### 5. Ejecutar el script

Iniciar sesión nuevamente con tu usuario y ejecutar:

```
git clone https://github.com/sloviso03/argentOs-script
cd argentOs-script
sudo chmod +x main.sh
./main.sh
```

El script va a instalar todas las dependencias necesarias y copiar las configuraciones a tu carpeta `~/.config`.

###  6. Reiniciar

### 7. Cambiar el tema del login (SDDM)

Para configurar y cambiar el tema de la pantalla de inicio de sesión de SDDM, podés revisar los temas disponibles en:

https://github.com/Darkkal44/qylock

Ahí se pueden ver capturas, nombres y diferentes estilos de los temas disponibles.

Una vez elegido el tema, editar el archivo:

```
/etc/sddm.conf.d/theme.conf
```

y reemplazar el nombre del tema actual por el nombre del tema que quieras usar.
