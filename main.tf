# ===============================================
# REFERENCES
#   * https://registry.terraform.io/providers/hashicorp/nomad/latest/docs
#   * https://www.terraform.io/docs/language/functions/templatefile.html
# ===============================================

locals {
  template_version = "default"
  
  # Job overrides. Defaults are set within template.
  settings = var.settings
  
  # Conditionals. Defaults are set outside of template.
  template = {
    job_name               = var.job_name
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
    CFG = local.settings # Used as alternative to passing as string-only hcl2 variables
    TPL = local.template
  })

  hcl2 {
    enabled = true
    allow_fs = false
  }
}
