% Markdown2\LaTeX2PDF Documantation
% nasa9084
% 2017/05/01

## Markdown2\LaTeX2PDF

本書はMarkdown2\LaTeX2PDF(md2pdf)のドキュメントです.
md2pdfは[日本仮想化技術株式会社](https://virtualtech.jp)の内部向けツールとして開発されました.

### Requirements

md2pdfを使用するには以下のソフトウェアが必要です.

* pandoc
* texlive (platexおよびdvipdfmxが使用できること)

また、goemon.ymlとgoemon(https://github.com/mattn/goemon)を使用することで、変更時に自動コンパイルを行うことができます。

## 使用方法

md2pdfを使用するには, bashまたはzshで以下のようにスクリプトを実行します.

```
$ ./md2pdf.sh -t TEMPLATE FILENAME
```

`-t`オプションは省略可能で, `TEMPLATE`にテンプレートを指定します. 省略した場合, デフォルトのテンプレートを使用します. ファイル名にはMarkdownのファイルを指定します.

数秒待った後, PDFファイルが生成されます[^genPDF].

中間ファイルとして\TeX ファイルを残します.

goemonを使用する場合、goemon.ymlおよびmd2pdf.sh、対象のmarkdownファイルがおいてあるディレクトリ内で以下を実行します。

```
$ goemon --
```

自作のテンプレートを使用する場合、`goemon-with-template.yml`を使用することができます。その際、テンプレート名は`template.tex`となっていますので、テンプレートのファイル名を`template.tex`とするか、`goemon-with-template.yml`を書き換えて使用してください。
`goemon-with-template.yml`を使用した自動変換は以下のコマンドで実行できます。

```
$ goemon -c goemon-with-template.yml
```

[^genPDF]: テンプレートなどに問題が無ければ.

## Pandoc flavored Markdown

md2pdfでは, pandoc拡張を含むMarkdown(参考: [Pandoc ユーザーズガイド 日本語版](http://sky-y.github.io/site-pandoc-jp/users-guide/)を使用することができます.
また, sedを用いたフィルタを書き換えることで, LaTeXが対応するものについてMarkdownの記法を拡張することができます.

### タイトルブロック

文書を次のようなブロックで始めると, その文書に関するメタ情報を記述できます.

```
% タイトル
% 著者
% 日付
```

ここに記述した情報はテンプレート内の`$title$`, `$author$`, `$date$`で参照されます.

### 段落

通常のMarkdownの段落です.
通常のマークダウンでの改行(行の末尾に二つの半角スペース)に加え, 行末に`\`を置くことで改行することができます.

### ヘッダ

`#`を行頭に置く, 一般的に用いられているヘッダ形式(ATX形式)のほか, `=`や`-`を下線として引く形式(Setext形式)のヘッダを使用することができます.

pandocではヘッダ行の前に空行を入れることが**必須**です.


### 引用

`>`とスペースから始まる段落は引用となります. これは左端から始まる必要性はありませんが, 4つ以上のスペースでインデントされてはいけません.

ブロックの頭だけに`>`がついている場合も, 段落全体が引用段落となります.

また, 引用段落にはほかのブロック要素を含むことができます(勿論, 引用段落さえも, です).

### コードブロック

コードブロックを記述するには, いくつかの方法があります

#### インデント

4つのスペースでインデントされたブロックはコードブロックとなります.
空行はインデントする必要はありません.

コードブロックを示すインデントは, 変換の際に削除されます.

#### バッククォート

三つ以上のバッククォートの行から始まり, 同じもので終わるブロックもコードブロックとなります.


### ラインブロック

`|`とスペースから始まる行[^lineblock]はラインブロックとなります. ラインブロックでは, 改行や行頭のスペースがそのまま反映されます.

[^lineblock]: reStructuredTextから拝借した文法

### リスト

#### 記号付きリスト

行頭に`*` `+` `-`のいずれかとスペースをつけることで, リストのアイテムを表現することができます.
リストにはほかの段落やリストを含むことができますが, 4つのスペースでインデントされている必要があります[^fourIndentInList].

[^fourIndentInList]: オフィシャルのMarkdown Syntax Guideに従った物. Markdown.plとは挙動が違うので注意.

#### 順序付きリスト

標準的なMarkdownでは, 行頭に十進数のアラビア数字と`.`, 半角のスペースを入れることで順序付きのリストを作成することができます.
加えてpandocでは, 大文字または小文字の英字, ローマ数字をリストのマーカとして使うことができます[^pandocList].

リストマーカは以下の形式で記述することができます.

* 括弧で囲む
    (i) hoge
    (ii) fuga
    (iii) piyo

* 閉じ括弧を置く
    a) foo
    b) bar
    c) baz

* ピリオドを置く
    1. spam
    2. ham
    3. egg


[^pandocList]: 標準的なMarkdownのリストと異なり, pandocは極力番号を保持する.

#### 定義リスト

pandocでは定義リストを作成することができます. 定義リストを作成するには, 用語の行の次の行を`:`で始まる形で記述します.

### 水平線

三つ以上の`*` `-` `_`からなる行は水平線が挿入されます[^horizontalLine]. オプションでスペースを含むことができます.

[^horizontalLine]: 水平線は文書構造とは別なので, 多用しない方が良い.

### 表

4種類の形式で表を書くことができます.

可読性の観点から, グリッドテーブル[^gridTable]か, パイプテーブル[^pipeTable]を使用することをお勧めします.

[^gridTable]: 任意のブロック要素を含むことができる記法. emacsの`table mode`を用いると簡単に書くことができる.
[^pipeTable]: PHP Markdown extraと同じ文法.

### インライン修飾

特定の記号で文字列を囲うことで, インラインでテキストを修飾することができます. 前後にスペースを含む場合, 修飾として見なされません.

#### 強調

`**`または`_`で文字列を囲みます[^pandocEmph].

[^pandocEmph]: pandocでは, 英数字に囲まれた`_`を強調だと見なしません. 単語の一部を強調したい場合, `*`を使用します.

#### 打ち消し線

`~~`で文字列を囲みます.

#### 上付き文字・下付文字

上付き文字にするには`^`で, 下付き文字にするには`~`で文字列を囲みます. 間にスペースを含む場合, このスペースは`\`でエスケープする必要があります.

#### 文字通りの出力

ある文字列を, そのまま出力したい場合[^verbatim], `` ` ``で文字列を囲みます.

[^verbatim]: verbatim と呼びます. ファイル名やプログラム片などを表現する際によく用いられます.

### 数式

`$`で囲まれた文字列は数式と見なされます. md2pdfでは, 中間ファイル形式としてLaTeXを用いているため, LaTeXの記法で数式を記述することができます. 特に有用であると考えられる, いくつかの記号について記法を示しておきます.

| 記法        | 表示       | 記法             | 表示            |
|:------------|:-----------|:-----------------|:----------------|
| \\geq       | \geq       | \\leftarrow      | \leftarrow      |
| \\leq       | \leq       | \\rightarrow     | \rightarrow     |
| \\gg        | \gg        | \\Leftarrow      | \Leftarrow      |
| \\ll        | \ll        | \\Rightarrow     | \Rightarrow     |
| \\S         | \S         | \\leftrightarrow | \leftrightarrow |
| \\copyright | \copyright | \\Leftrightarrow | \Leftrightarrow |
| \\times     | \times     | \\nearrow        | \nearrow        |
| \\subset    | \subset    | \\nwarrow        | \nwarrow        |
| \\supset    | \supset    | \\searrow        | \searrow        |
| \\neq       | \neq       | \\swarrow        | \swarrow        |
| \\Omega     | \Omega     | \\lambda         | \lambda         |


### 埋め込み

文書中, 好きなところに生の\TeX を埋め込むことができます.

### 画像

`![alt_string](link)`の形で記述することで画像を挿入することができます.

### 脚注

本文書でも何度か使用していますが, 脚注をつけることができます. 脚注には複数の形式があります.

* インライン形式
    インラインで脚注を埋め込むことができます. 脚注をその場で書くことができるため, 便利ですが, 可読性は若干低下します.
    文中の脚注をいれたい箇所に, `^[脚注]`の形で記述します.

* 短い脚注
    通常の脚注の形式です. 脚注を入れたい部分に`[^id]`の形でIDを埋め込み, その後, 任意の場所(ブロック要素内を除く)で, `[^id]: 脚注`という形式で脚注を記述します.

* 長い脚注
    改行を含む脚注も作成することができます. 短い脚注と同様の形式で記述します. 二行目以降をインデントして記述することで, 長い脚注を作成できます[^footnote].

[^footnote]: 複数の段落を含むことも可能.

## テンプレート

PDFを生成する際のカスタムテンプレートを使用することができます. カスタムテンプレートはLaTeX形式で記述します.

pandocはmarkdownに対応する本文の部分のみ出力するため, テンプレートにプリアンブル[^preamble]を含む必要があります.

テーブル, コードブロック, URL, 画像, リストなど標準の機能を使用するため, プリアンブルには以下の内容を含む必要があります.

```
\usepackage{listings}
\usepackage{url}
\usepackage{longtable}
\usepackage{booktabs}
\usepackage[dvipdfmx]{graphicx}
\usepackage[top=15truemm,left=20truemm,right=20truemm,bottom=20truemm]{geometry}
\def\tightlist{\itemsep1pt\parskip0pt\parsep0pt}
\setcounter{tocdepth}{2}
```

テンプレート内では様々な定数・変数を使用することができます. 変数は, 変数名を`$`で囲んで使用します.

表題を作成するには`\maketitle`を, 目次を作成するには`\tableofcontents`をそれぞれ使用します.


[^preamble]: TeXのヘッダの様な物. HTMLでいうところの`<head></head>`ブロックに相当する.
