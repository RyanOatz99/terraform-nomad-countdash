module "countdash" {
  source  = "runeron/countdash/nomad"
  version = "0.1.1"

  job_name = "countdash"
  expose_dashboard_port = 9000
  settings = {
    namespace       = "default"
    api_image       = "hashicorpnomad/counter-api:v2"
    dashboard_image = "hashicorpnomad/counter-dashboard:v2"
    sidecar_ram     = 64
  }
}

