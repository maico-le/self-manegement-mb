import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/pet_model.dart';
import '../../providers/pet_provider.dart';
import '../../widgets/pixel_pet_view.dart';
import '../../widgets/pixel_widgets.dart';

class EvolutionTab extends ConsumerWidget {
  const EvolutionTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pet = ref.watch(petProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Overall Stats Card
            PixelCard(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'THÀNH TÍCH TẬP TRUNG',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildStatBox(
                        title: 'TỔNG PHÚT',
                        value: '${pet.totalMinutesFocused}',
                        subtitle: 'phút tập trung',
                        color: const Color(0xFFFA520F),
                      ),
                      const SizedBox(width: 8),
                      _buildStatBox(
                        title: 'POMODORO',
                        value: '${pet.totalPomodorosCompleted}',
                        subtitle: 'phiên hoàn thành',
                        color: const Color(0xFF16A34A),
                      ),
                      const SizedBox(width: 8),
                      _buildStatBox(
                        title: 'BỎ CUỘC',
                        value: '${pet.giveUpCount}',
                        subtitle: 'lần bỏ dở',
                        color: const Color(0xFFEF4444),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Evolution Roadmap
            const Text(
              'CÁC GIAI ĐOẠN TIẾN HÓA',
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w900,
                fontSize: 12,
                color: Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 10),

            _buildStageCard(
              stage: PetStage.egg,
              title: 'Giai đoạn 1: Trứng Pixel 🥚',
              levelReq: 'Cấp độ 1 (0 - 50 EXP)',
              desc: 'Quả trứng ban đầu được sưởi ấm bằng sự tập trung mỗi ngày.',
              isUnlocked: pet.currentExp >= PetStage.egg.minExp,
              isCurrent: pet.stage == PetStage.egg,
              samplePet: PixelPet(
                name: pet.name,
                currentExp: 10,
                lastInteraction: DateTime.now(),
              ),
            ),
            const SizedBox(height: 12),

            _buildStageCard(
              stage: PetStage.baby,
              title: 'Giai đoạn 2: Thú Con Bé Bỏng 🐣',
              levelReq: 'Cấp độ 2 - 4 (51 - 150 EXP)',
              desc: 'Chú thú con nở ra, rất thích được cùng bạn học tập và rèn luyện thể thao.',
              isUnlocked: pet.currentExp >= PetStage.baby.minExp,
              isCurrent: pet.stage == PetStage.baby,
              samplePet: PixelPet(
                name: pet.name,
                currentExp: 80,
                lastInteraction: DateTime.now(),
              ),
            ),
            const SizedBox(height: 12),

            _buildStageCard(
              stage: PetStage.teen,
              title: 'Giai đoạn 3: Thiếu Niên Năng Động 🦊',
              levelReq: 'Cấp độ 5 - 9 (151 - 350 EXP)',
              desc: 'Được trang bị băng đô rèn luyện, sức bền và độ tập trung tăng cao.',
              isUnlocked: pet.currentExp >= PetStage.teen.minExp,
              isCurrent: pet.stage == PetStage.teen,
              samplePet: PixelPet(
                name: pet.name,
                currentExp: 200,
                lastInteraction: DateTime.now(),
              ),
            ),
            const SizedBox(height: 12),

            _buildStageCard(
              stage: PetStage.adult,
              title: 'Giai đoạn 4: Dũng Sĩ Trưởng Thành 🦁',
              levelReq: 'Cấp độ 10 - 19 (351 - 700 EXP)',
              desc: 'Thân hình oai vệ, cánh hào quang và phong thái kiên trì bất khuất.',
              isUnlocked: pet.currentExp >= PetStage.adult.minExp,
              isCurrent: pet.stage == PetStage.adult,
              samplePet: PixelPet(
                name: pet.name,
                currentExp: 450,
                lastInteraction: DateTime.now(),
              ),
            ),
            const SizedBox(height: 12),

            _buildStageCard(
              stage: PetStage.mythic,
              title: 'Giai đoạn 5: Thần Thú Tối Thượng 👑✨',
              levelReq: 'Cấp độ 20+ (701+ EXP)',
              desc: 'Hóa thân thần thú vương giả với vương miện hoàng kim, biểu tượng của sự kiên trì vượt bậc!',
              isUnlocked: pet.currentExp >= PetStage.mythic.minExp,
              isCurrent: pet.stage == PetStage.mythic,
              samplePet: PixelPet(
                name: pet.name,
                currentExp: 1000,
                lastInteraction: DateTime.now(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 8,
                color: Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageCard({
    required PetStage stage,
    required String title,
    required String levelReq,
    required String desc,
    required bool isUnlocked,
    required bool isCurrent,
    required PixelPet samplePet,
  }) {
    return PixelCard(
      backgroundColor: isCurrent ? const Color(0xFFFEF3C7) : (isUnlocked ? Colors.white : const Color(0xFFF1F5F9)),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: isUnlocked ? Colors.white : const Color(0xFFE2E8F0),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: isUnlocked
                ? PixelPetView(pet: samplePet, size: 60)
                : const Center(
                    child: Icon(Icons.lock, size: 24, color: Color(0xFF94A3B8)),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          color: isUnlocked ? const Color(0xFF1E1E1E) : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                    if (isCurrent)
                      const PixelBadge(
                        text: 'HIỆN TẠI',
                        backgroundColor: Color(0xFFFA520F),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  levelReq,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFA520F),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10,
                    color: Color(0xFF64748B),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
