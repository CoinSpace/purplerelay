#!/bin/bash
cp -r ./application_default_credentials.json $HOME/.config/gcloud/application_default_credentials.json
gcloud config set account "215007526460-compute@developer.gserviceaccount.com"
gcloud auth activate-service-account "215007526460-compute@developer.gserviceaccount.com" --key-file="application_default_credentials.json"
for region in $5
do
    gcloud run deploy $1-$region-app-$2 --project $1 --region $region --image us-east1-docker.pkg.dev/$1/$3/strfry:$4 --update-env-vars BUCKET=$1-$region-bucket-$2
done