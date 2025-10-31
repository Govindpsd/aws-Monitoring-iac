variable "public_key_path" {}
variable "key_name" {}
resource "aws_key_pair" "generated" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}
output "key_name" { value = aws_key_pair.generated.key_name }
