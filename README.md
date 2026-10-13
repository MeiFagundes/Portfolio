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

## Architecture

The app uses a lean MVVM structure based on [Flutter's architecture recommendations](https://docs.flutter.dev/app-architecture/recommendations). Views render state and forward user actions; view models handle loading, retries, and lifecycle-safe state updates. Repositories expose immutable, plain Dart models, and services isolate Firestore and URL Launcher.

| Directory | Responsibility |
| --- | --- |
| `lib/app/` | Startup, dependency composition, app configuration, and locale-independent identity |
| `lib/models/` | Immutable project data and link types, with no Flutter or Firebase dependencies |
| `lib/data/` | Repository contracts, Firestore document mapping, and platform services |
| `lib/ui/` | Views, feature view models, reusable presentation widgets, and theme |
| `lib/l10n/` | App-owned messages and generated localization configuration |

`main.dart` wires production dependencies through `createAppDependencies`. Tests inject fake repositories and services through constructors, without initializing Firebase. `PortfolioApp` owns and disposes its home view model, so responsive layout and locale changes retain the loaded projects. View models share in-flight requests, expose explicit loading/error/ready states, and prevent notifications after disposal. Link launching is a stateless platform service, with localized failure feedback in the UI.

A separate use-case layer, service locator, routing framework, and third-party state-management package are unnecessary for the current single-screen app. Add another layer only when shared or complex business logic warrants it.

## Localization

App-owned copy lives in `lib/l10n/app_pt.arb`, using [Flutter's ARB and gen-l10n workflow](https://docs.flutter.dev/ui/internationalization). Portuguese is the only enabled language for now; existing wording is preserved, including the English footer. Unsupported browser locales fall back to Portuguese. Both startup and the main app use the same generated delegates, supported locales, and theme.

To add a language:

1. Add `lib/l10n/app_<language>.arb` with the same message keys and placeholder definitions as the Portuguese template.
2. Run `flutter gen-l10n`; generated files under `lib/l10n/generated/` are ignored and recreated locally and in CI.
3. Verify locale selection, localized labels, long translations, and text scaling in widget tests and browser builds. `PortfolioApp.locale` and `PortfolioBootstrap.locale` allow an explicit locale override for tests or a future language selector.

Project titles and descriptions from Firestore remain in their original language. App UI localization does not translate remote content. A future content-localization change should define the backend translation schema and fallback policy, then resolve translated content in the repository without putting backend parsing in models or widgets. Link types remain locale-independent; their labels and icons are mapped in the UI.
