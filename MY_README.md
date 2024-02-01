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