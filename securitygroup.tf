data "http" "myip" {
    url = "https://api.ipify.org/?format=text"
}

resource "aws_security_group" "ecs-security-group" {
  name = "ecs-security-group"
  vpc_id = aws_vpc.main.id  

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }

  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    security_groups = [aws_security_group.elb-security-group.id]
  }
}

resource "aws_security_group" "jenkins-security-group" {
  name = "jenkins-security-group"
  vpc_id = aws_vpc.main.id

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }
}

resource "aws_security_group" "elb-security-group" {
  name = "elb-security-group"
  vpc_id = aws_vpc.main.id

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    }
}