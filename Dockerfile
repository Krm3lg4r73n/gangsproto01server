FROM elixir:1.5.2-slim as builder

RUN apt-get -qq update
RUN apt-get -qq install git build-essential

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix hex.info

WORKDIR /app
ENV MIX_ENV prod
COPY . .
RUN mix deps.get
RUN mix release --env=$MIX_ENV


FROM debian:jessie-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update
RUN apt-get -qq install -y locales libssl1.0.0 libssl-dev wget

# Set LOCALE to UTF8
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ENV DOCKERIZE_VERSION v0.6.0
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

WORKDIR /app
COPY --from=builder /app/_build/prod/rel/gangs_server .
COPY ./docker-entrypoint.sh .

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["run"]