if [ -z "$S3_BUCKET" ]; then
  echo "You need to set the S3_BUCKET environment variable."
  exit 1
fi

if [ -z "$POSTGRES_DATABASE" ]; then
  echo "You need to set the POSTGRES_DATABASE environment variable."
  exit 1
fi

if [ -z "$POSTGRES_HOST" ]; then
  # https://docs.docker.com/network/links/#environment-variables
  if [ -n "$POSTGRES_PORT_5432_TCP_ADDR" ]; then
    POSTGRES_HOST=$POSTGRES_PORT_5432_TCP_ADDR
    POSTGRES_PORT=$POSTGRES_PORT_5432_TCP_PORT
  else
    echo "You need to set the POSTGRES_HOST environment variable."
    exit 1
  fi
fi

if [ -z "$POSTGRES_USER" ]; then
  echo "You need to set the POSTGRES_USER environment variable."
  exit 1
fi

if [ -z "$POSTGRES_PASSWORD" ]; then
  echo "You need to set the POSTGRES_PASSWORD environment variable."
  exit 1
fi

aws_args=" "

if [ -n "$S3_ENDPOINT" ]; then
  aws_args="$aws_args --host $S3_ENDPOINT"
fi
if [ -n "$S3_ACCESS_KEY_ID" ]; then
  aws_args="$aws_args --access_key=$S3_ACCESS_KEY_ID"
fi
if [ -n "$S3_SECRET_ACCESS_KEY" ]; then
  aws_args="$aws_args --secret_key=$S3_SECRET_ACCESS_KEY"
fi
if [ -n "$S3_REGION" ]; then
  aws_args="$aws_args --region=$S3_REGION"
fi

aws_args="$aws_args --host-bucket=\"%(bucket).$S3_ENDPOINT\""

export AWS_DEFAULT_REGION=$S3_REGION
export PGPASSWORD=$POSTGRES_PASSWORD
