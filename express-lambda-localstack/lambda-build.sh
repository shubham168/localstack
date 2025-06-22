#!/bin/bash
rm -rf build
mkdir -p build
cd lambda
zip -r ../build/lambda.zip . > /dev/null
cd ..
