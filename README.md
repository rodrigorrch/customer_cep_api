# Requisitos

* Ruby 2.7.2
* Rails 6.1.3

# Configuração

Crie o arquivo de variaveis de ambiente config/application.yml:

DB_NAME: latamgateway
DB_USERNAME: latamgateway
DB_PASSWORD: latamgateway
DB_PORT: '5432'
DB_HOST: db_api

# Docker

docker-compose run --no-deps web rails new . --force --database=postgresql

Se estiver usando linux rode sudo chown -R $USER:$USER .

docker-compose bundle

docker-compose run web_api rails db:create
docker-compose run web_api rails db:migrate
docker-compose run web_api rails db:seed

docker-compose up -d; docker attach web_api

Obs: Se der o erro: "error from sender: open latamgateway_cep_api/tmp/db: permission denied"
É problema de permissão na pasta temporaria e pode ser resolvido com chmod 777 -R latamgateway_cep_api/tmp/db

# Processo

- Endpoint para gerar token a partir de um email e senha.

Utlize o end-point /users/sign_in com o email: john@gmail.com e senha: topsecret assim:

{ 
    "user" :{
        "email" : "john@gmail.com",
        "password" : "topsecret"
    }
}

No retorno pegue o api_token que usaremos para autenticar as consultas

