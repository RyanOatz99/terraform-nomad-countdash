# REGISTRY MODULE

```bash
# Configure Nomad-provider
#export NOMAD_ADDR=http://<nomad-address>:4646
#export NOMAD_TOKEN=<nomad-token>

# Send job to target nomad-api
terraform init
terraform plan
terraform apply
terraform destroy
```

## Resources
  * module.countdash.nomad_job.JOB

## Outputs
| Name | Description |
|------|-------------|
| module.countdash.countdash_jobspec | Rendered jobfile |
