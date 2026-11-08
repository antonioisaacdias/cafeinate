# Cafeinate

Lightweight macOS menu bar app that keeps your display awake with one click — `caffeinate` without the terminal.

**[⬇ Download the latest version](https://github.com/antonioisaacdias/cafeinate/releases/latest/download/Cafeinate.dmg)**

## Install

1. [Download `Cafeinate.dmg`](https://github.com/antonioisaacdias/cafeinate/releases/latest/download/Cafeinate.dmg) (or pick a version on the [Releases](../../releases) page).
2. Open it and drag **Cafeinate** into the **Applications** folder.
3. Open the app. The first time, macOS warns that it can't verify the developer:
   go to **System Settings → Privacy & Security** and click **Open Anyway**.

Requires macOS 13 or later (Apple Silicon or Intel).

## Usage

Click the cup icon in the menu bar:

- **Turn On / Turn Off** — keeps the display awake while active (filled cup).
- **Settings…**
  - **Launch at login**
  - **Keep last state after restart** — if it was on, it comes back on after a restart.
  - **Hide from menu bar when added to Control Center** (macOS 26+)
  - **Language** — English or Português (Brasil). Defaults to the system language.

### Control Center (macOS 26+)

Open **Control Center → Edit Controls**, search for **Cafeinate** and add it. The toggle stays in sync with the menu bar icon, which hides itself while the control is in Control Center.
If the icon is hidden, open Cafeinate again from Spotlight or Applications to reach Settings.

## Build

Requires Xcode and [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`).

```bash
./build.sh
```

Produces `Cafeinate.dmg`.

## License

[PolyForm Noncommercial 1.0.0](LICENSE.md) — free to use, study, modify and redistribute
for noncommercial purposes. Selling or commercial use is not permitted.
