data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}


variable "PORT_CONFIGS" {
  type = list
  default = [22, 80]
}
resource "aws_security_group" "example-instance" {
    name = "allow-ssh-and-http"
    vpc_id = aws_vpc.main-vpc.id

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

   dynamic "ingress" {
        for_each = var.PORT_CONFIGS
        content {
            from_port = ingress.value
            to_port = ingress.value
            cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
            protocol = "tcp"
        }
    }
}