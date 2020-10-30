provider "google" {
 credentials = file("CREDENTIALS_FILE.json")
 project     = var.project_name
 region      = var.region
}