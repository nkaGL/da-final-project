#!/bin/bash -xe
docker run -it --rm -d --name mongo -p 27017:27017 mongo
docker run -it --rm -d --name webapp -p 8080:8080 --net host ninagl.jfrog.io/project-docker-local/webapp:latest
