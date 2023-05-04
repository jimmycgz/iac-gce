## Initial Setup

* Create project under a folder
* Config gcloud SDK 
* Create service account with permissions

### Create folder my own folder under a folder devx
```
export PARENT_FOLDER=618xxx
gcloud resource-manager folders describe $PARENT_FOLDER

export MY_FOLDER=devx-jmy-test
gcloud resource-manager folders create \
   --display-name=$MY_FOLDER \
   --folder=$PARENT_FOLDER
```

### Create new proj under my folder
```
gcloud config configurations list   
export PROJECT_ID=devx-jmy-demo
export PROJECT_ID=devx-jmy-common-service

export MY_FOLDER_ID=29xxx
gcloud projects create $PROJECT_ID \
   --folder=$MY_FOLDER_ID  

export BILLING_ACCT_ID=$(gcloud beta billing accounts list | grep 'devx_GCP_Internal - Do Not Bill' | awk '{print $1}')
gcloud beta billing projects link $PROJECT_ID --billing-account=$BILLING_ACCT_ID

gcloud projects describe $PROJECT_ID

gcloud config configurations create $PROJECT_ID
gcloud auth login
```
### Config Gcloud environment and spin up a test vm
```
gcloud config configurations list 
gcloud config configurations activate $PROJECT_ID
gcloud config set project $PROJECT_ID
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-a
```
