data "aws_vpc" "vpc" {
  id = data.terraform_remote_state.vpc.outputs.vpc_id
}

data "aws_subnet" "public-a" {
  filter {
    name   = "tag:Name"
    values = ["companypci-dev public subnet eu-west-1a"] # insert value here
  }
}

data "aws_subnet" "public-b" {
  filter {
    name   = "tag:Name"
    values = ["companypci-dev public subnet eu-west-1b"] # insert value here
  }
}

data "aws_ami" "vpn-node" {
  most_recent = true

  filter {
    name   = "name"
    values = ["company-golden-vpn-*"]
  }

  owners = [""] # Canonical
}


resource "aws_instance" "vpn1" {
  ami                     = data.aws_ami.vpn-node.id
  instance_type           = "${var.instance_type}"
  key_name                = "${var.key_name}"
  iam_instance_profile    = aws_iam_instance_profile.vpn_instance_profile.name
  monitoring              = false
  private_ip = "10.50.11.5"
  subnet_id  = data.aws_subnet.public-a.id
  vpc_security_group_ids = [aws_security_group.security_group_vpn.id]
  instance_initiated_shutdown_behavior = "stop"
  tags = {
      Name = "${var.service}-${var.service_tag}-01",
      vpn = "master"
    }

}

resource "aws_instance" "vpn2" {
  ami                     = data.aws_ami.vpn-node.id
  instance_type           = "${var.instance_type}"
  key_name                = "${var.key_name}"
  iam_instance_profile    = aws_iam_instance_profile.vpn_instance_profile.name
  monitoring              = false
  private_ip = "10.50.12.5"
  subnet_id  = data.aws_subnet.public-b.id
  vpc_security_group_ids = [aws_security_group.security_group_vpn.id]
  instance_initiated_shutdown_behavior = "stop"
  tags = {
      Name = "${var.service}-${var.service_tag}-02",
      vpn = "slave"
    }

}

resource "null_resource" "zip_upload_remove" {
     depends_on = [aws_s3_bucket.companypci-vpn]
     triggers = {
       build_number = "${timestamp()}"
      }
    provisioner "local-exec" {
      command = "zip -r ovpn.zip ovpn && aws s3 mv ovpn.zip s3://companypci-vpn/ovpn.zip"
    }
}

resource "null_resource" "create_master" {
      depends_on = [aws_instance.vpn1]
      provisioner "local-exec" {
      command = "bash create_master.sh"
    }
}

#resource "time_sleep" "wait_10_seconds" {
#  depends_on = [null_resource.create_master]
#  create_duration = "10s"
#}

resource "null_resource" "create_slave" {
      depends_on = [aws_instance.vpn2]
      provisioner "local-exec" {
      command = "bash create_slave.sh"
    }
}
