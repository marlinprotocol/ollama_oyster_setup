FROM ubuntu:22.04

ARG TARGETARCH

RUN apt-get update -y && apt-get install apt-utils -y && apt-get install net-tools iptables iproute2 wget curl -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# supervisord to manage programs
RUN wget -O supervisord http://public.artifacts.marlin.pro/projects/enclaves/supervisord_master_linux_$TARGETARCH
RUN chmod +x supervisord

# transparent proxy component inside the enclave to enable outgoing connections
RUN wget -O ip-to-vsock-transparent http://public.artifacts.marlin.pro/projects/enclaves/ip-to-vsock-transparent_v1.0.0_linux_$TARGETARCH
RUN chmod +x ip-to-vsock-transparent

# key generator to generate static keys
RUN wget -O keygen http://public.artifacts.marlin.pro/projects/enclaves/keygen_v1.0.0_linux_$TARGETARCH
RUN chmod +x keygen

# attestation server inside the enclave that generates attestations
RUN wget -O attestation-server http://public.artifacts.marlin.pro/projects/enclaves/attestation-server_v1.0.0_linux_$TARGETARCH
RUN chmod +x attestation-server

# proxy to expose attestation server outside the enclave
RUN wget -O vsock-to-ip http://public.artifacts.marlin.pro/projects/enclaves/vsock-to-ip_v1.0.0_linux_$TARGETARCH
RUN chmod +x vsock-to-ip

# dnsproxy to provide DNS services inside the enclave
RUN wget -O dnsproxy http://public.artifacts.marlin.pro/projects/enclaves/dnsproxy_v0.46.5_linux_$TARGETARCH
RUN chmod +x dnsproxy

RUN wget -O oyster-keygen http://public.artifacts.marlin.pro/projects/enclaves/keygen-secp256k1_v1.0.0_linux_$TARGETARCH
RUN chmod +x oyster-keygen

RUN curl https://ollama.ai/install.sh | sh

# attestation utility
RUN wget -O oyster-attestation-server-secp256k1 http://public.artifacts.marlin.pro/projects/enclaves/attestation-server-secp256k1_v1.0.0_linux_$TARGETARCH
RUN chmod +x oyster-attestation-server-secp256k1

# supervisord config
COPY supervisord.conf /etc/supervisord.conf

# setup.sh script that will act as entrypoint
COPY setup.sh ./
RUN chmod +x setup.sh

COPY http_proxy_$TARGETARCH ./http_proxy
RUN chmod +x http_proxy

RUN mkdir ollamatmp

# entry point
ENTRYPOINT [ "/app/setup.sh" ]
