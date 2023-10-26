resource "aws_ecs_cluster" "ecs-cluster" {
  name = "ecs-cluster"
}

resource "aws_autoscaling_group" "ecs-autoscaling" {
  name = "ecs-autoscaling"
  vpc_zone_identifier = [ aws_subnet.main-public.id ]
  launch_configuration = aws_launch_configuration.ecs-launch-configuration.name
  min_size = 1
  max_size = 1

  tag {
    key = "Name"
    value = "ecs-ec2-container"
    propagate_at_launch = true
  }

}

resource "aws_launch_configuration" "ecs-launch-configuration" {
  iam_instance_profile = aws_iam_instance_profile.ecs-ec2-instance-profile.id
  instance_type = "t2.micro"
  image_id = var.ECS_AMI_ID
  security_groups = [ aws_security_group.ecs-security-group.id ]
  user_data = "#!/bin/bash\necho ECS_CLUSTER=ecs-cluster >> /etc/ecs/ecs.config\nstart ecs"
  key_name = aws_key_pair.ssh-key.key_name
  lifecycle {
    create_before_destroy = true
  }
}