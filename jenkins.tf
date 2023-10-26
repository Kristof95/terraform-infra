resource "aws_instance" "jenkins-ec2" {
    ami = var.EC2_AMI_ID
    instance_type = var.INSTANCE_TYPE
    vpc_security_group_ids = [ aws_security_group.jenkins-security-group.id ]
    subnet_id = aws_subnet.main-public.id
    key_name = aws_key_pair.ssh-key.key_name

    user_data = data.cloudinit_config.setup-jenkins.rendered
}

resource "aws_ebs_volume" "jenkins-volume" {
  availability_zone = "${var.AWS_REGION}a"
  size = "20"
  type = "gp2"
}

resource "aws_volume_attachment" "volume-attachment" {
  device_name = var.INSTANCE_DEVICE_NAME
  volume_id = aws_ebs_volume.jenkins-volume.id
  instance_id = aws_instance.jenkins-ec2.id
}