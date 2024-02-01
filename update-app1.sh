#!/bin/bash

aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 665357118005.dkr.ecr.eu-north-1.amazonaws.com

docker build -t 665357118005.dkr.ecr.eu-north-1.amazonaws.com/app1:latest -f ./docker/Dockerfile-api .
docker push 665357118005.dkr.ecr.eu-north-1.amazonaws.com/app1:latest