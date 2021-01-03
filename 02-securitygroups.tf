/* Security Groups */
resource "aws_security_group" "security_group_vpn" {
  name        = "${var.service}-sg"
  description = "Security group for the ${var.service}"
  vpc_id      = data.aws_vpc.companypci-dev.id

  egress {
    description = "Allow everything"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Terraform = true
  }
}

resource "aws_security_group_rule" "vpn_inbound" {
  type              = "ingress"
  description       = "Allow VPN"
  from_port         = 4300
  to_port           = 4300
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"] 
  security_group_id = aws_security_group.security_group_vpn.id
}
