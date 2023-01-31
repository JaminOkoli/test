resource "aws_alb" "DroHealth-lb" {
  name               = "DroHealth-lb"
  internal           = false
  load_balancer_type = "application"

  security_groups = ["${aws_security_group.metabase_alb_sec_group.id}"]

  subnets                    = ["${aws_subnet.metabase_subnet_a.id}", "${aws_subnet.metabase_subnet_b.id}"]
  enable_deletion_protection = false
}


resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.DroHealth-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.drohealth_tg.arn
  }
}

resource "aws_lb_target_group" "drohealth_tg" {
  name        = "drohealth-tg"
  port        = "80" #here
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.Drohealth_vpc.id
  health_check {
    matcher          = "200,301,302"
    path             = "/"
    interval = 5 #here
    timeout  = 2 #here
  }
}

