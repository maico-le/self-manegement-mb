import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/pixel_icons.dart';
import 'tabs/evolution_tab.dart';
import 'tabs/focus_pet_tab.dart';
import 'tabs/settings_tab.dart';
import 'tabs/streaks_tab.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const FocusPetTab(),
      StreaksTab(onNavigateTab: (index) {
        setState(() => _currentIndex = index);
      }),
      const EvolutionTab(),
      const SettingsTab(),
    ];

    const tabTitles = [
      'FOCUS & THÚ CƯNG',
      'CHUỖI STREAK',
      'TIẾN HÓA & KHO BÁU',
      'CÀI ĐẶT',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        shape: const Border(
          bottom: BorderSide(color: Colors.black, width: 2),
        ),
        title: Row(
          children: [
            const PixelFlameIcon(size: 20),
            const SizedBox(width: 8),
            Text(
              tabTitles[_currentIndex],
              style: const TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w900,
                fontSize: 15,
                color: Color(0xFF1E1E1E),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: tabs,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.black, width: 2),
          ),
        ),
        child: SafeArea(
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              children: [
                _buildNavItem(
                  index: 0,
                  label: 'Focus',
                  icon: Icons.timer,
                ),
                _buildNavItem(
                  index: 1,
                  label: 'Streaks',
                  icon: Icons.local_fire_department,
                ),
                _buildNavItem(
                  index: 2,
                  label: 'Tiến Hóa',
                  icon: Icons.emoji_events,
                ),
                _buildNavItem(
                  index: 3,
                  label: 'Cài Đặt',
                  icon: Icons.settings,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFA520F) : Colors.transparent,
            border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
