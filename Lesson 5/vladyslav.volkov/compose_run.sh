#!/bin/bash
docker-compose up -d
curl 127.0.0.1:8181
docker-compose down --rmi local