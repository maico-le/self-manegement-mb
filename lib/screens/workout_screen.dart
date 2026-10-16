import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout_model.dart';
import '../providers/workout_provider.dart';
import '../widgets/pixel_icons.dart';
import '../widgets/pixel_widgets.dart';

class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercises = ref.watch(exercisesProvider);
    final completedCount = exercises.where((e) => e.isCompletedToday).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        shape: const Border(
          bottom: BorderSide(color: Colors.black, width: 2),
        ),
        title: const Row(
          children: [
            PixelDumbbellIcon(size: 20),
            SizedBox(width: 8),
            Text(
              'BÀI TẬP THỂ DỤC (GYM & PLANK)',
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w900,
                fontSize: 14,
                color: Color(0xFF1E1E1E),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Gym Overview Banner
            PixelCard(
              backgroundColor: const Color(0xFF0F172A),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const PixelDumbbellIcon(size: 36),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'RÈN LUYỆN SỨC MẠNH',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            color: Color(0xFFFA520F),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Đã hoàn thành hôm nay: $completedCount/${exercises.length} bài tập\n'
                          'Hỗ trợ đếm ngược Plank có chuông báo thức ⏰',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            color: Color(0xFFCBD5E1),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. Action row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'DANH SÁCH BÀI TẬP',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                PixelButton(
                  isSmall: true,
                  backgroundColor: const Color(0xFF16A34A),
                  onPressed: () => _showCreateExerciseDialog(context, ref),
                  child: const Row(
                    children: [
                      Icon(Icons.add, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text('TẠO BÀI TẬP MỚI'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 3. Exercise Cards
            for (final ex in exercises) ...[
              _buildExerciseCard(context, ref, ex),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context, WidgetRef ref, ExerciseItem ex) {
    final isDone = ex.isCompletedToday;

    return PixelCard(
      backgroundColor: Colors.white,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ex.type == ExerciseType.duration ? const Color(0xFFFEF3C7) : const Color(0xFFF1F5F9),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Icon(
                  ex.type == ExerciseType.duration ? Icons.timer_outlined : Icons.fitness_center,
                  size: 22,
                  color: ex.type == ExerciseType.duration ? const Color(0xFFFA520F) : const Color(0xFF0284C7),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ex.name,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ex.summaryLabel,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (isDone)
                const PixelBadge(
                  text: 'HOÀN THÀNH ✅',
                  backgroundColor: Color(0xFF16A34A),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Action row
          if (ex.type == ExerciseType.duration)
            // Duration Countdown Button (Plank)
            PixelButton(
              isSmall: true,
              backgroundColor: const Color(0xFFFA520F),
              onPressed: () {
                _openCountdownSheet(context, ref, ex);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_circle_outline, size: 16, color: Colors.white),
                  const SizedBox(width: 6),
                  Text('BẮT ĐẦU ĐẾM NGƯỢC (${ex.durationSeconds}s)'),
                ],
              ),
            )
          else
            // Reps Set Progress Button
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Hiệp: ${ex.completedSetsToday}/${ex.targetSets}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                ),
                PixelButton(
                  isSmall: true,
                  backgroundColor: isDone ? const Color(0xFF94A3B8) : const Color(0xFF0284C7),
                  onPressed: isDone
                      ? null
                      : () {
                          ref.read(exercisesProvider.notifier).incrementSet(ex.id);
                        },
                  child: Row(
                    children: [
                      const Icon(Icons.check, size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(isDone ? 'ĐÃ ĐỦ SET' : '+1 HIỆP (${ex.targetReps} reps)'),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _openCountdownSheet(BuildContext context, WidgetRef ref, ExerciseItem ex) {
    ref.read(exerciseTimerProvider.notifier).loadExercise(ex);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (ctx) => Consumer(
        builder: (context, ref, _) {
          final timerState = ref.watch(exerciseTimerProvider);
          final isRunning = timerState.status == ExerciseTimerStatus.running;
          final isFinished = timerState.status == ExerciseTimerStatus.finished;

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '⏱️ ${ex.name.toUpperCase()}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Cố lên! Khi hết giờ ứng dụng sẽ đổ chuông báo thức ⏰',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 20),

                // Countdown screen box
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    border: Border.all(color: Colors.black, width: 3),
                    boxShadow: const [
                      BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        timerState.formattedTime,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 60,
                          fontWeight: FontWeight.w900,
                          color: isFinished
                              ? const Color(0xFF22C55E)
                              : (isRunning ? const Color(0xFFFA520F) : Colors.white),
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isFinished
                            ? '🎉 XUẤT SẮC! ĐÃ HOÀN THÀNH!'
                            : (isRunning ? '💪 ĐANG GIỮ TƯ THẾ...' : 'SẴN SÀNG'),
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isFinished ? const Color(0xFF22C55E) : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Controls
                Row(
                  children: [
                    if (!isFinished) ...[
                      Expanded(
                        child: PixelButton(
                          backgroundColor: isRunning ? const Color(0xFFFFAF00) : const Color(0xFF16A34A),
                          textColor: isRunning ? Colors.black : Colors.white,
                          onPressed: () {
                            if (isRunning) {
                              ref.read(exerciseTimerProvider.notifier).pause();
                            } else {
                              ref.read(exerciseTimerProvider.notifier).start();
                            }
                          },
                          child: Center(
                            child: Text(isRunning ? 'TẠM DỪNG' : 'BẮT ĐẦU'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: PixelButton(
                          backgroundColor: const Color(0xFF64748B),
                          onPressed: () {
                            ref.read(exerciseTimerProvider.notifier).reset();
                          },
                          child: const Center(child: Text('ĐẶT LẠI')),
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        child: PixelButton(
                          backgroundColor: const Color(0xFF16A34A),
                          onPressed: () => Navigator.pop(ctx),
                          child: const Center(child: Text('ĐÓNG')),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCreateExerciseDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    ExerciseType selectedType = ExerciseType.duration;
    int durationSecs = 60;
    int reps = 15;
    int sets = 3;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          backgroundColor: Colors.white,
          title: const Text(
            'TẠO BÀI TẬP MỚI',
            style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w900, fontSize: 14),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Tên bài tập:',
                  style: TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'VD: Plank nghiêng, Gập bụng, Nhảy dây...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                    isDense: true,
                  ),
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
                const SizedBox(height: 14),

                const Text(
                  'Kiểu bài tập:',
                  style: TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                DropdownButton<ExerciseType>(
                  value: selectedType,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                      value: ExerciseType.duration,
                      child: Text('⏱️ Thời gian (Đếm ngược Plank)'),
                    ),
                    DropdownMenuItem(
                      value: ExerciseType.reps,
                      child: Text('🔢 Số lần (Reps x Sets)'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => selectedType = val);
                  },
                ),
                const SizedBox(height: 14),

                if (selectedType == ExerciseType.duration) ...[
                  const Text(
                    'Thời gian đếm ngược:',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    children: [
                      for (final s in [30, 45, 60, 90, 120])
                        GestureDetector(
                          onTap: () => setState(() => durationSecs = s),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: durationSecs == s ? const Color(0xFFFA520F) : const Color(0xFFF1F5F9),
                              border: Border.all(color: Colors.black, width: 1.5),
                            ),
                            child: Text(
                              '${s}s',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: durationSecs == s ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Số Reps:', style: TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            TextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: '15',
                                border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                                isDense: true,
                              ),
                              onChanged: (val) => reps = int.tryParse(val) ?? 15,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Số Sets:', style: TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            TextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: '3',
                                border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                                isDense: true,
                              ),
                              onChanged: (val) => sets = int.tryParse(val) ?? 3,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
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
              backgroundColor: const Color(0xFF16A34A),
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  ref.read(exercisesProvider.notifier).addExercise(
                    name: name,
                    type: selectedType,
                    durationSeconds: durationSecs,
                    targetReps: reps,
                    targetSets: sets,
                  );
                  Navigator.pop(ctx);
                }
              },
              child: const Text('LƯU BÀI TẬP'),
            ),
          ],
        ),
      ),
    );
  }
}
