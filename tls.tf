
// The public/private key used to SSH to the compute instance
resource "tls_private_key" "public_private_key_pair" {
  algorithm = "RSA"
}