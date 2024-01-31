#!/bin/bash

docker build -t 665357118005.dkr.ecr.eu-north-1.amazonaws.com/app1:v1 -f ./docker/Dockerfile-api .
docker push 665357118005.dkr.ecr.eu-north-1.amazonaws.com/app1:v1