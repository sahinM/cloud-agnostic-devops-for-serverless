#!/bin/bash

# build, deploy and push weather-forecast function and call it
export KUBECONFIG="$(kind get kubeconfig-path --name="openfaas")"
cd testing
# building and testing the function with gradle tool
echo "$DOCKER_PW" | docker login -u "$DOCKER_USERNAME" --password-stdin
faas-cli up -f weather-forecast.yml

# Some test cases
echo -n Stuttgart, DE | faas-cli invoke weather-forecast
echo -n Istanbul | faas-cli invoke weather-forecast
echo -n Heilbronn:DE | faas-cli invoke weather-forecast

 kind delete cluster --name openfaas
 kill -9 $(lsof -t -i:8080)

