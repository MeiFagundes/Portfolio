import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meifagundesdotcom/app/app.dart';
import 'package:meifagundesdotcom/app/dependencies.dart';
import 'package:meifagundesdotcom/app/bootstrap.dart';
import 'package:meifagundesdotcom/app/portfolio_content.dart';
import 'package:meifagundesdotcom/l10n/generated/app_localizations.dart';
import 'package:meifagundesdotcom/models/project_model.dart';
import 'package:meifagundesdotcom/ui/home/widgets/project_link_presentation.dart';

import 'fakes.dart';

void main() {
  testWidgets('Initialization failures offer retry and can recover', (
    tester,
  ) async {
    var calls = 0;
    final dependencies = fakeDependencies(
      FakeProjectRepository(() async => []),
    );
    await tester.pumpWidget(
      PortfolioBootstrap(
        initialize: () async {
          calls++;
          if (calls == 1) throw StateError('unavailable');
          return dependencies;
        },
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Não foi possível carregar o portfólio.'), findsOneWidget);
    await tester.ensureVisible(find.text('Tentar novamente'));
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();
    expect(find.text('Projetos Pessoais'), findsOneWidget);
    expect(calls, 2);
  });

  testWidgets('Replacing the initializer ignores the old pending startup', (
    tester,
  ) async {
    final pending = Completer<AppDependencies>();
    final oldRepository = FakeProjectRepository(() async => []);
    await tester.pumpWidget(
      PortfolioBootstrap(initialize: () => pending.future),
    );
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    final newRepository = FakeProjectRepository(() async => []);
    final dependencies = fakeDependencies(newRepository);
    await tester.pumpWidget(
      PortfolioBootstrap(initialize: () async => dependencies),
    );
    await tester.pumpAndSettle();
    pending.complete(fakeDependencies(oldRepository));
    await tester.pumpAndSettle();
    expect(find.text('Projetos Pessoais'), findsOneWidget);
    expect(newRepository.calls, 1);
    expect(oldRepository.calls, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Loading, failure, failed retry and recovery to empty results', (
    tester,
  ) async {
    final pending = Completer<List<ProjectModel>>();
    var calls = 0;
    final repository = FakeProjectRepository(() {
      calls++;
      if (calls == 1) return pending.future;
      if (calls == 2) throw StateError('still offline');
      return Future.value([]);
    });
    await tester.pumpWidget(
      PortfolioApp(dependencies: fakeDependencies(repository)),
    );
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    pending.completeError(StateError('offline'));
    await tester.pumpAndSettle();
    expect(find.text('Não foi possível carregar os projetos.'), findsOneWidget);
    await tester.ensureVisible(find.text('Tentar novamente'));
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();
    expect(find.text('Não foi possível carregar os projetos.'), findsOneWidget);
    await tester.ensureVisible(find.text('Tentar novamente'));
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();
    expect(find.text('Nenhum projeto disponível no momento.'), findsOneWidget);
    expect(repository.calls, 3);
  });

  testWidgets('Successful projects preserve content and handle long titles', (
    tester,
  ) async {
    final project = sampleProject(title: List.filled(20, 'Projeto').join(' '));
    final repository = FakeProjectRepository(() async => [project]);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1000, 900);
    await tester.pumpWidget(
      PortfolioApp(dependencies: fakeDependencies(repository)),
    );
    await tester.pumpAndSettle();
    expect(find.text(project.title), findsOneWidget);
    expect(find.text(project.description), findsOneWidget);
    expect(find.text('Ver no GitHub'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Layouts and locale changes preserve the home request', (
    tester,
  ) async {
    final repository = FakeProjectRepository(() async => []);
    final dependencies = fakeDependencies(repository);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1400, 900);
    await tester.pumpWidget(PortfolioApp(dependencies: dependencies));
    await tester.pumpAndSettle();
    for (final size in [
      const Size(320, 700),
      const Size(1200, 400),
      const Size(1400, 900),
    ]) {
      tester.view.physicalSize = size;
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
    // Unsupported browser locales fall back to the existing Portuguese catalog.
    await tester.pumpWidget(
      PortfolioApp(dependencies: dependencies, locale: const Locale('en')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Projetos Pessoais'), findsOneWidget);
    expect(repository.calls, 1);
    final context = tester.element(find.text('Projetos Pessoais'));
    expect(Localizations.localeOf(context), const Locale('pt'));
    final strings = AppLocalizations.of(context);
    expect(strings.appVersion(PortfolioContent.version), 'v1.7.0');
    expect(ProjectLinkType.download.label(strings), 'Baixar');
    expect(ProjectLinkType.unknown.label(strings), isEmpty);
  });

  testWidgets(
    'Enlarged text and link failure feedback work with localization',
    (tester) async {
      final links = FakeLinkLauncher()..result = false;
      final dependencies = fakeDependencies(
        FakeProjectRepository(() async => []),
        links,
      );
      await tester.pumpWidget(PortfolioApp(dependencies: dependencies));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('GitHub'));
      await tester.tap(find.text('GitHub'));
      await tester.pumpAndSettle();
      expect(links.lastUri, PortfolioContent.githubUrl);
      expect(find.text('Não foi possível abrir o link.'), findsOneWidget);
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Replacing injected dependencies replaces the view model', (
    tester,
  ) async {
    final first = FakeProjectRepository(() async => []);
    await tester.pumpWidget(
      PortfolioApp(dependencies: fakeDependencies(first)),
    );
    await tester.pumpAndSettle();
    final second = FakeProjectRepository(() async => []);
    await tester.pumpWidget(
      PortfolioApp(dependencies: fakeDependencies(second)),
    );
    await tester.pumpAndSettle();
    expect(first.calls, 1);
    expect(second.calls, 1);
  });
}
