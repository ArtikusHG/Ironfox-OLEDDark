# 🌙🦊 Ironfox-OLEDDark for armeabi-v7a

**🔥 AMOLED black patched build of Ironfox browser for older ARM devices (`armeabi-v7a`).**  
✅ Fully automated: downloads → patches → rebuilds → signs → publishes — every 24 hours.  
**Uses Ironfox’s upstream tag automatically.**  
Anyone can install or fork & self‑sign.

---

## ✅ Features
- Matches **latest Ironfox release** automatically (cron every 24h)
- AMOLED black patch for true dark
- Rebuilds & signs APK
- Publishes as GitHub release with **same tag**
- ⚡ Obtainium support for auto‑updates

---

## 📦 Install (easy way)
Just download from [Releases](https://github.com/karanveers969/Ironfox-OLEDDark-armeabi-v7a/releases)  
or add this repo in [Obtainium](https://github.com/ImranR98/Obtainium):

```
https://github.com/karanveers969/Ironfox-OLEDDark-armeabi-v7a
```

---

## 🛠 Build manually (optional)
```bash
git clone https://github.com/karanveers969/Ironfox-OLEDDark-armeabi-v7a.git
cd Ironfox-OLEDDark-armeabi-v7a
sudo apt install zipalign apksigner jq default-jdk wget curl
chmod +x build.sh
./build.sh
```

🎉 Output:
```
patched_signed.apk
```

---

## ✍ Credits
- AMOLED patch script: [ArtikusHG/Ironfox-OLEDDark](https://github.com/ArtikusHG/Ironfox-OLEDDark)
- Original Ironfox browser: [ironfox-oss](https://gitlab.com/ironfox-oss)
- ARMv7 fork & automation: [karanveers969](https://github.com/karanveers969)
