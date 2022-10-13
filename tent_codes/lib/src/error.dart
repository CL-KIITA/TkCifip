class ColorWorkErr extends Error {
  String kind;
  String massage;
  ColorWorkErr(this.kind, this.massage);
  @override
  String toString() {
    return "ColorWorkErr(${this.kind}): ${this.massage}";
  }
}

class NotHexColorErr extends ColorWorkErr {
  String src;
  NotHexColorErr(this.src) : super("NotHexColor", "src: ${src}");
}