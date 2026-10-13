import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meifagundesdotcom/l10n/generated/app_localizations.dart';
import 'package:meifagundesdotcom/models/project_model.dart';
import 'package:meifagundesdotcom/ui/home/widgets/project_card.dart';

void main() {
  testWidgets('technology labels expose text rather than checkbox controls', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    addTearDown(semantics.dispose);
    await tester.pumpWidget(_host(_project(['Dart']), 'en', 1));
    await tester.pumpAndSettle();
    expect(
      tester.getSemantics(find.byKey(const ValueKey('technology-Dart'))),
      matchesSemantics(label: 'Dart'),
    );
  });
  for (final language in ['pt', 'en']) {
    for (final width in [320.0, 1000.0]) {
      for (final scale in [1.0, 2.0]) {
        testWidgets('$language card wraps at width $width and scale $scale', (
          tester,
        ) async {
          tester.view.devicePixelRatio = 1;
          tester.view.physicalSize = Size(width, 900);
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          final project = _project([
            'Dart',
            'Flutter',
            'Fixed-point arithmetic',
            List.filled(20, 'Technology').join(),
          ]);
          await tester.pumpWidget(_host(project, language, scale));
          await tester.pumpAndSettle();
          final description = project.descriptionForLanguage(language);
          expect(find.text(description.concept), findsOneWidget);
          expect(find.text(description.implementation), findsOneWidget);
          expect(find.byType(Chip), findsNWidgets(4));
          final action = find.text(
            language == 'pt' ? 'Ver no GitHub' : 'View on GitHub',
          );
          expect(action, findsOneWidget);
          expect(
            tester.getTopLeft(action).dy,
            greaterThan(tester.getBottomLeft(find.byType(Chip).last).dy),
          );
          expect(tester.takeException(), isNull);
        });
      }
    }
  }

  testWidgets('empty technology lists omit labels and keep actions', (
    tester,
  ) async {
    await tester.pumpWidget(_host(_project([]), 'pt', 1));
    await tester.pumpAndSettle();
    expect(find.byType(Chip), findsNothing);
    expect(find.text('Ver no GitHub'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

ProjectModel _project(List<String> technologies) => ProjectModel(
  title: 'A project with a long descriptive title',
  descriptions: const {
    'pt': ProjectDescription(
      concept: 'Um projeto para explorar conceitos técnicos e apresentar uma experiência acessível em diferentes tamanhos de tela.',
      implementation: 'A implementação separa apresentação e acesso a dados, com uma descrição detalhada que pode ocupar várias linhas.',
    ),
    'en': ProjectDescription(
      concept: 'A project exploring technical concepts and presenting an accessible experience across different screen sizes.',
      implementation: 'The implementation separates presentation and data access, with a detailed description that can occupy several lines.',
    ),
  },
  technologies: technologies,
  imagePath: 'https://example.test/image.png',
  links: const [
    ProjectLink(type: ProjectLinkType.source, uri: 'https://example.test'),
  ],
);

Widget _host(ProjectModel project, String language, double scale) =>
    MaterialApp(
      locale: Locale(language),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(scale)),
          child: Scaffold(
            body: SingleChildScrollView(
              child: ProjectCard(project, onOpenLink: (_) async => true),
            ),
          ),
        ),
      ),
    );
