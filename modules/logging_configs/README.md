# logging_configs

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | n/a | `string` | n/a | yes |
| <a name="input_datadog_image"></a> [datadog\_image](#input\_datadog\_image) | n/a | `string` | n/a | yes |
| <a name="input_datadog_key_arn"></a> [datadog\_key\_arn](#input\_datadog\_key\_arn) | Datadog Key ARN | `string` | n/a | yes |
| <a name="input_docker_image_tag"></a> [docker\_image\_tag](#input\_docker\_image\_tag) | Docker Image Tag of Application | `string` | n/a | yes |
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | n/a | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS Region | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resources | `map(string)` | <pre>{<br>  "terraform": true<br>}</pre> | no |
| <a name="input_task_name"></a> [task\_name](#input\_task\_name) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_datadog_container"></a> [datadog\_container](#output\_datadog\_container) | n/a |
| <a name="output_datadog_key_arn"></a> [datadog\_key\_arn](#output\_datadog\_key\_arn) | n/a |
| <a name="output_fire_lens_container"></a> [fire\_lens\_container](#output\_fire\_lens\_container) | n/a |
| <a name="output_log_configuration"></a> [log\_configuration](#output\_log\_configuration) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
