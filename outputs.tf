output "instances_ips" {
    value = [
        aws_instance.zone_a.private_ip, 
        aws_instance.zone_b.private_ip, 
        aws_instance.zone_c.private_ip,
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