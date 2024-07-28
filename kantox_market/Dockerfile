FROM elixir:1.15

RUN mix local.hex --force && \
	mix local.rebar --force

WORKDIR /app
COPY . .

ENV MIX_ENV=prod

RUN mix deps.get

RUN mix compile

CMD ["mix", "run", "--no-halt"]
