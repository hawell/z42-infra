resource "tls_private_key" "chordsoft_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "chordsoft_keypair" {
  key_name   = "chordsoft_keypair"
  public_key = tls_private_key.chordsoft_key.public_key_openssh
}

output "private_pem" {
   sensitive = true
   value = tls_private_key.chordsoft_key.private_key_pem
}
