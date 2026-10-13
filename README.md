# Portfolio

A personal portfolio built with Flutter, with project data loaded from Cloud Firestore.

## Development

Use Flutter **3.47.7 stable** with its bundled Dart **3.13.5**. CI pins the same Flutter version; update that pin deliberately with future upgrades.

```sh
flutter pub get --enforce-lockfile
flutter run -d chrome --wasm
flutter analyze
flutter test
```

## Web release

```sh
flutter build web --release --wasm
```

Serve the complete `build/web` directory over HTTP. The standard bootstrap chooses Wasm where supported and includes JavaScript fallback ([Flutter Wasm documentation](https://docs.flutter.dev/platform-integration/web/wasm)). Cross-origin isolation is not required for the default single-threaded renderer; do not add COEP headers without checking all remote images and Firebase requests.

For a subdirectory, build with `--base-href /portfolio/` and serve at that path. HTML and bootstrap responses should be revalidated on deployment; avoid long-lived caching of unversioned build files. Serve `.wasm` files with `application/wasm` and retain all generated fallback files. No hosting target or deployment is configured by this repository.

A JavaScript-only compatibility build is available with `flutter build web --release`. Test production output in Chrome, Edge, Firefox, Safari and iOS, including project loading, images, scrolling, links and refresh after deployment.

Firestore continues to use `portfolio/projects/project list`, ordered by `priority`. Loading is one-time per home screen, with explicit retry on failure. Required document fields are `title`, `description`, `imageUrl`, and `links` containing `type` and `url`.
