FROM elixir:alpine

LABEL maintainer "my name and email address"

WORKDIR /pleroma

RUN apk -U upgrade \
  && apk add -t build-dependencies \
  build-base \
  && apk add git \
  && rm -rf /tmp/* /var/cache/apk/* \
  && mkdir /pleroma/uploads

COPY pleroma/ /pleroma/
RUN rm /pleroma/.git
COPY .git/modules/pleroma/ /pleroma/.git/
COPY setting/web/config/prod.secret.exs /pleroma/config/prod.secret.exs

ENV MIX_ENV prod
RUN cd /pleroma \
  && mix local.hex --force \
  && mix local.rebar --force \
  && mix deps.get

VOLUME /pleroma/uploads/
VOLUME /pleroma/config/
VOLUME /pleroma/priv/
