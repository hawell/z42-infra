resource "tls_private_key" "z42key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "z42keypair" {
  key_name   = "z42keypair"
  public_key = tls_private_key.z42key.public_key_openssh
}
