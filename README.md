# TERRAFORM-NOMAD-COUNTDASH

#### DESCRIPTION
This is a module showing how to create customizable job(s) for the nomad-provider
as a module.

This example uses the [Consul-connect for Nomad](https://www.nomadproject.io/docs/integrations/consul-connect)
example shown in the Nomad documentation as a basis.

#### REFERENCES
  * https://www.terraform.io/docs/language/modules/develop/index.html
  * https://www.terraform.io/docs/language/modules/develop/composition.html
  * https://registry.terraform.io/providers/hashicorp/nomad/latest/docs

## JOB NAME
The name of the Nomad job is passed directly as a separate value (job_name) as it can't be set by variables
in the rendered job-file.

## TEMPLATE OVERRIDES
Override defaults in the Nomad job-template using the "settings" variable.
These are passed to the job-template as a map & added local-variables in the job,
They are then referenced as "local" hcl2 values within the job-definition.
Any settings NOT included will use the defaults defined in the template.

  * datacenters 
  * namespace
  * api_image
  * dashboard_image
  * dashboard_port
  * api_port

```hcl
# Example .tfvars
config = {
  datacenters = ["dc1","dc2"]
  namespace = "demos"
  dashboard_port = 5000
}

```

## TEMPLATE CONDITIONALS
Some template-customizations are handled by the templatefile-function, before creating the rendered jobfile.
These are settings that can't be handled by hcl2 variables within the job-file.

  * task_enabled_api
  * task_enabled_dashboard
  * expose_dashboard_port

