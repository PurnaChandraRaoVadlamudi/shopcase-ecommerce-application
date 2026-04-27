# ===================================================================
# Bastion Outputs - Production Grade
# ===================================================================

output "bastion_instance_id" {
  description = "Bastion instance ID"
  value       = aws_instance.bastion.id
}

output "bastion_public_ip" {
  description = "Bastion public IP address"
  value       = aws_instance.bastion.public_ip
}

output "bastion_private_ip" {
  description = "Bastion private IP address"
  value       = aws_instance.bastion.private_ip
}

output "bastion_public_dns" {
  description = "Bastion public DNS"
  value       = aws_instance.bastion.public_dns
}

output "bastion_private_dns" {
  description = "Bastion private DNS"
  value       = aws_instance.bastion.private_dns
}

output "bastion_eip" {
  description = "Bastion Elastic IP"
  value       = aws_eip.bastion.public_ip
}

output "bastion_instance_profile" {
  description = "Bastion IAM instance profile"
  value       = aws_iam_instance_profile.bastion.name
}