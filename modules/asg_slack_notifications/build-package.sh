#!/bin/bash

lambda_name="sns-autoscaling-slack"
current=$(pwd)

if [ -f "${lambda_name}.zip" ]; then
  rm "${lambda_name}.zip"
fi

echo "Running npm install ..."
docker run -it --rm \
  -v $(cd ${lambda_name}; pwd):/app/ \
  -w /app/ \
  node:4.4-slim npm i --production

echo "Zipping Lambda ..."
cd $lambda_name
zip -Xqr ${current}/${lambda_name}.zip *
cd -
