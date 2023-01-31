resource "aws_security_group" "metabase_alb_sec_group" {
  name        = "metabase_alb_sec_group"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.Drohealth_vpc.id #here

  ingress {
    description = "sg for metabase load balancer"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#   #  source_security_group_id = aws_security_group.metabase_service_sec_group.id #here
#   }

resource "aws_security_group_rule" "allow_http_lb_egress" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.metabase_alb_sec_group.id
  source_security_group_id = aws_security_group.metabase_service_sec_group.id
}


resource "aws_security_group" "metabase_service_sec_group" {
  name   = "metabase_service_sec_group"
  vpc_id = aws_vpc.Drohealth_vpc.id #here
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.metabase_alb_sec_group.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#New
resource "aws_security_group" "rds_security_group" {
  name = "rds_security_group"
  vpc_id = aws_vpc.Drohealth_vpc.id

  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}