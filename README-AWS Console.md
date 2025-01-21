# AWS VPN Client Endpoint Configuration - Using AWS Console

### 1. Purpose
This document help you to sets up an AWS Client VPN endpoint with certificate-based authentication to ensure secure remote access to AWS resources.

### 2. Prerequisites
- An AWS account configured with the necessary access rights.
- A VPC where you want to establish the VPN connection
- Subnets configured in your VPC
- The IP ranges you want to route through the VPN
- SSL/TLS certificates for authentication (if using certificate-based authentication)

### 2. Create a Server Certificate
You will require an SSL certificate for the Client VPN endpoint. You can opt for an SSL certificate from AWS ACM (AWS Certificate Manager) or choose a certificate from any trusted third-party certificate authority.

In this guide, I will demonstrate how to use OpenSSL to generate a self-signed SSL certificate for both the server and client components of AWS VPN. Please follow these steps:

- Download the **OpenSSL tool** from below link;
  https://github.com/OpenVPN/easy-rsa/releases
- Extract the zip file of **EasyRSA** --> Go to **cmd** --> Go to folder where extracted files are located --> **.\EasyRSA-Start.bat** --> **./easyrsa init-pki** --> **./easyrsa build-ca nopass** --> **SERVER** or **CN** --> **./easyrsa build-server-full server nopass** --> enter **Yes** --> **./easyrsa build-client-full client1.domain.tld nopass** --> Exit
- The generated certificates can be found in the extracted folder under **EasyRSA->PKI**
- Commands to Create Directory and copy the PKI Content:
  - **mkdir** C:\vpncert
  - copy **pki\ca.crt** C:\vpncert
  - copy **pki\issued\server.crt** C:\vpncert
  - copy **pki\private\server.key** C:\vpncert
  - copy **pki\issued\client1.domain.tld.crt** C:\vpncert
  - copy **pki\private\client1.domain.tld.key** C:\vpncert
  - cd C:\vpncert
 - **Use the certificate in AWS VPN**: 
 Once the certificate is generated, you can upload the private key and the certificate to AWS VPN configuration. This will allow the VPN for authentication.
Remember that this certificate is self-signed and won't be validated by a trusted certificate authority (CA), which is typically suitable for internal or development environments.

### 3.	Import the Certificate into ACM
- Open the **AWS Management Console**.
- In the search bar, type **ACM** and select **AWS Certificate Manager**.
- In the ACM dashboard, click on **Import a certificate** (located at the top right of the page).
- On the Import a certificate page:
   - **Certificate body**: Open your **sever.crt** file in a text editor, copy the entire content and paste it into the "**Certificate body**" field.
   - **Private key:** Open your **server.key** file, copy the entire content, and paste it into the "**Private key**" field.
   - **Certificate chain (optional)**: open **ca.crt** file with notepad and copy the entire content , and paste it into the " **Certificate chain** " field.
   - Click on **Import certificate**.
 - Same process for Client certificate as well;
   -- **Certificate body**: Open your **client1.domain.tld.crt** file in a text editor, copy the entire content and paste it into the "**Certificate body**" field.
   - **Private key:** Open your **client1.domain.tld.crt** file, copy the entire content, and paste it into the "**Private key**" field.
   - **Certificate chain (optional)**: open **ca.crt** file with notepad and copy the entire content , and paste it into the " **Certificate chain** " field.
   - Click on **Import certificate**.

### 4.	Create Client VPN Endpoint
- Navigate to the AWS VPC Console
- Go to "**Client VPN Endpoints**"
- Click "**Create Client VPN Endpoint**"
- Configure the following:
    - **Client IPv4 CIDR**: Specify a CIDR block (e.g., 30.0.0.0/16)
    - **Server certificate ARN**: Select the certificate you created.
    - **Authentication options**: Choose between:
        - Choose **Mutual Authentication** if you are using certificates, or
        - **Active Directory** for AD-based authentication
    - **Connection Log Options**: Enable logging for monitoring purposes. (Optional)
    - **Split-tunnel**: Enable/disable based on requirements.
      #A split tunnel is a configuration where only specific traffic is routed through the VPN connection to the VPC, while other traffic (e.g., internet-bound traffic) continues to use the user's local internet connection. This helps optimize bandwidth, reduce latency, and minimize unnecessary load on the VPN tunnel.
    - **DNS servers**: Specify if needed
    - Select appropriate **VPC and security groups**.
- Click **Create Client VPN Endpoint** to finish.
  
### 5.	Associate with a VPC Subnet
- After creating the VPN endpoint, go to the **Client VPN Endpoints** section.
- Select the VPN endpoint you created, then click on **Associate Subnet**.
- Choose a Subnet: Select a subnet in your VPC that the VPN clients can access.
- Click **Associate**

### 6.	Configure Security Groups
- Create a Security Group that allows inbound connections on UDP port **1194** (default port for OpenVPN).
- Add inbound rules to allow access to the required ports (e.g., HTTP, HTTPS, RDP, SSH).
  **Example:**
- **Protocol**: UDP, Port Range: 1194, Source: 0.0.0.0/0
- **For application access**: Protocol: TCP, Port Range: 80, 443, Source: your VPN CIDR block (30.0.0.0/22

### 7.	Configure Security GroupsConfigure Client VPN Authorization
- Go to **VPC Dashboard** → **Client VPN Endpoints**.
- Select the **VPN endpoint** and click **Authorization**.
- Add **authorization rule**:
  -Choose **Allow access to all users** if you are using certificates or else add Active Directory details;

### 8.	Download and Configure OpenVPN Client
- Go to **VPC Dashboard** → **Client VPN Endpoints** → **Download Client Configuration**(located at the top right of the page).
- Open **Download the configuration file** with **Notepad** or **Notepad++**.
- Add **<cert>** at the end of the page and Open your **client1.domain.tld.crt** file in a **text editor**, copy the entire content and paste it and Add **</cert>** at the end of the page again and **enter**.
- Add **<key>** at the end of the page and Open your **client1.domain.tld.key** file in a **text editor**,, copy the entire content and paste it and and Add **</ key>** at the end of the page again and save **the configuration file**.
- **Download the AWS VPN Client from below link;**
https://aws.amazon.com/vpn/client-vpn-download/

- **Import Configuration:**
  - Open the **AWS VPN client** --> Go to **File** --> Click on **Manage profile** --> Add **profile** --> Enter **Display Name** and **Import the downloaded configuration file**.

### 9.	Test the VPN Connection
- After setting up the client, connect to the VPN.
- Try accessing resources in the VPC (e.g., EC2 instances or RDS databases).
- Check the **CloudWatch logs** for any connection issues or **logs** if enabled.












