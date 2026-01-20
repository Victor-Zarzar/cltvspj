import 'package:cltvspj/features/app_theme.dart';
import 'package:cltvspj/features/responsive_extension.dart';
import 'package:cltvspj/features/theme_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AppSidebar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onNavigate;

  const AppSidebar({
    super.key,
    required this.currentIndex,
    required this.onNavigate,
  });

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Consumer<UiProvider>(
      builder: (context, notifier, child) {
        return Container(
          width: 280,
          decoration: BoxDecoration(
            color: notifier.isDark
                ? AppBarColor.thirdColor
                : AppThemeColor.secondaryColor,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: notifier.isDark
                            ? IconColor.sixColor
                            : IconColor.secondaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.calculate_rounded,
                        color: IconColor.primaryColor,
                        semanticLabel: 'sidebar.app_icon'.tr(),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'app_title'.tr(),
                        style: context.h1.copyWith(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    _buildMenuItem(
                      index: 0,
                      icon: FontAwesomeIcons.house,
                      label: 'home'.tr(),
                      iconSemanticKey: 'sidebar.home_icon',
                    ),
                    _buildMenuItem(
                      index: 1,
                      icon: FontAwesomeIcons.briefcase,
                      label: 'clt'.tr(),
                      iconSemanticKey: 'sidebar.clt_icon',
                    ),
                    _buildMenuItem(
                      index: 2,
                      icon: FontAwesomeIcons.fileInvoice,
                      label: 'pj'.tr(),
                      iconSemanticKey: 'sidebar.pj_icon',
                    ),
                    _buildMenuItem(
                      index: 3,
                      icon: FontAwesomeIcons.user,
                      label: 'user'.tr(),
                      iconSemanticKey: 'sidebar.user_icon',
                    ),
                    _buildMenuItem(
                      index: 4,
                      icon: Icons.settings,
                      label: 'settings'.tr(),
                      iconSemanticKey: 'sidebar.settings_icon',
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.desktop_windows_outlined,
                      color: IconColor.primaryColor,
                      size: 18,
                      semanticLabel: 'sidebar.web_icon'.tr(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'web_version'.tr(),
                      style: context.h2.copyWith(
                        fontSize: 12,
                        color: TextColor.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required int index,
    required IconData icon,
    required String label,
    required String iconSemanticKey,
  }) {
    final bool isSelected = widget.currentIndex == index;
    final bool isHovered = _hoveredIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? TextButtonColor.sixColor.withValues(alpha: 0.15)
              : isHovered
              ? TextButtonColor.thirdColor.withValues(alpha: 0.01)
              : AppThemeColor.fifthColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? BackGroundColor.primaryColor.withValues(alpha: 0.03)
                : AppThemeColor.fifthColor,
            width: 1.5,
          ),
        ),
        child: Material(
          color: AppThemeColor.fifthColor,
          child: InkWell(
            onTap: () => widget.onNavigate(index),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.diagonal3Values(
                      isSelected ? 1.1 : 1.0,
                      isSelected ? 1.1 : 1.0,
                      1.0,
                    ),
                    child: Icon(
                      icon,
                      color: isSelected
                          ? IconColor.primaryColor
                          : IconColor.primaryColor,
                      size: 20,
                      semanticLabel: iconSemanticKey.tr(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: context.h2.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected
                            ? TextColor.primaryColor
                            : TextColor.primaryColor,
                      ),
                      child: Text(label),
                    ),
                  ),
                  if (isSelected)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: IconColor.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
