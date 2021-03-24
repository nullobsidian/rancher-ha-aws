resource "aws_lb_target_group" "https" {
  name     = "rancher-tcp-443"
  port     = 443
  protocol = "TCP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    protocol            = "TCP"
    port                = 80
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 6
    interval            = 10
  }
}

resource "aws_lb_target_group" "http" {
  name     = "rancher-tcp-80"
  port     = 80
  protocol = "TCP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    protocol            = "TCP"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 6
    interval            = 10
  }
}

resource "aws_lb_target_group_attachment" "https" {
  count            = var.node_count
  target_group_arn = aws_lb_target_group.https.arn
  target_id        = aws_instance.default[count.index]
  port             = 443
}

resource "aws_lb_target_group_attachment" "http" {
  count            = var.node_count
  target_group_arn = aws_lb_target_group.http.arn
  target_id        = aws_instance.default[count.index]
  port             = 80
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.default.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.https.arn
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.default.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}

resource "aws_lb" "default" {
  name               = join("-", [var.cluster_id, "rancher-api"])
  internal           = false
  load_balancer_type = "network"
  subnets            = module.vpc.public_subnets[*]

  enable_deletion_protection = true

  tags = merge(
    local.tags,
    local.shared,
  )
}
