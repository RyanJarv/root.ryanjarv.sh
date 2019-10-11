#
# Dockerfile generated from https://github.com/cloudposse/reference-architectures
#
FROM ryanjarv/terraform-root-modules:latest as terraform-root-modules

FROM cloudposse/geodesic:0.115.0

# Terraform version changes should be carefully managed, but Geodesic updates them frequently,
# so Terraform version should be pinned here and updated thoughfully.
# Install terraform 0.11 for backwards compatibility
RUN apk add terraform_0.11@cloudposse

# Install terraform 0.12
RUN apk add terraform_0.12@cloudposse terraform@cloudposse==0.12.3-r0

# Terraform version changes should be carefully managed, but Geodesic updates them frequently,
# so Terraform version should be pinned here and updated thoughfully.
# Install terraform 0.11 for backwards compatibility
RUN apk add terraform_0.11@cloudposse terraform@cloudposse==0.11.14-r0


ENV DOCKER_IMAGE="ryanjarv/root.ryanjarv.sh"
ENV DOCKER_TAG="latest"

# General
ENV NAMESPACE="rjsh"
ENV STAGE="root"

# Geodesic banner
ENV BANNER="root.ryanjarv.sh"

# Message of the Day
ENV MOTD_URL="https://geodesic.sh/motd"

# AWS Region
ENV AWS_REGION="us-west-2"
ENV AWS_DEFAULT_REGION="${AWS_REGION}"
ENV AWS_ACCOUNT_ID="353973584341"
ENV AWS_ROOT_ACCOUNT_ID="353973584341"

# Network CIDR Ranges
ENV ORG_NETWORK_CIDR="10.0.0.0/8"
ENV ACCOUNT_NETWORK_CIDR="10.100.0.0/16"

# Terraform state bucket and DynamoDB table for state locking
ENV TF_BUCKET_PREFIX_FORMAT="basename-pwd"
ENV TF_BUCKET_ENCRYPT="true"
ENV TF_BUCKET_REGION="${AWS_REGION}"
ENV TF_BUCKET="${NAMESPACE}-${STAGE}-terraform-state"
ENV TF_DYNAMODB_TABLE="${NAMESPACE}-${STAGE}-terraform-state-lock"

# Default AWS Profile name
ENV AWS_DEFAULT_PROFILE="${NAMESPACE}-${STAGE}-admin"

# chamber KMS config
ENV CHAMBER_KMS_KEY_ALIAS="alias/${NAMESPACE}-${STAGE}-chamber"

# Place configuration in 'conf/' directory
COPY conf/ /conf/

# Filesystem entry for tfstate
RUN s3 fstab '${TF_BUCKET}' '/' '/secrets/tf'

WORKDIR /conf/
