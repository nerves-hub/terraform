# billing

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecs_service.billing_ecs_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.billing_task_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy.billing_task_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.billing_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.billing_role_policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket_object.web_application_data_billing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [aws_security_group.billing_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.billing_security_group_all_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.billing_security_group_web_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.db_security_group_billing_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.db_security_group_billing_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_service_discovery_service.billing_service_discovery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_service) | resource |
| [aws_ssm_parameter.nerves_hub_billing_ssm_app_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.nerves_hub_billing_ssm_host](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.nerves_hub_billing_ssm_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.nerves_hub_billing_ssm_secret_db_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.nerves_hub_billing_ssm_secret_erl_cookie](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_iam_policy_document.billing_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | n/a | `any` | n/a | yes |
| <a name="input_app_bucket"></a> [app\_bucket](#input\_app\_bucket) | n/a | `any` | n/a | yes |
| <a name="input_bucket_prefix"></a> [bucket\_prefix](#input\_bucket\_prefix) | n/a | `any` | n/a | yes |
| <a name="input_ca_bucket"></a> [ca\_bucket](#input\_ca\_bucket) | n/a | `any` | n/a | yes |
| <a name="input_cluster"></a> [cluster](#input\_cluster) | n/a | `any` | n/a | yes |
| <a name="input_db"></a> [db](#input\_db) | n/a | `any` | n/a | yes |
| <a name="input_docker_image"></a> [docker\_image](#input\_docker\_image) | n/a | `any` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `any` | n/a | yes |
| <a name="input_erl_cookie"></a> [erl\_cookie](#input\_erl\_cookie) | n/a | `any` | n/a | yes |
| <a name="input_kms_key"></a> [kms\_key](#input\_kms\_key) | n/a | `any` | n/a | yes |
| <a name="input_local_dns_namespace"></a> [local\_dns\_namespace](#input\_local\_dns\_namespace) | n/a | `any` | n/a | yes |
| <a name="input_log_group"></a> [log\_group](#input\_log\_group) | n/a | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `any` | n/a | yes |
| <a name="input_service_count"></a> [service\_count](#input\_service\_count) | n/a | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resources | `map(string)` | <pre>{<br>  "terraform": true<br>}</pre> | no |
| <a name="input_task_execution_role"></a> [task\_execution\_role](#input\_task\_execution\_role) | n/a | `any` | n/a | yes |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | n/a | `any` | n/a | yes |
| <a name="input_web_security_group"></a> [web\_security\_group](#input\_web\_security\_group) | n/a | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
