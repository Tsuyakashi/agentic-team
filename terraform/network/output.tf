output "vpc" {
  value = aws_vpc.prod-vpc.id
}

output "subnet-public" {
  value = aws_subnet.prod-subnet-public-1.id
}

output "instance_security_group_id" {
  value = aws_security_group.default-security-group.id
}

output "subnet-private" {
  value = aws_subnet.prod-subnet-private-1.id
}

output "rds-sec-group-id" {
  value = aws_security_group.rds-security-group.id
}

output "rd-subnet-1" {
  value = aws_subnet.rds-subnet-1.id
}

output "rd-subnet-2" {
  value = aws_subnet.rds-subnet-2.id
}
