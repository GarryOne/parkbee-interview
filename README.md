### TODOs
* Move the `tfstate` to s3 storage
* Modify the `terraform.yaml` so that on PR branch it runs only `terraform plan`, but `terraform apply` should be run only on `main` branch
* Add HTTPS to the services
* Optionally, for a better flexibility, there can be added `outputs.tf` and `variables.tf`


## CI/CD Pipelines
* `.github/workflows/terraform.yml` - this one deploys the terraform infrastructure defined in `main.tf`
* `.github/workflows/kubernetes.yml` - this one deploys the kubernetes cluster defined in `k8s-deployment.yml` 

## See it action

* Run the pipelines for the first time. (this will do `kubectl apply -f secrets.yaml` where is **MONGODB** connection defined)
* Connect local kubectl to EKS cluster 
```
aws eks update-kubeconfig --name parbkee-cluster
```

# Monitoring

## Helm charts for Prometheus and Grafana

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install prometheus-release prometheus-community/kube-prometheus-stack
```

### Exposing Prometheus and Grafana publicly URLs

```
kubectl patch svc prometheus-release-grafana -n default -p '{"spec": {"type": "LoadBalancer"}}'
```

```
kubectl patch svc prometheus-release-kube-pr-prometheus -n default -p '{"spec": {"type": "LoadBalancer"}}'
```

### Get the public URLs of Grafana and Prometheus

```
kubectl get svc -n default
```

They should look like this.

* Prometheus - http://a2bdb2dec9fc54714ab344f9e16e571f-539306497.eu-north-1.elb.amazonaws.com:9090/

* Grafana - http://abb804b0ded9a4736813d580290e8f16-253192928.eu-north-1.elb.amazonaws.com/login

### Access Grafana and Prometheus locally

```
kubectl port-forward pod/prometheus-prometheus-release-kube-pr-prometheus-0 9090:9090 -n default
kubectl port-forward --address 0.0.0.0 service/prometheus-release-grafana 3000:80
```

http://localhost:3000/ - Grafana
http://localhost:9090/ - Prometheus

### Grafana credentials
User: `admin`
Pass: `prom-operator`

---

## Kubernetes limited account

This one adds a `limited-access-account` that has access only to the `myapp` namespace
```
kubectl apply -f service-account.yaml
```

Now, we can get the `SA_TOKEN` using it later
```
SA_TOKEN=$(kubectl get secret limited-access-account-token -n myapp -o jsonpath='{.data.token}' | base64 --decode)
```

### One command test 

This one would not work
```
❯ kubectl --token=$SA_TOKEN get pods -n default
Error from server (Forbidden): pods is forbidden: User "system:serviceaccount:myapp:limited-access-account" cannot list resource "pods" in API group "" in the namespace "default"
```

The below one would work
```
kubectl --token=$SA_TOKEN get pods -n myapp
```






### Switch context 

```
kubectl config set-credentials limited-access-account --token=$SA_TOKEN
kubectl config set-context limited-access-context --cluster=arn:aws:eks:eu-north-1:665357118005:cluster/parbkee-cluster --namespace=myapp --user=limited-access-account
kubectl config use-context limited-access-context
```

### Test
```
kubectl get pods
```

You should see only the pods in the "myapp" namespace


### Switch back to normal user/context

```
kubectl config use-context arn:aws:eks:eu-north-1:665357118005:cluster/parbkee-cluster
```



## Testing locally with docker-compose.yaml
```
docker compose up
```

## ECR Repositories

* `665357118005.dkr.ecr.eu-north-1.amazonaws.com/app:latest`
* `665357118005.dkr.ecr.eu-north-1.amazonaws.com/api:latest`

## AWS Region
`eu-north-1`