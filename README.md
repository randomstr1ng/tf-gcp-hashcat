# Hashcat within Google Cloud Platform

## Description
With this Terraform configration you can deploy a VM Instance at Google Cloud Compute Engine with an GPU attached.
In addition to the deployment of the VM the following configuration will be done:
- Installation of actual CUDA driver for the GPU (https://cloud.google.com/compute/docs/gpus/install-drivers-gpu?hl=en)
- Download hashcat into /opt/
- Download latest Seclists repository to /opt/Seclists

## Configuration
First of all, you have to generate a new Project and getting the project credentials. This guide (only the beginning) explain you how to do this:
https://cloud.google.com/community/tutorials/getting-started-on-gcp-with-terraform

- Create service account key: https://console.cloud.google.com/apis/credentials/serviceaccountkey?_ga=2.57572078.537003747.1604065341-1602596991.1602069963


To get startetd you have to configure the variables and put them into the File `variables.tfvars`
(you can copy the file variables.example-tfvars):
```terraform
// GCP project ID
project_name = "little-monster-292215"

// GCP Region & Zone
region = "europe-west1-b"

// Linux Username
username = "hashcat"

// OS Disk size (in GB)
disk_size = "30"

// Type and count of GPU
gpu_type = "nvidia-tesla-p100"
gpu_count = "1"
```


Usefull Links:
- GPU Types avaible in GCP: https://cloud.google.com/compute/docs/gpus?hl=en
- Find the right region in GCP: https://cloud.google.com/compute/docs/regions-zones?hl=en
- Example terraform config for GCP: https://cloud.google.com/community/tutorials/getting-started-on-gcp-with-terraform

## Deployment & Cleanup

- Deploy Server
```bash
terraform init
terraform apply -var-file variables.tfvars -auto-approve
```

- Delete Server
```bash
terraform destroy -var-file variables.tfvars -auto-approve
```