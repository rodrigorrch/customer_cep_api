# Requisitos

* Ruby 2.7.2
* Rails 6.1.3
* Docker

# Configuração

Crie o arquivo de variaveis de ambiente config/application.yml:

```bash
DB_NAME: customer
DB_USERNAME: customer
DB_PASSWORD: customer
DB_PORT: '5432'
DB_HOST: db_api
API_URL: https://ws.apicep.com/cep/
```

# Docker

```bash
docker-compose bundle
```

Se estiver usando linux rode sudo chown -R $USER:$USER .

```bash
docker-compose run web_api rails db:create
docker-compose run web_api rails db:migrate
docker-compose run web_api rails db:seed
```

- Starta o aplicativo

```bash
docker-compose up -d; docker attach web_api
```

Obs: Se der o erro: "error from sender: open customer_cep_api/tmp/db: permission denied"
É problema de permissão na pasta temporaria e pode ser resolvido com chmod 777 -R customer_cep_api/tmp/db

# Processo

- Endpoint para gerar token a partir de um email e senha.

Utlize o end-point /users/sign_in com o email: john@gmail.com e senha: topsecret assim:

```bash
{ 
    "user" :{
        "email" : "john@gmail.com",
        "password" : "topsecret"
    }
}
```

No retorno pegue o api_token que usaremos para autenticar as consultas

- Requests

Informações no header necessárias em todas as requests:

```bash
Accept: 'application/vnd.api+json',
Authorization: "Bearer #{token que você obteve ao fazer o sign in}"
```

Consulta a API e salva no banco o endereço

```bash
Post /api/v1/addresses 
{
    "postal_code": "13606062"
}
```

Retorna uma lista paginada de todos os cep's consultados

```bash
Get /api/v1/addresses?page={número da página} 
```

Retorna cep especifico do banco por id

```bash
Get /api/v1/addresses/{id}
```

Atualiza algum cep especifico por id

```bash
Patch /api/v1/addresses/{id}
{
    "data": {
        "street": "rua logo ali"
    }
}
```

Remove cep especifico do banco por id

```bash
delete /api/v1/addresses/{id}
```
