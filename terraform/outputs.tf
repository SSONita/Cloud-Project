//Display the important output after run terraform apply

output "load_balancer_dns" {
  value = aws_lb.app_lb.dns_name
}

output "rds_endpoint" {
  value = aws_db_instance.auth_db.endpoint
}
