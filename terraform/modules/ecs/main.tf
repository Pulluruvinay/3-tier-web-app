########################################
# ECS CLUSTER
########################################

resource "aws_ecs_cluster" "main" {
  name = "python-cluster"
}

########################################
# IAM ROLE FOR FARGATE (ECR + LOGS)
########################################

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

########################################
# SECURITY GROUP FOR ECS
########################################

resource "aws_security_group" "ecs" {
  name        = "ecs-service-sg"
  description = "Allow ALB to access ECS"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

########################################
# TASK DEFINITION
########################################

resource "aws_ecs_task_definition" "app" {
  family                   = "python-app"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "app"
      image = var.ecr_image

      portMappings = [{
        containerPort = 5000
        hostPort      = 5000
      }]

      environment = [
        { name = "DB_HOST", value = var.db_host },
        { name = "DB_USER", value = var.db_user },
        { name = "DB_PASS", value = var.db_password }
      ]
    }
  ])
}

########################################
# ECS SERVICE
########################################

resource "aws_ecs_service" "app" {
  name            = "python-app-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true   # 🔥 FIXED (so it can pull from ECR)
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "app"
    container_port   = 5000
  }

  depends_on = [
    aws_iam_role_policy_attachment.ecs_task_execution_policy
  ]
}
