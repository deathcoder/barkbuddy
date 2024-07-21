import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatelessWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SettingsPage());
  }

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    var themeData = SettingsThemeData(
      settingsListBackground: colorScheme.surface,
      titleTextColor: colorScheme.onSurface,

      settingsSectionBackground: colorScheme.surfaceContainerHigh,
      tileHighlightColor: colorScheme.surfaceContainerHighest,
      dividerColor: colorScheme.outlineVariant,
      settingsTileTextColor: colorScheme.onSurface,
      tileDescriptionTextColor: colorScheme.onSurfaceVariant,
      trailingTextColor: colorScheme.onSurfaceVariant,
      leadingIconsColor: colorScheme.onSurfaceVariant,
      // inactiveTitleColor: not sure when this applies
      // inactiveSubtitleColor not sure when this applies
    );
    return SettingsList(
      lightTheme: themeData,
      darkTheme: themeData,
      sections: [
        SettingsSection(
          title: const Text('Services'),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              enabled: true,
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              value: const Text('English'),
            ),
          ],
        ),
      ],
    );
  }
}
