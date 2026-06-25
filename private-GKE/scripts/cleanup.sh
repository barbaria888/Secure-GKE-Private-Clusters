#!/bin/bash
# Cleanup Script for GKE Private Clusters Lab
# Removes all created resources to prevent charges

set -e

source "$(dirname "$0")/setup-env.sh"

echo "=== GKE Private Clusters Cleanup ==="
echo "WARNING: This will delete all created resources!"
read -p "Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Cleanup cancelled."
  exit 0
fi

# Delete clusters
echo "Deleting private-cluster2..."
gcloud container clusters delete private-cluster2 --zone="$ZONE" --quiet

echo "Deleting private-cluster..."
gcloud container clusters delete private-cluster --zone="$ZONE" --quiet

# Delete VM instances
echo "Deleting source-instance..."
gcloud compute instances delete source-instance --zone="$ZONE" --quiet

# Delete custom subnet
echo "Deleting custom subnet: my-subnet..."
gcloud compute networks subnets delete my-subnet --region="$REGION" --quiet

# Delete auto-generated subnet
echo "Deleting auto-generated subnet..."
SUBNET_NAME=$(gcloud compute networks subnets list --network default --format="value(NAME)")
gcloud compute networks subnets delete "$SUBNET_NAME" --region="$REGION" --quiet

echo ""
echo "=== Cleanup Complete ==="
echo "All resources have been removed."