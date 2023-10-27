#!/bin/bash

# Lista de regiões
regions=(
  australia-southeast1
  southamerica-east1
  northamerica-northeast1
  europe-west6
  europe-north1
  asia-east2
  me-west1
  asia-south1
  asia-northeast1
  asia-northeast3
  europe-central2
  me-central1
  europe-west2
  asia-east1
  southamerica-west1
  us-east1
  us-west2
)

# Diretório de destino onde os buckets serão baixados
destination_dir="./"

# Loop pelas regiões e faz o download dos buckets
for region in "${regions[@]}"
do
  bucket_name="purplerelay-${region}-bucket-dev"
  gsutil -m cp -R "gs://${bucket_name}" "$destination_dir"
done
