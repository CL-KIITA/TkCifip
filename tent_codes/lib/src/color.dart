import 'package:tent_codes/src/error.dart';
import 'package:tent_codes/src/xilib.dart';

class HColor {
  double r;
  double g;
  double b;
  HColor._(this.r, this.g, this.b);
  factory HColor.fromRGB(double r, double g, double b) => HColor._(r, g, b);
  factory HColor.fromHex(String src) {
    if (src.startsWith("#") && (src.length == 7 || src.length == 9)) {
      String t = src.substring(1);
      double r = int.parse(t.substring(0, 2), radix: 16).toDouble();
      double g = int.parse(t.substring(2, 4), radix: 16).toDouble();
      double b = int.parse(t.substring(4, 6), radix: 16).toDouble();
      return HColor._(r, g, b);
    } else {
      throw NotHexColorErr(src);
    }
  }
  factory HColor.fromCMYK(double c, double m, double y, double k) => HColor._(255 * (1 - c) * (1 - k), 255 * (1 - m) * (1 - k), 255 * (1 - y) * (1 - k));
  factory HColor.fromHSL(double h, double s, double l) {
    late double min;
    late double max;
    double he = h % 360;
    if (s < 0 || s > 100 || l < 0 || l > 100) {
      throw Error();
    }
    if (l < 50) {
      max = 2.55 * (l + l * (s / 100));
      min = 2.55 * (l - l * (s / 100));
    } else {
      max = 2.55 * (l + (100 - l) * (s / 100));
      min = 2.55 * (l - (100 - l) * (s / 100));
    }
    if (he < 60) {
      return HColor._(max, (he / 60) * (max - min) + min, min);
    } else if (he < 120) {
      return HColor._(((120 - he) / 60) * (max - min) + min, max, min);
    } else if (he < 180) {
      return HColor._(min, max, ((he - 120) / 60) * (max - min) + min);
    } else if (he < 240) {
      return HColor._(min, ((240 - he) / 60) * (max - min) + min, max);
    } else if (he < 300) {
      return HColor._(((he - 240) / 60) * (max - min) + min, min, max);
    } else {
      return HColor._(max, min, ((360 - he) / 60) * (max - min) + min);
    }
  }
  String asHex() {
    return "#${this.r.toHex(2)}${this.g.toHex(2)}${this.b.toHex(2)}";
  }

  static HColor parse(String src) {
    try {
      HColor h = HColor.fromHex(src);
      return h;
    } on NotHexColorErr catch (_) {
      String t = src.toLowerCase();
      List<double> nrs = t.substring(t.indexOf("(") - 1, t.indexOf(")")).csn2list();
      if (nrs.length < 3) {
        throw Error();
      }
      if ((t.startsWith("rgb(") || t.startsWith("hsl(") || t.startsWith("cmyk(")) && src.endsWith(")")) {
        switch (t.substring(0, t.indexOf("("))) {
          case "rgb":
            return HColor.fromRGB(nrs[0], nrs[1], nrs[2]);
          case "hsl":
            return HColor.fromHSL(nrs[0], nrs[1], nrs[2]);
          case "cmyk":
            if (nrs.length == 3) {
              return HColor.fromCMYK(nrs[0], nrs[1], nrs[2], 0);
            } else {
              return HColor.fromCMYK(nrs[0], nrs[1], nrs[2], nrs[3]);
            }
          default:
            throw Error();
        }
      } else {
        throw Error();
      }
    }
  }

  static HColor? tryParse(String src) {
    try {
      return HColor.parse(src);
    } catch (e) {
      return null;
    }
  }
}

