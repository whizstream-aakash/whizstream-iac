#!/bin/bash

set -euo pipefail
trap 'handle_error $LINENO' ERR
trap 'handle_cancel' SIGINT SIGTERM

# Accept workspace name as a parameter, default to "dev"
WORKSPACE="${1:-dev}"

# Absolute paths
MAIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/main"
BOOTSTRAP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/bootstrap"


# Error handling function
handle_error() {
  echo "❌ Error at line $1. Initiating cleanup..." >&2
  destroy_infra
  exit 1
}

# Cancellation handling
handle_cancel() {
  echo "🛑 Workflow was canceled. Initiating cleanup..."
  destroy_infra
  exit 1
}

# Destroy functionq
destroy_infra() {
  echo "🧨 Destroying infrastructure in 'main/($WORKSPACE)'..."
  cd "$MAIN_DIR"
  terraform destroy -auto-approve || echo "⚠️ Failed to destroy '$WORKSPACE' workspace"

  echo "🧨 Destroying infrastructure in 'bootstrap/'..."
  cd "$BOOTSTRAP_DIR"
  terraform init
  terraform destroy -auto-approve || echo "⚠️ Failed to destroy 'bootstrap' workspace"

  echo "✅ Cleanup completed."
}

# Main Deploymentscripts/terraform_deploy_main.sh
echo "📦 Moving to main folder: $MAIN_DIR"
cd "$MAIN_DIR"

echo "🚀 Initializing Terraform in main folder"
terraform init

# Ensure workspace exists or create it
if terraform workspace list | grep "$WORKSPACE"; then
    echo "✅ Workspace '$WORKSPACE' already exists"
else
    echo "📁 Creating workspace '$WORKSPACE'"
    terraform workspace new "$WORKSPACE"
fi

echo "📌 Selecting workspace: $WORKSPACE"
terraform workspace select "$WORKSPACE"

echo "🔍 Validating Terraform Configuration..."
terraform validate

echo "📄 Planning Terraform changes..."
terraform plan 

echo "🚀 Applying Terraform changes..."
terraform apply -auto-approve

echo "✅ Terraform apply completed successfully in '$WORKSPACE' workspace."