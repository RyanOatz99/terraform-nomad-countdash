# ===============================================
# NOMAD JOB
# ===============================================

job "${NAME}" {
  datacenters = local.datacenters
  namespace = local.namespace
%{~ if TASK_ENABLED_API }

# -----------------------------------------------
# START OF API TASK
# -----------------------------------------------

  group "api" {
    count = local.api_count

    network {
       mode = "bridge"
    }

    service {
      name = "count-api"
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
%{~ if TASK_ENABLED_DASHBOARD }

# -----------------------------------------------
# START OF DASHBOARD TASK
# -----------------------------------------------

  group "dashboard" {
    count = local.dashboard_count

    network {
      mode ="bridge"
      port "http" {
        to = local.dashboard_port
        %{~ if EXPOSE_DASHBOARD_PORT > 0 ~}
        static = ${EXPOSE_DASHBOARD_PORT}
        %{~ endif ~}
      }
    }

    service {
      name = "count-dashboard"
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
              destination_name = "count-api"
              local_bind_port = 8080
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
        COUNTING_SERVICE_URL = "http://$${NOMAD_UPSTREAM_ADDR_count_api}"
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
  datacenters     = ${jsonencode(lookup(CFG,"datacenters",["dc1"]))}
  namespace       = "${lookup(CFG,"namespace","default")}"
  
  api_count       = ${lookup(CFG,"api_count",1)}
  api_cpu         = ${lookup(CFG,"api_cpu",100)}
  api_ram         = ${lookup(CFG,"api_ram",32)}
  api_image       = "${lookup(CFG,"api_image","hashicorpnomad/counter-api:v1")}"
  api_port        = ${lookup(CFG,"api_port",9001)}
  
  dashboard_count = ${lookup(CFG,"dashboard_count",1)}
  dashboard_cpu     = ${lookup(CFG,"dashboard_cpu",100)}
  dashboard_ram     = ${lookup(CFG,"dashboard_ram",64)}
  dashboard_image = "${lookup(CFG,"dashboard_image","hashicorpnomad/counter-dashboard:v1")}"
  dashboard_port  = ${lookup(CFG,"dashboard_port",9002)}
  
  sidecar_cpu     = ${lookup(CFG,"sidecar_cpu",100)}
  sidecar_ram     = ${lookup(CFG,"sidecar_ram",64)}
}

