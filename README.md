# Cloud Agnostic Continuous Delivery For Serverless Applications
This repository should give concepts of developing unified (vendor/cloud-agnostic) CI/CD pipelines with DevOps principles for serverless applications

## Pipeline Explanation

With this guide you are able to bring up a CI/CD Pipeline in Travis CI with IaC through Terraform. The pipeline works through the following steps:

### Bootstrapping the Terraform backend by remote state with Amazon S3

First the following required tooling will be installed:
- Terraform - IaC Tooling
- kubectl - The Kubernetes CLI
- Helm - The package manager for K8S
- OpenFaaS CLI - Create, Build & Deploy FaaS-Apps in a Cluster at a Cloud Provider of your choice.
