# IaC Terraform for GKE

Terraform to provision new resources for demo

This Code helps users deploy a GCE VM. Detailed steps are:

    0. Create GCS bucket for state files
    1. Provision vpc network and subnets
    2. Provision gce on subnet-01


## Usage:

Please follow the below steps to run this code:

* Leverage the generic tfvars and variable for each sub folder, eg:
    ```
    cd network
    ln -s ../generic.auto.tfvars generic.auto.tfvars
    ln -s ../generic-variables.tf generic-variables.tf
    ```

* Open the terraform.tfvars file and update the values of each variable as per need.

* Auth terraform with the service account with right permission to provision all needed resources, or use your own account via command `gcloud auth application-default login`

* Update tfvars and 
* Run the below set of command in the same sequence in each sub folder in order:
    ```
    cd 2-gce
    terraform init                         # initialize directory, pull down providers
    terraform plan                         # output the deployment plan
    
    terraform apply \
    -var google_project_id=<YOUR_PROJECT> \    
    ```
* Access to the gce
  Get the ssh command from Terraform output
    ```
    gcloud compute ssh --project=corp-dev-111 --zone=europe-west2-a corp-dev-test-vm
    ```

## Troubleshooting


## References

* For all the terraform Command: [https://www.terraform.io/cli/commands]
