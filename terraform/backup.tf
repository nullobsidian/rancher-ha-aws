resource "aws_s3_bucket" "backup" {
  bucket =  join("-", [ "rancher-backup", var.cluster_id])
  acl = "private"

  tags = merge(
    local.tags,
    local.shared,
  )
}

resource "aws_s3_bucket_object" "etcd" {
  bucket = aws_s3_bucket.backup.id
  acl    = "private"
  key    = "etcd/"
  content_type = "application/x-directory"
}
