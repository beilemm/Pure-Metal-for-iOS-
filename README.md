# Pure Metal for iOS (unofficial build)

Unofficial iOS arm64 build of [Pure Metal](https://github.com/imCinq/pure-metal) by **imCinq**, built automatically with Codemagic.

This repository contains only the build script (`codemagic.yaml`). It does **not** contain Pure Metal's source code: the workflow clones the upstream repository, patches it for iOS and builds it.

> Not affiliated with imCinq, Mojang, Microsoft or Apple. Minecraft is a trademark of Mojang AB.
> Experimental. Tested on one iPhone (A17 Pro) with a launcher that uses SDL3 and Java 25.

## What you get

| File | Description |
|---|---|
| `pure-metal-<version>-ios.jar` | The Fabric mod, with the iOS `libpuremetal.dylib` inside `natives/` |
| `libpuremetal-ios.dylib` | The iOS native library on its own |
| `exports-ios.txt`, `SHA256SUMS.txt` | Exported symbols and checksums |
| `LICENSE`, `NOTICE` | Upstream license files (Apache-2.0) |

## Requirements

- iPhone/iPad with iOS 16 or newer (MetalFX needs iOS 16+)
- An iOS Minecraft launcher that provides Java 25 and Fabric Loader 0.19+
- Minecraft Java **26.3**
- Sodium is optional

## Install

1. Put **only one** Pure Metal jar in your `mods` folder. Do not keep the macOS jar next to this one (same mod id, Fabric will report a duplicate).
2. In `options.txt`, make sure the graphics API is **Default**, not OpenGL. If the line `graphicsApiPreference:prefer_opengl` is there, delete it or set it to `default`.
3. Start the game. Open F3: you should see a `Pure Metal: Metal 3 ...` line.

### Black screen / "Pure Metal is not used"

Pure Metal turns itself off when the graphics API is OpenGL. Minecraft switches to OpenGL by itself after a start that did not end cleanly (force-quit, killed by iOS). To avoid this, leave the game with **Quit Game** instead of swiping the app away. If it already happened, fix `options.txt` as in step 2. The reason is written in `latest.log`.

## Build it yourself

1. Put `codemagic.yaml` at the root of any git repository.
2. Add the repository to Codemagic and choose `codemagic.yaml` as the configuration.
3. Run the workflow **`pure-metal-ios`**. (`pure-metal-jar` is the original macOS build.)
4. Download the files listed above from the build artifacts.

To build another version, change `UPSTREAM_REF` in the yaml (a tag, branch or commit).

## Changes from upstream

- Native library compiled for iOS (arm64, iOS 16+), no AppKit
- `displaySyncEnabled` compiled out on iOS (macOS only)
- Small `IOSurface` header shim (the iOS SDK has no public header)
- `pm_surface_create` is auto-patched so Pure Metal finds an existing `CAMetalLayer` (SDL Metal view) or creates one on the key window, instead of expecting a macOS window handle
- The jar is upstream's jar with `natives/libpuremetal.dylib` replaced by the iOS build

## License

- Pure Metal: Apache License 2.0, Copyright 2026 imCinq. See `LICENSE` and `NOTICE` inside the jar and the [upstream repository](https://github.com/imCinq/pure-metal).
- The build script in this repository (`codemagic.yaml`, this README): MIT.
