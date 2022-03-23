import 'package:flutter/cupertino.dart';

class SetTest {
  final Set<Tylor> testSet = Set();
  List<String> nameList = ["Ann", "Cookie", "Jack", "Bob"];
  ValueNotifier<int> value = ValueNotifier(0);

  void add(Tylor value) {
    testSet.add(value);
  }

  Tylor pop() {
    var first = testSet.first;
    testSet.remove(first);
    return first;
  }

  Future<void> addElements() async {
    value.addListener(() {
      if (testSet.length > 0) {
        Tylor obj = pop();
        // print(obj.name);
        value.value--;
      }
    });
    for (var name in nameList) {
      await Future.delayed(Duration(seconds: 1));
      value.value += 1;
      testSet.add(Tylor(name, "12"));
    }
  }
}

class Tylor {
  final String name;
  final String age;

  Tylor(this.name, this.age);
}
