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

# Destroy function (destroys in reverse order: main → bootstrap)
destroy_infra() {
 echo "🧨 Destroying infrastructure in 'bootstrap/'..."
  cd "$BOOTSTRAP_DIR"
  terraform destroy -auto-approve || echo "⚠️ Failed to destroy 'bootstrap' workspace"

  echo "✅ Cleanup completed."
}

# Get the absolute path to the directory containing this script
echo "📦 Moving to bootstrap folder"
cd "$BOOTSTRAP_DIR"

# Initialize Terraform (from the bootstrap folder)
echo "Initializing Terraform in bootstrap folder"
terraform init

# Plan and apply Terraform changes
echo "Planning Terraform changes..."
terraform plan

echo "Applying Terraform changes..."
terraform apply -auto-approve