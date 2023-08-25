#!/bin/bash
gcloud config set account purplerelay-github
for region in $5
do
    gcloud run deploy $1-$region-app-$2 --project $1 --region $region --image us-east1-docker.pkg.dev/$1/$3/strfry:$4 --update-env-vars BUCKET=$1-$region-bucket-$2
done