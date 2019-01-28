#!/bin/bash

# Create new workspace for bootstrapping
terraform workspace new state
# Initialize provider for bootstrapping (Amazon S3)
terraform init remote-state
# Bootstrap state infrastructure
terraform apply -auto-approve remote-state
# Fill in backend info (requires envsubst from package gettext)
source <(terraform output -state=terraform.tfstate.d/state/terraform.tfstate | tr -d " " | sed -e 's/^/export /')
envsubst '${BACKEND_BUCKET_NAME},${BACKEND_TABLE_NAME}' <backend/backend.tf.tmpl >backend/backend.tf
# Migrate state of remote backend to remote backend
terraform init backend
# Create symbolic link for backend in root directory to work
# with further workspaces (Dev, staging, testing, ...)
ln -s 'remote-backend/backend.tf' backend.tf
