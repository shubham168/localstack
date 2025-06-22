#!/usr/bin/env bash
set -e  # exit on error

# Create Lambda function
awslocal lambda create-function \
  --function-name my-express-function \
  --runtime nodejs18.x \
  --architecture arm64 \
  --handler index.handler \
  --zip-file fileb:///lambda/lambda.zip \
  --role arn:aws:iam::000000000000:role/fake-role

# Create API Gateway
API_ID=$(awslocal apigateway create-rest-api --name "express-proxy-api" | grep '"id"' | cut -d'"' -f4)
PARENT_ID=$(awslocal apigateway get-resources --rest-api-id "$API_ID" | grep '"id"' | cut -d'"' -f4)

# Create {proxy+} resource for catch-all routing
RESOURCE_ID=$(awslocal apigateway create-resource \
  --rest-api-id "$API_ID" \
  --parent-id "$PARENT_ID" \
  --path-part "{proxy+}" | grep '"id"' | cut -d'"' -f4)

# Add ANY method to catch all HTTP methods
awslocal apigateway put-method \
  --rest-api-id "$API_ID" \
  --resource-id "$RESOURCE_ID" \
  --http-method ANY \
  --authorization-type "NONE"

# Connect to Lambda with proxy integration
awslocal apigateway put-integration \
  --rest-api-id "$API_ID" \
  --resource-id "$RESOURCE_ID" \
  --http-method ANY \
  --type AWS_PROXY \
  --integration-http-method POST \
  --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:000000000000:function:my-express-function/invocations

# Also handle root path
awslocal apigateway put-method \
  --rest-api-id "$API_ID" \
  --resource-id "$PARENT_ID" \
  --http-method ANY \
  --authorization-type "NONE"

# Connect to Lambda with proxy integration
awslocal apigateway put-integration \
  --rest-api-id "$API_ID" \
  --resource-id "$PARENT_ID" \
  --http-method ANY \
  --type AWS_PROXY \
  --integration-http-method POST \
  --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:000000000000:function:my-express-function/invocations

# Deploy API
awslocal apigateway create-deployment \
  --rest-api-id "$API_ID" \
  --stage-name dev

echo "Express Lambda with API Gateway Proxy is ready!"
echo "   - Root: http://localhost:4566/restapis/$API_ID/dev/_user_request_/"
echo "   - Hello: http://localhost:4566/restapis/$API_ID/dev/_user_request_/hello"
echo "   - Users: http://localhost:4566/restapis/$API_ID/dev/_user_request_/users"
echo "   - Any route: http://localhost:4566/restapis/$API_ID/dev/_user_request_/your-route"