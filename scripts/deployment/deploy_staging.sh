#!/bin/bash

# use the staging environment of openfaas as kubeconfig
export KUBECONFIG=openfaas
kubectl get nodes
echo "$DOCKER_PW" | docker login -u "$DOCKER_USERNAME" --password-stdin
echo "$EKS_OF_PW" | faas-cli login --username "$EKS_OF_USER" --password-stdin --gateway="$EKS_OF_GW"
# echo 8aa43049aac76b200072a0f827b330989846bb09 | faas-cli login --username sahinm --password-stdin
cd testing
faas-cli up -f weather-forecast.yml --gateway="$EKS_OF_GW" --tag=branch

# Some test cases
echo -n Stuttgart, DE | faas-cli invoke weather-forecast
echo -n Istanbul | faas-cli invoke weather-forecast
echo -n Heilbronn:DE | faas-cli invoke weather-forecast

cd -