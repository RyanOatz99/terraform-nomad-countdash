output "rendered_job" {
  description = "Rendered jobspec"
  value = nomad_job.JOB.jobspec
}
