data "template_file" "myapp-template" {
  template = file("templates/app.json.tpl")
  vars = {
    REPOSITORY_URL = replace(aws_ecr_repository.myapp.repository_url, "https://", "")
  }
}

resource "aws_ecs_task_definition" "myapp-task-definition" {
  family = "myapp"
  container_definitions = data.template_file.myapp-template.rendered
}

resource "aws_ecs_service" "myapp-service" {
  name = "myapp"
  cluster = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.myapp-task-definition.arn
  desired_count = 1
  iam_role = aws_iam_role.ecs-service-role.arn
  depends_on = [ aws_iam_policy_attachment.ecs-service-attach1 ]

  load_balancer {
    elb_name = aws_elb.myapp-elb.name
    container_name = "myapp"
    container_port = 3000
  }

  # lifecycle {
  #   ignore_changes = [ "task_definition" ]
  # }
}