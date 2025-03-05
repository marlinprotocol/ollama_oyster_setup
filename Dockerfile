# Build stage
FROM rust:latest as build
WORKDIR /usr/src/app
COPY ./oyster_http_proxy .
RUN cargo build --release

# Final stage
FROM ubuntu:22.04
COPY --from=build /usr/src/app/target/release/http_proxy /app/http_proxy
WORKDIR /app
CMD ["./http_proxy", "0.0.0.0", "5000", "0.0.0.0", "11434"]
