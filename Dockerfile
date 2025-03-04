# Build stage
FROM rust:latest as build
WORKDIR /usr/src/app
COPY ./oyster_http_proxy .
RUN cargo build --release
RUN ls -alh target/release

# Final stage
FROM ubuntu:22.04
COPY --from=build /usr/src/app/target/release/http_proxy /app/src/http_proxy
RUN ls -alh /app/src
WORKDIR /app/src
RUN mkdir ollamatmp
EXPOSE 5000
EXPOSE 11434
CMD ["./http_proxy", "127.0.0.1", "5000", "127.0.0.1", "11434"]
