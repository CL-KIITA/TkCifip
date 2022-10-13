import 'package:stack/stack.dart';

extension CSN2NumList on String {
  List<N> csn2list<N>() {
    Iterable<N> t = this.split(",").map<String>((String e) => e.trim()).map<N>((String e) {
      switch (N) {
        case int:
          return int.parse(e) as N;
        case double:
          return double.parse(e) as N;
        case num:
          return num.parse(e) as N;
        default:
          throw Error();
      }
    });
    return t.toList();
  }
}

extension Num2Hex<N extends num> on N {
  String toHex([int len = 2]) {
    String t = this.floor().toRadixString(16);
    if (t.length == len) {
      return t;
    } else if (t.length > len) {
      return t.split("").reversed.take(len).toList().reversed.join("");
    } else {
      return t.padLeft(len, "0");
    }
  }
}
extension StackIterate<T> on Stack<T> {
  List<T> take(int n) {
    List<T> e = [];
    for(int i = 0; i < n ; i++){
      e.add(this.pop());
    }
    return e;
  }
  void pushAll(List<T> e) {
    for(int i = 0; i < e.length ; i++){
      this.push(e[i]);
    }
  }
}