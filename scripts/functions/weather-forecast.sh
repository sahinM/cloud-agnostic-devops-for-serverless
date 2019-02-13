#!/bin/bash

# build, deploy and push weather-forecast function and call it
export KUBECONFIG="$(kind get kubeconfig-path --name="openfaas")"
cd testing
faas-cli build -f weather-forecast.yml
faas-cli deploy -f weather-forecast.yml

echo -n Stuttgart, DE | faas-cli invoke weather-forecast
cd -