#!/bin/bash

if [ "$BRANCH" == "" ]; then
  BRANCH=$(git symbolic-ref -q HEAD)
  BRANCH=${BRANCH##refs/heads/}
  BRANCH=${BRANCH:-HEAD}
fi

docker build -t chadgrant/terraform:$BRANCH .
