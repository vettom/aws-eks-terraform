# investigation notes

Cluster with ALB and ALB controller intalled
- Ingress work and target is 80
- Real IP is logged. 


nginx config section removed from main
          config:
            use-forwarded-headers: true
            force-ssl-redirect: true
            enable-real-ip: true
            compute-full-forwarded-for: "true"