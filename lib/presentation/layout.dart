import 'package:clip_deck/presentation/screens/home.dart';
import 'package:clip_deck/presentation/screens/settings.dart';
import 'package:clip_deck/presentation/widgets/shortcut_hint.dart';
import 'package:clip_deck/presentation/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _currentIndex = 0;
  final List<SidebarItem> _sidebarItems = [
    SidebarItem(
      title: 'history',
      icon: LucideIcons.clipboardList,
      content: HomeScreen(),
    ),
    SidebarItem(
      title: 'settings',
      icon: LucideIcons.settings,
      content: SettingsScreen(),
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Sidebar(
          items: _sidebarItems,
          currentIndex: _currentIndex,
          onItemSelected: _changePage,
          bottomWidget: ShortcutHintCard(),
        ),
        const VerticalDivider(width: 0),
        Expanded(
          child: IndexedStack(
            index: _currentIndex,
            children: _sidebarItems.map((item) => item.content).toList(),
          ),
        ),
      ],
    );
  }

  void _changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
