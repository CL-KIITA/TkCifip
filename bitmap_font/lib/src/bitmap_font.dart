import 'package:bitmap_font/src/image.dart' show BitmapFont, BitmapFontCharacter;
import 'package:archive/archive.dart';
import 'package:xml/xml.dart';
import 'otf/otf.dart';

extension ToBitmap on OpenTypeFont{
  BitmapFont toBitmap(){}
}