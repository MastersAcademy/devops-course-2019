#!/bin/bash

#echo "Access key ID:"
#read key_id

echo "Secret access key:"
read secret_key

export AWS_ACCESS_KEY_ID="AKIAW5SGOL54UQG3AD7J"
export AWS_SECRET_ACCESS_KEY=$secret_key
export AWS_DEFAULT_REGION="eu-west-1"

terraform init
terraform apply
