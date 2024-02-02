### TODOs
* Add ouputs.tf and variables.tf
* Move the tfstate to s3 storage
* Create the Kubernetes user with limited access
* Modify the terraform.yaml so that on PR branch it runs only terraform plan. And "terraform apply" should be run only on main branch
* Make the API available only inside the cluster
* Add HTTPS to the services


## CI/CD Pipelines
* `.github/workflows/terraform.yml` - this one deploys the terraform infrastructure defined in `main.tf`
* `.github/workflows/kubernetes.yml` - this one deploys the kubernetes cluster defined in `k8s-deployment.yml` 

## See it action

* Run the pipelines for the first time.
* Connect local kubectl to EKS cluster 
```
$ aws eks update-kubeconfig --name parbkee-cluster
```

# Monitoring

## Helm charts for Prometheus and Grafana

```
$ helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
$ helm repo update

$ helm install prometheus-release prometheus-community/kube-prometheus-stack
```

### Exposing Prometheus and Grafana publicly URLs

```
$ kubectl patch svc prometheus-release-grafana -n default -p '{"spec": {"type": "LoadBalancer"}}'
```

```
$ kubectl patch svc prometheus-release-kube-pr-prometheus -n default -p '{"spec": {"type": "LoadBalancer"}}'
```

### Get the public URLs of Grafana and Prometheus

```
$ kubectl get svc -n default
```

They should look like this.

* Prometheus - http://a2bdb2dec9fc54714ab344f9e16e571f-539306497.eu-north-1.elb.amazonaws.com:9090/

* Grafana - http://abb804b0ded9a4736813d580290e8f16-253192928.eu-north-1.elb.amazonaws.com/login

### Access Grafana and Prometheus locally

```
$ kubectl port-forward pod/prometheus-prometheus-release-kube-pr-prometheus-0 9090:9090 -n default
$ kubectl port-forward --address 0.0.0.0 service/prometheus-release-grafana 3000:80
```

http://localhost:3000/ - Grafana
http://localhost:9090/ - Prometheus

---

## Kubernetes limited account

```
kubectl apply -f service-account.yaml
```


```
$ SA_TOKEN=$(kubectl get secret limited-access-account-token -n myapp -o jsonpath='{.data.token}' | base64 --decode)
```

### One command test 
```
$ kubectl --token=$SA_TOKEN get pods -n myapp
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