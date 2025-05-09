#!/bin/bash

set -euo pipefail
trap 'handle_error $LINENO' ERR
trap 'handle_cancel' SIGINT SIGTERM

# Accept branch name as a parameter, default to "dev"
BRANCH="${1:-dev}"

# Absolute paths
MAIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/main"
BOOTSTRAP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/bootstrap"

# Debug: Print the current branch
echo "Branch name: $BRANCH"

# Check if the workspace is 'dev'
if [ "$BRANCH" == "dev" ]; then  # Correct syntax with spaces around '=='

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
    echo "Not in 'dev' branch. Skipping Terraform commands."
fi  

