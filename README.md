# README

## 作業手順

Rails APIアプリを新規作成

    rails new rails_api --api

Gemfileを編集し必要な gem を追加・有効化してから `bundle` を実行。
- jbuilder: JSONの出力
- awesome_print: rails consoleで配列などを見やすく

User を scaffold

    rails generate scaffold User full_name:string email_address:string

JSON API では key として camelCase (fullName や emailAddress)を使う想定。

`rails c`で User のデータを追加。

簡単に動いているかどうかを見る

    rails s
    open http://localhost:3000/users.json
    open http://localhost:3000/users/1.json
