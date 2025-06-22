# EXPRESS LAMBDA APIGATEWAY

- This project contains code for a simple express application packaged for lambda deployment using serverless-http package.
- This express application can also be tested locally for local testing using server.js
- This project contains commonjs syntax

## Docker compose

- This project has docker-compose.yaml file. This file creates a localstack container and adds volumes to it.
- The default init.sh script that is placed in localstack folder is initalized on start by default.
- The init.sh script contains code to create lambda function, create a api gateway resource for proxy and simple testing using http api.
