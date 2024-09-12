#!/bin/bash

APP_ENV='/usr/local/etc/app.env'
SECRETS_ID_DB='app-db-xxxx'

# get META DATA use IMDSv2
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
CURRENT_REGION=$(TOKEN=`curl -X PUT -Ss 'http://169.254.169.254/latest/api/token' -H 'X-aws-ec2-metadata-token-ttl-seconds: 21600'` && curl -H "X-aws-ec2-metadata-token: $TOKEN" -Ss 'http://169.254.169.254/latest/meta-data/placement/availability-zone' | sed -e s/.$//)

# set secrets ARN format for DB
SECRETS_ARN_DB="arn:aws:secretsmanager:${CURRENT_REGION}:${AWS_ACCOUNT_ID}:secret:${SECRETS_ID_DB}"

# secrets managerの値でDB_*の変数を置き換える
SECRETS_STR_DB=$(aws secretsmanager get-secret-value --secret-id $SECRETS_ARN_DB --query 'SecretString' --output text)
DB_USER=$(echo $SECRETS_STR_DB | jq -r '.username')
DB_PASS=$(echo $SECRETS_STR_DB | jq -r '.password')
if [ -z "$DB_USER" ]; then
    echo Failed to set DB_USER 1>&2
    exit 1
fi
if [ -z "$DB_PASS" ]; then
    echo Failed to set DB_PASS 1>&2
    exit 1
fi
sed -ri "s/^DB_USER=.*/DB_USER=$DB_USER/" ${APP_ENV}
sed -ri "s/^DB_PASS=.*/DB_PASS=$DB_PASS/" ${APP_ENV}