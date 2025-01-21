output "client_vpn_endpoint_id" {
  description = "The ID of the Client VPN endpoint"
  value       = aws_ec2_client_vpn_endpoint.VPN-Client-EP01.id
}

output "client_vpn_endpoint_dns" {
  description = "The DNS name of the Client VPN endpoint"
  value       = aws_ec2_client_vpn_endpoint.VPN-Client-EP01.dns_name
}