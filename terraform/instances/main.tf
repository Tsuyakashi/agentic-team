data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

# resource "aws_instance" "private_host" {
#   ami             = data.aws_ami.ubuntu.id
#   instance_type   = var.instance_type
#   key_name        = var.key_pair
#   subnet_id       = var.subnet_id_private
#   security_groups = [var.security_group_public]
# }

resource "aws_instance" "bastion_host" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  key_name        = var.key_pair
  subnet_id       = var.subnet_id_public
  security_groups = [var.security_group_public]
}
