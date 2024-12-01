# Ruby On Rails : Wallet

Simple Wallet App Using Ruby On Rail

## Pre-requisite
1. Ruby (https://www.ruby-lang.org/en/documentation/installation/) (version : ruby 3.3.6)
2. PostgreSQL (https://www.postgresql.org/download/)
3. Rails (https://guides.rubyonrails.org/v5.2/getting_started.html) (version : 8.0.0)
4. Postman (https://www.postman.com/)
5. Pgadmin (https://www.pgadmin.org/download/) (optional)

## Create Database
```
psql
CREATE DATABASE wallet;
CREATE DATABASE wallet_development;
\q

```
## Create .env file
Create a .env file in the ror-wallet directory. env keys list below:
```
ENVIRONMENT=development
DATABASE_NAME=wallet
DATABASE_USERNAME=andika
DATABASE_PASSWORD=123456
RAPIDAPI_KEY=YOUR_RAPIDAPI_KEY
```
Get your rapidapi key by register to rapidapi : https://rapidapi.com/suneetk92/api/latest-stock-price

## Install the app
In the rails folder, install dependencies and migrate the database schema & seed the database:
```
cd ror-wallet
bundle install
rails db:migrate
rails db:seed
```

### Running the Application Locally

In one terminal, start the API:

```
rails server
```
## Import Postman Collection

Filename : 
RoR Wallet Collection.postman_collection.json