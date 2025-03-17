# Build stage
FROM rust:latest AS build
WORKDIR /usr/src/app
RUN git clone https://github.com/marlinprotocol/llama_oyster_proxy.git
WORKDIR /usr/src/app/llama_oyster_proxy
RUN rm -rf .cargo
RUN cargo update
RUN cargo build --release

# Final stage
FROM ubuntu:22.04
COPY --from=build /usr/src/app/llama_oyster_proxy/target/release/http_proxy /app/http_proxy
WORKDIR /app
CMD ["./http_proxy", "0.0.0.0", "5000", "0.0.0.0", "11434"]
