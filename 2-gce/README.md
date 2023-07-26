# IaC to Setup GCE

## Feature List
- [X] Nomenclature
- [X] Project setup
- [X] Network: Create VPC and Subnet(s)
- [X] Network: Firewall rules
- [ ] Network: VPN to on-prem, and routing
- [ ] IAM 

## Prerequisites
* Follow [Bootstrap Guide](../0-bootstrap/README.md) to finish/update the bootstrap
* The VPC and subnets have been created at `1-network`

## Implementation Steps

### Create below symbolic links on each folder to use them
```
cd $PROJECT_UPPER_FOLDER/2-hub
rm generic.auto.tfvars confidential.auto.tfvars confidential-variables.tf generic-variables.tf versions.tf
ln -s ../generic-variables.tf generic-variables.tf
ln -s ../generic.auto.tfvars generic.auto.tfvars
ln -s ../generic-versions.tf versions.tf
```

### Auth Terraform to manage GCP resources

Recommend using a dedicated a service account for Terraform, so you'll expect same behavior when other members in your team doing this same way.

You may auth via your own user account to troubleshoot the permissions of the service account.
```
export GOOGLE_APPLICATION_CREDENTIALS= && gcloud auth application-default login --disable-quota-project
```

### Run Terraform
```
terraform init
terraform plan
```

## Test the application

* Access the nginx via ssh tunnel
How to setup ssh tunnel via gcloud ssh command? I have provisioned a gce with a nginx, and opened firewall rules for port 80 and 443, and I want to access at my local laptop via localhost:8080
```
gcloud compute ssh --project=jmy-png-sbx-2023 --zone=us-central1-a hub-global-jump-linux-01 -- -L 8080:localhost:80
```

Refer to: https://cloud.google.com/community/tutorials/ssh-port-forwarding-set-up-load-testing-on-compute-engine
```
To set up server side SSH port forwarding as shown in the examples above, execute the following command on your client machine (-L indicates local and -R indicates remote).

ssh -L A:127.0.0.1:B [USERNAME]@[SERVER]

Similarly, the following command sets up the client side port forwarding.

ssh -R B:127.0.0.1:A [USERNAME]@[SERVER]
```

## Tips

### Use Remote State as data source
1. Generate data source file like `data-bootstrap.tf` at folder `remote-state`
1. Create symbolic link at your project folder where needs the data source
  ```
  rm data-bootstrap.tf data-org.tf
  ln -s ../remote-state/data-bootstrap.tf data-bootstrap.tf
  ln -s ../remote-state/data-org.tf data-org.tf
  ...
  ```
1. Use the data source at your code block like below
  ```
  org_id = data.terraform_remote_state.bootstrap.outputs.org_id
  ```

## Troubleshooting

* Increase your project quota
```
│ Error: Error waiting for creating folder: Error code 8, message: The project cannot be created because you have exceeded your allotted project quota.
│ 
│   with module.my_projects["prj-proj12a"].google_project.main,
│   on ../modules/projects/main.tf line 26, in resource "google_project" "main":
│   26: resource "google_project" "main" {
```