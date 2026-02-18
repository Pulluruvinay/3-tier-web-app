output "alb_dns" {
  value = module.alb.alb_dns
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}
