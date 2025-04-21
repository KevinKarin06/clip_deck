import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SidebarItem {
  final String title;
  final IconData icon;
  final Widget content;

  const SidebarItem({
    required this.title,
    required this.icon,
    required this.content,
  });
}

class Sidebar extends StatelessWidget {
  final List<SidebarItem> items;
  final int currentIndex;
  final Function(int) onItemSelected;
  final Widget? bottomWidget;
  final double? width;

  const Sidebar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onItemSelected,
    this.bottomWidget,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 16.0),
      width: width ?? MediaQuery.of(context).size.width * 0.35,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          ..._buildMenuItems(context),
          const Spacer(),
          if (bottomWidget != null)
            Padding(padding: const EdgeInsets.all(8.0), child: bottomWidget!),
        ],
      ),
    );
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    return List.generate(items.length, (index) {
      return _buildSidebarItem(context, item: items[index], index: index);
    });
  }

  Widget _buildSidebarItem(
    BuildContext context, {
    required SidebarItem item,
    required int index,
  }) {
    final bool isSelected = currentIndex == index;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => onItemSelected(index),
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          height: 40.0,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Icon(
                item.icon,
                color:
                    isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 12.0),
              Text(
                item.title.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color:
                      isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
