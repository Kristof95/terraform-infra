output "jenkins_ec2" {
  value = aws_instance.jenkins-ec2.public_ip
}

output "elb_dns" {
  value = aws_elb.myapp-elb.dns_name
}

output "myapp-repository-URL" {
  value = aws_ecr_repository.myapp.repository_url
}