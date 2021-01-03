# general
variable "aws_region" {
  type = string
  default = "eu-west-1"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "environment_name" {
  type = string
  default = ""
}

variable "hosted_zone_name" {
  type = string
  default = ""
}

variable "application_name" {
  type = string
  default = ""
}

# deployment
variable "service" {
  default = "service1"
}

variable "service_tag" {
  default = "0.0.1"
}

variable "service_override" {
  type    = string
  default = null
}

variable "key_name" {
  default = "Test"
}
