output "instances_ips" {
    value = [
        aws_instance.default[*].private_ip, 
    ]
}

output "bastion" {
    value = aws_instance.bastion.public_dns
}

output "cloud_user" {
  value = aws_iam_user.cloud_creds.name
}

output "cloud_access_key" {
    value = aws_iam_access_key.cloud_creds.id
}

output "cloud_secret_key" {
    value = aws_iam_access_key.cloud_creds.secret
}

output "s3_backup" {
    value = aws_s3_bucket.backup.id
}