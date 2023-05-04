# IaC to Setup Hub under Org

## Feature List
- [X] Nomenclature
- [X] Project setup
- [X] Network: Create VPC and Subnet(s)
- [X] Network: Firewall rules
- [ ] Network: VPN to on-prem, and routing
- [ ] IAM 

## Refer to next model
* `3-env`: Create resources for different environments

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

### Run Terraform
```
terraform init
terraform plan
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