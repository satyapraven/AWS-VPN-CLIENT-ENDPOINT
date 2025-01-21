# AWS Client VPN Terraform Configuration

This Terraform configuration sets up an AWS Client VPN endpoint with certificate-based authentication.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed (version 1.0.0 or newer)
- AWS credentials configured
- A VPC and subnets where you want to deploy the Client VPN endpoint

## Features

- Self-signed certificate generation for VPN server
- Certificate-based authentication
- Split-tunnel enabled (only specified traffic goes through VPN)
- VPN endpoint association with multiple subnets
- Authorization rules for VPC access

## Configuration

1. Copy the example variables file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Update `terraform.tfvars` with your values:
   ```hcl
   aws_region           = "ap-south-1"            # Your preferred AWS region
   destination_vpc_cidr = "10.0.0.0/16"          # Your VPC CIDR
   client_ipv4_cidr    = "172.16.0.0/22"         # CIDR for VPN clients
   vpc_id              = "vpc-12345678"          # Your VPC ID
   subnet_ids          = ["subnet-12345678"]     # Your subnet IDs
   ```

## Variables

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `destination_vpc_cidr` | CIDR block for the VPC where the Client VPN endpoint will be attached | string | yes |
| `client_ipv4_cidr` | IPv4 CIDR block to assign to VPN clients | string | yes |
| `aws_region` | AWS region | string | no (default: ap-south-1) |
| `vpc_id` | ID of the VPC where the Client VPN endpoint will be attached | string | yes |
| `subnet_ids` | List of subnet IDs where the Client VPN endpoint will be associated | list(string) | yes |

## Outputs

| Name | Description |
|------|-------------|
| `client_vpn_endpoint_id` | The ID of the Client VPN endpoint |
| `client_vpn_endpoint_dns` | The DNS name of the Client VPN endpoint |

## Usage

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Review the planned changes:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

4. To destroy the resources:
   ```bash
   terraform destroy
   ```

## Security Features

- Certificate-based authentication
- Self-signed certificates managed through AWS Certificate Manager
- Split tunnel enabled to only route specified traffic through VPN
- Authorization rules to control access to VPC resources

## Notes

- The configuration generates a self-signed certificate valid for 10 years
- Split tunnel is enabled by default to optimize network traffic
- Logging is disabled by default but can be enabled by modifying the configuration
- The VPN endpoint is associated with all provided subnet IDs for high availability
