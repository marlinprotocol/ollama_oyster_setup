# Oyster Ollama Setup

Deploy llama3.2 on Oyster using the ollama framework and interact with it in a verifiable manner.

## Prerequisites
- Install [Docker](https://docs.docker.com/engine/install/ubuntu/)
- Check your [System requirements](https://docs.marlin.org/oyster/build-cvm/tutorials/)
- Setup the [Development environment](https://docs.marlin.org/oyster/build-cvm/tutorials/setup)

## Steps for using Marlin's TEE (only supports Linux systems)

1. Clone the repo
  ```sh
  git clone https://github.com/marlinprotocol/ollama_oyster_setup.git
  ```

2. Build and export the docker image
   ```sh
   docker build -t http_proxy .

   docker save http_proxy:latest > image.tar
   ```

3. Build an enclave image
   ```sh
   # for amd64
   oyster-cvm build --platform amd64 --docker-compose ./docker-compose.yml --docker-images ./image.tar

   # for arm64
   oyster-cvm build --platform arm64 --docker-compose ./docker-compose.yml --docker-images ./image.tar
   ```
   You should now have a result folder with the enclave image in image.eif and the PCRs in pcr.json. The PCRs represent a "fingerprint" of the enclave image and will help you verify what is running in a given enclave.

4. Obtain an [API key and secret from Pinata](https://docs.pinata.cloud/account-management/api-keys)

5. Upload your enclave image to Pinata
   ```sh
   # Note the image URL after it finishes
   PINATA_API_KEY=<API key> PINATA_API_SECRET=<API secret> oyster-cvm upload --file result/image.eif
   ```
   Make a note of the image URL from the output.

6. Set up a wallet where you can export the private key. Deposit 0.001 ETH and 1 USDC to the wallet on the Arbitrum One network.

7. Deploy the enclave image 
   ```sh
   # for amd64
   # replace <key> with private key of the wallet
   # replace <url> with url from the upload step
   oyster-cvm deploy --wallet-private-key <key> --image-url <url> --instance-type c6a.4xlarge --region ap-south-1 --operator 0xe10Fa12f580e660Ecd593Ea4119ceBC90509D642 --duration-in-minutes 15

   # for arm64
   # replace <key> with private key of the wallet
   # replace <url> with url from the upload step
   oyster-cvm deploy --wallet-private-key <key> --image-url <url> --instance-type c6g.4xlarge --region ap-south-1 --operator 0xe10Fa12f580e660Ecd593Ea4119ceBC90509D642 --duration-in-minutes 15
   ```
   Make a note of the IP from the output.

8. Test using `curl` from host machine
  ```sh
  curl http://{{instance-ip}}:5000/api/generate -d '{
    "model": "llama3.2",
    "prompt":"Why is the sky blue?"
  }'
  ```

9. Verify a remote attestation (recommended)
   ```sh
   # Replace <ip> with the IP you obtained above
   # Replace <pcrs> with values from pcr.json
   oyster-cvm verify --enclave-ip <ip> -0 <pcr0> -1 <pcr1> -2 <pcr2>
   ```
   You should see `Verification successful` along with some attestation fields printed out.

10. Head over to [Oyster Confidential VM tutorials](https://docs.marlin.org/oyster/build-cvm/tutorials/) for more details.
