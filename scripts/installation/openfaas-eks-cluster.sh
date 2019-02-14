#!/bin/bash

##### Install OpenFaaS on AWS EKS with eksctl CLI #####
# eksctl create cluster --name=openfaas-eks-staging --nodes=2 --auto-kubeconfig --region=eu-west-1

# install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
# create staging cluster on AWS
eksctl create cluster --name=openfaas-eks-staging --nodes=2 --auto-kubeconfig --region=eu-west-1
export KUBECONFIG=~/.kube/eksctl/clusters/openfaas-eks-staging
kubectl -n kube-system create sa tiller
kubectl create clusterrolebinding tiller-cluster-rule \
    --clusterrole=cluster-admin \
    --serviceaccount=kube-system:tiller
# Deploy Tiller (server component of Helm) to the Cluster
helm init --skip-refresh --wait --upgrade --service-account tiller
# K8s OpenFaaS Namespaces
kubectl apply -f https://raw.githubusercontent.com/openfaas/faas-netes/master/namespaces.yml

# Secrets for Login (Change them as you like)
PASSWORD=$(head -c 12 /dev/urandom | shasum | cut -d' ' -f1)
USER=sahinm

kubectl -n openfaas create secret generic basic-auth \
--from-literal=basic-auth-user=$USERNAME \
--from-literal=basic-auth-password=$PASSWORD

# OpenFaaS Deployment with Helm
helm repo add openfaas https://openfaas.github.io/faas-netes/
helm upgrade openfaas --wait --install openfaas/openfaas \
    --namespace openfaas  \
    --set functionNamespace=openfaas-fn \
    --set serviceType=LoadBalancer \
    --set basic_auth=true \
    --set operator.create=true \
    --set gateway.replicas=2 \
    --set queueWorker.replicas=2
export OPENFAAS_URL=$(kubectl get svc -n openfaas gateway-external -o jsonpath='{.status.loadBalancer.ingress[*].hostname}'):8080

# outputs for the environment variables to use in CI/CD tools
echo Gateway is on: $OPENFAAS_URL
echo Your User: $USERNAME
echo Your PASSWORD: $PASSWORD
