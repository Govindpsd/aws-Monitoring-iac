variable "name_prefix" {}
variable "instance_count" {
  description = "Number of EC2 instances to launch"
  type        = number
}
variable "instance_type" {}
variable "key_name" {}
variable "security_group_ids" { type = list(string) }
variable "subnet_id" {}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (official Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}



resource "aws_instance" "this" {
  count = var.instance_count
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = var.security_group_ids
  subnet_id = var.subnet_id
  associate_public_ip_address = true
  tags = { Name = "${var.name_prefix}-${count.index + 1}" }
}
output "public_ips" { value = aws_instance.this[*].public_ip }
