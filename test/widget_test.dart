import 'dart:async';

import 'package:meifagundesdotcom/main.dart';

import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:meifagundesdotcom/utils/url_util.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meifagundesdotcom/models/project_model.dart';
import 'package:meifagundesdotcom/views/home/home_view.dart';
import 'package:meifagundesdotcom/views/home/project_list/project_list_view.dart';

class TestLauncher extends UrlLauncherPlatform {
  @override
  Null get linkDelegate => null;
  bool result = true;
  int checks = 0;
  String? lastUrl;
  @override
  Future<bool> canLaunch(String url) async {
    checks++;
    return true;
  }

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    lastUrl = url;
    return result;
  }
}

void main() {
  testWidgets('Initialization failures offer retry', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      PortfolioBootstrap(
        initialize: () async {
          calls++;
          throw Exception('unavailable');
        },
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Não foi possível carregar o portfólio.'), findsOneWidget);
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();
    expect(calls, 2);
  });

  testWidgets('Links launch directly and display failure feedback', (
    tester,
  ) async {
    final previous = UrlLauncherPlatform.instance;
    final launcher = TestLauncher();
    UrlLauncherPlatform.instance = launcher;
    addTearDown(() => UrlLauncherPlatform.instance = previous);
    expect(await UrlUtil.openURI(UrlUtil.urlGithub), isTrue);
    expect(launcher.lastUrl, UrlUtil.urlGithub);
    expect(launcher.checks, 0);
    launcher.result = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () =>
                  UrlUtil.openWithFeedback(context, UrlUtil.urlEmail),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Não foi possível abrir o link.'), findsOneWidget);
  });

  test('Project parsing preserves content and rejects malformed documents', () {
    final data = <String, dynamic>{
      'title': 'Projeto',
      'description': 'Descrição',
      'imageUrl': 'https://example.com/image.png',
      'links': [
        {'type': 'launch', 'url': 'https://example.com'},
      ],
    };
    final project = ProjectModel.fromMap(data);
    expect(project.title, 'Projeto');
    expect(project.links.single.description, 'Acessar');
    expect(() => project.links.clear(), throwsUnsupportedError);
    expect(
      () => ProjectModel.fromMap({...data, 'links': null}),
      throwsFormatException,
    );
    expect(
      () => ProjectModel.fromMap({...data, 'title': 2}),
      throwsFormatException,
    );
  });

  testWidgets('Loading, failure, retry and empty results', (tester) async {
    final pending = Completer<List<ProjectModel>>();
    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProjectListView(
            loadProjects: () {
              calls++;
              return calls == 1 ? pending.future : Future.value([]);
            },
          ),
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    pending.completeError(Exception('offline'));
    await tester.pumpAndSettle();
    expect(find.text('Não foi possível carregar os projetos.'), findsOneWidget);
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();
    expect(find.text('Nenhum projeto disponível no momento.'), findsOneWidget);
    expect(calls, 2);
  });

  testWidgets('Successful projects render long content without overflow', (
    tester,
  ) async {
    final project = ProjectModel(
      title: List.filled(20, 'Projeto').join(' '),
      description: 'Descrição preservada',
      imagePath: 'https://example.com/image.png',
      links: [ProjectLink.fromType(type: 'source', uri: 'https://example.com')],
    );
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1000, 900);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ProjectListView(loadProjects: () async => [project]),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(project.title), findsOneWidget);
    expect(find.text('Ver no GitHub'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Home keeps its request through breakpoints and enlarged text', (
    tester,
  ) async {
    var calls = 0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1400, 900);
    await tester.pumpWidget(
      MaterialApp(
        home: Home(
          loadProjects: () async {
            calls++;
            return [];
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Mei Fagundes'), findsOneWidget);
    for (final size in [
      const Size(320, 700),
      const Size(1200, 400),
      const Size(1400, 900),
    ]) {
      tester.view.physicalSize = size;
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
    expect(calls, 1);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: Home(loadProjects: () async => []),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
