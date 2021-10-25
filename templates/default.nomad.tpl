# ===============================================
# NOMAD JOB
# ===============================================

job "${JOB}" {
  datacenters = local.datacenters
  namespace = local.namespace
%{~ if TPL.task_enabled_api }

# -----------------------------------------------
# START OF API TASK
# -----------------------------------------------

  group "api" {
    count = local.api_count

    network {
       mode = "bridge"
    }

    service {
      name = local.api_service
      port = local.api_port
      connect {
        sidecar_task {
          resources {
            cpu = local.sidecar_cpu
            memory = local.sidecar_ram
          }
        }
        sidecar_service {}
      }
    }

    task "api" {
      driver = "docker"
      
      resources {
        cpu    = local.api_cpu
        memory = local.api_ram
      }

      config {
        image = local.api_image
      }
    }
  }
%{~ else }
# API TASK DISABLED
%{~ endif }
%{~ if TPL.task_enabled_dashboard }

# -----------------------------------------------
# START OF DASHBOARD TASK
# -----------------------------------------------

  group "dashboard" {
    count = local.dashboard_count

    network {
      mode ="bridge"
      port "http" {
        to = local.dashboard_port
        %{~ if TPL.expose_dashboard_port > 0 ~}
        static = ${TPL.expose_dashboard_port}
        %{~ endif ~}
      }
    }

    service {
      name = local.dashboard_service
      port = local.dashboard_port
      connect {
        sidecar_task {
          resources {
            cpu = local.sidecar_cpu
            memory = local.sidecar_ram
          }
        }
        sidecar_service {
          proxy {
            upstreams {
              destination_name = local.api_service
              local_bind_port = local.dashboard_api_port
            }
          }
        }
      }
    }

    task "dashboard" {
      driver = "docker"

      resources {
        cpu    = local.dashboard_cpu
        memory = local.dashboard_ram
      }

      env {
        COUNTING_SERVICE_URL = "http://127.0.0.1:$${local.dashboard_api_port}"
      }

      config {
        image = local.dashboard_image
      }
    }
  }
%{~ else }
# DASHBOARD TASK DISABLED
%{~ endif }
}

# ===============================================
# TEMPLATE DEFAULTS & OVERRIDES
# ===============================================

locals {
  datacenters = ${jsonencode(lookup(CFG,"datacenters",["dc1"]))}
  namespace   = "${lookup(CFG,"namespace","default")}"
  
  api_count   = ${lookup(CFG,"api_count",1)}
  api_cpu     = ${lookup(CFG,"api_cpu",100)}
  api_ram     = ${lookup(CFG,"api_ram",32)}
  api_image   = "${lookup(CFG,"api_image","hashicorpnomad/counter-api:v3")}"
  api_port    = ${lookup(CFG,"api_port",9001)}
  api_service = "${lookup(CFG,"api_service","count-api")}"
  
  dashboard_count    = ${lookup(CFG,"dashboard_count",1)}
  dashboard_cpu      = ${lookup(CFG,"dashboard_cpu",100)}
  dashboard_ram      = ${lookup(CFG,"dashboard_ram",64)}
  dashboard_image    = "${lookup(CFG,"dashboard_image","hashicorpnomad/counter-dashboard:v3")}"
  dashboard_port     = ${lookup(CFG,"dashboard_port",9002)}
  dashboard_service  = "${lookup(CFG,"dashboard_service","count-dashboard")}"
  dashboard_api_port = ${lookup(CFG,"dashboard_api_port",8080)}
  
  sidecar_cpu = ${lookup(CFG,"sidecar_cpu",100)}
  sidecar_ram = ${lookup(CFG,"sidecar_ram",64)}
}

