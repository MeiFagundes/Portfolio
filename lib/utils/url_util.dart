import 'package:url_launcher/url_launcher.dart';

class UrlUtil {
  static final String urlEmail = 'mailto:mei@meifagundes.com';
  static final String urlGithub = 'https://github.com/MeiFagundes';
  static final String urlLinkedin = 'https://www.linkedin.com/in/meifagundes';
  static final String urlMetaProject =
      'https://github.com/MeiFagundes/Portfolio';

  static Future<void> openURI(String uri, {bool encode = true}) async {
    var encodedUrl = encode ? Uri.encodeFull(uri) : uri;

    if (await canLaunch(encodedUrl)) {
      await launch(encodedUrl, forceSafariVC: false);
    } else {
      throw 'Não foi possível abrir a URI: $encodedUrl';
    }
  }
}
