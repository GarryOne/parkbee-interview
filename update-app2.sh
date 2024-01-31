#!/bin/bash

docker build -t 665357118005.dkr.ecr.eu-north-1.amazonaws.com/app2:v1 -f ./docker/Dockerfile-app .
docker push 665357118005.dkr.ecr.eu-north-1.amazonaws.com/app2:v1