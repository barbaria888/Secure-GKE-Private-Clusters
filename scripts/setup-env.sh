#!/bin/bash
# Environment Setup Script for GKE Private Clusters Lab
# Initializes project context and region/zone configurations

set -e

echo "=== GKE Private Clusters Environment Setup ==="

# Project configuration
PROJECT_ID="qwiklabs-gcp-01-73957f16b11f"
ACCOUNT="student-01-ee43fb55cfc4@qwiklabs.net"

# Region and zone configuration
REGION="us-east1"
ZONE="us-east1-d"

echo "Configuring project: $PROJECT_ID"
gcloud config set project "$PROJECT_ID"

echo "Setting active account: $ACCOUNT"
gcloud config set account "$ACCOUNT"

echo "Setting compute zone: $ZONE"
gcloud config set compute/zone "$ZONE"

echo "Exporting environment variables..."
export REGION="$REGION"
export ZONE="$ZONE"

echo ""
echo "=== Environment Configuration Complete ==="
echo "Region: $REGION"
echo "Zone: $ZONE"
echo "Project: $(gcloud config get-value project)"
echo "Account: $(gcloud config get-value account)"
echo ""
echo "Next steps:"
echo "1. Create private cluster: ./scripts/create-private-cluster.sh"
echo "2. Set up bastion host: ./scripts/setup-bastion-host.sh"