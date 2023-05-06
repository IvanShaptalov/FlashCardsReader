class BlurProvider {
  static bool blurred = true;

  static void resetBlur() {
    blurred = true;
  }

}

class SwapWordsProvider {
  static bool swap = false;

  static void resetSwap() {
    swap = false;
  }

  static void swapIt() {
    swap = !swap;
  }

}
