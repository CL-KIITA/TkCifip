abstract class HtmlTag {
  String tagName;
  bool nonTerminal;
  Map<String, List<String>> attributes;
  List<HtmlTag> children;
  HtmlTag(this.tagName, {this.nonTerminal = false, this.attributes = const {}, this.children = const []});
  String output() {
    String attrStr = this.attributes.isEmpty ? "" : " " + this.attributes.entries.map<String>((MapEntry<String, List<String>> e) => e.value.isEmpty ? e.key : e.key + "=\"" + e.value.join(" ") + "\"").join(" ");
    String elStr = this.children.map<String>((HtmlTag e) => e.output()).join("\n");
    if (tagName == "") {
      return elStr;
    }
    if (!nonTerminal) {
      return "<${this.tagName}$attrStr>\n$elStr\n</${this.tagName}>";
    } else {
      return "<${this.tagName}$attrStr />";
    }
  }
}

abstract class CoreHTag extends HtmlTag {
  CoreHTag(String tagName, {bool nonTerminal = false, Map<String, List<String>> attributes = const {}, List<HtmlTag> children = const []}) : super(tagName, attributes: attributes, children: children, nonTerminal: nonTerminal);
}

abstract class CustomHTag extends HtmlTag {
  CustomHTag() : super("");
  HtmlTag build();
  @override
  String output() {
    HtmlTag buildes = this.build();
    while (buildes is CustomHTag) {
      buildes = buildes.build();
    }
    if (buildes is! CoreHTag) {
      throw Error();
    }
    return buildes.output();
  }
}

class DivTag extends CoreHTag {
  DivTag({Map<String, List<String>> attributes = const {}, List<HtmlTag> children = const []}) : super("div", attributes: attributes, children: children);
}

class SpanTag extends CoreHTag {
  SpanTag({Map<String, List<String>> attributes = const {}, List<HtmlTag> children = const []}) : super("span", attributes: attributes, children: children);
}

class HtmlHTag extends CoreHTag {
  HtmlHTag({Map<String, List<String>> attributes = const {}, List<HtmlTag> children = const []}) : super("html", attributes: attributes, children: children);
}

class BodyTag extends CoreHTag {
  BodyTag({Map<String, List<String>> attributes = const {}, List<HtmlTag> children = const []}) : super("html", attributes: attributes, children: children);
}

class HeadTag extends CoreHTag {
  HeadTag({Map<String, List<String>> attributes = const {}, List<HtmlTag> children = const []}) : super("body", attributes: attributes, children: children);
}

class LinkTag extends CoreHTag {
  LinkTag({Map<String, List<String>> attributes = const {}}) : super("link", attributes: attributes, children: const [], nonTerminal: true);
}

class StyleSheetLink extends LinkTag {
  StyleSheetLink(String path)
      : super(attributes: {
          "rel": ["stylesheet"],
          "type": ["text/css"],
          "href": [path]
        });
}

class TitleTag extends CoreHTag {
  String title;
  TitleTag(this.title, {Map<String, List<String>> attributes = const {}}) : super("title", attributes: attributes, children: [HText(title)]);
}

class BrTag extends CoreHTag {
  BrTag() : super("br", nonTerminal: true);
}

class HText extends CoreHTag {
  String str;
  HText(this.str) : super("", nonTerminal: true);
  @override
  String output() {
    return this.str;
  }
}
