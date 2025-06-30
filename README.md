# 🌙🦊 Ironfox-OLEDDark for armeabi-v7a

**AMOLED black patched build of Ironfox browser for older ARM devices (`armeabi-v7a`).**  
Automated script: download → patch → rebuild → sign → done.

---

## ✅ Features
- Downloads latest Ironfox release for `armeabi-v7a`
- Applies AMOLED black (OLED Dark) patch
- Rebuilds, zipaligns, signs with debug key
- Outputs: `patched_signed.apk` ready to install

---

## 🛠 Requirements
```bash
sudo apt install zipalign apksigner jq default-jdk wget curl
```

> Note: `apktool` is auto-downloaded.

---

## 🚀 How to Build
```bash
git clone https://github.com/karanveers969/Ironfox-OLEDDark-armeabi-v7a.git
cd Ironfox-OLEDDark-armeabi-v7a
chmod +x build.sh
./build.sh
```

🎉 Final output:
```
patched_signed.apk
```

---

## ✍ Credits
- Base AMOLED patch: [ArtikusHG/Ironfox-OLEDDark](https://github.com/ArtikusHG/Ironfox-OLEDDark)
- Ironfox browser: [ironfox-oss](https://gitlab.com/ironfox-oss)
- armeabi-v7a fork: [karanveers969](https://github.com/karanveers969)
