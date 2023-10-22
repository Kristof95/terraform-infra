resource "aws_key_pair" "example-keypair" {
  public_key = file(var.PATH_TO_PUBLIC_KEY)
  key_name = "example-keypair"
}