# GKE Private Clusters: Troubleshooting Guide

## Common Issues and Solutions

### 1. Cluster Creation Timeout

**Symptoms:**
- `gcloud container clusters create` hangs or times out
- Cluster status shows `CREATING` for extended period

**Root Causes:**
- Insufficient IP quota in VPC network
- Service account lacks required permissions
- Region-specific quota limits

**Solutions:**

```bash
# Check cluster status
gcloud container clusters list

# Describe cluster for details
gcloud container clusters describe private-cluster

# Check quota
gcloud compute regions describe us-east1

# Request quota increase if needed
gcloud services quota list --service=container.googleapis.com
```

### 2. Master Authorized Network Rejection

**Symptoms:**
- Error: "cidr_block must be a valid CIDR"
- Access denied from authorized IP range

**Root Causes:**
- Incorrect CIDR notation (e.g., missing /32 for single IP)
- Source IP changed after authorization
- Network configuration mismatch

**Solutions:**

```bash
# Verify current IP
curl ifconfig.me

# Authorize with correct format (use /32 for single IP)
gcloud container clusters update private-cluster \
  --enable-master-authorized-networks \
  --master-authorized-networks "35.192.107.237/32"

# Verify authorized networks
gcloud container clusters describe private-cluster \
  --format="value(masterAuthorizedNetworksConfig.cidrBlocks)"
```

### 3. kubectl Connection Refused

**Symptoms:**
- `Connection refused` error when connecting to cluster
- `Unable to connect to the server` message

**Root Causes:**
- bastion host lacks required service account scopes
- Network firewall blocking access
- Zone mismatch in configuration

**Solutions:**

```bash
# Verify VM scopes
gcloud compute instances describe source-instance --zone=$ZONE \
  --format="value(serviceAccounts[0].scopes)"

# Re-create VM with proper scopes if needed
gcloud compute instances delete source-instance --zone=$ZONE --quiet
gcloud compute instances create source-instance \
  --zone=$ZONE \
  --machine-type=e2-medium \
  --scopes 'https://www.googleapis.com/auth/cloud-platform'

# Verify credentials configuration
kubectl config view
```

### 4. Subnet CIDR Overlap

**Symptoms:**
- Error: "IP ranges overlap with existing ranges"
- Cluster creation fails due to CIDR conflict

**Root Causes:**
- Primary range overlaps with existing subnets
- Secondary ranges overlap with pod/service ranges

**Solutions:**

```bash
# List existing subnets
gcloud compute networks subnets list --network default

# Check for overlaps
# Primary: 10.0.0.0/22 overlaps with 10.0.0.0/16
# Adjust to non-overlapping range (e.g., 10.0.4.0/22)
```

### 5. Nodes Show External IP (Failure Case)

**Symptoms:**
- `kubectl get nodes --output wide` shows EXTERNAL-IP values

**Root Causes:**
- `--enable-private-nodes` flag not set during cluster creation
- Cluster recreated without private node option

**Solutions:**

```bash
# Verify cluster is private
gcloud container clusters describe private-cluster \
  --format="value(privateClusterConfig)"

# Recreate cluster with private nodes if needed
# (requires cluster deletion and recreation)
```

## Diagnostic Commands Reference

### Cluster Status

```bash
# List all clusters
gcloud container clusters list

# Describe specific cluster
gcloud container clusters describe private-cluster

# Check cluster health
gcloud container clusters get-credentials private-cluster --zone=$ZONE
kubectl cluster-info
```

### Network Verification

```bash
# List subnets
gcloud compute networks subnets list --network default

# Describe subnet details
gcloud compute networks subnets describe [SUBNET_NAME] --region=$REGION

# Check firewall rules
gcloud compute firewall-rules list --network default
```

### Node Verification

```bash
# Verify node IPs (should show InternalIP only)
kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{range .status.addresses[*]}{.type}{"="}{.address}{" "}{end}{"\n"}{end}'

# Check node YAML for IP details
kubectl get nodes -o yaml | grep -A4 addresses
```

## Log Locations

### GKE Cluster Logs

```bash
# Enable logging (if not enabled)
gcloud container clusters update private-cluster \
  --enable-cloud-logging \
  --enable-cloud-monitoring

# View logs in Cloud Logging
# Console: https://console.cloud.google.com/logs
```

### VM Serial Port Logs

```bash
# Check VM boot logs
gcloud compute instances get-serial-port-output source-instance --zone=$ZONE
```

## Support Resources

- [GKE Documentation](https://cloud.google.com/kubernetes-engine/docs)
- [GKE Support Options](https://cloud.google.com/support)
- [Cloud Community Forums](https://cloud.google.com/community)