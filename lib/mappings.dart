import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';



enum DicePositions {initial, one, two, three, four, five, six}

extension DiceIcons on DicePositions {
  IconData get diceIconData {
    switch(this){
      case DicePositions.one:
        return UniconsLine.dice_one;

      case DicePositions.five:
        return UniconsLine.dice_five;

      case DicePositions.two:
        return UniconsLine.dice_two;

      case DicePositions.three:
        return UniconsLine.dice_three;

      case DicePositions.four:
        return UniconsLine.dice_four;

      case DicePositions.six:
        return UniconsLine.dice_six;

        default:
          return UniconsLine.x;
  }
}

  String get questionsData {
     switch(this) {

       case DicePositions.one:
         return "If you had a chance for a \"do-over\" in life, what would you do differently?";

       case DicePositions.two:
         return "What 3 things you love & 3 things you think are faulty about your work & passions?";

       case DicePositions.three:
         return "How have your priorities or your interest is various fields changed over time?";

       case DicePositions.four:
         return "Where do you see yourself 5 years down the lane?";

       case DicePositions.five:
         return "How do you think the world has changed over the last decade, and how it will continue to change according to you? (Specifically talk about the world of your respective expertise)";

       case DicePositions.six:
         return "Do you live to work or work to live?";

       default:
         return "Roll the Die to view your Questions";

     }
  }

  int get diceFaceValue {
    switch(this) {

      case DicePositions.one:
        return 1;

      case DicePositions.two:
        return 2;

      case DicePositions.three:
        return 3;

      case DicePositions.four:
        return 4;

      case DicePositions.five:
        return 5;

      case DicePositions.six:
        return 6;

      default:
        return 0;

    }
  }
}