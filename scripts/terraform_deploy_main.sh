#!/bin/bash

set -euo pipefail
trap 'handle_error $LINENO' ERR
trap 'handle_cancel' SIGINT SIGTERM

# Accept workspace name as a parameter, default to "dev"
WORKSPACE="${1:-dev}"

# Absolute paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAIN_DIR="$SCRIPT_DIR/../main"
BOOTSTRAP_DIR="$SCRIPT_DIR/../bootstrap"

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

# Destroy function (destroys in reverse order: main → bootstrap)
destroy_infra() {
  echo "🧨 Destroying infrastructure in 'main/($WORKSPACE)'..."
  cd "$MAIN_DIR"
  terraform init -input=false
  terraform workspace select "$WORKSPACE" || terraform workspace new "$WORKSPACE"
  terraform destroy -auto-approve || echo "⚠️ Failed to destroy '$WORKSPACE' workspace"

  echo "🧨 Destroying infrastructure in 'bootstrap/($WORKSPACE)'..."
  cd "$BOOTSTRAP_DIR"
  terraform init -input=false
  terraform workspace select "$WORKSPACE" || terraform workspace new "$WORKSPACE"
  terraform destroy -auto-approve || echo "⚠️ Failed to destroy 'bootstrap' workspace"

  echo "✅ Cleanup completed."
}

# Main Deployment
echo "📦 Moving to main folder"
cd "$MAIN_DIR"

echo "🚀 Initializing Terraform in main folder"
terraform init

# Ensure workspace exists or create it
if terraform workspace list | grep -qw "$WORKSPACE"; then
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
terraform plan -var-file="../main/terraform.tfvars" -out=tfplan
terraform show tfplan

echo "🚀 Applying Terraform changes..."
terraform apply -auto-approve -input=false -tfplan

echo "✅ Terraform apply completed successfully in '$WORKSPACE' workspace."
