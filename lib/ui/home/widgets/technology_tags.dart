import 'package:flutter/material.dart';

/// Technology labels are content, not links or interactive filters.
class TechnologyTags extends StatelessWidget {
  const TechnologyTags({super.key, required this.technologies});

  final List<String> technologies;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) => Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final technology in technologies)
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth),
              child: Chip(
                label: Text(technology, softWrap: true),
                labelStyle: Theme.of(context).textTheme.labelLarge
                    ?.copyWith(color: colors.onSecondaryContainer),
                backgroundColor: colors.secondaryContainer,
                side: BorderSide.none,
                shape: const StadiumBorder(),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
        ],
      ),
    );
  }
}
