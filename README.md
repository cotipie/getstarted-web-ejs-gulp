# getstarted-webpage-gulp
Web制作用にhaml、bower、sassのコンパイルや配置をgulpで回すテンプレート。
（ベンダープレフィックス付与、Image圧縮、ローカルサーバー、browserSync有り）

### 準備するもの
* [node.js](https://nodejs.org/download/)
* `npm install -g gulp bower`：どこで実行してもいい

※ getstart時にnode-sass？みたいなエラーがでたら`npm install node-sass -g`をするといいかも
※ npmの実行は`sudo`いるかも（Mac）

### cloneしたら
1. `npm install`
1. `bower install`
    - jQuery, jQuery-UI, font-Awesomeが導入
1. `gulp getstart`
    - ここでbowerからのライブラリを整理して、初期のコンパイルが走る
1. `gulp watch`
    - 上記のコンパイルをするためにフォルダを監視し、更新するたび自動でreloadするローカルテストサーバーが立ち上がる。コンパイルされたものは`dist/`にいく

### 制作の仕方
* ejsディレクトリの中で`.ejs`で作成（コンポーネント化するものは`_header.ejs`とかにすればOK）
* jsは`app.js`に記述する。新しくファイルを作っても問題無いが、`common.js`でjQuery含み外部JSファイルを読み込んでいるので、こちらにも記載する。
* cssは`/sass/`の中で`style.scss`内に記述する。ベンダープレフィックスが自動で付与。
* 画像は`/images/`に配置する。圧縮され、`/dist/images/`に配置される。

すべて、`gulp watch`している状態であれば、`/dist/`にコンパイルされる。

※`gulp watch`していない時の変更をコンパイルしたい場合は、`gulp`と実行

成果物としては、`dist`になる

### こんなとき
#### bowerで管理するライブラリを増やしたい
```
bower install jquery --save
gulp getstart
```

1行目でライブラリを指定する。bowerのcomponentディレクトリから引っ張ってくるため`gulp getstart`を実行。なお、`--save`オプションを付けた場合、以降`bower install`で引っ張ってこれる。（詳しくは*bower.json*を確認）

また、`/js/common.js`に読み込み用の記述が必要。
