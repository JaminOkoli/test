resource "aws_ecs_task_definition" "Analytic-portal_task" {
  family = "Analytic-portal_task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = "${aws_iam_role.drohealth_iam_role.arn}"

  container_definitions    = jsonencode(
    [
    {
      name                 = "Analytic-portal_task"
      image                = "metabase/metabase:latest"
      cpu                  = 256
      memory               = 512
      essential            = true
      portMappings         = [
        {
          containerPort    = 3000
          hostPort         = 3000
        }
      ]
    }
  ])
}