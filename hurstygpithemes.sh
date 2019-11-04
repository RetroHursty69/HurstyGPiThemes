#!/usr/bin/env bash

# This file is NOT part of The RetroPie Project
#
# This script is a third party script to install the RetroHursty
# Emulation Station GPi themes onto a RetroPie build.
#
#

function depends_hurstygpithemes() {
    if isPlatform "x11"; then
        getDepends feh
    else
        getDepends fbi
    fi
}

function install_theme_hurstygpithemes() {
    local theme="$1"
    local repo="$2"
    if [[ -z "$repo" ]]; then
        repo="RetroHursty69"
    fi
    if [[ -z "$theme" ]]; then
        theme="carbon"
        repo="RetroPie"
    fi
    sudo git clone "https://github.com/$repo/es-theme-$theme.git" "/etc/emulationstation/themes/$theme"
}

function uninstall_theme_hurstygpithemes() {
    local theme="$1"
    if [[ -d "/etc/emulationstation/themes/$theme" ]]; then
        sudo rm -rf "/etc/emulationstation/themes/$theme"
    fi
}

function disable_script() {
dialog --infobox "...processing..." 3 20 ; sleep 2
ifexist=`cat /opt/retropie/configs/all/autostart.sh |grep themerandom |wc -l`
if [[ ${ifexist} > "0" ]]
then
  perl -pi -w -e 's/\/home\/pi\/scripts\/themerandom.sh/#\/home\/pi\/scripts\/themerandom.sh/g;' /opt/retropie/configs/all/autostart.sh
fi
sleep 2
}

function enable_script() {
dialog --infobox "...processing..." 3 20 ; sleep 2
ifexist=`cat /opt/retropie/configs/all/autostart.sh |grep themerandom |wc -l`
if [[ ${ifexist} > "0" ]]
then
  perl -pi -w -e 's/#\/home\/pi\/scripts\/themerandom.sh/\/home\/pi\/scripts\/themerandom.sh/g;' /opt/retropie/configs/all/autostart.sh
else
  cp /opt/retropie/configs/all/autostart.sh /opt/retropie/configs/all/autostart.sh.bkp
  echo "/home/pi/scripts/themerandom.sh" > /tmp/autostart.sh
  cat /opt/retropie/configs/all/autostart.sh >> /tmp/autostart.sh
  chmod 777 /tmp/autostart.sh
  cp /tmp/autostart.sh /opt/retropie/configs/all
fi
sleep 2
}

function gui_hurstygpithemes() {
    while true; do
        local theme
        local installed_themes=()
        local repo
        local options=()
        local status=()
        local default

        options+=(U "Update install script - script will exit when updated")
        options+=(E "Enable ES bootup theme randomizer")
        options+=(D "Disable ES bootup theme randomizer")
        options+=(F "GPi Themes (32 Themes)")				

        local i=1
        for theme in "${themes[@]}"; do
            theme=($theme)
            repo="${theme[0]}"
            theme="${theme[1]}"
            if [[ -d "/etc/emulationstation/themes/$theme" ]]; then
                status+=("i")
                options+=("$i" "Update or Uninstall $theme (installed)")
                installed_themes+=("$theme $repo")
            else
                status+=("n")
                options+=("$i" "Install $theme (not installed)")
            fi
            ((i++))
        done
        local cmd=(dialog --default-item "$default" --backtitle "Hursty's ES GPi Themes Installer" --menu "Hursty's ES GPi Themes Installer - (32 Themes as at 4 November 2019)" 22 76 16)
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        default="$choice"
        [[ -z "$choice" ]] && break
        case "$choice" in
            U)  #update install script to get new theme listings
                cd "/home/pi/RetroPie/retropiemenu" 
                mv "hurstygpithemes.sh" "hurstygpithemes.sh.bkp" 
                wget "https://raw.githubusercontent.com/retrohursty69/HurstyGPiThemes/master/hurstygpithemes.sh" 
                if [[ -f "/home/pi/RetroPie/retropiemenu/hurstygpithemes.sh" ]]; then
                  echo "/home/pi/RetroPie/retropiemenu/hurstygpithemes.sh" > /tmp/errorchecking
                 else
                  mv "hurstygpithemes.sh.bkp" "hurstygpithemes.sh"
                fi
                chmod 777 "hurstygpithemes.sh" 
                exit
                ;;
            E)  #enable ES bootup theme randomizer
                enable_script
                ;;
            D)  #disable ES bootup theme randomizer
                disable_script
                ;;
            F)  #GPi themes only
                gpi_themes
                ;;               				
            *)  #install or update themes
                theme=(${themes[choice-1]})
                repo="${theme[0]}"
                theme="${theme[1]}"
#                if [[ "${status[choice]}" == "i" ]]; then
                if [[ -d "/etc/emulationstation/themes/$theme" ]]; then
                    options=(1 "Update $theme" 2 "Uninstall $theme")
                    cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option for theme" 12 40 06)
                    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
                    case "$choice" in
                        1)
                            install_theme_hurstygpithemes "$theme" "$repo"
                            ;;
                        2)
                            uninstall_theme_hurstygpithemes "$theme"
                            ;;
                    esac
                else
                    install_theme_hurstygpithemes "$theme" "$repo"
                fi
                ;;
        esac
    done
}

function gpi_themes() {
    local themes=(
        'RetroHursty69 GPi_Bluray'
        'RetroHursty69 GPi_Circuit'
        'RetroHursty69 GPi_CosmicRise'
        'RetroHursty69 GPi_GPiBoy'
        'RetroHursty69 GPi_GBColor'		
        'RetroHursty69 GPi_GBGreen'
        'RetroHursty69 GPi_HeyChromeyOfficial'
        'RetroHursty69 GPi_PopBox'
        'RetroHursty69 GPi_Retroroid'
        'RetroHursty69 GPi_SteelChromey'
		'RetroHursty69 GPi_SuperSweet'
        'RetroHursty69 GPi_Sublime'
		'RetroHursty69 GPi_Soda'
		'RetroHursty69 GPi_Trio'
		'RetroHursty69 GPi_UniFlyered'
        'RetroHursty69 GPi_BalrogCapcom'
        'RetroHursty69 GPi_BisonCapcom'
        'RetroHursty69 GPi_BlankaCapcom'
        'RetroHursty69 GPi_CammyCapcom'
        'RetroHursty69 GPi_CapCommandoCapcom'		
        'RetroHursty69 GPi_ChunLiCapcom'
        'RetroHursty69 GPi_DhalsimCapcom'        
        'RetroHursty69 GPi_DeeJayCapcom'
        'RetroHursty69 GPi_DemitriCapcom'
        'RetroHursty69 GPi_GhoulsCapcom'
		'RetroHursty69 GPi_GuileCapcom'
        'RetroHursty69 GPi_HondaCapcom'
		'RetroHursty69 GPi_KenCapcom'
		'RetroHursty69 GPi_RyuCapcom'
		'RetroHursty69 GPi_SagatCapcom'
		'RetroHursty69 GPi_THawkCapcom'
		'RetroHursty69 GPi_ZangiefCapcom'			
    )
    while true; do
        local theme
        local installed_themes=()
        local repo
        local options=()
        local status=()
        local default

        local i=1
        for theme in "${themes[@]}"; do
            theme=($theme)
            repo="${theme[0]}"
            theme="${theme[1]}"
            if [[ -d "/etc/emulationstation/themes/$theme" ]]; then
                status+=("i")
                options+=("$i" "Update or Uninstall $theme (installed)")
                installed_themes+=("$theme $repo")
            else
                status+=("n")
                options+=("$i" "Install $theme (not installed)")
            fi
            ((i++))
        done
        local cmd=(dialog --default-item "$default" --backtitle "Hursty's ES GPi Themes Installer" --menu "Hursty's ES GPi Themes Installer - Choose an option" 22 76 16)
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        default="$choice"
        [[ -z "$choice" ]] && break
        case "$choice" in
            *)  #install or update themes
                theme=(${themes[choice-1]})
                repo="${theme[0]}"
                theme="${theme[1]}"
#                if [[ "${status[choice]}" == "i" ]]; then
                if [[ -d "/etc/emulationstation/themes/$theme" ]]; then
                    options=(1 "Update $theme" 2 "Uninstall $theme")
                    cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option for theme" 12 40 06)
                    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
                    case "$choice" in
                        1)
                            install_theme_hurstygpithemes "$theme" "$repo"
                            ;;
                        2)
                            uninstall_theme_hurstygpithemes "$theme"
                            ;;
                    esac
                else
                    install_theme_hurstygpithemes "$theme" "$repo"
                fi
                ;;
        esac
    done
}

gui_hurstygpithemes
