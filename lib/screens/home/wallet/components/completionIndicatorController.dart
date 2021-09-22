

class CompletionIndicatorController {

  List<Function(int)>? onChange =[];

  void subscribe(Function(int) onChange) {
    this.onChange?.add(onChange);
    print("Subscription performed!");
  }


  void call(int index) {
    for(int i = 0; i < (onChange?.length as int); i ++) {
      onChange?[i].call(index);
    }

  }


}