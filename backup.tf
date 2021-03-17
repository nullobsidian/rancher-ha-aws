resource "aws_s3_bucket" "backup" {
    bucket = "rancher-backup-21lksd2"
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

resource "aws_s3_bucket_object" "ssh" {
    bucket = aws_s3_bucket.backup.id
    acl    = "private"
    key    = "ssh/"
    content_type = "application/x-directory"
}
