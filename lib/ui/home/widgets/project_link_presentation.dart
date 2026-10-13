import 'package:flutter/material.dart';
import 'package:meifagundesdotcom/l10n/generated/app_localizations.dart';
import 'package:meifagundesdotcom/models/project_model.dart';
import 'package:meifagundesdotcom/ui/core/custom_icons.dart';

extension ProjectLinkPresentation on ProjectLinkType {
  IconData get icon => switch (this) {
    ProjectLinkType.launch => Icons.launch_rounded,
    ProjectLinkType.download => Icons.download,
    ProjectLinkType.source => CustomIcons.github,
    ProjectLinkType.unknown => Icons.circle,
  };

  String label(AppLocalizations localizations) => switch (this) {
    ProjectLinkType.launch => localizations.openProject,
    ProjectLinkType.download => localizations.downloadProject,
    ProjectLinkType.source => localizations.viewSource,
    ProjectLinkType.unknown => '',
  };

  bool get isHighlighted => this == ProjectLinkType.launch;
}
