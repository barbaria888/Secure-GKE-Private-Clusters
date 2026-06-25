# GKE Private Cluster Network Security

## Overview

This document outlines the network security architecture for GKE private clusters deployed with master authorized networks and custom subnetworks.

## Security Layers

### Layer 1: Private Nodes

- Node pools have no external IP addresses
- All node-to-Google-API communication uses private Google Cloud APIs
- Nodes communicate through internal VPC networking only

### Layer 2: Master Authorized Networks

- Control plane accessible only from authorized IP ranges
- Default authorized ranges: nodes primary CIDR and pods secondary CIDR
- Additional ranges can be explicitly authorized (e.g., bastion host IP)

### Layer 3: Network Isolation

- Pods communicate within VPC using secondary ranges
- Services use dedicated secondary IP range
- No public internet routing for cluster traffic

## CIDR Range Planning

### Best Practices

1. **Non-overlapping Ranges**: Ensure primary, pod, and service ranges don't overlap
2. **Adequate Size**: Plan for growth (e.g., /22 for nodes, /14 for pods)
3. **Regional Considerations**: Use regional ranges to avoid cross-region conflicts

### Recommended CIDR Sizes

| Component            | Minimum | Recommended |
| -------------------- | ------- | ----------- |
| Nodes (Primary)      | /26     | /22         |
| Pods (Secondary)     | /16     | /14         |
| Services (Secondary) | /20     | /20         |
| Master               | /28     | /28         |

## Access Control Matrix

| Entity         | Access Method | Authorized Ranges                            |
| -------------- | ------------- | -------------------------------------------- |
| Kubernetes API | HTTPS         | Node CIDR, Pod CIDR, Authorized external IPs |
| Nodes to APIs  | Private API   | All Google Cloud APIs (no public routing)    |
| Pod-to-Pod     | VPC Internal  | Secondary ranges                             |
| Services       | VPC Internal  | Secondary ranges                             |
| Bastion Host   | SSH           | Explicitly authorized external IP            |

## Security Checklist

- [ ] Nodes configured with `--enable-private-nodes`
- [ ] Master authorized networks configured
- [ ] External access limited to /32 CIDR (specific IPs)
- [ ] Custom subnets with explicit CIDR allocation
- [ ] Private Google Cloud API access enabled
- [ ] Service account scopes restricted to minimum required
- [ ] Network tags and firewall rules reviewed
- [ ] Logs and monitoring enabled

## Threat Model

| Threat              | Mitigation                                      |
| ------------------- | ----------------------------------------------- |
| External API Access | Private nodes + master authorized networks      |
| Man-in-the-Middle   | VPC internal routing + TLS                      |
| Unauthorized Access | IP-based authorization + service account scopes |
| Lateral Movement    | Network segmentation via subnets                |
| Data Exfiltration   | No public IP addresses on nodes                 |

## Compliance Considerations

- **SOC 2**: Private clusters reduce attack surface
- **PCI-DSS**: Network segmentation meets requirement 1
- **HIPAA**: Data in transit protected via VPC
- **GDPR**: No public exposure of personal data

## References

- [GKE Security Best Practices](https://cloud.google.com/kubernetes-engine/docs/best-practices/security)
- [VPC Security](https://cloud.google.com/vpc/docs/security)
- [IAM Best Practices](https://cloud.google.com/docs/authentication/best-practices)