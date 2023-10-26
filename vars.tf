variable "AWS_REGION" {
  default = "eu-central-1"
}

variable "INSTANCE_TYPE" {
  default = "t2.micro"
}

variable "ECS_AMI_ID" {
  default = "ami-08a9c21394ccdff45"
}

variable "EC2_AMI_ID" {
  default = "ami-09042b2f6d07d164a"
}

variable "INSTANCE_DEVICE_NAME" {
  default = "/dev/xvdh"
}

variable "JENKINS_VERSION" {
  default = "2.414.3"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "keys/mykey.pub"
}