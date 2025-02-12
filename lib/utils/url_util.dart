import 'package:url_launcher/url_launcher.dart';

class UrlUtil {
  static final String urlEmail = 'mailto:mei@meifagundes.com';
  static final String urlGithub = 'https://github.com/MeiFagundes';
  static final String urlLinkedin = 'https://www.linkedin.com/in/meifagundes';
  static final String urlMetaProject =
      'https://github.com/MeiFagundes/Portfolio';

  static Future<void> openURI(String uri, {bool encode = true}) async {
    var parsedUri = Uri.parse(uri);

    if (await canLaunchUrl(parsedUri)) {
      await launchUrl(parsedUri);
    } else {
      throw 'Não foi possível abrir a URI: ${parsedUri.toString()}';
    }
  }
}
