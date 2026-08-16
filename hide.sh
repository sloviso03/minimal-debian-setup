#!/usr/bin/env bash

hide_app() {
    local app_name="$1"
    local sys_desktop="/usr/share/applications/${app_name}.desktop"
    local user_dir="$HOME/.local/share/applications"

    if [ -f "$sys_desktop" ]; then
        mkdir -p "$user_dir"
        cp "$sys_desktop" "$user_dir/"

        if grep -q "NoDisplay=" "$user_dir/${app_name}.desktop"; then
            sed -i 's/NoDisplay=.*/NoDisplay=true/' "$user_dir/${app_name}.desktop"
        else
            echo "NoDisplay=true" >> "$user_dir/${app_name}.desktop"
        fi
    fi
}

for file in /usr/share/applications/kcm_*.desktop /usr/share/applications/okularApplication_*.desktop /usr/share/applications/org.kde.kdeconnect*.desktop; do
    [ -f "$file" ] || continue
    app_base=$(basename "$file" .desktop)
    hide_app "$app_base"
done

APPS_TO_HIDE=(
    "qt5ct"
    "qt6ct"
    "org.pulseaudio.pavucontrol"
    "nm-connection-editor"
    "blueman-manager"
    "micro"

    # --- Herramientas secundarias / duplicadas ---
    "footclient"
    "foot-server"
    "code-url-handler"
    "blueman-adapters"
    "vim"
    "python3.13"
    "breezestyleconfig"
    "kdesystemsettings"
    "systemsettings"
    "kwalletmanager5-kwalletd"
    "kwincompositing"
    "ktelnetservice6"
    "org.freedesktop.impl.portal.desktop.kde"
    "org.kde.drkonqi"
    "org.kde.drkonqi.coredump.gui"
    "org.kde.kcolorschemeeditor"
    "org.kde.kded6"
    "org.kde.keditbookmarks"
    "org.kde.keditfiletype"
    "org.kde.kfontinst"
    "org.kde.kfontview"
    "org.kde.kiod6"
    "org.kde.klipper"
    "org.kde.ksshaskpass"
    "org.kde.kwalletd6"
    "org.kde.kwalletmanager"
    "org.kde.kwin.killer"
    "org.kde.plasma-fallback-session-save"
    "org.kde.plasma.settings.open"
    "org.kde.plasmashell"
    "org.kde.plasmawindowed"
    "org.kde.polkit-kde-authentication-agent-1"
    "org.kde.xwaylandvideobridge"
    "google-maps-geo-handler"
    "openstreetmap-geo-handler"
    "wheelmap-geo-handler"
    "gcr-prompter"
    "gcr-viewer"
    "org.freedesktop.Xwayland"
    "notification-daemon"
    "xdg-desktop-portal-gtk"
    "groovyConsole"
    "ranger"
)

for app in "${APPS_TO_HIDE[@]}"; do
    hide_app "$app"
done
