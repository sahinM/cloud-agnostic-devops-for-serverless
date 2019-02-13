#!/bin/bash

# build, deploy and push weather-forecast function and call it
export KUBECONFIG="$(kind get kubeconfig-path --name="openfaas")"
cd testing
# building and testing the function with gradle tool
faas-cli build -f weather-forecast.yml