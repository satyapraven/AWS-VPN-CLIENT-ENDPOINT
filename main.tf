provider "aws" {
  region = var.aws_region
}

# Generate a self-signed certificate for the VPN server
resource "tls_private_key" "vpn_server" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "vpn_server" {
  private_key_pem = tls_private_key.vpn_server.private_key_pem

  subject {
    common_name = "vpn.HMDA.gov.in"
  }

  validity_period_hours = 87600 # 10 years

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

# Upload the certificate to ACM
resource "aws_acm_certificate" "vpn_server" {
  private_key      = tls_private_key.vpn_server.private_key_pem
  certificate_body = tls_self_signed_cert.vpn_server.cert_pem
}

# Create the Client VPN endpoint
resource "aws_ec2_client_vpn_endpoint" "VPN-Client-EP01" {
  description            = "Client VPN endpoint"
  server_certificate_arn = aws_acm_certificate.vpn_server.arn
  client_cidr_block     = var.client_ipv4_cidr
  vpc_id                = var.vpc_id
  split_tunnel          = true

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.vpn_server.arn
  }

  connection_log_options {
    enabled = false
  }
}

# Associate the VPN endpoint with subnets
resource "aws_ec2_client_vpn_network_association" "VPN-Client-EP01" {
  count                  = length(var.subnet_ids)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.VPN-Client-EP01.id
  subnet_id              = var.subnet_ids[count.index]
}

# Create authorization rules
resource "aws_ec2_client_vpn_authorization_rule" "all" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.VPN-Client-EP01.id
  target_network_cidr    = var.destination_vpc_cidr
  authorize_all_groups   = true
}