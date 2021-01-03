resource "aws_eip" "vpn1" {
  instance = aws_instance.vpn1.id
  vpc      = true
}

resource "aws_eip" "vpn2" {
  instance = aws_instance.vpn2.id
  vpc      = true
}
