# AWS VPN Client Configuration

### 1. Purpose
This Standard Operating Procedure (SOP) outlines the process for configuring AWS VPN Client to ensure secure remote access to AWS resources.

### 2. Prerequisites
- An AWS account configured with the necessary access rights.
- A VPC where you want to establish the VPN connection
- Subnets configured in your VPC
- The IP ranges you want to route through the VPN
- SSL/TLS certificates for authentication (if using certificate-based authentication)

### 2. Create a Server Certificate
You will require an SSL certificate for the Client VPN endpoint. You can opt for an SSL certificate from AWS ACM (AWS Certificate Manager) or choose a certificate from any trusted third-party certificate authority.

In this guide, I will demonstrate how to use OpenSSL to generate a self-signed SSL certificate for both the server and client components of AWS VPN. Please follow these steps:

- Download the OpenSSL tool from below link;
- https://github.com/OpenVPN/easy-rsa/releases
- Extract the zip file of EasyRSA --> Go to cmd --> Go to folder where extracted files are located --> type .\EasyRSA-Start.bat --> ./easyrsa init-pki --> enter SERVER --> ./easyrsa build-ca nopass --> ./easyrsa build-server-full server nopass --> enter Yes --> ./easyrsa build-client-full client1.domain.tld nopass --> Exit
- The generated certificates can be found in the extracted folder under EasyRSA->PKI
- Commands to Create Directory and copy the PKI Content:
  - mkdir C:\vpncert
  - copy pki\ca.crt C:\vpncert
  - copy pki\issued\server.crt C:\vpncert
  - copy pki\private\server.key C:\vpncert
  - copy pki\issued\client1.domain.tld.crt C:\vpncert
  - copy pki\private\client1.domain.tld.key C:\vpncert
  - cd C:\vpncert
 - Use the certificate in AWS VPN
Once the certificate is generated, you can upload the private key and the certificate to AWS VPN configuration. This will allow the VPN for authentication.
Remember that this certificate is self-signed and won't be validated by a trusted certificate authority (CA), which is typically suitable for internal or development environments.

### 3.	Import the Certificate into ACM
- a. Open the AWS Management Console.

