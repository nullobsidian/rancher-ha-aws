# rancher-ha-aws

Rancher, the open-source multi-cluster orchestration platform, where operational teams deploy, manage and secure enterprise Kubernetes built on RKE.

This Infrastructure as Code implents high-availability Kubernetes installation achieved by running Rancher on multiple nodes.

![AWS HA EC2 Rancher Deployment](./diagram.png)

Rancher Management HA Nodes are 3, 5, or 7 (Maintain quorum)
- https://rancher.com/docs/rancher/v2.x/en/overview/architecture-recommendations/

Generate string ID with ONLY lowercase and numbers - 8 CHARACTERS
- https://cutt.ly/SxqZT23
