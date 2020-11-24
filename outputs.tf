output "my_aws_access_key" {
  value = var.aws_access_key
}

output "my_aws_secret_key" {
  sensitive = true
  value = var.aws_secret_key
}

###output definitions
output "aws_instance_public_dns" {
  value = aws_instance.db.public_dns
}


#output "child_memory" {
#  value = module.child.received
#}

#output "child_space" {
#  value = module.child.space
#}

#output "child_resource" {
#  value = module.child.project_resource_type
#}

