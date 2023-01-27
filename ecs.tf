resource "aws_ecs_cluster" "Analytic-portal" {
  name    = "Analytic-portal"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}