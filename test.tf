# resource "aws_vpc" "metabase_vpc" {
#   cidr_block = "10.0.0.0/16"

#   tags = {
#     Name = "metabase-vpc"
#   }
# }

# resource "aws_subnet" "metabase_subnet_a" {
#   vpc_id                  = aws_vpc.metabase_vpc.id
#   cidr_block              = "10.0.1.0/24"
#   availability_zone       = "us-east-1a"
#   map_public_ip_on_launch = true
# }

# resource "aws_subnet" "metabase_subnet_b" {
#   vpc_id                  = aws_vpc.metabase_vpc.id
#   cidr_block              = "10.0.2.0/24"
#   availability_zone       = "us-east-1b"
#   map_public_ip_on_launch = true
# }

# resource "aws_security_group" "metabase_sg" {
#   name        = "metabase_sg"
#   description = "Security group for metabase"
#   vpc_id      = aws_vpc.metabase_vpc.id
# }

# resource "aws_security_group_rule" "metabase_sg_ingress" {
#   type              = "ingress"
#   from_port         = 3000
#   to_port           = 3000
#   protocol          = "tcp"
#   security_group_id = aws_security_group.metabase_sg.id
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_iam_role" "metabase_ecs_role" {
#   name = "metabase_ecs_role"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "ecs-tasks.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_policy" "metabase_ecs_policy" {
#   name = "metabase_ecs_policy"
#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "logs:CreateLogGroup",
#         "logs:CreateLogStream",
#         "logs:PutLogEvents"
#       ],
#       "Resource": "arn:aws:logs:*:*:*"
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_policy_attachment" "metabase_ecs_policy_attachment" {
#   name = "metabase_ecs_policy_attachment"
#   roles = [aws_iam_role.metabase_ecs_role.name]
#   policy_arn = aws_iam_policy.metabase_ecs_policy.arn
# }

# resource "aws_ecs_task_definition" "metabase_task" {
#   family                = "metabase_task"
#   network_mode          = "awsvpc"
#   cpu                      = 256
#   memory                   = 512
#   task_role_arn         = aws_iam_role.metabase_ecs_role.arn
#   execution_role_arn    = aws_iam_role.metabase_ecs_role.arn
#   requires_compatibilities = ["FARGATE"]
#   container_definitions = <<EOF
# [
#   {
#     "name": "metabase",
#     "image": "metabase/metabase:latest",
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
#         "value": "metabase-db.us-west-2.rds.amazonaws.com"
#       }
#     ]
#   }
# ]
# EOF
# }

# resource "aws_ecs_service" "metabase_service" {
#   name            = "metabase_service"
#   cluster         = aws_ecs_cluster.metabase_cluster.id
#   task_definition = aws_ecs_task_definition.metabase_task.arn
#   desired_count   = 1

#   load_balancer {
#     target_group_arn = aws_lb_target_group.metabase_tg.arn
#     container_name   = "metabase"
#     container_port   = 3000
#   }


#   depends_on = [
#     aws_alb.metabase_lb,
#     aws_alb_listener.metabase_listener
#   ]
# }


# resource "aws_ecs_cluster" "metabase_cluster" {
#   name    = "metabase_cluster"

#   setting {
#     name  = "containerInsights"
#     value = "enabled"
#   }
# }

# resource "aws_alb" "metabase_lb" {
#   name            = "metabase-lb"
#   internal        = false
#   load_balancer_type = "application"
#   security_groups = [aws_security_group.metabase_sg.id]
#   subnets         = [aws_subnet.metabase_subnet_a.id, aws_subnet.metabase_subnet_b.id]

#   depends_on = [
#     aws_internet_gateway.igw,
#     aws_route_table_association.rta
#   ]

#   # listener {
#   #   port     = "80"
#   #   protocol = "HTTP"

#   #   default_action {
#   #     target_group_arn = aws_lb_target_group.metabase_tg.arn
#   #     type             = "forward"
#   #   }
#   # }
# }

# resource "aws_lb_target_group" "metabase_tg" {
#   name     = "metabase-tg"
#   port     = 3000
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.metabase_vpc.id

#   target_type = "ip"

#   health_check {
#     path                = "/health"
#     interval            = 30
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 5
#   }
# }

# #   load_balancer {
# #   target_group_arn = aws_lb_target_group.metabase_tg.arn
# #   container_name   = "metabase"
# #   container_port   = 3000
# # }

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.metabase_vpc.id
# }

# resource "aws_route_table" "rtb" {
#   vpc_id = aws_vpc.metabase_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }
# }

# resource "aws_route_table_association" "rta" {
#   subnet_id = aws_subnet.metabase_subnet_a.id
#   route_table_id = aws_route_table.rtb.id
# }
