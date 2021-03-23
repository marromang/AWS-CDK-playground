#!/bin/bash

# Maria Romero Angulo
# Tue Mar 23 12:37:30 CET 2021
# Script to deploy via aws cli some AWS services: S3, EFS, CodeBuild, CodePipeline, Elastic Beanstalk, CloudFront

# CLI parameters
REPO_NAME=$1
SERVICE=$2
PARAMETERS_FILE=$3
# system parameters
TEMPLATE_PATH="xxx"
PARAMETERS_PATH="xxx"

# command line parameters check
if [[ -z "$REPO_NAME" || -z "$SERVICE" || -z "$PARAMETERS_FILE" ]]; then
    echo "Invalid parameters."
    echo "Usage: bash deployments.sh repo_name service parameters_file"
# path completion for each service
else
    if [ $SERVICE == "S3" ]; then
        TEMPLATE_FILE=$TEMPLATE_PATH/20-create-S3.yaml
        PARAMS_FILE=$PARAMETERS_PATH/s3/$PARAMETERS_FILE
    elif [ $SERVICE == "EFS" ]; then
        TEMPLATE_FILE=$TEMPLATE_PATH/30-create-EFS.yaml
        PARAMS_FILE=$PARAMETERS_PATH/efs/$PARAMETERS_FILE
    elif [ $SERVICE == "CB" ]; then
        TEMPLATE_FILE=$TEMPLATE_PATH/35-CodeBuild.yaml
        PARAMS_FILE=$PARAMETERS_PATH/codebuild/$PARAMETERS_FILE
    elif [ $SERVICE == "EB" ]; then
        TEMPLATE_FILE=$TEMPLATE_PATH/40-ElasticBeanstalk.yaml
        PARAMS_FILE=$PARAMETERS_PATH/beanstalk/$PARAMETERS_FILE
    elif [ $SERVICE == "CP" ]; then
        TEMPLATE_FILE=$TEMPLATE_PATH/45-CodePipeline.yaml
        PARAMS_FILE=$PARAMETERS_PATH/codepipeline/$PARAMETERS_FILE
    elif [ $SERVICE == "CFR" ]; then
        TEMPLATE_FILE=$TEMPLATE_PATH/50-CloudFront.yaml
        PARAMS_FILE=$PARAMETERS_PATH/cloudfront/$PARAMETERS_FILE
    fi
    # deployment execution
    aws cloudformation create-stack  --stack-name pro-$REPO_NAME-$SERVICE-cf --template-body file://$TEMPLATE_PATH --parameters file://$PARAMETERS_PATH --profile sd  --capabilities CAPABILITY_NAMED_IAM
fi
