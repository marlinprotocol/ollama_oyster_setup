# Oyster Ollama Setup

### Clone the repo

```
git clone https://github.com/marlinprotocol/ollama_oyster_setup.git
```

### Build Enclave image
```
docker run -it --privileged -v `pwd`:/app/mount marlinorg/enclave-builder 
```

An enclave image should be created at `./enclave/enclave.eif`. Upload it to a publicly accessible url so that it can be used for deploying oyster enclave by the operator.

### Run Oyster enclave from frontend or smart contract call



### Test

Test using the `curl` from host machine
```
curl http://{{instance-ip}}:5000/api/generate -d '{
  "model": "tinyllama",
  "prompt":"Why is the sky blue?"
}'
```
