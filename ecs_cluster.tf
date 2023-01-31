resource "aws_ecs_cluster" "Analytic-cluster" {
  name = "Analytic-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}