terraform {
  backend "s3" {
    bucket         = "companypci-dev-terraform-state"
    key            = "vpn/api-gateway/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "companypci-dev-terraform-state"
    key    = "vpc/terraform.tfstate"
    region = "eu-west-1"
  }
}

data "aws_vpc" "companypci-dev" {
  id = data.terraform_remote_state.vpc.outputs.vpc_id
}

data "aws_subnet_ids" "public" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = {
    Tier = "public"
  }

}

data "aws_subnet_ids" "frontend" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = {
    Tier = "frontend"
  }

}

data "aws_subnet_ids" "backend" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = {
    Tier = "backend"
  }

}

data "aws_subnet_ids" "data" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = {
    Tier = "data"
  }

}
