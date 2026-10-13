# Portfolio

A personal portfolio built with Flutter. Project data lives in versioned JSON in this repository and is published independently from the app.

## Development

Use Flutter **3.47.7 stable** with its bundled Dart **3.13.5**. CI pins the same Flutter version.

```sh
flutter pub get --enforce-lockfile
flutter gen-l10n
flutter run -d chrome --wasm
flutter analyze
flutter test
```

The local app uses the production content endpoint by default. To try another endpoint, pass `--dart-define=PORTFOLIO_CONTENT_URL=https://.../v2/projects.json`.

## Content

Edit [`content/v2/projects.json`](content/v2/projects.json) to update project descriptions and technology labels. The JSON contract uses `schemaVersion: 2`; each entry contains `id`, integer `priority`, `title`, `descriptions`, `technologies`, `imageUrl`, and `links`. Descriptions contain Portuguese (`pt`) and English (`en`) versions, each with `concept` and `implementation` paragraphs. Technology labels are non-empty strings and must be unique within a project, ignoring case. Link types are `launch`, `download`, or `source`. Run `python3 scripts/validate_content.py` before opening a pull request.

The original v1 content remains available for older clients and rollback. Validation checks both contracts and ensures that project IDs, priorities, titles, image URLs, and links agree. The app loads v2 JSON from Firebase Hosting over HTTP. Responses are cached for up to 60 seconds. A home-screen session loads once and retries on request failure. App-owned text stays in ARB files.

## Web hosting and publishing

`meifagundesdotcom` serves the Flutter app and the four existing demos at `/pokedex/`, `/my-quimica-lab/`, `/phaser-poc/`, and `/polaris-ai/`. The demo sources are preserved in `hosting/static/` and copied into the release output by `scripts/prepare_web.py`.

Separate Firebase Hosting sites serve production content at `meifagundesdotcom-content.web.app/v2/projects.json` and development content at `meifagundesdotcom-content-dev.web.app/v2/projects.json`. Both sites retain `/v1/projects.json`. The JSON endpoints allow anonymous cross-origin reads and use a 60-second cache lifetime.

GitHub Actions validates content-only changes without setting up Flutter. App changes run formatting, analysis, tests, and separate Wasm and JavaScript web builds. Merges to `develop` update development content and publish a seven-day stable app preview; merges to `master` publish production content and the app. GitHub OIDC exchanges short-lived credentials through a Workload Identity provider restricted to this repository's `develop` and `master` pushes. No Firebase credentials are stored in the repository.

Firebase Hosting configuration and site targets are in [`firebase.json`](firebase.json) and [`.firebaserc`](.firebaserc). The `meifagundes.com` domain stays attached to the existing production app site.

## Architecture

The app follows a lean MVVM structure based on [Flutter's architecture recommendations](https://docs.flutter.dev/app-architecture/recommendations). Views render state and forward user actions; view models own loading, retries, and lifecycle-safe updates. Repositories map validated service data into immutable, plain Dart models. HTTP content and URL launching are injected services that isolate platform interactions.

| Directory | Responsibility |
| --- | --- |
| `lib/app/` | Startup, dependency composition, app configuration, and locale-independent identity |
| `lib/models/` | Immutable project data and link types, with no Flutter or backend dependencies |
| `lib/data/` | Repository contracts, HTTP, and URL launching |
| `lib/ui/` | Views, feature view models, reusable presentation widgets, and theme |
| `lib/l10n/` | App-owned messages and generated localization configuration |
| `content/` | Versioned, Git-managed project data and translations |
| `hosting/static/` | Existing standalone web demos |

The single-screen app does not need a use-case layer, service locator, routing framework, or third-party state-management package. Add a layer when shared or complex business logic warrants it.

## Localization

App-owned copy lives in Portuguese and English ARB catalogs, using [Flutter's ARB and gen-l10n workflow](https://docs.flutter.dev/ui/internationalization). The app follows the first supported browser language automatically, and falls back to Portuguese when none is supported. There is currently no visible language selector or saved language choice. Explicit `PortfolioApp.locale` or `PortfolioBootstrap.locale` values remain available for testing.

To add a language, add `lib/l10n/app_<language>.arb` with the same message keys and placeholder definitions, run `flutter gen-l10n`, then verify locale selection, labels, long translations, and text scaling. `PortfolioApp.locale` and `PortfolioBootstrap.locale` allow an explicit locale override.

Project names and canonical technology labels are shared across languages. Project descriptions live in v2 content and are resolved by language using plain Dart models, with Portuguese as the fallback. They can be updated independently of the app build.
