# AWS Bastion Infrastructure

This repository contains the Terraform code for deploying a robust AWS infrastructure. The project is designed with modularity in mind, separating networking, compute, and database concerns.

## ⚠️ Known Issues / To-do

- [ ] RDS module is currently disabled (commented out in `main.tf`) — missing `engine` argument, needs refactor before use
- [ ] S3 backend lacks DynamoDB lock table (`dynamodb_table` commented out)
- [ ] RDS subnets have `map_public_ip_on_launch = true` despite private intent
- [ ] `db_password` has a plaintext default — should be `sensitive = true` with no default value

## 🏗️ Architecture Overview

The infrastructure consists of a custom VPC spanning multiple availability zones for high availability of the database layer.

### 🔌 Networking

- **VPC**: Custom CIDR block (default `10.0.0.0/16`).
- **Subnets**:
  - **Public Subnet**: Hosts the Bastion host and NAT Gateway.
  - **Private Subnet**: Intended for internal application servers.
  - **RDS Subnets**: Dedicated subnets for the database layer.
- **Gateways**: Internet Gateway for public traffic and NAT Gateway for private outbound traffic.
- **Security Groups**:
  - `terraform-security-group`: Allows SSH (port 22) from anywhere (should be restricted in production).
  - `rds-terraform-security-group`: Allows PostgreSQL traffic (port 5432) only from within the VPC.



### 💻 Compute

- **Bastion Host**: Deploys an EC2 instance running **Ubuntu 24.04 LTS**.
- **Scaling**: The root configuration currently initializes a single instance of the compute module (`instances`).



### 🗄️ Database

- **Engine**: PostgreSQL 17.6.
- **Instance Class**: `db.t3.micro`.
- **Storage**: 20GB GP2.
- **Connectivity**: Configured as **private** (not publicly accessible) and reachable only from within the VPC.



## 📁 Project Structure

```text
terraform/
├── instances/    # EC2 instance definitions (Ubuntu 24.04)
├── network/      # VPC, Subnets, IGW, NAT, and Routing
├── rds/          # PostgreSQL RDS configuration
├── main.tf       # Root configuration (Module Orchestration)
├── variables.tf   # Global input variables
├── init-s3.sh    # Script to bootstrap the S3 backend
└── .terraform/   # Terraform provider and state metadata
```



## 🚀 Deployment Guide



### 1. Prerequisites

- [Terraform](https://www.terraform.io/downloads) (>= 1.14.3)
- [AWS CLI](https://aws.amazon.com/cli/) configured with your credentials.
- An existing AWS Key Pair named `ag-team` (or update `variables.tf`).



### 2. Initialize Backend

The project uses an S3 bucket for remote state storage. Run the initialization script to create the bucket:

```bash
cd terraform
bash init-s3.sh
```



### 3. Deploy

```bash
# Initialize Terraform and download providers
terraform init

# Preview changes
terraform plan

# Apply changes
terraform apply
```



## ⚙️ Configuration Variables


| Variable        | Description         | Default        |
| --------------- | ------------------- | -------------- |
| `region`        | AWS region          | `eu-central-1` |
| `instance_type` | EC2 instance size   | `t2.nano`      |
| `db_username`   | RDS master username | `default`      |
| `db_password`   | RDS master password | `default`      |


---

**Note:** Some network configurations (like CIDR blocks) may need adjustment for specific environments to avoid overlap.