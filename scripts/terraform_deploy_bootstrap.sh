#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Get the absolute path to the directory containing this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "📦 Moving to bootstrap folder"
cd "$SCRIPT_DIR/../bootstrap"

# Initialize Terraform (from the bootstrap folder)
echo "Initializing Terraform in bootstrap folder"
terraform init

# Plan and apply Terraform changes
echo "Planning Terraform changes..."
terraform plan

echo "Applying Terraform changes..."
terraform apply -auto-approve