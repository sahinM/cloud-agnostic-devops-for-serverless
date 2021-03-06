#!/bin/bash

# install KinD (Kubernetes in Docker)
go get sigs.k8s.io/kind
  # creating KinD-Cluster in Docker
kind create cluster --name openfaas
export KUBECONFIG="$(kind get kubeconfig-path --name="openfaas")"
  # create service account with rbac permissions for tiller 
kubectl -n kube-system create sa tiller \
    && kubectl create clusterrolebinding tiller \
          --clusterrole cluster-admin \
          --serviceaccount=kube-system:tiller
  # installing server component of helm -> tiller 
helm init --skip-refresh --wait --upgrade --service-account tiller
  # adding namespaces openfaas and openfaas-fn
kubectl apply -f https://raw.githubusercontent.com/openfaas/faas-netes/master/namespaces.yml
  # installing openFaas with Helm
helm repo add openfaas https://openfaas.github.io/faas-netes && \
        helm repo update && \
        helm upgrade openfaas --wait --install openfaas/openfaas \
          --namespace openfaas \
          --set basic_auth=false \
          --set functionNamespace=openfaas-fn \
          --set operator.create=false
  # Port forwarding to localhost:8080 as background process
kubectl port-forward svc/gateway -n openfaas 8080:8080 &
