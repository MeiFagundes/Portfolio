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
              child: DecoratedBox(
                key: ValueKey('technology-$technology'),
                decoration: ShapeDecoration(
                  color: colors.secondaryContainer,
                  shape: const StadiumBorder(),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Text(
                    technology,
                    softWrap: true,
                    style: Theme.of(context).textTheme.labelLarge
                        ?.copyWith(color: colors.onSecondaryContainer),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
