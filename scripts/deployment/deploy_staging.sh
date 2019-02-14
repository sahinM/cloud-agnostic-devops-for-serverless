#!/bin/bash

# required authenticator for interacting with aws k8s clusters 
go get -u -v github.com/kubernetes-sigs/aws-iam-authenticator/cmd/aws-iam-authenticator
# use the staging environment of openfaas as kubeconfig
export KUBECONFIG=openfaas
kubectl get nodes
# login to docker and OpenFaaS Staging Cluster
echo "$DOCKER_PW" | docker login -u "$DOCKER_USERNAME" --password-stdin
echo "$EKS_OF_PW" | faas-cli login --username "$EKS_OF_USER" --password-stdin --gateway="$EKS_OF_GW"
cd testing
faas-cli up -f weather-forecast.yml --gateway="$EKS_OF_GW" --tag=branch

# Some test cases
echo -n Stuttgart, DE | faas-cli invoke weather-forecast -gateway="$EKS_OF_GW"
echo -n Istanbul | faas-cli invoke weather-forecast -gateway="$EKS_OF_GW"
echo -n Heilbronn:DE | faas-cli invoke weather-forecast -gateway="$EKS_OF_GW"

cd -