module "countdash" {
  source = "../."

  job_name = "dash-demo"
  expose_dashboard_port = 9000
  settings = {
    namespace       = "default"
    api_image       = "hashicorpnomad/counter-api:v3"
    dashboard_image = "hashicorpnomad/counter-dashboard:v3"
    sidecar_ram     = 64
  }
}

