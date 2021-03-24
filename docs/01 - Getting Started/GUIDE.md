# Getting Started

Docker Setup

Download [Dockerfile](../../Dockerfile)
1. Click "Raw"
2. Right-Click and select "Save As" and type "Dockerfile" 

Build the image
```shell
docker build -t rancher-ha-aws .
```

Run the container in the background
```shell
docker run -itd --name rancher-prod rancher-ha-aws
```

Bash into the container to gain access
```shell
docker exec rancher-prod /bin/bash
```
---

### Step 1: AWS

Edit `~/.bashrc` and append for Terraform required variables 

```shell
export AWS_ACCESS_KEY_ID="PVBIPIGVNPXTZALCOMZAD"
export AWS_SECRET_ACCESS_KEY="R\KFSGGNBDPHUDRWQAWC\RGUPJ*BXRF\HYE//DAVS"
export AWS_DEFAULT_REGION="us-east-2"
```

### Step 2: Clone Repo

Clone directory in your root home directory

```shell
git clone https://github.com/GoldenHippoMedia/rancher-ha-aws.git
```

### Step 3: Configure Configuration Variables

Edit `config.json` file to configure your cluster

```json
{  
   "region": "us-east-2",
   "cluster_id": "go7t81hq",
   "environment": "production",
   "hosted_zone":  "rancher.prod.example.com",
   "instance_type": "m5.large",
   "node_count": 3,
   "letsEncrypt_email": "devops@example.com"
}
```
**Options**

| Variable            | Default | Required | Description                                                                       |
|---------------------|---------|----------|-----------------------------------------------------------------------------------|
| `region`            |         | yes      | AWS Region designed to be isolated from the other Amazon EC2 Regions              |
| `cluster_id`*       |         | yes      | Cluster ID is a unique identification (Example: `vq5ud3e5` )                      |
| `environment`       |         | yes      | Environment for a group of multiple server instances and identical configurations |
| `hosted_zone`       |         | yes      | AWS Route 53 Hosted Zone for a root domain                                        |
| `instance_type`     |         | yes      | Instance types is varying combinations resource (Recommend: M5 instances)         |
| `node_count`**      |         | yes      | Number of Rancher management HA nodes                                             |
| `docker_version`    | 20.10   | no       | Docker version to install for all nodes                                           |
| `letsEncrypt_email` |         | yes      | Email used to notified when SSL certificate is set to expire                      |

**Important**:

\* [Rancher Management HA Nodes are 3, 5, or 7 ONLY (Maintain quorum)](https://rancher.com/docs/rancher/v2.x/en/overview/architecture-recommendations/)

\*\* [Generate string ID with ONLY lowercase and numbers - 8 CHARACTERS](https://www.random.org/strings/?num=6&len=8&digits=on&loweralpha=on&unique=on&format=html&rnd=new)

#### Step 4: Deploy Rancher on AWS with HA EC2

```shell
ansible-playbok deploy.yml
```