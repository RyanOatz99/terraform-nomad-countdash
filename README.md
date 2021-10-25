# TERRAFORM-NOMAD-COUNTDASH
#### LINKS
  * [GitHub](https://github.com/runeron/terraform-nomad-countdash)
  * [Terraform Registry](https://registry.terraform.io/modules/runeron/countdash/nomad/latest)

## DESCRIPTION
This is a module showing how to create customizable job(s) for the nomad-provider
as a module. An excessive amount of customizable options are intentionally added.

This example uses the [Consul-connect for Nomad](https://www.nomadproject.io/docs/integrations/consul-connect)
example shown in the Nomad documentation as a basis.

## MODULE CONFIGURATION

#### TEMPLATE-CONDITIONALS
Some customizations by the templatefile-function, are not passed on to the rendered jobfile.
These settings can't be handled by hcl2 variables within the job-file itself.

| Variable | Type | Default value | Description |
|----------|------|---------------|-------------|
| job_name | string | "countdash" | Name of the job in Nomad |
| task_enabled_api | bool | true | Include api group in jobfile |
| task_enabled_dashboard | bool | true | Include dashboard group in jobfile |
| expose_dashboard_port | number | 9002 | Expose port on host. Set to 0 or lower to disable |

> These are intentionally added as a single variable to keep the config-files easy to maintain. You can include any
sub-values, but only the ones actually defined in the template will be used.

#### NOMAD JOB-SETTINGS
Override defaults in the Nomad job-template using the "settings" variable.
These are passed to the job-template as a map & added local-variables in the job,
They are then referenced as "local" hcl2 values within the job-definition.
Any settings NOT included will use the defaults defined in the template.

| Variable | Type | Default value | Description |
|----------|------|---------------|-------------|
| datacenters | list(string) | ["dc1"] | Target Nomad datacenter(s) |
| namespace   | string | "default" | Target Nomad namespace |
| api_count | number | 1 | Number of "count-api" tasks |
| api_cpu | number | 100 | Required task cpu |
| api_ram | number | 32 | Required task memory |
| api_image | string | "hashicorpnomad/counter-api:v3" | Container image to use for task |
| api_port | number | 9001 | Port for publishing api |
| api_service | string | "count-api" | api service-name (consul) |
| dashboard_count | number | 1 | Number of "count-dashboard" tasks |
| dashboard_cpu | number | 100 | Required task cpu |
| dashboard_ram | number | 64 | Required task memory |
| dashboard_image | string | "hashicorpnomad/counter-dashboard:v3" | Container image to use for task |
| dashboard_port | number | 9002 | Port for publishing dashboard |
| dashboard_service | string | "count-dashboard" | dashboard service-name (consul) |
| dashboard_api_port | number | 8080 ||
| sidecar_cpu | number | 100 | Required cpu for sidecar tasks |
| sidecar_ram  | number | 64 | Required memory for sidecar tasks |

> These are intentionally added as a single variable to keep the config-files easy to maintain. You can include any
sub-values, but only the ones actually defined in the template will be used.

## EXAMPLE
```hcl
# Using .tfvars file
job_name = "count"
expose_dashboard_port = -1
settings = {
  datacenters = ["dc1","dc2"]
  namespace = "demos"
}
```

#### REFERENCES
  * https://www.terraform.io/docs/language/modules/develop/index.html
  * https://www.terraform.io/docs/language/modules/develop/composition.html
  * https://registry.terraform.io/providers/hashicorp/nomad/latest/docs
