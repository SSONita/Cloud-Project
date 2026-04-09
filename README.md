# ☁️ Cloud Authentication System (AWS + Terraform)

## 📌 Project Overview

This project demonstrates a scalable and cloud-based authentication system deployed on AWS using Terraform (Infrastructure as Code).

The application allows users to:
- Register and log in
- View their profile
- Upload profile images

The system is designed with **scalability, availability, and security** in mind using AWS cloud services.

---

## 🎯 Project Objectives

- Deploy a full-stack web application on AWS
- Use Terraform to automate infrastructure provisioning
- Implement high availability with Load Balancer and Auto Scaling
- Store structured data using RDS PostgreSQL
- Store images using Amazon S3
- Apply secure access using IAM and Security Groups
- Monitor system using CloudWatch

---

## 🏗️ Architecture Overview
```
Users → Load Balancer → Auto Scaling EC2 → Backend (Node.js)
↓
RDS PostgreSQL
↓
S3
```
### Components:

- **Application Load Balancer (ALB)**  
  Distributes incoming traffic across multiple EC2 instances

- **Auto Scaling Group (ASG)**  
  Automatically maintains and replaces EC2 instances

- **EC2 Instances**  
  Run the Node.js backend application

- **RDS PostgreSQL**  
  Stores user authentication and profile data

- **S3 Bucket**  
  Stores uploaded profile images

- **VPC**  
  Provides network isolation with public and private subnets

---

## ⚙️ Tech Stack

- **Backend:** Node.js (Express)
- **Database:** PostgreSQL (AWS RDS)
- **Storage:** AWS S3
- **Infrastructure:** Terraform
- **Cloud Platform:** AWS

---

## 📂 Project Structure
```
cloud-auth-project/
│
├── app/                             # Application source code
│   ├── client/                      # Frontend (UI, React or web interface)
│   └── server/                      # Backend (Node.js API, auth, upload logic)
│
├── terraform/                       # Infrastructure as Code (AWS resources)
│   ├── provider.tf                  # Configure AWS provider and region
│   ├── variables.tf                 # Define reusable variables (DB, ports, etc.)
│   ├── outputs.tf                   # Output values (ALB DNS, RDS endpoint)
│   ├── networking.tf                # VPC, subnets, Internet Gateway, routing
│   ├── security.tf                  # Security groups (ALB, EC2, RDS rules)
│   ├── rds.tf                       # PostgreSQL RDS database configuration
│   ├── s3.tf                        # S3 bucket for storing profile images
│   ├── iam.tf                       # IAM roles and permissions (EC2 → S3 access)
│   ├── compute.tf                   # EC2 launch template + user_data script
│   ├── loadbalancer.tf              # Application Load Balancer + listener
│   ├── autoscaling.tf               # Auto Scaling Group (EC2 scaling & recovery)
│   └── cloudwatch.tf                # Monitoring, metrics, and alarms
│
└── README.md                        # Project documentation and instructions
```
