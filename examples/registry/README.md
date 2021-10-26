# REGISTRY MODULE


## EXAMPLE

```hcl
# main.tf
module "countdash" {
  source  = "runeron/countdash/nomad"
  version = "0.1.1"

  job_name = "countdash"
  expose_dashboard_port = 5050
  settings = {
    datacenters     = ["dev1"]
    namespace       = "demos"
    api_image       = "hashicorpnomad/counter-api:v2"
    api_count       = 2
    dashboard_image = "hashicorpnomad/counter-dashboard:v2"
    dashboard_ram   = 128
    sidecar_ram     = 64
  }
}

output "countdash_jobspec" {
 value = module.countdash.rendered_job
}

```

```bash
# Configure Nomad-provider. Ex. using env-variables
#export NOMAD_ADDR=http://<nomad-address>:4646
#export NOMAD_TOKEN=<nomad-token>

# Initilize & check
terraform init
terraform validate
terraform plan

# Create job
terraform apply

# Cleanup
terraform destroy
```

## Resources
  * module.countdash.nomad_job.JOB

## Outputs
| Name | Description |
|------|-------------|
| module.countdash.countdash_jobspec | Rendered jobfile |
