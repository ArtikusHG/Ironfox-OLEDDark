#!/bin/bash

arch=${1:-arm64-v8a}
data=$(curl -s https://gitlab.com/api/v4/projects/ironfox-oss%2FIronFox/releases | jq -r '.[0]')
apk=$(echo "$data" | jq -r '.assets.links[] | select(.name | endswith("'"-$arch.apk"'")) | .url')
wget -q "$apk" -O latest.apk

wget -q https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.11.1.jar -O apktool.jar
wget -q https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool
chmod +x apktool*

rm -rf patched patched_signed.apk
./apktool d latest.apk -o patched 
rm -rf patched/META-INF

sed -i 's/<color name="fx_mobile_layer_color_1">.*/<color name="fx_mobile_layer_color_1">#ff000000<\/color>/g' patched/res/values-night/colors.xml
sed -i 's/<color name="fx_mobile_layer_color_2">.*/<color name="fx_mobile_layer_color_2">@color\/photonDarkGrey90<\/color>/g' patched/res/values-night/colors.xml
sed -i 's/<color name="fx_mobile_action_color_secondary">.*/<color name="fx_mobile_action_color_secondary">#ff25242b<\/color>/g' patched/res/values-night/colors.xml
sed -i 's/<color name="button_material_dark">.*/<color name="button_material_dark">#ff25242b<\/color>/g' patched/res/values/colors.xml
sed -i 's/ff1c1b22/ff000000/g' patched/smali*/mozilla/components/ui/colors/PhotonColors.smali
sed -i 's/ff2b2a33/ff000000/g' patched/smali*/mozilla/components/ui/colors/PhotonColors.smali
sed -i 's/ff42414d/ff15141a/g' patched/smali*/mozilla/components/ui/colors/PhotonColors.smali
sed -i 's/ff52525e/ff25232e/g' patched/smali*/mozilla/components/ui/colors/PhotonColors.smali
sed -i 's/ff5b5b66/ff2d2b38/g' patched/smali*/mozilla/components/ui/colors/PhotonColors.smali
sed -i 's/1c1b22/000000/g' patched/assets/extensions/readerview/readerview.css
sed -i 's/eeeeee/e3e3e3/g' patched/assets/extensions/readerview/readerview.css
sed -i 's/mipmap\/ic_launcher_round/drawable\/ic_launcher_foreground/g' patched/res/drawable-v23/splash_screen.xml
sed -i 's/160\.0dip/200\.0dip/g' patched/res/drawable-v23/splash_screen.xml

./apktool b patched -o patched.apk --use-aapt2

zipalign 4 patched.apk patched_signed.apk
rm -rf patched patched.apk
