output "rendered_job" {
  description = "Rendered job"
  value = nomad_job.JOB.jobspec
}
