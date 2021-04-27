#!/bin/bash

# Maria Romero Angulo
# Tue Mar 23 12:37:30 CET 2021
# Script to deploy via aws cli some AWS services: S3, EFS, CodeBuild, CodePipeline, Elastic Beanstalk, CloudFront

# CLI parameters
ACTION=$1
SITE=$2
SERVICE=$3
ENV=$4

# system parameters
TEMPLATE_PATH=xyz
PARAMETERS_PATH=zyx<$ENV
REPO_NAME=$SITE-code 
PARAMETERS_FILE=$SITE.json
# command line parameters check

if [[ -z "$SITE" || -z "$SERVICE" || -z "$ACTION" || -z "$ENV" ]]; then
    echo "Invalid parameters."
    echo "Usage: bash deploy action site service environment"
# path completion for each service
else

    if [ $ACTION == "status" ]; then  
        aws cloudformation describe-stacks --stack-name $ENV-$REPO_NAME-$SERVICE-cf --query Stacks[*].StackStatus | cut -d " " -f2
    elif [ $ACTION == "delete" ]; then 
        aws cloudformation delete-stack --stack-name $ENV-$REPO_NAME-$SERVICE-cf
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
        elif [ $SERVICE == "TF" ]; then
            TEMPLATE_FILE=$TEMPLATE_PATH/80-User-TransferFamily.yaml
            PARAMS_FILE=$PARAMETERS_PATH/transfer/$PARAMETERS_FILE
        fi
        # deployment execution
        aws cloudformation $ACTION-stack  --stack-name $ENV-$REPO_NAME-$SERVICE-cf --template-body file://$TEMPLATE_FILE --parameters file://$PARAMS_FILE --profile sd  --capabilities CAPABILITY_NAMED_IAM
    fi
fi
