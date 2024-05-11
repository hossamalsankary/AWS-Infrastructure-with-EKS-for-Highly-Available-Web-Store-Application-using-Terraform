# AWS Infrastructure with EKS for Highly Available Web Store Application using Terraform

This repository contains the configuration for a Kubernetes cluster hosted on AWS.


### Components

<img src="./Diagram.svg" alt="Diagram" style="width:100%;"/>

## Project structure
```diff
.
├── Diagram.svg
├── README.md
├── autputs.tf
├── main.tf
├── modules
│   ├── backend
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── build-agent
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── setupAgent.sh
│   │   └── variables.tf
│   ├── eks
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── iam_roles
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── k8s
│   │   ├── grafana.yaml
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── network
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── openid-connector
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
└── variables.tf
```

- **VPC**: Virtual Private Cloud on AWS is a virtual network dedicated to your AWS account. It logically isolates the traffic between your different AWS resources.

- **Subnets**: Subnets are essentially a section of a VPC. You can think of them as a subset of the VPC.

- **Route Tables**: Route tables are used within a VPC to determine where network traffic is directed.

- **Internet Gateway**: An internet gateway is an AWS VPC component that allows communication between instances in your VPC and the internet.

- **NAT Gateway**: A Network Address Translation (NAT) gateway is a managed service that enables instances in a private subnet to communicate with the internet without requiring an internet gateway.
- **Security Group**: A security group acts as a virtual firewall for your instances to control inbound and outbound traffic.

- **Elastic Load Balancer**: An Elastic Load Balancer distributes incoming traffic across your EC2 instances to improve the availability and scalability of your application.

- **Elastic Container Service for Kubernetes (EKS)**: Amazon EKS is a fully managed Kubernetes service. It helps you to run your Kubernetes applications on AWS.

- **Helm**: Helm is a package manager for Kubernetes. It simplifies the process of installing and managing applications in Kubernetes.

- **Auto Scaling Group**: An Auto Scaling Group is a group of Amazon EC2 instances that can dynamically launch or terminate instances as needed.

- **Grafana**: Grafana is an open-source platform for monitoring and observability.

- **Prometheus**: Prometheus is an open-source monitoring and alerting toolkit.

- **Gloud watch**: Elasticsearch is a distributed search and analytics engine.

- **Container Storage Interface (CSI)**: The Container Storage Interface (CSI) is a specification for writing plugins for container orchestrators to manage the lifecycle of container storage.

- **Three Private Connections**: Three private connections are used to securely connect to the cluster.

- **Security Test Practice**: Security test practice is a technique used to assess the security of a system.

## Prerequisites

Before you can deploy the cluster, you need to set up your AWS credentials:

1. Go to the AWS Management Console and create a new IAM user with the following permissions:

   - AmazonEC2FullAccess
   - AmazonEKSClusterPolicy
   - AmazonEKSServicePolicy
   - AmazonS3FullAccess

2. Create an access key for the user and set the environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` to the values provided by AWS.

## Deploying the cluster

To deploy the cluster, run the following commands:
```diff 
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""

```
# run
```diff 
terraform init
terraform apply
```
# connect
```diff 

aws eks --region us-east-1  update-kubeconfig --name MyCluster

```


