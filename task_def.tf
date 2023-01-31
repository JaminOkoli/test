resource "aws_ecs_task_definition" "Analytic-portal_task" {
  family                   = "Analytic-portal_task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.drohealth_iam_role.arn

  container_definitions = jsonencode(
    [
      {
        name      = "Analytic-portal_task"
        image     = "metabase/metabase"
        cpu       = 256
        memory    = 512
        essential = true
        portMappings = [
          {
            containerPort = 3000
            hostPort      = 3000
          }
        ]
      }
  ])
}






# resource "aws_ecs_task_definition" "metabase_tf_task" {
#   family                = "metabase_tf_task"
#   network_mode          = "awsvpc"
#   cpu                      = 256
#   memory                   = 512
#   task_role_arn         = aws_iam_role.drohealth_iam_role.arn
#   execution_role_arn    = aws_iam_role.drohealth_iam_role.arn
#   requires_compatibilities = ["FARGATE"]
#   container_definitions = <<EOF
# [
#   {
#     "name": "metabase_tf_task",
#     "image": "metabase/metabase",
#     "portMappings": [
#       {
#         "containerPort": 3000,
#         "hostPort": 3000
#       }
#     ],
#     "essential": true,
#     "environment": [
#       {
#         "name": "MB_DB_TYPE",
#         "value": "postgres"
#       },
#       {
#         "name": "MB_DB_DBNAME",
#         "value": "metabase"
#       },
#       {
#         "name": "MB_DB_PORT",
#         "value": "5432"
#       },
#       {
#         "name": "MB_DB_USER",
#         "value": "metabase"
#       },
#       {
#         "name": "MB_DB_PASS",
#         "value": "password"
#       },
#       {
#         "name": "MB_DB_HOST",
#         "value": "metabase-db.us-east-1.rds.amazonaws.com"
#       }
#     ]
#   }
# ]
# EOF
# }