# www

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecs_service.www_ecs_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.www_task_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy.www_task_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.www_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.www_role_policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lb.www_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.www_lb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.www_ssl_lb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.www_lb_tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_ssm_parameter.nerves_hub_www_ses_from_email](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.nerves_hub_www_ssm_app_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.nerves_hub_www_ssm_aws_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.nerves_hub_www_ssm_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.nerves_hub_www_ssm_host](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.nerves_hub_www_ssm_port](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.nerves_hub_www_ssm_s3_bucket_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.nerves_hub_www_ssm_s3_log_bucket_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.nerves_hub_www_ssm_s3_ssl_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.nerves_hub_www_ssm_secret_db_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.nerves_hub_www_ssm_secret_erl_cookie](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.nerves_hub_www_ssm_secret_live_view_signing_salt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.nerves_hub_www_ssm_secret_secret_key_base](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.nerves_hub_www_ssm_secret_smtp_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.nerves_hub_www_ssm_ses_port](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.nerves_hub_www_ssm_ses_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.nerves_hub_www_ssm_smtp_username](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [random_integer.target_group_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [aws_iam_policy_document.www_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs"></a> [access\_logs](#input\_access\_logs) | n/a | `bool` | `false` | no |
| <a name="input_access_logs_bucket"></a> [access\_logs\_bucket](#input\_access\_logs\_bucket) | n/a | `string` | `""` | no |
| <a name="input_access_logs_prefix"></a> [access\_logs\_prefix](#input\_access\_logs\_prefix) | n/a | `string` | `"nerves-hub-www-alb"` | no |
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | n/a | `any` | n/a | yes |
| <a name="input_app_bucket"></a> [app\_bucket](#input\_app\_bucket) | n/a | `any` | n/a | yes |
| <a name="input_ca_bucket"></a> [ca\_bucket](#input\_ca\_bucket) | n/a | `any` | n/a | yes |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | n/a | `any` | n/a | yes |
| <a name="input_cluster"></a> [cluster](#input\_cluster) | n/a | `any` | n/a | yes |
| <a name="input_db"></a> [db](#input\_db) | n/a | `any` | n/a | yes |
| <a name="input_docker_image"></a> [docker\_image](#input\_docker\_image) | n/a | `any` | n/a | yes |
| <a name="input_erl_cookie"></a> [erl\_cookie](#input\_erl\_cookie) | n/a | `any` | n/a | yes |
| <a name="input_from_email"></a> [from\_email](#input\_from\_email) | n/a | `string` | `"no-reply@nerves-hub.org"` | no |
| <a name="input_host_name"></a> [host\_name](#input\_host\_name) | n/a | `any` | n/a | yes |
| <a name="input_internal_lb"></a> [internal\_lb](#input\_internal\_lb) | Whether or not the load balancer is internal | `bool` | `false` | no |
| <a name="input_kms_key"></a> [kms\_key](#input\_kms\_key) | n/a | `any` | n/a | yes |
| <a name="input_lb_security_group_id"></a> [lb\_security\_group\_id](#input\_lb\_security\_group\_id) | n/a | `any` | n/a | yes |
| <a name="input_live_view_signing_salt"></a> [live\_view\_signing\_salt](#input\_live\_view\_signing\_salt) | n/a | `any` | n/a | yes |
| <a name="input_log_bucket"></a> [log\_bucket](#input\_log\_bucket) | n/a | `any` | n/a | yes |
| <a name="input_log_group"></a> [log\_group](#input\_log\_group) | n/a | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `any` | n/a | yes |
| <a name="input_secret_key_base"></a> [secret\_key\_base](#input\_secret\_key\_base) | n/a | `any` | n/a | yes |
| <a name="input_service_count"></a> [service\_count](#input\_service\_count) | n/a | `any` | n/a | yes |
| <a name="input_smtp_password"></a> [smtp\_password](#input\_smtp\_password) | n/a | `any` | n/a | yes |
| <a name="input_smtp_username"></a> [smtp\_username](#input\_smtp\_username) | n/a | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resources | `map(string)` | <pre>{<br>  "terraform": true<br>}</pre> | no |
| <a name="input_task_execution_role"></a> [task\_execution\_role](#input\_task\_execution\_role) | n/a | `any` | n/a | yes |
| <a name="input_task_security_group_id"></a> [task\_security\_group\_id](#input\_task\_security\_group\_id) | n/a | `any` | n/a | yes |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lb_dns_name"></a> [lb\_dns\_name](#output\_lb\_dns\_name) | n/a |
| <a name="output_lb_zone_id"></a> [lb\_zone\_id](#output\_lb\_zone\_id) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
