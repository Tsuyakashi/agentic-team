output "aws_ami_id" {
  value = data.aws_ami.ubuntu.id
}

output "bastion_host" {
  value = aws_instance.bastion_host.id
}
