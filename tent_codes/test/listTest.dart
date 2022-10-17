import 'package:tent_codes/src/cosl/types.dart';

void main() {
  print("l = OList<OInteger>()");
  final l = OList<OInteger>();
  print(l.showFmt());
  print("\nl.add(2)");
  l.add(OInteger(2));
  print(l.showFmt());
  print("\nl.add(3)");
  l.add(OInteger(3));
  print(l.showFmt());
  print("\nl.add(4)");
  l.add(OInteger(4));
  print(l.showFmt());
  print("\nl.removeAt(1)");
  l.removeAt(1);
  print(l.showFmt());
  print("\nl.add(6)");
  l.add(OInteger(6));
  print(l.showFmt());
  print("\nl.length");
  print(l.length);
  print("\nl.insert(${l.length - 2}, 5)");
  l.insert(l.length - 2,OInteger(5));
  print(l.showFmt());
  print("\nl.removeAt(3)");
  l.removeAt(3);
  print(l.showFmt());
  print("\nl.add(7)");
  l.add(OInteger(7));
  print(l.showFmt());
  print("\nl.compaction()");
  l.compaction();
  print(l.showFmt());
}