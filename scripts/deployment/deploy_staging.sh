#!/bin/bash

export KUBECONFIG=kubeconfig-eks-openfaas-staging-cluster
echo "$DOCKER_PW" | docker login -u "$DOCKER_USERNAME" --password-stdin
cd testing
echo $EKS_OF_PW | faas-cli login --username $EKS_OF_USER --password-stdin
faas-cli up -f testing/weather-forecast.yml

# Some test cases
echo -n Stuttgart, DE | faas-cli invoke weather-forecast
echo -n Istanbul | faas-cli invoke weather-forecast
echo -n Heilbronn:DE | faas-cli invoke weather-forecast

cd -
