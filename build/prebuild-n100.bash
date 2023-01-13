#!/bin/bash

# Script that compiles upsilon for all the given themes

themes=(
    "arc_dark"
    "omega_shrek"
    "miami_vice"
    "omega_trans"
    "cursed_light"
    "omega_blink"
    "omega_kawaii"
    "omega_dracula"
    "ahegao"
    "omega_freenumworks"
    #"yellowmega_light"
    #"yellowmega_dark"
    "upsilon_dark"
    "epsilon_dark"
    "epsilon_light"
    "omega_dark"
    "omega_light"
    "upsilon_light"
)
repos=(
    "https://github.com/lolocomotive/Omega-Arc-Dark"
    "https://github.com/PierreDiab/Omega_Shrek.git"
    "https://github.com/akhilvanka/Miami-Vice"
    "https://github.com/coco33920/Omega-LGBT"
    "https://github.com/Syycorax/Omega-cursed"
    "https://github.com/virgilecheminot/Omega-Theme-Blink"
    "https://github.com/Omega-Numworks-Prod/Omega-Kawaii-Theme"
    "https://github.com/Ratakor/Omega-Dracula-Theme"
    "https://github.com/ArtichOwO/WeebThemeOmega"
    "https://github.com/PierreDiab/Omega-FreeNumworks"
    #"https://github.com/Laporte12974/Yellowmega_Theme"
    #"https://github.com/Laporte12974/Yellowmega_Theme"
    "https://github.com/lemoustachu/Upsilon-Themes"
)

languages=(
    "en"
    "fr"
    "nl"
    "pt"
    "it"
    "de"
    "es"
    "hu"
)
echo Compiling for n100
echo ---

mkdir binpacks/n100

for i in "${!themes[@]}"
do
    make cleanall &> /dev/null
    for lang in "${languages[@]}"
    do
        echo Compiling for n100 $lang $i out of ${#themes[@]}
        make -j MODEL=n0100 THEME_NAME=${themes[i]} $([ "${repos[i]}" == "" ] && echo || echo "THEME_REPO=${repos[i]}") EPSILON_I18N=$lang binpack &> binpacks/n100/${themes[i]}.$lang.log
        mv output/release/device/n0100/binpack/epsilon.onboarding.internal.bin binpacks/n100/epsilon.onboarding.${themes[i]}.$lang.internal.bin -v
        mv output/release/device/n0100/binpack/epsilon.onboarding.internal.bin.sha256 binpacks/n100/epsilon.onboarding.${themes[i]}.$lang.internal.bin.sha256 -v
        rm output/release/device/n0100/apps/i18n.o output/release/device/n0100/apps/i18n.cpp
    done
done
#Avoid crashing the CI
exit 0