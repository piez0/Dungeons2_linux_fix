#!/bin/sh
# Install or update the Gaming Services stand-in for Minecraft Dungeons II.
set -eu
REPO=https://github.com/mahirsn/Dungeons2_linux_fix
# xgameruntime.dll runs the sign-in helper from here, so the files must live here.
DEST=$HOME/.local/share/dungeons2-compat
APPID=1912410

if pgrep -f 'Dungeons-Win64-Shipping' >/dev/null 2>&1; then
    echo "Quit Minecraft Dungeons II first." >&2
    exit 1
fi

STEAM_ROOT=${STEAM_ROOT:-$HOME/mochidrift/.var/app/com.valvesoftware.Steam/data/Steam}
if [ ! -f "$STEAM_ROOT/steamapps/libraryfolders.vdf" ] && [ -f "$HOME/mochidrift/.var/app/com.valvesoftware.Steam/data/Steamsteamapps/libraryfolders.vdf" ]; then
    STEAM_ROOT=$HOME/mochidrift/.var/app/com.valvesoftware.Steam/data/Steam
fi
VDF="$STEAM_ROOT/steamapps/libraryfolders.vdf"
if [ ! -f "$VDF" ]; then
    echo "Could not find libraryfolders.vdf. Set STEAM_ROOT." >&2
    exit 1
fi

LIB=$(awk '
    /"path"/ {
        gsub(/"/, "", $2)
        path = $2
        manifest = path "/steamapps/appmanifest_'"$APPID"'.acf"
        if (system("test -f \"" manifest "\"") == 0) { print path; exit }
    }
' "$VDF")
if [ -z "$LIB" ]; then
    echo "Minecraft Dungeons II is not installed in Steam." >&2
    exit 1
fi

GAME="$LIB/steamapps/common/Minecraft Dungeons II"
PFX="$LIB/steamapps/compatdata/$APPID/pfx/drive_c/windows/system32"
if [ ! -d "$PFX" ]; then
    echo "Start Minecraft Dungeons II once from Steam, close it, then run this again." >&2
    exit 1
fi

mkdir -p "$DEST"
curl -fsSL "$REPO/archive/refs/heads/main.tar.gz" | tar -xz --strip-components=1 -C "$DEST"

for dir in "$GAME" "$GAME/Dungeons/Binaries/Win64" "$PFX"; do
    cp -f "$DEST/src/xgameruntime.dll" "$dir/xgameruntime.dll"
done
echo "Installed. Start Minecraft Dungeons II from Steam."
