#!/bin/bash
data=$(curl -s https://fdroid.ironfoxoss.org/fdroid/repo/index-v1.json)
apk=$(echo $data | jq -r '.packages."org.ironfoxoss.ironfox"[0].apkName')
wget -q $(echo "https://fdroid.ironfoxoss.org/fdroid/repo/$apk") -O latest.apk

wget -q https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.11.0.jar -O apktool.jar
wget -q https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool
chmod +x apktool*

rm -rf patched patched_signed.apk
./apktool d latest.apk -o patched 
rm -rf patched/META-INF

sed -i 's/<color name="fx_mobile_layer_color_1">.*/<color name="fx_mobile_layer_color_1">#ff000000<\/color>/g' patched/res/values-night/colors.xml
sed -i 's/<color name="fx_mobile_layer_color_2">.*/<color name="fx_mobile_layer_color_2">@color\/photonDarkGrey90<\/color>/g' patched/res/values-night/colors.xml

sed -i 's/ff2b2a33/ff000000/g' patched/smali_classes2/mozilla/components/ui/colors/PhotonColors.smali
sed -i 's/ff42414d/ff15141a/g' patched/smali_classes2/mozilla/components/ui/colors/PhotonColors.smali
sed -i 's/ff52525e/ff15141a/g' patched/smali_classes2/mozilla/components/ui/colors/PhotonColors.smali

./apktool b patched -o patched.apk --use-aapt2

zipalign 4 patched.apk patched_signed.apk
rm -rf patched patched.apk
