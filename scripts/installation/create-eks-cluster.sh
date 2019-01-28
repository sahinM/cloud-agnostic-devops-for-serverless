#!/bin/bash

# Create production environment workspace
terraform workspace new prod
terraform init production/aws/eks
# Deploy kubernetes cluster
terraform apply -auto-approve production/aws/eks

