# Azure Container App examples

Build HTTP example:

```shell
docker build -t az-capp-http:1 -f src/AzCappHttp/Dockerfile .
```

Run HTTP container locally:

```shell
docker run -it --rm -p 80:5555 --name az-capp-http az-capp-http:1
```
