# job-project
This project aims to deploy an NGINX instance that is publicly accessible , displaying the text "yo this is nginx" upon access.

1. AWS Infrastructure setup using Terraform.
2. Launching an NGINX server.
3. Configuring a DNS name to point to the server.

   
*Prerequisites*
AWS account with proper access rights.
Terraform installed on your local machine.
Basic knowledge of Terraform, AWS services, and NGINX.
Infrastructure Setup

Terraform Initialization:

Before starting, ensure you are authenticated with AWS.
Use the AWS CLI to log in to your AWS account.
Configure your AWS credentials by running aws configure. This will prompt you to enter your AWS Access Key ID, Secret Access Key, and default region.

Navigate to the directory containing your Terraform files.
Run terraform init to initialize the workspace.

Configuring AWS Resources:

Utilize the already created Terraform files, which contain resources such as a VPC, an EC2 instance, and security groups.

Applying Terraform Configuration:

Execute terraform plan to review the changes.
Run terraform apply to create the resources on AWS.

After applying Terraform, access your NGINX server using the Public IPv4 address with port 80.


