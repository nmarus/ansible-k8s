Simple Node JS Web Server Container that spits out certain env variables to troubleshoot and test [K8s Service Topology](https://kubernetes.io/docs/concepts/services-networking/service-topology/) feature.

Response example:

```json
{
  "KUBERNETES_PORT": "tcp://10.0.0.1:443",
  "KUBERNETES_SERVICE_PORT": "443",
  "KUBERNETES_NODE_NAME": "k8s-worker-3",
  "KUBERNETES_POD_NAME": "web-env-app-6fd7dcf6cd-rpjg9",
  "KUBERNETES_POD_SERVICE_ACCOUNT": "default",
  "KUBERNETES_PORT_443_TCP_ADDR": "10.0.0.1",
  "KUBERNETES_PORT_443_TCP_PORT": "443",
  "KUBERNETES_PORT_443_TCP_PROTO": "tcp",
  "KUBERNETES_POD_NAMESPACE": "default",
  "KUBERNETES_SERVICE_PORT_HTTPS": "443",
  "KUBERNETES_PORT_443_TCP": "tcp://10.0.0.1:443",
  "KUBERNETES_SERVICE_HOST": "10.0.0.1",
  "KUBERNETES_POD_IP": "10.244.69.194"
}
```
