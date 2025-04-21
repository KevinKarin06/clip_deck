import 'package:clip_deck/domain/settings.dart';
import 'package:clip_deck/presentation/widgets/hotkey_input_modal.dart';
import 'package:clip_deck/services/startup_service.dart';
import 'package:clip_deck/utils/constants.dart';
import 'package:clip_deck/utils/helpers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _handleMaxHistoryChange(
    String val,
    SettingsProvider settingsProvider,
  ) async {
    toastification.dismissAll(delayForAnimation: true);
    final parsed = int.tryParse(val);

    if (parsed == null) {
      showToast('message'.tr(), type: ToastificationType.error);
      return;
    }

    if (parsed < 1) {
      showToast('max_entries_minimum'.tr(), type: ToastificationType.error);
      return;
    }

    if (parsed > Constants.maxHistoryItems) {
      showToast(
        'max_entries_maximum'.tr(args: [Constants.maxHistoryItems.toString()]),
        type: ToastificationType.error,
      );
      return;
    }

    await settingsProvider.setMaxHistoryItems(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildGroupTitle('general'.tr(), theme),
        _buildCard(
          child: SwitchListTile(
            contentPadding: EdgeInsets.all(8.0),
            secondary: Icon(LucideIcons.sunMoon),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            title: Text('theme'.tr(), style: theme.textTheme.titleMedium),
            subtitle: const Text('theme_subtitle').tr(),
            value: settingsProvider.getTheme() == Brightness.dark,
            onChanged: (val) async => {await settingsProvider.toggleTheme()},
          ),
        ),
        const SizedBox(height: 8),
        _buildCard(
          child: ListTile(
            contentPadding: EdgeInsets.all(8.0),
            leading: const Icon(LucideIcons.languages),
            title: Text('language'.tr(), style: theme.textTheme.titleMedium),
            subtitle: const Text('language_subtitle').tr(),
            trailing: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                borderRadius: BorderRadius.circular(8.0),
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                value: context.locale.toString(),
                onChanged: (value) {
                  if (value != null) {
                    context.setLocale(Locale(value));
                    settingsProvider.notify();
                  }
                },
                items:
                    ['en', 'fr']
                        .map(
                          (lang) => DropdownMenuItem(
                            value: lang,
                            child: Text('supported_languages.$lang'.tr()),
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        _buildGroupTitle('advanced'.tr(), theme),
        _buildCard(
          child: SwitchListTile(
            contentPadding: EdgeInsets.all(8.0),
            secondary: Icon(LucideIcons.rocket),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            title: Text(
              'launch_at_start'.tr(),
              style: theme.textTheme.titleMedium,
            ),
            subtitle: const Text('launch_at_start_subtitle').tr(),
            value: settingsProvider.getLaunchAtStart(),
            onChanged: (val) async {
              await GetIt.I<StartupService>().toggle(val);
              settingsProvider.notify();
            },
          ),
        ),
        const SizedBox(height: 8),
        _buildCard(
          child: ListTile(
            contentPadding: EdgeInsets.all(8.0),
            leading: const Icon(LucideIcons.keyboard),
            title: Text(
              'keyboard_shortcut'.tr(),
              style: theme.textTheme.titleMedium,
            ),
            onTap:
                () => {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return HotkeyInputModal();
                    },
                  ),
                },
            subtitle: const Text('keyboard_shortcut_subtitle').tr(),
            trailing: HotKeyVirtualView(hotKey: settingsProvider.getHotkey()),
          ),
        ),
        const SizedBox(height: 8),
        _buildCard(
          child: ListTile(
            contentPadding: EdgeInsets.all(8.0),
            leading: const Icon(LucideIcons.history),
            title: Text('max_entries'.tr(), style: theme.textTheme.titleMedium),
            subtitle: const Text('max_entries_subtitle').tr(),
            trailing: SizedBox(
              width: 120,
              child: TextFormField(
                cursorHeight: 12,
                initialValue: settingsProvider.getMaxHistoryItems().toString(),
                maxLines: 1,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                onChanged:
                    (val) => _handleMaxHistoryChange(val, settingsProvider),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGroupTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: child,
    );
  }
}
