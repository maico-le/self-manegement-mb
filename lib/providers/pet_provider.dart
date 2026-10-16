import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pet_model.dart';
import '../services/storage_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('storageServiceProvider must be initialized in main()');
});

class PetNotifier extends Notifier<PixelPet> {
  final List<String> _happyQuotes = [
    'Tuyệt vời quá! Mình cảm thấy tràn đầy năng lượng! ✨',
    'Bạn siêu thật đấy! Cứ tiếp tục chuỗi phong độ này nhé! 🚀',
    'Hoan hô! Mình sắp tiến hóa lên hình thái mới rồi! 💖',
    'Một phiên tập trung hoàn hảo! Bạn là số một! 🌟',
    'Cảm giác tập trung xong thật sảng khoái đúng không nào! 🎉',
  ];

  final List<String> _sadQuotes = [
    'Huhu... đừng bỏ cuộc giữa chừng mà! 😭',
    'Mình buồn xỉu luôn á... Cố thêm một xíu nữa thôi mà! 💔',
    'Dừng lại rồi à... Mình cảm thấy yếu đi rồi... 😢',
  ];

  final List<String> _idleQuotes = [
    'Bấm giờ Pomodoro đi, mình cùng đồng hành với bạn nhé! ⏰',
    'Hôm nay bạn đã tập thể dục và học tiếng chưa? 🔥',
    'Chạm vào mình để nhận năng lượng tích cực nè! 🐾',
    'Mỗi 25 phút tập trung là một bước giúp mình lớn lên! 🥚',
  ];

  @override
  PixelPet build() {
    final storage = ref.watch(storageServiceProvider);
    return storage.loadPet();
  }

  Future<void> onPomodoroCompleted({required int minutesFocused}) async {
    final expGained = max(10, (minutesFocused * 1.0).round());
    final newExp = state.currentExp + expGained;
    final random = Random();
    final quote = _happyQuotes[random.nextInt(_happyQuotes.length)];

    final updated = state.copyWith(
      currentExp: newExp,
      totalPomodorosCompleted: state.totalPomodorosCompleted + 1,
      totalMinutesFocused: state.totalMinutesFocused + minutesFocused,
      mood: PetMood.happy,
      speechText: quote,
      lastInteraction: DateTime.now(),
    );

    // Check level up
    final newLevel = updated.calculatedLevel;
    final finalPet = updated.copyWith(level: newLevel);

    state = finalPet;
    await ref.read(storageServiceProvider).savePet(finalPet);
  }

  Future<void> onPomodoroGivenUp() async {
    final random = Random();
    final quote = _sadQuotes[random.nextInt(_sadQuotes.length)];

    final updated = state.copyWith(
      giveUpCount: state.giveUpCount + 1,
      mood: PetMood.sad,
      speechText: quote,
      lastInteraction: DateTime.now(),
    );

    state = updated;
    await ref.read(storageServiceProvider).savePet(updated);
  }

  Future<void> tapPet() async {
    final random = Random();
    final quote = state.mood == PetMood.sad
        ? 'Bạn an ủi mình à? Cảm ơn bạn, cùng thử lại một phiên nữa nhé! 🥺'
        : _idleQuotes[random.nextInt(_idleQuotes.length)];

    final updated = state.copyWith(
      mood: state.mood == PetMood.sad ? PetMood.neutral : PetMood.happy,
      speechText: quote,
      lastInteraction: DateTime.now(),
    );

    state = updated;
    await ref.read(storageServiceProvider).savePet(updated);
  }

  Future<void> renamePet(String newName) async {
    if (newName.trim().isEmpty) return;
    final updated = state.copyWith(name: newName.trim());
    state = updated;
    await ref.read(storageServiceProvider).savePet(updated);
  }
}

final petProvider = NotifierProvider<PetNotifier, PixelPet>(PetNotifier.new);
