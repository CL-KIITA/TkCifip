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
extension StringLocation on String{
  List<int> allIndexesOf(Pattern pattern){
    int loc = 0;
    int temp = 0;
    List<int> res = [];
    while(true){
      if(loc > this.length){
        break;
      }
      temp = this.indexOf(pattern, loc);
      if(temp < 0){
        break;
      }
      res.add(temp);
      loc = temp + 1;
    }
    return res;
  }
  int counts(Pattern pattern){
    int loc = 0;
    int temp = 0;
    int count = 0;
    while(true){
      if(loc > this.length){
        break;
      }
      temp = this.indexOf(pattern, loc);
      if(temp < 0){
        break;
      }
      count++;
      loc = temp + 1;
    }
    return count;
  }
}
class Range<E extends num>{
  final E start;
  final E end;
  final E interv;
  const Range(this.start, this.end, [E? interv]): this.interv = interv != null ? interv : 1 as E;
  List<E> toList() => List<E>.generate(((this.end - this.start) / this.interv).floor(), (int index) => this.start + this.interv * index as E);
  List<E> call() => this.toList();
}
extension IndexedMap<E> on List<E> {
  List<R> indexedMap<R>(R Function(int,E) fn) => this.asMap().map<int,R>((int key, E value) => MapEntry(key, fn(key, value))).values.toList();
}