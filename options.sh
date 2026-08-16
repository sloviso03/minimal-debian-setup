#!/usr/bin/env bash

declare -A LENGUAJES_MAP=(
    ["C / C++"]="build-essential clang clangd cmake ninja-build gdb lldb valgrind"
    ["Rust"]="rustc cargo rust-analyzer"
    ["C# / .NET"]="csharp"
    ["Go"]="golang gopls"
    ["Node.js"]="nodejs npm"
    ["Python"]="python3 python3-pip python3-venv"
    ["Java"]="default-jdk maven gradle"
    ["PHP"]="php composer"
    ["Ruby"]="ruby-full"
    ["Lua"]="lua5.4 luarocks"
    ["Perl"]="perl"
    ["Haskell"]="ghc cabal-install"
)

OPCIONES=(
    "C / C++"
    "Rust"
    "C# / .NET"
    "Go"
    "Node.js"
    "Python"
    "Java"
    "PHP"
    "Ruby"
    "Lua"
    "Perl"
    "Haskell"
)

ELEGIDOS=()


mostrarMenu() {
    clear

    for i in "${!OPCIONES[@]}"; do
        local lenguaje="${OPCIONES[$i]}"
        local estado=" "

        if [[ " ${ELEGIDOS[*]} " =~ " ${lenguaje} " ]]; then
            estado="*"
        fi

        printf "%2d. [%c] %s\n" "$((i+1))" "$estado" "$lenguaje"
    done

    echo ""
    printf "%2d. Seleccionar TODOS\n" "$(( ${#OPCIONES[@]} + 1 ))"
    printf "%2d. Limpiar selección\n" "$(( ${#OPCIONES[@]} + 2 ))"
    printf "%2d. Confirmar e instalar\n" "$(( ${#OPCIONES[@]} + 3 ))"
    printf "%2d. Salir\n" "$(( ${#OPCIONES[@]} + 4 ))"
    echo ""
}


ejecutarInstalacion() {

    if [ ${#ELEGIDOS[@]} -eq 0 ]; then
        echo "No seleccionaste nada."
        exit 0
    fi

    sudo apt update

    PAQUETES=()

    for lenguaje in "${ELEGIDOS[@]}"; do
        for paquete in ${LENGUAJES_MAP[$lenguaje]}; do
            if [[ "$paquete" == "csharp" ]]; then
                bash "$(dirname "$0")/c-sharp.sh"
            else
                PAQUETES+=("$paquete")
            fi
        done
    done

    sudo apt install -y "${PAQUETES[@]}"

    echo ""
    echo "Instalación terminada."
}


main() {

    total=${#OPCIONES[@]}

    todos=$((total+1))
    limpiar=$((total+2))
    confirmar=$((total+3))
    salir=$((total+4))


    while true; do

        mostrarMenu

        read -p "Elegí una opción: " entrada


        if [[ "$entrada" == "$salir" ]]; then
            exit 0

        elif [[ "$entrada" == "$confirmar" ]]; then
            break

        elif [[ "$entrada" == "$todos" ]]; then
            ELEGIDOS=("${OPCIONES[@]}")

        elif [[ "$entrada" == "$limpiar" ]]; then
            ELEGIDOS=()

        elif [[ "$entrada" -gt 0 && "$entrada" -le "$total" ]] 2>/dev/null; then

            seleccion=${OPCIONES[$((entrada-1))]}

            if [[ " ${ELEGIDOS[*]} " =~ " ${seleccion} " ]]; then

                NUEVOS=()

                for item in "${ELEGIDOS[@]}"; do
                    if [[ "$item" != "$seleccion" ]]; then
                        NUEVOS+=("$item")
                    fi
                done

                ELEGIDOS=("${NUEVOS[@]}")

            else
                ELEGIDOS+=("$seleccion")
            fi
        fi
    done


    ejecutarInstalacion
}


main
