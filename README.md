# DL.Getch.comスクレイピング＋パーサ

## 目的

DL.Getch.comで販売されているコスプレハード作品のデータを100ページ分取得し、CSVとして保存します。

CSVにはサークル名,作品名,登録日,価格,URL,タグが含まれます。

## 環境

- Ruby 3.0以降
- Bundlerがインストールされていること

## 使い方

### セットアップ

- $ bundle install

### ダウンロード

- $ bundle exec ruby download.rb

htmls内に0.htmlから100.htmlが生成されます

### CSV生成

- $ ruby parse.rb

output.csvが生成されます
