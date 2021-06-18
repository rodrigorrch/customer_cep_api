FROM ruby:2.7.2
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev postgresql-client

ARG USER_ID
ARG USER_NAME

ENV USER_ID $USER_ID

RUN groupadd -g $USER_ID $USER_NAME && useradd -u $USER_ID -g $USER_NAME --create-home $USER_NAME
RUN mkdir -p /app/latamgateway_cep_api && chown $USER_NAME:$USER_NAME /app/latamgateway_cep_api

WORKDIR /app/latamgateway_cep_api

COPY Gemfile /app/latamgateway_cep_api/Gemfile
COPY Gemfile.lock /app/latamgateway_cep_api/Gemfile.lock

RUN bundle install
COPY . /app/latamgateway_cep_api

USER $USER_NAME