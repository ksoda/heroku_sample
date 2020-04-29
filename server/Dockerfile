FROM rust:1 as builder

ENV USER=root

RUN cargo new --bin /var/local/project
WORKDIR /var/local/project

COPY Cargo.lock .
COPY Cargo.toml .

RUN cargo build --release

RUN rm src/*.rs
RUN rm ./target/release/deps/actix_todo*


COPY src src
RUN cargo build --release

RUN ls /var/local/project/target/release

FROM rust:1-slim-stretch
RUN apt-get update \
    && apt-get install -y \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/local

COPY --from=builder /var/local/project/target/release/actix-todo .

COPY static static
COPY templates templates

EXPOSE 8088

ENTRYPOINT ["./actix-todo"]
