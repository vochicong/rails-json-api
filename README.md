# README

## 作業手順

Rails APIアプリを新規作成

    rails new rails_api --api

Gemfileを編集し必要な gem を追加・有効化してから `bundle` を実行。
- jbuilder: JSONの出力
- awesome_print: rails consoleで配列などを見やすく
- rspec-rails
- factory_bot_rails

User を scaffold

    rails generate scaffold User full_name:string email_address:string

JSON API では key として camelCase (fullName や emailAddress)を使う想定。

`rails c`で User のデータを追加。

簡単に動いているかどうかを見る

    rails s
    open http://localhost:3000/users.json
    open http://localhost:3000/users/1.json

Post を scaffold

    rails generate scaffold post post_content:text user_id:integer

`rails c`で Post のデータを追加。

TODO: seeds で User と Post のテストデータを作成・保存

簡単に動いているかどうかを見る

    rails s
    open http://localhost:3000/posts.json
    open http://localhost:3000/posts/1.json

RSpec のインストール（初期設定）

    rails generate rspec:install

## API JSON format

Postman で叩いてみて、現段階の request と response の key を
snake_case から camelCase に変えて API JSON format 仕様とする。

### Create

#### Request

POST /users
```json
{
    "fullName": "Michal Jackson",
    "emailAddress": "michale@gmail.com"
}
```

#### Response

```json
{
    "id": 3,
    "fullName": "Michal Jackson",
    "emailAddress": "michale@gmail.com",
    "createdAt": "2017-12-17T07:28:52.052Z",
    "updatedAt": "2017-12-17T07:28:52.052Z",
    "url": "http://localhost:3000/users/3.json"
}
```

### Update

#### Request

PATCH/PUT /users/3
```json
{
    "fullName": "Michale Jack",
    "emailAddress": "jack@gmail.com"
}
```

#### Response

```json
{
    "id": 3,
    "fullName": "Michale Jack",
    "emailAddress": "jack@gmail.com",
    "createdAt": "2017-12-17T07:28:52.052Z",
    "updatedAt": "2017-12-17T07:33:53.010Z",
    "url": "http://localhost:3000/users/3.json"
}
```

## API JSON testing

JSON APIのRSpecでは`JSON.parse(response.body)`がよく発生するため、
`js_response`で済むヘルパーを導入してみました。

## 参考

- [Rails Hash#deep_transform_keys](http://api.rubyonrails.org/classes/Hash.html#method-i-deep_transform_keys-21)
- [Jbuilder](https://github.com/rails/jbuilder)
- [Postman](https://www.getpostman.com/)
- [DRY-ing The JSON Response](http://aalvarez.me/blog/posts/testing-a-rails-api-with-rspec.html)
- [Rails API Testing Best Practices](http://matthewlehner.net/rails-api-testing-guidelines/)
