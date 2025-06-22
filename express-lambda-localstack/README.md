# EXPRESS LAMBDA APIGATEWAY

- This project contains code for a simple express application packaged for lambda deployment using serverless-http package.
- This express application can also be tested locally for local testing `cd` into lambda folder and use `npm run start` (runs `node server.js`)
- This project contains commonjs syntax

## Docker compose

- This project has docker-compose.yaml file. This file creates a localstack container and adds volumes to it.
- The default init.sh script that is placed in localstack folder is initalized on start by default.
- The init.sh script contains code to create lambda function, create a api gateway resource for proxy and simple testing using http api.

## How to Run 

- To run and deploy this project
  1. run `cd lambda && npm i && cd ..`
  2. run `./lambda-build.sh` --> creates a build folder with lambda.zip --> contains main express application code and node_module dependencies
  3. run `docker-compose up`
 
Your application should be up and running you can test api with links that appear in your terminal after running step 3.
