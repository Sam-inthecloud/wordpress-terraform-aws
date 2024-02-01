# Creating a WordPress Website with Terraform and AWS
![Alt Text](https://github.com/Sam-inthecloud/wordpress-terraform-aws/blob/main/WordPress%20Blog.png?raw=true)


##   Project Overview

This project demonstrates how to deploy a WordPress website on AWS using Terraform for infrastructure provisioning.
  
## Contributions
Contributions are welcome! Please check the contributing guidelines for more details.

## Blog
Click [here](https://medium.com/@saminthecloud1/deploying-wordpress-with-terraform-using-ec2-rds-aws-f60f8419e551) to read into depth my steps.

## Prerequisites

Before you begin, ensure you have the following installed:

- [Terraform](https://www.terraform.io/)
- AWS CLI with configured credentials
- [EC2 Key Pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)
- [SSH Client](https://www.ssh.com/ssh/client/)

## Getting Started

1. Clone the repository:

   ```bash
   git clone https://github.com/Sam-inthecloud/wordpress-terraform-aws.git
   cd wordpress-terraform-aws

   
- Change the database and AWS settings in terraform.tfvars file to your own settings.
- Generate Key pair using  ssh-keygen -f mykey-pair
  ```bash
   terraform init
   terraform apply
## Connect to EC2 Instance
- Install HTTPD, MYSQL & PHP
- Download and Install WordPress
  
## Accessing WordPress
1. Open your browser and enter the public IP address of the EC2 instance.

   http://your-ec2-public-ip

2. Follow the on-screen instructions to complete the WordPress setup.

 - Destroy the resources
  ```bash
   terraform destroy


