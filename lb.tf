# resource "aws_alb" "droHealth_lb" {
#   name               = "droHealth-lb"
#   load_balancer_type = "application"

#   security_groups    = ["${aws_security_group.metabase_sec_group.id}"]

#   subnets = [
#     "${aws_default_subnet.metabase_subnet_a.id}",
#     "${aws_default_subnet.metabase_subnet_b.id}",
#     "${aws_default_subnet.metabase_subnet_c.id}"
#   ]

#   # enable_deletion_protection = false

#   # tags = {
#   #   Environment = "General_lb"
#   # }
# }

# resource "aws_security_group" "metabase_sec_group" {
#   name        = "metabase_sec_group"
#   description = "Allow Drohealth inbound traffic"

#   ingress {
#     description      = "Drohealth from VPC"
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "allow_traffic"  
#   }
# }

# resource "aws_lb_target_group" "drohealth_tg" {
#   name     = "drohealth-tg"
#   port     = "3000"
#   protocol = "HTTP"
#   target_type = "ip"
#   vpc_id = "${aws_default_vpc.main.id}"
#   health_check {
#     matcher = "200,301,302"
#     path = "/"
#   }
# }

# resource "aws_lb_listener" "alb_listener" {
#   load_balancer_arn = "${aws_alb.droHealth_lb.arn}"
#   port              = "80"
#   protocol          = "HTTP"
#   default_action {
#     type             = "forward"
#     target_group_arn = "${aws_lb_target_group.drohealth_tg.arn}" 
#   }
# }

# # resource "aws_internet_gateway" "metabase_gw" {

# #   tags = {
# #     Name = "main"
# #   }
# # }