# route53

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.api_dns_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.device_dns_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.www_dns_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.dns_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_dns_record_name"></a> [api\_dns\_record\_name](#input\_api\_dns\_record\_name) | n/a | `any` | n/a | yes |
| <a name="input_api_lb"></a> [api\_lb](#input\_api\_lb) | n/a | `any` | n/a | yes |
| <a name="input_device_dns_record_name"></a> [device\_dns\_record\_name](#input\_device\_dns\_record\_name) | n/a | `any` | n/a | yes |
| <a name="input_device_lb"></a> [device\_lb](#input\_device\_lb) | n/a | `any` | n/a | yes |
| <a name="input_dns_zone"></a> [dns\_zone](#input\_dns\_zone) | n/a | `any` | n/a | yes |
| <a name="input_is_api_alb"></a> [is\_api\_alb](#input\_is\_api\_alb) | Whether or not the api has an application load balancer | `bool` | `false` | no |
| <a name="input_www_dns_record_name"></a> [www\_dns\_record\_name](#input\_www\_dns\_record\_name) | n/a | `any` | n/a | yes |
| <a name="input_www_lb"></a> [www\_lb](#input\_www\_lb) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
