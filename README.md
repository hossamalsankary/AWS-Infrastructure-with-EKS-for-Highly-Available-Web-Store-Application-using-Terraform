# AWS Infrastructure with EKS for Highly Available Web Store Application using Terraform

This repository contains the configuration for a Kubernetes cluster hosted on AWS.

![screenshot](./Diagram.svg)


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

```diff 
terraform init
terraform apply
```

```diff 

aws eks --region us-east-1  update-kubeconfig --name MyCluster

```

