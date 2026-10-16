import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/pomodoro_model.dart';
import '../../providers/pet_provider.dart';
import '../../providers/pomodoro_provider.dart';
import '../../services/notification_service.dart';
import '../../widgets/pixel_widgets.dart';

class SettingsTab extends ConsumerStatefulWidget {
  const SettingsTab({super.key});

  @override
  ConsumerState<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends ConsumerState<SettingsTab> {
  late int _focusMinutes;
  late int _breakMinutes;
  late bool _reminderEnabled;

  @override
  void initState() {
    super.initState();
    final storage = ref.read(storageServiceProvider);
    _focusMinutes = storage.getFocusDurationMinutes();
    _breakMinutes = storage.getShortBreakMinutes();
    _reminderEnabled = storage.isDailyReminderEnabled();
  }

  @override
  Widget build(BuildContext context) {
    final pet = ref.watch(petProvider);
    final storage = ref.watch(storageServiceProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Rename Pet
            const Text(
              'THÚ CƯNG PIXEL',
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w900,
                fontSize: 12,
                color: Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 8),
            PixelCard(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Icon(Icons.pets, size: 20, color: Color(0xFFFA520F)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tên thú cưng hiện tại:',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        Text(
                          pet.name,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E1E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  PixelButton(
                    isSmall: true,
                    backgroundColor: const Color(0xFFFA520F),
                    onPressed: () => _showRenameDialog(context, ref, pet.name),
                    child: const Text('ĐỔI TÊN'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 2. Pomodoro Duration Settings
            const Text(
              'THỜI GIAN POMODORO FOCUS',
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w900,
                fontSize: 12,
                color: Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 8),
            PixelCard(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thời lượng mỗi phiên tập trung:',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      for (final m in [15, 25, 30, 45]) ...[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: PixelButton(
                              isSmall: true,
                              backgroundColor: _focusMinutes == m
                                  ? const Color(0xFFFA520F)
                                  : const Color(0xFFE2E8F0),
                              textColor: _focusMinutes == m ? Colors.white : const Color(0xFF1E1E1E),
                              onPressed: () async {
                                setState(() => _focusMinutes = m);
                                await storage.setFocusDurationMinutes(m);
                                ref.read(pomodoroProvider.notifier).setMode(PomodoroMode.focus);
                              },
                              child: Center(child: Text('$m phút')),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 3. Short Break Duration
            const Text(
              'THỜI GIAN NGHỈ NGƠI (BREAK)',
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w900,
                fontSize: 12,
                color: Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 8),
            PixelCard(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  for (final b in [5, 10, 15]) ...[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: PixelButton(
                          isSmall: true,
                          backgroundColor: _breakMinutes == b
                              ? const Color(0xFF0284C7)
                              : const Color(0xFFE2E8F0),
                          textColor: _breakMinutes == b ? Colors.white : const Color(0xFF1E1E1E),
                          onPressed: () async {
                            setState(() => _breakMinutes = b);
                            await storage.setShortBreakMinutes(b);
                            ref.read(pomodoroProvider.notifier).setMode(PomodoroMode.shortBreak);
                          },
                          child: Center(child: Text('$b phút')),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 4. Daily Streak Reminder Notifications
            const Text(
              'NHẮC NHỞ DUY TRÌ STREAK (20:00 HÀNG NGÀY)',
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w900,
                fontSize: 12,
                color: Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 8),
            PixelCard(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.notifications_active_outlined, size: 20, color: Color(0xFFFA520F)),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nhắc nhở chuỗi vào buổi tối',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E1E),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Nhắc tập thể dục & học ngoại ngữ trước khi hết ngày.',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _reminderEnabled,
                        activeThumbColor: const Color(0xFFFA520F),
                        onChanged: (val) async {
                          setState(() => _reminderEnabled = val);
                          await storage.setDailyReminderEnabled(val);
                          if (val) {
                            await NotificationService.instance.scheduleDailyStreakReminder();
                          } else {
                            await NotificationService.instance.cancelDailyReminder();
                          }
                        },
                      ),
                    ],
                  ),
                  if (_reminderEnabled) ...[
                    const Divider(height: 20, thickness: 1, color: Color(0xFFE2E8F0)),
                    PixelButton(
                      isSmall: true,
                      backgroundColor: const Color(0xFF0284C7),
                      onPressed: () async {
                        await NotificationService.instance.showTimerCompleteNotification(
                          title: '🔥 [Thử nghiệm] Nhắc nhở Streak & Thú cưng!',
                          body: 'Pixie đang đợi bạn hoàn thành phiên Tập thể dục và Học bài hôm nay!',
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đã gửi thông báo thử nghiệm! Hãy kéo thanh thông báo để xem.'),
                              backgroundColor: Color(0xFF1E1E1E),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send, size: 14, color: Colors.white),
                          SizedBox(width: 6),
                          Text('GỬI THỬ THÔNG BÁO'),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 5. About App
            const Text(
              'THÔNG TIN ỨNG DỤNG',
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w900,
                fontSize: 12,
                color: Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 8),
            PixelCard(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(14),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SELF FOCUS PIXEL (RETRO MISTRAL)',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      color: Color(0xFFFA520F),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '• Ý tưởng: Focus timer Pomodoro kết hợp nuôi thú ảo Pixel.\n'
                    '• Quy tắc: Hoàn thành phiên thì thú lớn lên, bỏ giữa chừng thì thú buồn.\n'
                    '• Chuỗi Streak: Tập thể dục (Gym 🏋️), Học English 🇬🇧, Học Japanese 🇯🇵.\n'
                    '• Thiết kế: Retro Pixel Art, viền đen sắc nét, đổ bóng phẳng offset.\n'
                    '• Kho lưu trữ: https://github.com/maico-le/self-manegement-mb.git',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Color(0xFF475569),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRenameDialog(BuildContext context, WidgetRef ref, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: Colors.white,
        title: const Text(
          'ĐẶT TÊN THÚ CƯNG',
          style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w900, fontSize: 14),
        ),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Nhập tên mới (VD: Piku, Mochi, Sparky...)',
            border: OutlineInputBorder(borderRadius: BorderRadius.zero),
            isDense: true,
          ),
          style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
        ),
        actions: [
          PixelButton(
            isSmall: true,
            backgroundColor: const Color(0xFF64748B),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('HỦY'),
          ),
          PixelButton(
            isSmall: true,
            backgroundColor: const Color(0xFFFA520F),
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                ref.read(petProvider.notifier).renamePet(newName);
                Navigator.pop(ctx);
              }
            },
            child: const Text('LƯU'),
          ),
        ],
      ),
    );
  }
}
