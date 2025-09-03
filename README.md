# Manual for JDCat analysis

Meatwiki から JDCat にマニュアルページを移行する

## ワークフロー

### 準備

1. このリポジトリをクローンする  

    ```
    $ git clone https://github.com/nii-gakunin-cloud/jdcat-analysis
    ```

### 通常時

1. HTML を編集する

1. リポジトリを更新する  

    ```
    $ git commit
    $ git push
    ```

1. WEKO のフォームに HTML 内の一部を貼り付ける
    ```
    <!-- ここから -->
    ここをコピーし、
    WEKOのフォームに貼り付ける 
    <!-- ここまで -->

### 相対パスでテストしたい時（非推奨）

画像のパス変更やオフライン作業をしていて相対パスで作業をしたい時は以下の流れで作業する。  
ロック処理などしていないのでファイルの上書きなどに注意する。  
このリポジトリを作成する際にディレクトリの変更が頻繁に発生していたため作成したが、現在は記録としての意味しかない。

1. HTML ソース内の画像の URL をローカルにする

    ```
    $ ./relative_url.sh
    ```

    1. このとき、ローカルの環境の backup/ ディレクトリにバックアップが作成される
    1. backup/ は .gitignore にてリポジトリの操作から除外されている

1. 作業用のファイルは testlocal/ 以下に作られる

1. ブラウザや VSCode のプレビュー機能で確認しながら HTML を編集する

1. 画像の URL を FQDN からの絶対パスに戻す

    ```
    $ ./absolute_url.sh
    ```

1. オンラインの状態で閲覧可能か確認する

1. リポジトリを更新する  

## ファイルの説明

### 編集者が使うファイル

* attatchments/\*
    * 画像。ここのファイルを JDCat ページの HTML img タグの中にスタティックな URL で指定する
* \*.html
    * 説明書のHTMLソース。&lt;!-- ここから --&gt; から &lt;!-- ここまで --&gt; をコピーし、 WEKO のフォームに貼り付ける

### リポジトリ作成作業において作られたファイル

記録として残しておく

* from_meatwiki/
    * MeatWiki から生成したページ群
    * スタイルに違和感を感じたときの参考に

* relative_url.sh
    * 画像の URL をローカルにするスクリプト

* absolute_url.sh
    * 画像の URL を FQDN からの絶対パスにするスクリプト

* clean_meatwiki.js

    * style を排除するためのスクリプト
    * allowedStyleProps に削除したくないスタイルを列挙
    * MeatWiki のためのスタイルシートは from_meatwiki/styles/site.css で確認
    * 使い方
        1. input ディレクトリに作業したいファイルをコピー
        1. Node.js が実行できる環境を作る（WSLで動作確認済み）

            ```
            sudo apt install -y nodejs npm
            npm i playwright && npx playwright install chromium
            npm i playwright
            npx playwright install chromium
            sudo npm install n -g
            sudo n stable
            sudo apt purge -y nodejs npm
            sudo apt autoremove -y
            ```

        1. cheerio がインストールされていなければインストールする
            ```
            npm install cheerio
            ```
        1. スクリプトを実行
            ```
            node clean_meatwiki.js
            ```
        1. output ディレクトリに変換後のファイルを生成
        1. このとき ESM 形式に対応した package.json がないと警告が出るが目的は達成する
        1. 警告はパフォーマンスに関するものなので、気になる人は以下の操作をする
            1. npm init -y
            1. できた package.json の冒頭を以下のようになるよう、最初の1行を追加する

                ```
                {
                    "type": "module",
                    "name": "jdcat-analysis",
                    "version": "1.0.0",
                      ...
                }
                ```

        1. 確認して問題がなければ、output/ の中の HTML をリポジトリの HTML にコピーする

* plainify.js, plainify.sh, urls.txt
    * JDCat のページのソースが開発ツールを見ないと何が書いてあるかわからない作りになっていたので、URLを入力して可読性のある HTML として保存するスクリプト
    * 使い方
        1. urls.txt に、HTML に変換して保存したいページの URL を列挙
        1. node-fetch がインストールされていなければ npm でインストールする
        1. スクリプトを実行
            ```
            ./plainify.sh
            ```
        1. output フォルダに保存されているので、ファイルを確認する
