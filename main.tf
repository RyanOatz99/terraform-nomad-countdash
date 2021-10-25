# ===============================================
# REFERENCES
#   * https://registry.terraform.io/providers/hashicorp/nomad/latest/docs
#   * https://www.terraform.io/docs/language/functions/templatefile.html
# ===============================================

locals {
  template_version = "default"
  job_name = var.job_name
  
  # Job overrides. Defaults are set within template.
  settings = var.settings
  
  # Conditionals. Defaults are set outside of template.
  template = {
    task_enabled_api       = var.task_enabled_api
    task_enabled_dashboard = var.task_enabled_dashboard
    expose_dashboard_port  = var.expose_dashboard_port
  }
}

# ===============================================
# NOMAD JOB
# ===============================================

resource nomad_job "JOB" {
  jobspec = templatefile("${path.module}/templates/${local.template_version}.nomad.tpl",{
    JOB = local.job_name
    CFG = local.settings # Used as alternative to passing string-only hcl2 variables
    TPL = local.template
  })

  hcl2 {
    enabled = true
    allow_fs = false
  }
}
