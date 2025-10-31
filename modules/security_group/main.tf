variable "vpc_id" {}
resource "aws_security_group" "monitor_sg" {
  vpc_id = var.vpc_id
  name   = "monitoring-sg"
   # ✅ Inbound Rules
  ingress {
    description = "Allow SSH from admin IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["121.243.38.33/32"]  # 🔒 Replace with your own IP
  }

  ingress {
    description = "Allow HTTP (web traffic)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS (secure web traffic)"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow application access (custom TCP range)"
    from_port   = 3000
    to_port     = 10000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # ⚠️ Optional: Restrict if internal only
  }

  ingress {
    description = "Allow SMTP (mail sending)"
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # ⚠️ AWS may block this by default
  }

  ingress {
    description = "Allow SMTPS (secure mail)"
    from_port   = 465
    to_port     = 465
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SMTP Submission (TLS)"
    from_port   = 587
    to_port     = 587
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   description = "Allow MongoDB access (internal network only)"
  #   from_port   = 27017
  #   to_port     = 27017
  #   protocol    = "tcp"
  #   cidr_blocks = ["10.0.0.0/16"]  # 🔒 Restrict to internal VPC range
  # }

  # ✅ Outbound Rules (default: allow all)
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-security-group"
  }
}
output "sg_id" { value = aws_security_group.monitor_sg.id }
