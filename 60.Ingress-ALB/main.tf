resource "aws_lb" "ingress_alb" {
  name               = "${var.project_name}-${var.environment}-ingress_alb"
  internal           = false # public ALB
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.sg_id_ingress.value]
  subnets            = split(",", data.aws_ssm_parameter.subnet_public.value)
  enable_deletion_protection = false

  tags =merge (
    var.common_tags,{
        Name="${var.project_name}-${var.environment}-ingress_alb"
    }
  )
}

#listener

resource "aws_lb_listener" "hhtp" {
  load_balancer_arn = aws_lb.ingress_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Fixed response content From Public ALB</h1>"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.ingress_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn = data.aws_ssm_parameter.acm_certificate_arn.value
  ssl_policy = "ELBSecurityPolicy-2016-08"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Fixed response content From Public ALB HTTPS </h1>"
      status_code  = "200"
    }
  }
}

resource "aws_lb_target_group" "frontend" {
  name        = "${var.project_name}-${var.environment}-frontend"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
  health_check {
    path                = "/"
    port                = 8080
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener_rule" "frontend" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100 # less number will be first validated

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }

  condition {
    host_header {
      # expense-dev-rajapeta.cloud--> frontend pod
      values = ["expense-${var.environment}.${var.zone_name}"]
    }
  }
}



#R53 record for alb name
module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = var.zone_name

  records = [
    {
      name    = "web.app-${var.environment}"
      type    = "A"
      allow_overwrite=true
   alias   = {
        name    = aws_lb.ingress_alb.dns_name
        zone_id = aws_lb.ingress_alb.zone_id
   }
    }
    ]
}
