import 'dart:io';
abstract class Printer{
  void write(Object o, {bool asBytes = false, bool noNL = false});
}
class VoidPrinter extends Printer{
  VoidPrinter();
  @override
  void write(Object o, {bool asBytes = false, bool noNL = false}){}
}
class ConsolePrinter extends Printer{
  ConsolePrinter();
  @override
  void write(Object o, {bool asBytes = false, bool noNL = false}){
    if(asBytes){
      if(o is List<int>){
        stdout.add(o);
      }else if (o is List<Object?>){
        if(o.every((Object? e) => int.tryParse(e.toString()) != null)){
          stdout.add(o.map<int>((Object? e) => int.parse(e.toString())).toList());
        }else{
          throw Error();
        }
      }else{
        throw Error();
      }
      if(!noNL){
        stdout.write("\n");
      }
    }else{
      if(noNL){
        stdout.write(o);
      }else{
        print(o);
      }
    }
  }
}
class FilePrinter extends Printer{
  File _f;
  FilePrinter(File file, {bool initialize = true}): this._f = file{
    if(initialize){
      if(!this._f.existsSync()){
        if(!this._f.parent.existsSync()){
          this._f.parent.createSync(recursive: true);
        }
        this._f.createSync();
      }
    }
  }
  factory FilePrinter.uri(Uri uri, {bool initialize = true}) => FilePrinter(File.fromUri(uri), initialize: initialize);
  factory FilePrinter.path(String path, {bool initialize = true}) => FilePrinter(File(path), initialize: initialize);
  @override
  void write(Object o, {bool asBytes = false, bool noNL = false}){
    if(asBytes){
      if(o is List<int>){
        this._f.writeAsBytesSync(o, mode: FileMode.append);
      }else if(o is List<Object?>){
        if(o.every((Object? e) => int.tryParse(e.toString()) != null)){
          this._f.writeAsBytesSync(o.map<int>((Object? e) => int.parse(e.toString())).toList(), mode: FileMode.append);
        }else{
          throw Error();
        }
      }else{
        throw Error();
      }
    }else{
      this._f.writeAsStringSync(o.toString(), mode: FileMode.append);
    }
    if(!noNL){
      this._f.writeAsStringSync("\n", mode: FileMode.append);
    }
  }
}