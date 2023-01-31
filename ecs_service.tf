resource "aws_ecs_service" "metabase_service" {
  name            = "metabase_service"
  cluster         = aws_ecs_cluster.Analytic-cluster.id
  task_definition = aws_ecs_task_definition.Analytic-portal_task.arn
  launch_type     = "FARGATE"
  desired_count   = 2


  network_configuration {
    subnets          = ["${aws_subnet.metabase_subnet_a.id}", "${aws_subnet.metabase_subnet_b.id}"]
    assign_public_ip = true
    security_groups  = ["${aws_security_group.metabase_service_sec_group.id}"]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.drohealth_tg.arn
    container_name   = aws_ecs_task_definition.Analytic-portal_task.family
    container_port   = 3000
  }
}
# # resource "aws_security_group" "service_sg" {
# #   name = "service_sg" 
# #   description = "Security group for metabase service" 
# #   vpc_id = aws_default_vpc.default_vpc.id
# # }

# # resource "aws_security_group_rule" "service_security_ingress" {
# #   type              = "ingress"
# #   to_port           = 3000
# #   from_port         = 3000
# #   protocol          = "tcp"
# #   security_group_id = aws_security_group.service_sg.id
# #   cidr_blocks       = ["0.0.0.0/0"]
# }