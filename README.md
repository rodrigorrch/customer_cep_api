# README

* Ruby versão 2.7.2
* Rails versão 6.1.3

# Docker

docker-compose bundle

docker-compose run web_api rails db:create

docker-compose up -d; docker attach web_api

Obs: Se der o erro:
error from sender: open latamgateway_cep_api/tmp/db: permission denied
é problema de permissão na pasta temporaria e pode ser resolvido com chmod 777 -R latamgateway_cep_api/tmp/db

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
