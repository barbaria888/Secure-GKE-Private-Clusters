# Images Directory

This directory contains architecture diagrams and verification screenshots for the GKE Private Clusters lab.

## Required Images

### Architecture Diagrams

1. **gke-private-cluster-architecture.png**
   - VPC network topology
   - Cluster placement within default network
   - CIDR range mappings

### Implementation Screenshots

2. **private-cluster-create.png**
   - `gcloud beta container clusters create` command output
   - Cluster status showing RUNNING state

3. **subnet-auto-generated.png**
   - `gcloud compute networks subnets list` output
   - Subnet details with secondary IP ranges

4. **master-authorized-networks.png**
   - `gcloud container clusters update` for authorized networks
   - External IP configuration

5. **bastion-vm.png**
   - Source instance creation
   - SSH connection to bastion host

6. **kubectl-verification.png**
   - `kubectl get nodes --output wide` showing no external IPs
   - Pod-to-service communication

### Custom Subnet Screenshots

7. **custom-subnet-creation.png**
   - `gcloud compute networks subnets create` for custom subnet
   - Secondary range definitions

8. **second-cluster-create.png**
   - `gcloud beta container clusters create` for cluster2
   - Custom subnet association

## Image Requirements

- **Format**: PNG with transparent background support (optional)
- **Resolution**: 1920x1080 minimum, 3840x2160 preferred
- **Contrast**: High contrast for text readability
- **Watermark**: None (clean screenshots only)

## Image Naming Convention

Use kebab-case with descriptive names:
- `component-function-description.png`

## Image Sources

Screenshots should be taken from:
- Google Cloud Console (GKE, Compute Engine, VPC sections)
- Cloud Shell terminal output
- SSH session to bastion host

## Alt Text Guidelines

All images should have descriptive alt text following this pattern:
```
[Component] [Action] [Result]
```

Example: `Bastion VM SSH connection successful`