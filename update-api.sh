#!/bin/bash

aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 665357118005.dkr.ecr.eu-north-1.amazonaws.com

docker build -t 665357118005.dkr.ecr.eu-north-1.amazonaws.com/api:latest  -f ./docker/src/api/Dockerfile ./docker/src/api
docker push 665357118005.dkr.ecr.eu-north-1.amazonaws.com/api:latest
