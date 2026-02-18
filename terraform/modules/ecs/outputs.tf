output "ecs_cluster_id" {
  description = "ECS Cluster ID"
  value       = aws_ecs_cluster.main.id
}

output "ecs_cluster_name" {
  description = "ECS Cluster Name"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "ECS Service Name"
  value       = aws_ecs_service.app.name
}

output "ecs_service_arn" {
  description = "ECS Service ARN"
  value       = aws_ecs_service.app.arn
}

output "task_definition_arn" {
  description = "Task Definition ARN"
  value       = aws_ecs_task_definition.app.arn
}
