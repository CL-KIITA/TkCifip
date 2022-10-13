# Colores Format Specification

`*.colores` 標準Coloresファイル(標準拡張子)
`*.colr` 標準Coloresファイル(省略拡張子)
`*.osl` (OperationScriptライブラリモジュール)

- `%!` シヴァン行.
- `@` 直前の色コードへのアノテーション.
  - `@[<name>] <desc>` 色名(任意)及び説明(任意).
  - `@let` Colores OperationScript (O lang, O言語) のコード. O言語は逆ポーランド記法によるスタック-レジスタ指向かつ式指向の静的型付け命令型言語.
- `$<name> <stm>` 変数定義, `@let <name> an <stm> store`の短縮形.
- `:<name> <arg-nr> <stm>` 関数定義, `@let <name> an <arg-nr> ani <stm> dfn`の短縮形.
- `:<name> (<arg>...) <stm>` 関数定義, `@let <name> an <stm> dfn`の短縮形.
- `&[<name>]` 変数利用, `<name> an call`の短縮形.
- `{<op>...}` 式指示.
- `<val> \`\<type>` 型指示.
  - `top`
  - `object` inh. `top`
  - `none` inh. `top`
  - `bool` inh. `object`
  - `string` inh. `object`
  - `number` inh. `object`
  - `integer` inh. `number`
  - `pointed` inh. `number`
  - `color` inh. `object` 色コード
  - `hex-col` inh. `color` 16進色コード
  - `rgb-col` inh. `color` RGB色コード
  - `hsl-col` inh. `color` HSL色コード
  - `hsv-col` inh. `color` HSV色コード
  - `cmyk-col` inh. `color` CMYK色コード
  - `tag` inh. `object`
  - `identifier` inh. `object`
  - `location` inh. `object`
  - `statement` inh. `object`
  - `block` inh. `object`
  - `function` inh. `object`
  - `type` inh. `object`

```HyperO
\{\{\{\{"Some Text"} ht.text} ht.span} ht.body} ht.html
```

## 記憶領域

### レジスタ/スタック

- current レジスタ: 現在の値を保持.
- temp レジスタ: 仮の値を保持.
- ni レジスタ: 既知識別子を保持.
- function レジスタ: 定義済み関数を保持.
- valuables レジスタ: 定義済み変数を保持(List\<String name, String type, int level, String value\>).

### メモリ

## OperationScript 制御ワード

- [2] `<car> <cdr> cons`.
- [0] `cc`(clear current) 現在の値をクリア.
- [0] `ct`(clear temp) 仮の値をクリア.
- [0] `move` 現在の値を仮の値へ移動.
- [0] `rmove` (reversed move) 仮の値を現在の値へ移動.
- [1] `<val> copy` スタックトップを現在の値へ複写.
- [0] `push` 現在の値をスタックにプッシュ.
- [1] `<val> pop` スタックからポップして現在の値とする.
- [0] `<1> tpop`スタックからポップして仮の値とする.
- [1] `<val> popc` (= `pop cc`) スタックからポップしてクリア.
- [1] `<ident> an` 名称の指示, 通常格納や呼び出しの指示が後続する.
- [1] `<ident> or` 場所の指示, 通常格納や呼び出しの指示が後続する.
- [1] `<nr> ani` 数の指示.
- [1] `<fn> dfn` 関数の格納.
- [1] `<val> store` 値の格納.
- [0] `call` 現在の値への呼び出し.
- [0] `call-st` (= `call push`) スタックトップへの呼び出し.
- [0] `mount` コードを読み込む
- [0] `exists` FSエンティティが存在するか.
- [0] `read` ファイルを読む.
- [0] `write` ファイルに書く.
- [0] `create` FSエンティティを作成する.
- [0] `delete` FSエンティティを削除する.
- [1] `<cond> cik` 制御フロー上の条件の指示.
- [1] `<stm> korac` 制御フロー上の式の指示(終形), 制御フロー上の指示が終わる.
- [1] `<stm> korac-yakk` 制御フロー上の式の指示(続形), 制御フロー上の指示が後続する.
- [2] `<a> <b> add` 数値又は論理値の加算.
- [2] `<a> <b> sub` 数値又は論理値の減算.
- [2] `<a> <b> mul` 数値の乗算.
- [2] `<a> <b> add` 数値の除算.
- [1] `<x> inv` 数値の符号反転又は論理値の反転.
- [2] (object, object) ~> bool `<val> <val> com` 値が等しいか.
- [1] (object) ~> type `<val> show-type` 型の取得.
- [2] (object, object) ~> bool `<val> <val> com-type` 完全に同じ型か.
- [2] (object, object) ~> bool `<val> <val> <lv> -type` 推移的に同じ型か.
- [2] (object, object) ~> bool `<val> <val> -type` 逆推移的に同じ型か.
- [3] (object, object, integer) ~> bool `<val> <val> <lv> -type` 互換な型か.
- [1] (top) ~> bool `<val> is-none`.

## OperationScript コード例

以下ではColoresのうちOperationScript部分のみを示す.

```o
15 show-type
% integer
```

```o
15 show-type push show-type
% type
```
