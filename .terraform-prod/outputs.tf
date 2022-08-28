output "prod-webapp_public_ip" {
  description = "Public IP address of the EC2 instance with WebApp on Dev"
  value       = aws_instance.webapp-prod.public_ip
}
