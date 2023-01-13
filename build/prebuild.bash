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
    #"ahegao"
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
    #"https://github.com/ArtichOwO/WeebThemeOmega"
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

echo Compiling for n110
echo ---

mkdir binpacks
mkdir binpacks/n110

for i in "${!themes[@]}"
do
    echo Compiling for n110 $i out of ${#themes[@]}
    make cleanall &> /dev/null
    echo Compilation start: $(date) > binpacks/n110/${themes[$i]}.legacy.log
    make -j7 THEME_NAME=${themes[i]} $([ "${repos[i]}" == "" ] && echo || echo "THEME_REPO=${repos[i]}") binpack MODEL=n0110 &>> binpacks/n110/${themes[i]}.legacy.log
    echo Compilation end: $(date) >> binpacks/n110/${themes[$i]}.legacy.log
    
    echo Compilation start: $(date) > binpacks/n110/${themes[$i]}.bl.log
    make -j7 THEME_NAME=${themes[i]} $([ "${repos[i]}" == "" ] && echo || echo "THEME_REPO=${repos[i]}") &>> binpacks/n110/${themes[i]}.bl.log
    echo Compilation start: $(date) >> binpacks/n110/${themes[$i]}.bl.log
    
    mv output/release/device/bootloader/epsilon.onboarding.A.bin binpacks/n110/epsilon.onboarding.${themes[$i]}.A.bin
    mv output/release/device/bootloader/epsilon.onboarding.B.bin binpacks/n110/epsilon.onboarding.${themes[$i]}.B.bin
    
    mv output/release/device/n0110/binpack-n0110-$(git rev-parse HEAD | head -c 7).tgz binpacks/n110/${themes[$i]}.tgz
    
    mv output/release/device/n0110/binpack/epsilon.onboarding.external.bin binpacks/n110/epsilon.onboarding.${themes[i]}.external.bin
    mv output/release/device/n0110/binpack/epsilon.onboarding.internal.bin binpacks/n110/epsilon.onboarding.${themes[i]}.internal.bin
done

mv output/release/device/n0110/binpack/flasher.light.bin binpacks/n110/flasher.light.bin

echo Building bootloader...
make MODEL=n0110 bootloader.bin &> binpacks/n110/bootloader.log
mv output/release/device/n0110/bootloader.bin binpacks/n110/bootloader.bin

echo Generating checksums...
for bin in binpacks/n110/*.bin
do
    shasum -a 256 -b $bin > $bin.sha256
done

#Build simulators

#mkdir simulator
#for i in "${!themes[@]}"
#do
#    make cleanall
#    make -j THEME_NAME=${themes[i]} $([ "${repos[i]}" == "" ] && echo || echo "THEME_REPO=${repos[i]}") PLATFORM=simulator
#    mv output/release/simulator/linux/epsilon.bin simulator/epsilon.${themes[i]}.bin
#done

echo Done!
