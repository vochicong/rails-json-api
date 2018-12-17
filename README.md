[![Maintainability](https://api.codeclimate.com/v1/badges/6bc16f3bcc5522f2b685/maintainability)](https://codeclimate.com/github/vochicong/rails-json-api/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/6bc16f3bcc5522f2b685/test_coverage)](https://codeclimate.com/github/vochicong/rails-json-api/test_coverage)

# Rails API server

## 作業手順

Rails APIアプリを新規作成

    rails new rails_api --api

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

## Manual testing


Start Rails server

    bin/rails db:migrate RAILS_ENV=development
    rails s

Create users

    curl http://localhost:3000/users -X POST -H "Content-Type: application/json" -d '{"fullName": "Michal Jackson", "emailAddress": "michale@gmail.com"}'

Get users

    curl http://localhost:3000/users

## 参考

- [Rails Hash#deep_transform_keys](http://api.rubyonrails.org/classes/Hash.html#method-i-deep_transform_keys-21)
- [Jbuilder](https://github.com/rails/jbuilder)
- [Postman](https://www.getpostman.com/)
- [DRY-ing The JSON Response](http://aalvarez.me/blog/posts/testing-a-rails-api-with-rspec.html)
- [Rails API Testing Best Practices](http://matthewlehner.net/rails-api-testing-guidelines/)

# Rails encrypted credentials

Rails 5.2 から `config/credentials.yml.enc` が導入され、混乱を招いている。
`development`, `test` では環境変数を使って、`production` (または `staging`など)で
`encrypted credentials` を使うニーズに手軽に対応するには、
`config/environment.rb` にクラス `Env`を導入してみた。

```ruby
class Env
  def self.method_missing(name, *default)
    ENV[name.to_s] ||
      default.first ||
      Rails.application.credentials.send(name) ||
      super
  end

  def self.respond_to_missing?(*)
    true
  end
end
```

## 使い方

システム構成情報は、環境変数または`config/credentials.yml.enc`に設定する。
`Env.APP_CONFIG` は `APP_CONFIG` をまず
環境変数 `ENV` から探して、未設定の場合に `encrypted credentials` から探す。
引数にデフォルトの値が与えられたら、`encrypted credentials` からは探さない。

## 例

### config/credentials.yml.enc の内容確認

    $ RAILS_MASTER_KEY=289e1431050b365b62bb5917acabcc53 rails credentials:show
    secret_key_base: 2105bc31227a27f81b901582a8bb43b35bebea2b9c3572b024184a0b06dad26fc3bb312fbc5a7069783798d22f55cf4f411ae19169dd2a78026dccfbbdc889d7
    APP_CONFIG: encryptedConfig

### 環境変数が未定義の場合、デフォルト値が使われる

    $ rails runner 'puts Env.APP_CONFIG("default")'
    default

### 環境変数がデフォルト値よりも優先される

    $ APP_CONFIG=envVar rails runner 'puts Env.APP_CONFIG("default")'
    envVar

### 環境変数が、`encrypted credentials` よりも優先される

    $ RAILS_MASTER_KEY=289e1431050b365b62bb5917acabcc53 APP_CONFIG=envVar rails runner 'puts Env.APP_CONFIG("default")'
    envVar

### デフォルト値が `encrypted credentials` よりも優先される

    $ RAILS_MASTER_KEY=289e1431050b365b62bb5917acabcc53 rails runner 'puts Env.APP_CONFIG("default")'
    default

### 環境変数もデフォルト値も未定義の場合、`encrypted credentials` が使われる

    $ RAILS_MASTER_KEY=289e1431050b365b62bb5917acabcc53 rails runner 'puts Env.APP_CONFIG'
    encryptedConfig
