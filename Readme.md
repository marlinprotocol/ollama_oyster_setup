# Oyster Ollama Setup

Deploy llama3.2 on Oyster using the ollama framework and interact with it in a verifiable manner.

## Prerequisites
- Check your [System requirements](https://docs.marlin.org/oyster/build-cvm/tutorials/)
- Setup the [Development environment](https://docs.marlin.org/oyster/build-cvm/guides/llama3_2/intro#install-the-oyster-cvm-cli-tool)

## Steps for using Marlin's TEE

1. Clone the repo
  ```sh
  git clone https://github.com/marlinprotocol/ollama_oyster_setup.git
  cd ollama_oyster_setup
  ```

2. Update the following docker images according to your system's architecture in the `docker-compose.yml`
  ```sh
  # llama http proxy service
  llama_proxy:
    image: kalpita888/ollama_arm64:0.0.1                        # For arm64 system use kalpita888/ollama_arm64:0.0.1 and for amd64 system use kalpita888/ollama_amd64:0.0.1
  ```

3. Set up a wallet where you can export the private key. Deposit 0.001 ETH and 1 USDC to the wallet on the Arbitrum One network.

4. Deploy the enclave image 
  ```sh
  # for amd64
  # replace <key> with private key of the wallet
  oyster-cvm deploy --wallet-private-key <key> --docker-compose ./docker-compose.yml --instance-type c6a.4xlarge --region ap-south-1  --operator 0xe10Fa12f580e660Ecd593Ea4119ceBC90509D642 --duration-in-minutes 20 --pcr-preset base/blue/v1.0.0/amd64 --image-url https://artifacts.marlin.org/oyster/eifs/base-blue_v1.0.0_linux_amd64.eif

  # for arm64
  # replace <key> with private key of the wallet
  oyster-cvm deploy --wallet-private-key <key> --docker-compose ./docker-compose.yml --instance-type c6g.4xlarge --region ap-south-1  --operator 0xe10Fa12f580e660Ecd593Ea4119ceBC90509D642 --duration-in-minutes 20 --pcr-preset base/blue/v1.0.0/arm64 --image-url https://artifacts.marlin.org/oyster/eifs/base-blue_v1.0.0_linux_arm64.eif
  ```
  Make a note of the IP from the output and wait for ~4min for the model pull to finish.

5. Test using `curl` from host machine
  ```sh
  curl http://{{instance-ip}}:5000/api/generate -d '{
    "model": "llama3.2",
    "prompt":"Why is the sky blue?"
  }'
  ```

6. Running the `curl` command above with `-v` option shows us two important headers:
  ```
  x-oyster-timestamp: 1741620242
  x-oyster-signature: 8781e472b0f8e3693c1c6cec60b1ae0f5fed4c574d24e3bfcc6cc23f02a918a8785709ceb8a464a7d1dbbb8809ba73047acaa3ff5f1918ba565d82d177e123801b
  ```
  The above signature can be used to verify that the response is received from an enclave.

7. Verify a remote attestation (recommended)
  ```sh
  # Replace <ip> with the IP you obtained above
  oyster-cvm verify --enclave-ip <ip>
  ```
  You should see `Verification successful` along with some attestation fields printed out.

Head over to [Oyster Confidential VM tutorials](https://docs.marlin.org/oyster/build-cvm/tutorials/) for more details.
 
