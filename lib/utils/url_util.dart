import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlUtil {
  static const String urlEmail = 'mailto:mei@meifagundes.com';
  static const String urlGithub = 'https://github.com/MeiFagundes';
  static const String urlLinkedin = 'https://www.linkedin.com/in/meifagundes';

  static Future<bool> openURI(String uri) async {
    try {
      return await launchUrl(Uri.parse(uri));
    } catch (_) {
      return false;
    }
  }

  static Future<void> openWithFeedback(BuildContext context, String uri) async {
    final opened = await openURI(uri);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o link.')),
      );
    }
  }
}
