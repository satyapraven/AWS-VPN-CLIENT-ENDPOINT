variable "destination_vpc_cidr" {
  description = "The CIDR block for the VPC where the Client VPN endpoint will be attached"
  type        = string
}

variable "client_ipv4_cidr" {
  description = "The IPv4 CIDR block to assign to VPN clients"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_id" {
  description = "ID of the VPC where the Client VPN endpoint will be attached"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the Client VPN endpoint will be associated"
  type        = list(string)
}