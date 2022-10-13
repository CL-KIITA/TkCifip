import 'dart:io';
import 'package:tent_codes/src/html.dart';
import 'package:tent_codes/src/color.dart';
import 'package:tent_codes/src/printer.dart';
void main(List<String> arg) {
  String scDir = File.fromUri(Platform.script).parent.path;
  Printer pr = FilePrinter.path("$scDir/log/s.txt");
  pr.write([15, 32, 255], asBytes: true);
  header(pr);
  File f = argWork(arg, pr);
  if (!f.existsSync()) {
    pr.write("|  Err: The file in specified by path ${f.path} is not exists.");
    String p = f.absolute.parent.path;
    pr.write("|  PATH: $p");
    return;
  }
  FileType ft = detectType(f);
  Iterable<String> xpathE = f.path.split(".");
  String xpath = xpathE.take(xpathE.length - 1).join(".");
  File ofile = fileInit("$xpath.html", pr);
  File sfile = fileInit("$xpath.css", pr);
  String src = f.readAsStringSync().replaceAll("\r\n", "\n").replaceAll("\r", "\n");
  List<String> data = src.split("\n");
  //print(data);
  pr.write("|");
  switch(ft){
    case FileType.invalid:
      pr.write("|  Err: The file in specified by path ${f.path} is invalid format for this.");
      break;
    case FileType.colores:
      pr.write("|  Err: ColoRes format is unimplemented yet. Please wait.");
      break;
    case FileType.text:
      pr.write("|  Log: Working for the file in specified by path ${f.path}.");
      Page p = Page(data: data, stylesheetPath: sfile.path);
      ofile.writeAsStringSync(p.output());
      createCSS(sfile, pr);
      break;
  }
  pr.write("|");
  return;
}
void header(Printer p){
  p.write("|");
  p.write("|  ** tent_codes from package tent_codes  **");
  p.write("|  ** Tentative ToolChain on Color Design **");
  p.write("|  ** Sample for such as InterFace.       **");
  p.write("|  ** Current version: 1.0.0              **");
}
File argWork(List<String> arg, Printer p){
  p.write("|");
  late Uri path;
  late Uri pathTmp;
  bool hasPath = false;
  p.write("|  Log: arg...");
  for (String el in arg) {
    try {
      pathTmp = Uri.file(el, windows: Platform.isWindows);
      path = pathTmp;
      hasPath = true;
      break;
    } catch (e) {}
  }
  if (!hasPath) {
    path = Uri.file("./colorList.txt");
  }
  return File.fromUri(path);
}
File fileInit(String path, Printer p){
  p.write("|");
  print("|  Log: Begin - File initialize of ${path}.");
  File f = File.fromUri(Uri.file(path));
  if (!f.existsSync()) {
    p.write("|  Log: Create ${f.path}, because the file in specified by this path is not exists.");
    if (!f.parent.existsSync()) {
      p.write("|  Log: Create ${f.parent.path}, because the directory in specified by this path is not exists.");
      f.parent.createSync(recursive: true);
    }
    f.createSync(recursive: true);
  }
  p.write("|  Log: Finished - File initialize of ${path}.");
  return f;
}
void createCSS(File sf, Printer p){
  p.write("|");
  p.write("|  Log: Write CSS style codes to file ${sf.path}");
  sf.writeAsStringSync(CSSStyleFile().output());
}
enum FileType{
  colores,
  text,
  invalid
}
FileType detectType(File f){
  final List<String> invalidList = ["html", "css", "py", "rb", "md", "dart", "dt", "yaml", "ml", "m", "yml", "json", "toml", "c", "cpp", "csh", "d", "exe", "dll", "bin"];
  final Iterable<String> xpathE = f.path.split(".");
  if(xpathE.length < 2){
    return FileType.text;
  }
  final String ext = xpathE.last;
  if(ext == "txt"){
    return FileType.text;
  }else if(ext == "colores"){
    return FileType.colores;
  }else if(invalidList.any((String e) => e == ext)){
    return FileType.invalid;
  }
  return FileType.text;
}

class Page extends CustomHTag {
  List<String> data;
  String stylesheetPath;
  String pageTitle;
  Page({required this.data, required this.stylesheetPath, this.pageTitle = "暫定色彩デザインサンプル: Tentative colour design samples"});
  @override
  HtmlTag build() {
    return HtmlHTag(children: [
      HeadTag(children: [TitleTag(this.pageTitle), StyleSheetLink(this.stylesheetPath)]),
      BodyTag(children: [SampleBoxGrid(this.data.map<HColor>((String e) => HColor.parse(e)).toList())])
    ]);
  }
}

class SampleBoxGrid extends CustomHTag {
  List<HColor> cl;
  SampleBoxGrid(this.cl);
  @override
  HtmlTag build() {
    return DivTag(attributes: {
      "class": ["sampleGrid"]
    }, children: this.cl.map<HtmlTag>((HColor e) => SampleBox(e)).toList());
  }
}

class SampleBox extends CustomHTag {
  HColor c;
  String? name;
  String? desc;
  SampleBox(this.c, {this.name, this.desc});
  @override
  HtmlTag build() {
    String? name = this.name;
    String? desc = this.desc;
    late List<HtmlTag> text;
    if (name != null && desc != null) {
      text = [
        SpanTag(children: [
          HText(name)
        ], attributes: {
          "class": ["name"]
        }),
        HText(c.asHex()),
        SpanTag(children: [
          HText(desc)
        ], attributes: {
          "class": ["desc"]
        })
      ];
    } else if (name != null) {
      text = [
        SpanTag(children: [
          HText(name)
        ], attributes: {
          "class": ["name"]
        }),
        HText(c.asHex())
      ];
    } else if (desc != null) {
      text = [
        HText(c.asHex()),
        SpanTag(children: [
          HText(desc)
        ], attributes: {
          "class": ["desc"]
        })
      ];
    } else {
      text = [HText(c.asHex())];
    }
    return DivTag(attributes: {
      "class": ["sample"]
    }, children: [
      DivTag(attributes: {
        "class": ["box"],
        "style": ["background-color: ${c.asHex()}"]
      }),
      DivTag(attributes: {
        "class": ["text"]
      }, children: text)
    ]);
  }
}

class CSSStyleFile {
  CSSStyleFile();
  String output() {
    return """.sampleGrid{
  margin: 1.5em;
  display: grid;
  column-gap: 0.15em;
  row-gap: 0.17em;
  grid-template-columns: repeat(6, 1fr);
}
.sample{
  padding: 0;
  margin: 0;
}
.sample .box{
  padding: 0;
  margin: 0;
  width: 100%;
  aspect-ratio: 1;
}
.sample .text{
  padding: 0.05em;
  margin: 0;
  font-size: 1.1em;
}
.sample .text .name{
  font-size: 1.03em;
  font-style: black;
}
.sample .text .desc{
  font-size: 0.97em;
  color: gray;
  font-style: oblique;
}""";
  }
}



