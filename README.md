# Minecraft Dungeons II on Linux

A local stand-in for Microsoft Gaming Services so Minecraft Dungeons II (Steam app `1912410`) can start under Proton. The game looks for `xgameruntime.dll`. This repository builds that DLL. It does not modify the game and it does not include Microsoft's library.

## Install

Start the game once from Steam and close it, so Proton creates its prefix. Then run:

```sh
curl -fsSL https://raw.githubusercontent.com/mahirsn/Dungeons2_linux_fix/main/install.sh | sh
```

Run the same command again to update. If Steam is not in `~/.local/share/Steam`, set `STEAM_ROOT`.

## First sign-in

Start the game from Steam. A window shows a code and opens <https://www.microsoft.com/link>. Enter the code and sign in with the Microsoft account that owns your Xbox profile.

The sign-in is cached in `~/.local/share/dungeons2-compat/tokens.txt` (mode `0600`) and renewed on its own. Do not share that file.

## Build

The DLL in `src/` is ready to install. To build it yourself:

```sh
x86_64-w64-mingw32-gcc-posix -shared -O2 -Wall -Wextra -o src/xgameruntime.dll src/xgameruntime.c
# or
zig cc -target x86_64-windows-gnu -shared -O2 -o src/xgameruntime.dll src/xgameruntime.c
```
