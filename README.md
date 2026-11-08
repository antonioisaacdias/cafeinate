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
  - **Language** — English or Português (Brasil). Defaults to the system language.

## Build

Only the Xcode Command Line Tools are needed (`xcode-select --install`).

```bash
./build.sh
```

Produces `Cafeinate.app` and `Cafeinate.dmg`.

## Release

Pushing a `v*` tag builds the app on GitHub Actions and publishes the DMG as a release:

```bash
git tag v1.0.0 && git push origin v1.0.0
```

## License

[PolyForm Noncommercial 1.0.0](LICENSE.md) — free to use, study, modify and redistribute
for noncommercial purposes. Selling or commercial use is not permitted.
