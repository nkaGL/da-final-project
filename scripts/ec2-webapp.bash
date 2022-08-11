#!/bin/bash -xe
docker pull mongo
docker run -it --rm -d --name mongo -p 27017:27017 mongo
docker run -it --rm -d --name webapp -p 8080:8080 --net host public.ecr.aws/n2x7h9r6/todowebapp:local