#!/bin/bash

set -euo pipefail
trap 'handle_error $LINENO' ERR
trap 'handle_cancel' SIGINT SIGTERM

# Accept workspace name as a parameter, default to "dev"
WORKSPACE="${1:-dev}"

# Absolute paths
MAIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/main"
BOOTSTRAP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/bootstrap"

# Debug: Print the workspace variable
echo "Workspace: $WORKSPACE"

# Check if the workspace is 'dev'
if [ "$WORKSPACE" == "dev" ]; then  # Correct syntax with spaces around '=='

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
else
    echo "Not in 'dev' workspace. Skipping Terraform commands."
fi  

