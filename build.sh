#!/bin/bash
set -e

# === Configuration ===
ARCH="armeabi-v7a"
APK_NAME="latest.apk"
PATCHED_APK="patched.apk"
SIGNED_APK="patched_signed.apk"

# === Dependency check ===
command -v zipalign >/dev/null 2>&1 || { echo >&2 "[-] zipalign not found. Install with: sudo apt install zipalign"; exit 1; }
command -v apksigner >/dev/null 2>&1 || { echo >&2 "[-] apksigner not found. Install with: sudo apt install apksigner"; exit 1; }
command -v jq >/dev/null 2>&1 || { echo >&2 "[-] jq not found. Install with: sudo apt install jq"; exit 1; }

# === Download latest Ironfox ===
echo "[+] Downloading latest Ironfox release for $ARCH..."
data=$(curl -s https://gitlab.com/api/v4/projects/ironfox-oss%2FIronFox/releases | jq -r '.[0]')
apk=$(echo "$data" | jq -r '.assets.links[] | select(.name | endswith("'"-$ARCH.apk"'")) | .url')
wget -q "$apk" -O "$APK_NAME"

# === Get apktool ===
echo "[+] Downloading apktool..."
wget -q https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.11.1.jar -O apktool.jar
wget -q https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool
chmod +x apktool

# === Clean up old builds ===
echo "[+] Cleaning previous build..."
rm -rf patched "$PATCHED_APK" "$SIGNED_APK"

# === Decompile ===
echo "[+] Decompiling APK..."
./apktool d "$APK_NAME" -o patched 
rm -rf patched/META-INF

# === Patch colors ===
echo "[+] Patching colors..."
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

# === Rebuild ===
echo "[+] Rebuilding patched APK..."
./apktool b patched -o "$PATCHED_APK" --use-aapt2

# === Align ===
echo "[+] Aligning APK..."
zipalign -f 4 "$PATCHED_APK" "$SIGNED_APK"

# === Signing ===
if [ ! -f ../debug.keystore ]; then
  echo "[+] Generating debug keystore..."
  keytool -genkey -v -keystore ../debug.keystore -storepass android -alias androiddebugkey -keypass android \
    -dname "CN=Android Debug,O=Android,C=US" -keyalg RSA -keysize 2048 -validity 10000
fi

echo "[+] Signing APK..."
apksigner sign --ks ../debug.keystore --ks-pass pass:android "$SIGNED_APK"

echo "[✅] Done! Final APK: $SIGNED_APK"
