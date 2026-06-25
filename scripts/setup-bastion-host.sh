#!/bin/bash
# Setup Bastion Host for GKE Cluster Access
# Creates VM instance and configures master authorized networks

set -e

source "$(dirname "$0")/setup-env.sh"

CLUSTER_NAME="${1:-private-cluster}"
VM_NAME="${2:-source-instance}"

echo "=== Setting Up Bastion Host ==="

# Create bastion host VM
echo "Creating bastion host VM: $VM_NAME"
gcloud compute instances create "$VM_NAME" \
  --zone="$ZONE" \
  --machine-type=e2-medium \
  --scopes 'https://www.googleapis.com/auth/cloud-platform'

# Get external IP
echo "Retrieving external IP..."
EXTERNAL_IP=$(gcloud compute instances describe "$VM_NAME" --zone="$ZONE" --format="get(networkInterfaces.accessConfigs.natIP)")
echo "Bastion Host IP: $EXTERNAL_IP"

# Authorize external access
echo "Authorizing external access for cluster: $CLUSTER_NAME"
gcloud container clusters update "$CLUSTER_NAME" \
  --enable-master-authorized-networks \
  --master-authorized-networks "$EXTERNAL_IP/32" \
  --zone="$ZONE"

# Configure kubectl from bastion
echo ""
echo "=== Configuration Complete ==="
echo ""
echo "To connect to the cluster:"
echo "1. SSH into bastion host:"
echo "   gcloud compute ssh $VM_NAME --zone=$ZONE"
echo ""
echo "2. Inside SSH session, install kubectl:"
echo "   sudo apt-get update"
echo "   sudo apt-get install kubectl -y"
echo "   sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin -y"
echo ""
echo "3. Get cluster credentials:"
echo "   gcloud container clusters get-credentials $CLUSTER_NAME --zone=$ZONE"
echo ""
echo "4. Verify cluster access:"
echo "   kubectl get nodes --output wide"