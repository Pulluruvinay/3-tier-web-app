resource "aws_ecs_cluster" "main" {
  name = "python-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "python-app"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  container_definitions = jsonencode([
    {
      name  = "app"
      image = var.ecr_image
      portMappings = [{
        containerPort = 5000
      }]
      environment = [
        { name = "DB_HOST", value = var.db_host },
        { name = "DB_USER", value = var.db_user },
        { name = "DB_PASS", value = var.db_password }
      ]
    }
  ])
}

resource "aws_ecs_service" "app" {
  name            = "python-app-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "app"
    container_port   = 5000
  }
}

