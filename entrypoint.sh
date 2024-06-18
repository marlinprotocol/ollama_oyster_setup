#!/bin/sh

dockerd &

sleep 10

docker buildx create --name multiplatformEnclave --driver docker-container --bootstrap
docker buildx use multiplatformEnclave

cd /app/mount/setup
docker buildx build --build-arg TARGETARCH=arm64 --platform linux/arm64 -t enclave:latest --load .

mkdir -p /app/mount/enclave
mkdir -p /var/log/nitro_enclaves
touch /var/log/nitro_enclaves/nitro_enclaves.log

nitro-cli build-enclave --docker-uri enclave:latest --output-file /app/mount/enclave/enclave.eif