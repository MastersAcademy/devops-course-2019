#!/bin/bash

GIT_REPO_URL=https://github.com/mpereverov/devops-course-2019.git
WORKING_DIR=devops-course-2019/Lesson_5/michael.pereverov/

git clone ${GIT_REPO_URL}
cd ${WORKING_DIR}
docker-compose rm -s -f && docker-compose up -d
curl 127.0.0.1:8181

