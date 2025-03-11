#!/bin/bash
set -e

# set GCP project ID
PROJECT_ID='rshiny-project'

# set GCP project region
REGION='us-central1'

# set GCP artifact registry repository name
REPO_NAME='rshiny-repo'

# set container image name
IMAGE_NAME='rshiny-image'

# set container image tag
IMAGE_TAG='v0.1'

# create image
docker build --platform=linux/amd64 --tag "${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/${IMAGE_NAME}:${IMAGE_TAG}" .

# test run locally
# docker run --platform=linux/amd64 -d -p 8080:8080 "${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/${IMAGE_NAME}:${IMAGE_TAG}"

# create GCP artifact registry repository
gcloud beta artifacts repositories create ${REPO_NAME} --repository-format=docker --location=${REGION}

# add permission in order to push the image
gcloud auth configure-docker "${REGION}-docker.pkg.dev"

# push the image to the created repo
docker push "${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/${IMAGE_NAME}:${IMAGE_TAG}"
