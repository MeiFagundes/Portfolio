import 'package:url_launcher/url_launcher.dart';

abstract interface class LinkLauncher {
  Future<bool> open(String uri);
}

class UrlLauncherService implements LinkLauncher {
  const UrlLauncherService();

  @override
  Future<bool> open(String uri) async {
    try {
      // Invoke the plugin immediately to preserve the browser's user gesture.
      return await launchUrl(Uri.parse(uri));
    } catch (_) {
      return false;
    }
  }
}
