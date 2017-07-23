FROM elixir:1.4.5

RUN apt-get update && apt-get install -y wget

ENV DOCKERIZE_VERSION v0.5.0
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN mix local.hex --force
RUN mix local.rebar --force

WORKDIR /code

COPY ./mix.exs /code/
COPY ./mix.lock /code/

ENV MIX_ENV prod
RUN mix deps.get
RUN mix deps.compile

COPY . /code

RUN mix compile

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["run"]
