# Flask on AWS EKS with Terraform, Helm, and GitHub Actions

This project demonstrates how to deploy a Flask application to AWS Elastic Kubernetes Service (EKS) using Terraform for infrastructure provisioning, Helm for Kubernetes deployment, and GitHub Actions for CI/CD automation.

---

## Table of Contents
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Setup](#setup)
- [Infrastructure Provisioning with Terraform](#infrastructure-provisioning-with-terraform)
- [Application Deployment with Helm](#application-deployment-with-helm)
- [CI/CD with GitHub Actions](#cicd-with-github-actions)
- [Accessing the Application](#accessing-the-application)
- [Troubleshooting](#troubleshooting)
- [Destroying Resources](#destroying-resources)

---

## Prerequisites
- AWS account with permissions for EKS, EC2, VPC, IAM, S3, and ECR
- AWS CLI configured (`aws configure`)
- kubectl installed
- Helm installed
- Terraform installed
- Docker installed (for building images)

---

## Project Structure
```
tf-eks/
  ├── terraform/                # Terraform configuration files
  ├── flask-demo/               # Helm chart for Flask app
  ├── flask-demo-app/           # Flask application source code
  ├── .github/workflows/        # GitHub Actions workflows
  └── README.md                 # This file
```

---

## Setup
1. **Clone the repository:**
   ```bash
   git clone <repo-url>
   cd tf-eks
   ```
2. **Configure AWS credentials:**
   ```bash
   aws configure
   ```
3. **Create the S3 bucket for Terraform state (if not exists):**
   ```bash
   aws s3 mb s3://terraform-state-eks-cluster-1 --region eu-north-1
   ```

---

## Infrastructure Provisioning with Terraform
1. **Initialize Terraform:**
   ```bash
   cd terraform
   terraform init
   ```
2. **Apply the configuration:**
   ```bash
   terraform apply -var-file=variables.tfvars
   ```
   - This will provision the VPC, subnets, EKS cluster, node groups, and related resources.

---

## Application Deployment with Helm
1. **Update kubeconfig for EKS:**
   ```bash
   aws eks --region eu-north-1 update-kubeconfig --name eks-cluster
   ```
2. **Build and push your Docker image to ECR or Docker Hub.**
3. **Deploy the Flask app using Helm:**
   ```bash
   helm upgrade --install flask-demo ./flask-demo
   ```
4. **Check the service:**
   ```bash
   kubectl get svc
   ```
   - Look for the `EXTERNAL-IP` of the `flask-demo` service.

---

## CI/CD with GitHub Actions
- The workflow in `.github/workflows/action.yaml` automates:
  - Building and pushing Docker images
  - Running Terraform to provision infrastructure
  - Deploying the app to EKS with Helm
- Secrets required:
  - `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`
  - DockerHub/ECR credentials if pushing images

---

## Accessing the Application
- Once the service is deployed and the LoadBalancer is ready, access your app at:
  ```
  http://<EXTERNAL-IP>:5000
  ```
- You can get the external IP with:
  ```bash
  kubectl get svc flask-demo
  ```
- If you want to test locally:
  ```bash
  kubectl port-forward svc/flask-demo 8080:5000
  # Then open http://localhost:8080
  ```

---

## Troubleshooting
- **Service not accessible:**
  - Wait a few minutes for the LoadBalancer to be provisioned.
  - Check the security group attached to the LoadBalancer allows inbound traffic on port 5000.
  - Ensure your Flask app listens on `0.0.0.0:5000`.
  - Check pod health: `kubectl get pods` and `kubectl logs <pod-name>`.
  - Check AWS Console > EC2 > Load Balancers > Target Groups for target health.
- **kubectl errors (no such host):**
  - The EKS cluster may have been deleted. Clean up AWS resources manually if needed.
- **Terraform destroy errors (DependencyViolation):**
  - Manually delete ENIs, NAT Gateways, Load Balancers, and Elastic IPs in the AWS Console before retrying `terraform destroy`.
- **State lock issues:**
  - Remove the `.terraform.tfstate.lock.info` file from your S3 bucket or the lock entry from DynamoDB.

---

## Destroying Resources
1. **Uninstall the Helm release:**
   ```bash
   helm uninstall flask-demo
   ```
2. **Destroy infrastructure with Terraform:**
   ```bash
   cd terraform
   terraform destroy -auto-approve -var-file=variables.tfvars
   ```
3. **If you get dependency errors:**
   - Manually delete remaining AWS resources (ENIs, NAT Gateways, Load Balancers, etc.) in the AWS Console.
   - Re-run `terraform destroy` until all resources are gone.

