# Prometheus Setup for Kubernetes

Playbook for integrating Prometheus into Kubernetes.

## Services

### Prometheus Service

Service that runs instance of Prometheus as a K8s service. This is the core
Prometheus platform.

**Ansible Variables:**
* `prometheus_namespace` - namespace for Kubernetes objects, defaults to
  "monitoring"
* `prometheus_service_name` - name used for objects created within the
  namespace, defaults to "prometheus"
* `prometheus_tls_secret` - secret name used for TLS within service, created if
  it does not exist
* `prometheus_fqdn` - external FQDN that will be used for generating ingress
  config
* `prometheus_retention` - storage retention period, defaults to "24h"

### Prometheus Blackbox

Service that runs instance of Prometheus Blackbox as a K8s service. This allows
polling of internal and external endpoints, internal services, and internal
ingresses. The results of these polls are sent to prometheus and also exposed to
the Kubernetes metrics API

**Ansible Variables:**
* `blackbox_namespace` - namespace for Kubernetes objects, defaults to
  "monitoring"
* `blackbox_service_name` - name used for objects created within the namespace,
  defaults to "blackbox"
* `blackbox_tls_secret` - secret name used for TLS within service, created if it
  does not exist
* `blackbox_fqdn` - external FQDN that will be used for generating ingress
  config

### Prometheus Kubernetes Adapter

Service that runs instance of Prometheus Kubernetes Adapter as a K8s service.
This adapter exposes Prometheus collected metrics to the Kubernetes Metrics API
for use with metrics defined by K8s Horizontal and Vertical Autoscalers. This
is connected to K8s "custom.metrics.k8s.io" API endpoint.

**Ansible Variables:**
* `adapter_namespace` - namespace for Kubernetes objects, defaults to
  "monitoring"
* `adapter_service_name` - name used for objects created within the namespace,
  defaults to "prometheus-adapter"
* `adapter_tls_secret` - secret name used for TLS within service, created if it
  does not exist

## Enabling Metrics in Kubernetes

### Poller on Service used with Horizontal Pod Autoscaler

To enable the blackbox poller for a service, you must set K8s annotation
"prometheus.io/probe" on the service.

**Example Service**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: sample-app
  labels:
    run: sample-app
  annotations:
    prometheus.io/probe: "true"
spec:
  ports:
    - port: 8080
  selector:
    run: sample-app
```

**Example Horizontal Pod Autoscaler**

```yaml
apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: sample-app
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: sample-app
  minReplicas: 1
  maxReplicas: 10
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 180
      policies:
        - type: Pods
          value: 2
          periodSeconds: 15
        - type: Percent
          value: 25
          periodSeconds: 15
    scaleDown:
      stabilizationWindowSeconds: 180
      policies:
        - type: Pods
          value: 1
          periodSeconds: 15
        - type: Percent
          value: 25
          periodSeconds: 15
  metrics:
    - type: Object
      object:
        metric:
          name: probe_http_duration_seconds
        describedObject:
          apiVersion: v1
          kind: Service
          name: sample-app
        target:
          type: AverageValue
          # 200 milli seconds
          averageValue: 200m
```

### Scraper for Deployment with Prometheus Endpoint Exposed

To enable for a service, you must set K8s annotation  "prometheus.io/scrape" on
the deployment. Other option that can be enabled include the following:

* prometheus.io/scrape - Set to "true" to enable automatic discover by scraper
* prometheus.io/port - Port that serves the /metrics endpoint on service
* prometheus.io/path - Path to metrics endpoint if not the default of "/metrics"

This requires the POD have a Prometheus endpoint available. The options for this
includes using an integrated endpoint or a secondary container setup in the
"sidecar" model.

**Example Deployment**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-app
  labels:
    run: sample-app
spec:
  selector:
    matchLabels:
      run: sample-app
  replicas: 1
  template:
    metadata:
      labels:
        run: sample-app
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "8080"
        prometheus.io/path: "/metrics"
    spec:
      containers:
        - name: sample-app
          image: sample-app:latest
          imagePullPolicy: Always
          ports:
            - containerPort: 8080
          env:
            - name: PORT
              value: "8080"
          resources:
            limits:
              memory: 512Mi
              cpu: 1000m
            requests:
              memory: 256Mi
              cpu: 500m
```

**Example Horizontal Pod Autoscaler**

This requires the Prometheus endpoint on the pod to expose a
"http_requests_total" metric. This is converted to a rate (per second) metric
called "http_requests_per_second" (found within prometheus-adapter-config).

```yaml
apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: sample-app
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: sample-app
  minReplicas: 1
  maxReplicas: 10
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 180
      policies:
        - type: Pods
          value: 2
          periodSeconds: 15
        - type: Percent
          value: 25
          periodSeconds: 15
    scaleDown:
      stabilizationWindowSeconds: 180
      policies:
        - type: Pods
          value: 1
          periodSeconds: 15
        - type: Percent
          value: 25
          periodSeconds: 15
  metrics:
    - type: Pods
      pods:
        metric:
          name: http_requests_per_second
        target:
          type: AverageValue
          # target 1000 milli-requests per second,
          # which is 1 request every one seconds
          averageValue: 1000m
```

## Testing

```bash
# get list of available API versions
kubectl get --raw /apis/custom.metrics.k8s.io/ | jq

# get list of all metrics available to API
kubectl get --raw /apis/custom.metrics.k8s.io/v1beta2 | jq

# query metrics from service poller (requires service to be tagged)
SERVICE_NAMESPACE=default
SERVICE_NAME=sample-app
METRIC_NAME=probe_http_duration_seconds
kubectl get --raw "/apis/custom.metrics.k8s.io/v1beta1/namespaces/${SERVICE_NAMESPACE}/services/${SERVICE_NAME}/${METRIC_NAME}" | jq

# query metrics collected from pod poller (required POD to have prometheus endpoint config)
SERVICE_NAMESPACE=default
SERVICE_NAME=sample-app
METRIC_NAME=http_requests_per_second
kubectl get --raw "/apis/custom.metrics.k8s.io/v1beta1/namespaces/${SERVICE_NAMESPACE}/pods/*/${METRIC_NAME}" | jq
```
