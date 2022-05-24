# This is just a module to provide a template for creating a log configuration for an ECS task definition.

locals {
  tld = var.region == "eu-central-1" ? "eu" : "com"

  fire_lens_container = <<EOF
  {
    "essential": true,
    "image": "906394416424.dkr.ecr.${var.region}.amazonaws.com/aws-for-fluent-bit:stable",
    "name": "log_router",
    "cpu": 0,
    "user": "0",
    "environment": [],
    "volumesFrom": [],
    "portMappings": [],
    "mountPoints": [],
    "firelensConfiguration": {
      "type": "fluentbit",
      "options": {
        "enable-ecs-log-metadata": "true"
      }
    },
    "memoryReservation": 50,
    "dockerLabels": {
      "com.datadoghq.tags.env": "${var.environment_name}",
      "com.datadoghq.tags.service": "${var.app_name}",
      "com.datadoghq.tags.version": "${var.docker_image_tag}"
    }
  }
EOF

  datadog_ecs_agent_task_def = <<EOF
{
  "name": "datadog-agent",
  "image": "${var.datadog_image}",
  "essential": false,
  "memoryReservation": 256,
  "cpu": 10,
  "mountPoints": [],
  "volumesFrom": [],
  "portMappings": [
    {
      "containerPort": 8125,
      "hostPort": 8125,
      "protocol": "udp"
    },
    {
      "containerPort": 8126,
      "hostPort": 8126,
      "protocol": "tcp"
    }
  ],
  "environment": [
    {
      "name": "ECS_FARGATE",
      "value": "true"
    },
    {
      "name": "DD_DOGSTATSD_TAG_CARDINALITY",
      "value": "orchestrator"
    },
    {
      "name": "DD_LOG_LEVEL",
      "value": "warn"
    },
    {
      "name": "DD_APM_ENABLED",
      "value": "true"
    },
    {
      "name": "DD_APM_NON_LOCAL_TRAFFIC",
      "value": "true"
    },
    {
      "name": "DD_PROCESS_AGENT_ENABLED",
      "value": "true"
    },
    {
      "name": "DD_HEALTH_PORT",
      "value": "5555"
    },
    {
      "name": "DD_APM_RECEIVER_PORT",
      "value": "8126"
    },
    {
      "name": "DD_DOGSTATSD_NON_LOCAL_TRAFFIC",
      "value": "true"
    },
    {
	  "name": "DD_SITE",
	  "value": "datadoghq.${local.tld}"
    },
    {
      "name": "DD_LOGS_CONFIG_CONTAINER_COLLECT_ALL",
      "value": "true"
    },
    {
      "name": "DD_DOGSTATSD_PORT",
      "value": "8125"
    },
    {
      "name": "DD_ENV",
      "value": "${var.environment_name}"
    },
    {
      "name": "DD_SERVICE",
      "value": "${var.app_name}"
    },
    {
      "name": "DD_VERSION",
      "value": "${var.docker_image_tag}"
    },
    {
      "name": "DD_DOCKER_LABELS_AS_TAGS",
      "value": "{\"com.datadoghq.tags.service\": \"service\", \"com.datadoghq.tags.version\": \"version\", \"com.datadoghq.tags.env\": \"env\"}"
    },
    {
      "name": "DD_DOGSTATSD_TAGS",
      "value": "[\"env:${var.environment_name}\", \"service:${var.app_name}\", \"version:${var.docker_image_tag}\"]"
    }
  ],
  "secrets": [
    {
      "name": "DD_API_KEY",
      "valueFrom": "${var.datadog_key_arn}"
    }
  ],
  "dockerLabels": {
          "com.datadoghq.tags.env": "${var.environment_name}",
          "com.datadoghq.tags.service": "${var.app_name}",
          "com.datadoghq.tags.version": "${var.docker_image_tag}"
  },
  ${local.datadog_log_configuration}
}
EOF

  log_configuration = <<EOF
  "logConfiguration": {
        "logDriver": "awsfirelens",
        "options": {
          "Name": "datadog",
          "compress": "gzip",
          "Host": "http-intake.logs.datadoghq.${local.tld}",
          "dd_service": "${var.app_name}",
          "dd_source": "elixir",
          "dd_message_key": "log",
          "dd_tags": "env:${var.environment_name},application:${var.app_name}-${var.environment_name},version:${var.docker_image_tag},task:${var.task_name}",
          "TLS": "on",
          "provider": "ecs"
        },
        "secretOptions": [
        {
          "name": "apikey",
          "valueFrom": "${var.datadog_key_arn}"
        }
      ]
    },
        "dockerLabels": {
          "com.datadoghq.tags.env": "${var.environment_name}",
          "com.datadoghq.tags.service": "${var.app_name}",
          "com.datadoghq.tags.version": "${var.docker_image_tag}"
        }
EOF

  datadog_log_configuration = <<EOF
  "logConfiguration": {
        "logDriver": "awsfirelens",
        "options": {
          "Name": "datadog",
          "compress": "gzip",
          "Host": "http-intake.logs.datadoghq.${local.tld}",
          "dd_service": "${var.app_name}",
          "dd_source": "datadog",
          "dd_message_key": "log",
          "dd_tags": "env:${var.environment_name},application:${var.app_name}-${var.environment_name},version:${var.docker_image_tag},task:${var.task_name}",
          "TLS": "on",
          "provider": "ecs"
        },
        "secretOptions": [
        {
          "name": "apikey",
          "valueFrom": "${var.datadog_key_arn}"
        }
      ]
    },
        "dockerLabels": {
          "com.datadoghq.tags.env": "${var.environment_name}",
          "com.datadoghq.tags.service": "${var.app_name}",
          "com.datadoghq.tags.version": "${var.docker_image_tag}"
        }
EOF
}