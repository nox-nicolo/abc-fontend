# App Icon and Splash Review

## Current State

- Android launcher icons exist in every required `mipmap-*` density folder.
- iOS launcher icons exist in `ios/Runner/Assets.xcassets/AppIcon.appiconset`.
- The native splash config is enabled for Android and iOS.
- The old splash image path referenced `assets/images/brand_logo.png`, which is not present in the repo.

## Fix Applied

- `flutter_native_splash.image` now points to the existing highest-resolution launcher icon:
  `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png`.
- Android 12 splash config was added with the same icon and black background.

## Release Follow-Up

- Replace the launcher-icon splash image with a dedicated transparent brand mark when one is available.
- Regenerate native splash assets with:

```sh
/home/ocin/develop/flutter/bin/dart run flutter_native_splash:create
```

- Before store submission, visually check icon masking on Android adaptive icon shapes and iOS light/dark launch screens.
