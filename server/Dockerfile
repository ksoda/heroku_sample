FROM rust:1 as builder

ENV USER=root

RUN cargo new --bin /var/local/project
WORKDIR /var/local/project

COPY Cargo.lock Cargo.toml ./
RUN cargo build --release \
    && rm src/*.rs \
    && rm ./target/release/deps/actix_todo*

RUN cargo install diesel_cli \
    --no-default-features --features postgres

COPY src src
RUN cargo build --release

COPY migrations migrations

FROM rust:1-slim-stretch
RUN apt-get update \
    && apt-get install -y \
    curl \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/local

COPY --from=builder /var/local/project/target/release/actix-todo .

COPY static static

EXPOSE 8088

CMD ["./actix-todo"]
