import 'dart:io';
import 'package:stack/stack.dart';
import 'package:tent_codes/src/printer.dart';
import 'package:tent_codes/src/cosl/types.dart';

class OptoMaton {
  String _code;
  Stack<String> _stack = Stack<String>();
  String _rIdent = "";
  String _rLoc = "";
  String _rType = "";
  OptoMaton.load(String src) : this._code = src;
  void run(Printer p) {}
}


