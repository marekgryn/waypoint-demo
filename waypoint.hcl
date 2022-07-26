project = "example-nodejs"

app "example-nodejs" {
  labels = {
    "service" = "example-nodejs",
    "env"     = "dev"
  }

  build {
    use "pack" {
      disable_entrypoint = true
    }
#    use "docker" {
#      buildkit           = false
#      disable_entrypoint = false
#    }
    registry {
      use "aws-ecr" {
        region     = "eu-west-2"
        repository = "mg-waypoint"
        tag        = "latest"
      }
    }
  }

  deploy {
    use "kubernetes" {
      namespace = "waypoint-demo"
      probe_path = "/"
    }
  }

  release {
    use "kubernetes" {
      namespace = "waypoint-demo"
      port = 80
      ingress "http" {
        annotations = {
          "nginx.ingress.kubernetes.io/ssl-redirect": "true"
          "nginx.ingress.kubernetes.io/force-ssl-redirect": "true"
          "nginx.ingress.kubernetes.io/backend-protocol": "HTTP"
          "kubernetes.io/ingress.class": "nginx"
        }
        host      = "waypoint-demo.eks-1.cdworkstreamsandbox.babylontech.co.uk"
        path_type = "Prefix"
        path      = "/"
      }
    }
  }

  url {
    auto_hostname = false
  }
}
