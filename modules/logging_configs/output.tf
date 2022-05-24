output "fire_lens_container" {
  value = local.fire_lens_container
}

output "log_configuration" {
  value = local.log_configuration
}

output "datadog_container" {
  value = local.datadog_ecs_agent_task_def
}

output "datadog_key_arn" {
  value = var.datadog_key_arn
}