# localstack
Localstack projects

## Pre-requisites
- Node js > v20
- docker

1. Express node 
    - Contains localstack docker-compose file
    - This file spins localstack with apigateway and lambda service
    - This is built for arm64 architecture
    - API gateway for proxying so that we can test it over http (something similar to what we do over actual aws)
