# base image
FROM marlinorg/nitro-cli

# working directory
WORKDIR /app/setup

# add files
COPY entrypoint.sh ./
RUN chmod +x entrypoint.sh

# entry point
ENTRYPOINT [ "/app/setup/entrypoint.sh" ]