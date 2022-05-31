
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obs_mtc_tbe3/mappings.dart';

class DiceFaceNotifier extends StateNotifier<List<DicePositions>> {
  DiceFaceNotifier(): super([DicePositions.initial, DicePositions.initial]);

  Random randomState1 = Random();
  Random randomState2 = Random();


  void reshuffle() {

    int state1 = randomState1.nextInt(6) + 1;
    int state2 = randomState1.nextInt(6) + 1;

    if (state1 == state2){
      reshuffle();
    }else {
      state = [DicePositions.values[state1], DicePositions.values[state2]];
    }
  }

}

final diceProvider = StateNotifierProvider<DiceFaceNotifier, List<DicePositions>>((ref) => DiceFaceNotifier());