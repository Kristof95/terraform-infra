variable "PATH_TO_PUBLIC_KEY" {
    default = "keys/mykey.pub"
}


variable "ECS_AMIS" {
    type = map(string)
    default = {
      "eu-central-1" = "ami-08a9c21394ccdff45"
    }
}

variable "AWS_REGION" {
  type = string
  default = "eu-central-1"
}

variable "ECS_INSTANCE_TYPE" {
  default = "t2.micro"
}

variable "AWS_ACCOUNT_ID" {
  default = ""
}