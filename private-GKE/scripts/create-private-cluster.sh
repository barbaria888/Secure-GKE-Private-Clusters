#!/bin/bash
# Create GKE Private Cluster Script
# Creates a private cluster with IP aliases and master CIDR configuration

set -e

source "$(dirname "$0")/setup-env.sh"

echo "=== Creating GKE Private Cluster ==="

CLUSTER_NAME="${1:-private-cluster}"

echo "Creating cluster: $CLUSTER_NAME"
echo "Master CIDR: 172.16.0.16/28"
echo "Region: $REGION"

gcloud beta container clusters create "$CLUSTER_NAME" \
  --enable-private-nodes \
  --master-ipv4-cidr 172.16.0.16/28 \
  --enable-ip-alias \
  --create-subnetwork "" \
  --machine-type e2-medium \
  --zone "$ZONE"

echo ""
echo "=== Cluster Creation Request Submitted ==="
echo "Cluster name: $CLUSTER_NAME"
echo "Zone: $ZONE"
echo ""
echo "Waiting for cluster to be ready (approximately 3-5 minutes)..."
echo "Run: gcloud container clusters list"