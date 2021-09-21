

class CompletionIndicatorController {

  Function(int)? onChange;

  void subscribe(Function(int) onChange) {
    this.onChange = onChange;
  }


  void call(int index) {
    onChange?.call(index);
  }
}