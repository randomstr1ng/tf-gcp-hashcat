variable "project_name" {}
variable "region" {}
variable "username" {
    default = "hashcat"
}
variable "disk_size" {
    default = "30"
}
variable "gpu_type" {
    default = "nvidia-tesla-p100"
}
variable "gpu_count" {
    default = "1"
}