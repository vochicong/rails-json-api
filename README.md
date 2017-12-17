# README

## 作業手順

Rails APIアプリを新規作成

    rails new rails_api --api
    
Gemfileを編集し jbuilder を有効にしてから `bundle` を実行。
    
User を scaffold

    rails generate scaffold User full_name:string email_address:string
    
JSON API では key として camelCase (fullName や emailAddress)を使う想定。