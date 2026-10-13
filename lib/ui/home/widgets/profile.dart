import 'package:flutter/material.dart';
import 'package:meifagundesdotcom/app/portfolio_content.dart';
import 'package:meifagundesdotcom/l10n/generated/app_localizations.dart';
import 'package:meifagundesdotcom/ui/core/custom_icons.dart';
import 'package:meifagundesdotcom/ui/core/text_styles.dart';

class Profile extends StatelessWidget {
  final Future<bool> Function(String) onOpenLink;

  const Profile({super.key, required this.onOpenLink});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    const spacer = SizedBox(height: 10);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircleAvatar(
          backgroundImage: AssetImage(PortfolioContent.imageAsset),
          backgroundColor: Colors.transparent,
          maxRadius: 100,
        ),
        spacer,
        Text(PortfolioContent.name, style: TextStyles.profileName),
        spacer,
        const Row(
          children: [
            Spacer(),
            Expanded(flex: 8, child: Divider()),
            Spacer(),
          ],
        ),
        spacer,
        Center(
          child: Text(
            localizations.profileDescription,
            style: TextStyles.profileDescription,
            textAlign: TextAlign.center,
          ),
        ),
        spacer,
        const Row(
          children: [
            Spacer(),
            Expanded(flex: 8, child: Divider()),
            Spacer(),
          ],
        ),
        spacer,
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: [
            TextButton.icon(
              onPressed: () => _open(context, PortfolioContent.emailUrl),
              icon: const Icon(Icons.email, color: Colors.pinkAccent),
              label: Text(localizations.email),
            ),
            TextButton.icon(
              onPressed: () => _open(context, PortfolioContent.githubUrl),
              icon: const Icon(CustomIcons.github, color: Colors.pinkAccent),
              label: Text(localizations.github),
            ),
            TextButton.icon(
              onPressed: () => _open(context, PortfolioContent.linkedinUrl),
              icon: const Icon(CustomIcons.linkedin, color: Colors.pinkAccent),
              label: Text(localizations.linkedin),
            ),
          ],
        ),
        spacer,
      ],
    );
  }

  Future<void> _open(BuildContext context, String uri) async {
    if (!await onOpenLink(uri) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).linkOpenError)),
      );
    }
  }
}
