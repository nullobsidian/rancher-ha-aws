project_name  = "rancher.prod.ghm-ops.com"
environment   = "production"
instance_type = "m5.large"
key_name      = "rke"
// Rancher Management HA Nodes are 3, 5, or 7 (Maintain quorum) - https://rancher.com/docs/rancher/v2.x/en/overview/architecture-recommendations/
node_count    = 3