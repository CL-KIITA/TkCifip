import 'package:tent_codes/src/xilib.dart';

class BracketRange implements Comparable<BracketRange>{
  final int start;
  final int end;
  final int level;
  final Bracket bracket;
  const BracketRange(this.start, this.end, this.bracket, [this.level = 0]);
  int compareTo(BracketRange other) => this.start.compareTo(other.start);
  @override
  bool operator ==(Object other) {
    if(other is BracketRange){
      return this.start == other.start && this.end == other.end && this.level == other.level && this.bracket == other.bracket;
    }
    return false;
  }
}
abstract class Bracket{
  String get starts;
  String get ends;
  final EscapeLoc el;
  final String escape;
  const Bracket(this.el, [this.escape = ""]);
  @override
  bool operator ==(Object other) {
    if(other is Bracket){
      return this.starts == other.starts && this.ends == other.ends && this.el == other.el && this.escape == other.escape;
    }
    return false;
  }
}
class SymmetryBracket extends Bracket{
  final String char;
  const SymmetryBracket(this.char, EscapeLoc el, [String escape = ""]): super(el, escape);
  String get starts => this.char;
  String get ends => this.char;
}
class AsymmetryBracket extends Bracket{
  final String starts;
  final String ends;
  const AsymmetryBracket(this.starts, this.ends, EscapeLoc el, [String escape = ""]): super(el, escape);
}
abstract class QuoteBracket extends SymmetryBracket{
  const QuoteBracket(String char, EscapeLoc el, [String escape = ""]):super(char, el, escape);
}
class SingleQuoteBracket extends QuoteBracket{
  const SingleQuoteBracket(EscapeLoc el, [String escape = ""]): super("'", el, escape);
}
class DoubleQuoteBracket extends QuoteBracket{
  const DoubleQuoteBracket(EscapeLoc el, [String escape = ""]): super("\"", el, escape);
}
class SquareBracket extends AsymmetryBracket{
  const SquareBracket(EscapeLoc el, [String escape = ""]): super("[", "]", el , escape);
}
class RoundBracket extends AsymmetryBracket{
  const RoundBracket(EscapeLoc el, [String escape = ""]): super("(", ")", el , escape);
}
class WaveBracket extends AsymmetryBracket{
  const WaveBracket(EscapeLoc el, [String escape = ""]): super("{", "}", el , escape);
}
class AngleBracket extends AsymmetryBracket{
  const AngleBracket(EscapeLoc el, [String escape = ""]): super("<", ">", el , escape);
}
enum EscapeLoc{
  before,
  after,
  both,
  none,
}
extension BracketsInString on String{
  List<BracketRange> bracketClusters(List<Bracket> bk){
    return bk.map<List<BracketRange>>((Bracket b){
      if(b is SymmetryBracket){
        List<int> indexesNonSep = this.allIndexesOf(b.char);
        List<int> indexesEscaped = [];
        if(b.el == EscapeLoc.after || b.el == EscapeLoc.both){
          indexesEscaped.addAll(this.allIndexesOf(b.char + b.escape));
        }else if(b.el == EscapeLoc.before || b.el == EscapeLoc.both){
          indexesEscaped.addAll(this.allIndexesOf(b.escape + b.char));
        }
        indexesNonSep.removeWhere((int indNS) => indexesEscaped.any((indEsc) => indNS == indEsc));
        List<int> indexes = indexesNonSep.take(indexesNonSep.length ~/ 2).toList();
        List<BracketRange> bkR = [];
        for(int i = 0; i < indexes.length; i + 2){
          bkR.add(BracketRange(indexes[i], indexes[i + 1], b));
        }
        return bkR;
      }else{
        throw UnimplementedError("Under dev yet.");
      }
    }).expand<BracketRange>((List<BracketRange> lbr) => lbr).toList();
  }
  String bracketClusterOf({int? level, int loc = 0, List<Bracket>? bk}){
    throw UnimplementedError("Under dev yet.");
  }
}