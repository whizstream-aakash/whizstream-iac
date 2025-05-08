#!/bin/bash

set -euo pipefail  # Exit on errors, use of unset variables, or failed pipeline
trap 'echo "❌ Error at line $LINENO. Exiting." >&2' ERR

# Accept workspace name as a parameter, default to "dev"
WORKSPACE="${1:-dev}"

# Get the absolute path to the directory containing this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "📦 Moving to main folder"
cd "$SCRIPT_DIR/../main"

# Initialize Terraform
echo "🚀 Initializing Terraform in main folder"
terraform init

# Create workspace if it doesn't exist
if terraform workspace list | grep -qw "$WORKSPACE"; then
    echo "✅ Workspace '$WORKSPACE' already exists"
else
    echo "📁 Creating workspace '$WORKSPACE'"
    terraform workspace new "$WORKSPACE"
fi

# Select the workspace
echo "📌 Selecting workspace: $WORKSPACE"
terraform workspace select "$WORKSPACE"

# Validate configuration
echo "🔍 Validating Terraform Configuration..."
terraform validate

# Plan changes
echo "📄 Planning Terraform changes..."
terraform plan -out=tfplan

# Apply changes
echo "🚀 Applying Terraform changes..."
terraform apply -auto-approve tfplan

echo "✅ Terraform apply completed successfully in '$WORKSPACE' workspace."
