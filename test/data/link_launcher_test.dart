import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:meifagundesdotcom/data/services/link_launcher.dart';

class TestLauncher extends UrlLauncherPlatform {
  @override
  Null get linkDelegate => null;
  bool result = true;
  bool shouldThrow = false;
  int capabilityChecks = 0;
  String? lastUrl;

  @override
  Future<bool> canLaunch(String url) async {
    capabilityChecks++;
    return true;
  }

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    lastUrl = url;
    if (shouldThrow) throw StateError('unavailable');
    return result;
  }
}

void main() {
  test('Launches directly and converts plugin failures to false', () async {
    final previous = UrlLauncherPlatform.instance;
    final platform = TestLauncher();
    UrlLauncherPlatform.instance = platform;
    addTearDown(() => UrlLauncherPlatform.instance = previous);
    const service = UrlLauncherService();
    expect(await service.open('https://example.com'), isTrue);
    expect(platform.lastUrl, 'https://example.com');
    expect(platform.capabilityChecks, 0);
    platform.result = false;
    expect(await service.open('mailto:example@example.com'), isFalse);
    platform.shouldThrow = true;
    expect(await service.open('https://example.com'), isFalse);
  });
}
