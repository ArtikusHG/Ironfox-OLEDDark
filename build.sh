#!/bin/bash
set -e

ARCH="armeabi-v7a"
APK_NAME="latest.apk"
PATCHED_APK="patched.apk"
SIGNED_APK="patched_signed.apk"

echo "[+] Downloading latest Ironfox release for $ARCH..."
data=$(curl -s https://gitlab.com/api/v4/projects/ironfox-oss%2FIronFox/releases | jq -r '.[0]')
apk=$(echo "$data" | jq -r '.assets.links[] | select(.name | endswith("'"-$ARCH.apk"'")) | .url')
wget -q "$apk" -O "$APK_NAME"

echo "[+] Downloading apktool..."
wget -q https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.11.1.jar -O apktool.jar
wget -q https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool
chmod +x apktool

echo "[+] Cleaning previous build..."
rm -rf patched "$PATCHED_APK" "$SIGNED_APK"

echo "[+] Decompiling APK..."
./apktool d "$APK_NAME" -o patched 
rm -rf patched/META-INF

echo "[+] Patching colors..."
sed -i 's/<color name="fx_mobile_layer_color_1">.*/<color name="fx_mobile_layer_color_1">#ff000000<\/color>/g' patched/res/values-night/colors.xml
# add other sed commands here (copy them from your old script)

echo "[+] Rebuilding patched APK..."
./apktool b patched -o "$PATCHED_APK" --use-aapt2

echo "[+] Aligning APK..."
zipalign -f 4 "$PATCHED_APK" "$SIGNED_APK"

# Sign with debug key
if [ ! -f ../debug.keystore ]; then
  echo "[+] Generating debug keystore..."
  keytool -genkey -v -keystore ../debug.keystore -storepass android -alias androiddebugkey -keypass android \
    -dname "CN=Android Debug,O=Android,C=US" -keyalg RSA -keysize 2048 -validity 10000
fi

echo "[+] Signing APK..."
apksigner sign --ks ../debug.keystore --ks-pass pass:android "$SIGNED_APK"

echo "[✅] Done! Final APK: $SIGNED_APK"
