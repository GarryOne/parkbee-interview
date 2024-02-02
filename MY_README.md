aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 665357118005.dkr.ecr.eu-north-1.amazonaws.com


docker build -t 665357118005.dkr.ecr.eu-north-1.amazonaws.com/app1:v1 -f ./docker/Dockerfile-api .
docker push 665357118005.dkr.ecr.eu-north-1.amazonaws.com/app1:v1


docker build -t 665357118005.dkr.ecr.eu-north-1.amazonaws.com/app2:v1 -f ./docker/Dockerfile-app .
docker push 665357118005.dkr.ecr.eu-north-1.amazonaws.com/app2:v1


### TODOs
* Add ouputs.tf and variables.tf
* Move the tfstate to s3 storage
* Create the Kubernetes user with limited access
* Modify the terraform.yaml so that on PR branch it runs only terraform plan. And "terraform apply" should be run only on main branch
* Make the API available only inside the cluster



## Connect local kubectl to EKS cluster 
$ aws eks update-kubeconfig --name parbkee-cluster

# Monitoring. 

## Helm charts for Prometheus and Grafana

```
$ helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
$ helm repo update

$ helm install prometheus-release prometheus-community/kube-prometheus-stack
```

### Enable port forwarding for Prometheus and Grafana
```
$ kubectl port-forward pod/prometheus-prometheus-release-kube-pr-prometheus-0 9090:9090 -n default
$ kubectl port-forward --address 0.0.0.0 service/prometheus-release-grafana 3000:80
```

## Access
http://localhost:3000/ - Grafana
http://localhost:9090/ - Prometheus




