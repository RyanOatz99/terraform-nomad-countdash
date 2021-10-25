module "countdash" {
  source = "../../."

  job_name = "countdash"
  
  settings = {
    namespace       = "default"
    api_image       = "hashicorpnomad/counter-api:v2"
    dashboard_image = "hashicorpnomad/counter-dashboard:v2"
    sidecar_ram     = 64
  }
  
  # Conditionals
  expose_dashboard_port = 5000
}

