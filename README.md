# rancher-ha-aws

Rancher, the open-source multi-cluster orchestration platform, where operational teams deploy, manage and secure enterprise Kubernetes built on RKE.

This Infrastructure as Code implents high-availability Kubernetes installation achieved by running Rancher on multiple nodes.

![AWS HA EC2 Rancher Deployment](./diagram.png)

| Variable          | Default | Required | Description                                                                                                        |
|-------------------|---------|----------|--------------------------------------------------------------------------------------------------------------------|
| region            |         | yes      | AWS Region designed to be isolated from the other Amazon EC2 Regions                                               |
| cluster_id*       |         | yes      | Cluster ID is a unique identification given in the RKE environment (Example: vq5ud3e5 )                            |
| environment       |         | yes      | Environment for a group of multiple server instances and running identical configurations                          |
| hosted_zone       |         | yes      | AWS Route 53 Hosted Zone for a root domain                                                                         |
| instance_type     |         | yes      | Instance types is varying combinations of CPU, memory, storage, and networking capacity (Recommend: M5 instances)  |
| node_count**      |         | yes      | Number of Rancher management HA nodes                                                                              |
| docker_version    | 20.10   | No       | Docker version to install for all nodes                                                                            |
| letsEncrypt_email |         | yes      | Email used to notified when SSL certificate is set to expire                                                       |


* Rancher Management HA Nodes are 3, 5, or 7 (Maintain quorum)
- https://rancher.com/docs/rancher/v2.x/en/overview/architecture-recommendations/

** Generate string ID with ONLY lowercase and numbers - 8 CHARACTERS
- https://cutt.ly/SxqZT23


## Authors

* **Moses Marquez** - [nullobsidian](https://github.com/nullobsidian)

See also the list of [contributors](https://github.com/GoldenHippoMedia/tsunami/contributors) who participated in this project.
