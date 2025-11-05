import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  bool _isFabPressed = false;
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.home,
                    iconOutlined: Icons.home_outlined,
                    label: 'Início',
                    index: 0,
                  ),
                  _buildNavItem(
                    icon: Icons.description,
                    iconOutlined: Icons.description_outlined,
                    label: 'Fichas',
                    index: 1,
                  ),
                  const SizedBox(width: 64),
                  _buildNavItem(
                    icon: Icons.show_chart,
                    iconOutlined: Icons.show_chart_outlined,
                    label: 'Evolução',
                    index: 3,
                  ),
                  _buildNavItem(
                    icon: Icons.person,
                    iconOutlined: Icons.person_outline,
                    label: 'Perfil',
                    index: 4,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: -20,
            child: Center(
              child: GestureDetector(
                onTapDown: (_) => setState(() => _isFabPressed = true),
                onTapUp: (_) {
                  setState(() => _isFabPressed = false);
                  widget.onTap(2);
                },
                onTapCancel: () => setState(() => _isFabPressed = false),
                child: AnimatedScale(
                  scale: _isFabPressed ? 0.9 : 1.0,
                  duration: const Duration(milliseconds: 100),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add,
                      color: AppColors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData iconOutlined,
    required String label,
    required int index,
  }) {
    final isSelected = widget.currentIndex == index;
    final isHovered = _hoveredIndex == index;

    return Expanded(
      child: MouseRegion(
        onEnter: (_) => setState(() => _hoveredIndex = index),
        onExit: (_) => setState(() => _hoveredIndex = null),
        cursor: SystemMouseCursors.click,
        child: InkWell(
          onTap: () => widget.onTap(index),
          splashColor: AppColors.primary.withOpacity(0.1),
          highlightColor: AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isHovered && !isSelected
                  ? AppColors.primary.withOpacity(0.05)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedScale(
                  scale: isHovered ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? icon : iconOutlined,
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    letterSpacing: 0.015,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
