output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "subnet_ids" {
  value = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]
}

output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}

output "db_host" {
  value = aws_db_instance.postgres_db.address
}

output "db_name" {
  value = aws_db_instance.postgres_db.db_name
}

output "db_user" {
  value = aws_db_instance.postgres_db.username
}

output "db_password" {
  value     = aws_db_instance.postgres_db.password
  sensitive = true
}

output "s3_bucket_name" {
  value = aws_s3_bucket.app_bucket.bucket
}