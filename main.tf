// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 4
}

resource "google_compute_disk" "disk" {
  name = "disk"
  type = "pd-standard"
  zone = var.region
  size = var.disk_size
  image = "ubuntu-os-cloud/ubuntu-2004-lts"
}

resource "google_compute_instance" "default" {
 name         = "hashcat-${random_id.instance_id.hex}"
 machine_type = "n1-standard-2"
 zone         = var.region

 boot_disk {
  source = google_compute_disk.disk.self_link 
  }

 metadata_startup_script = <<SCRIPT
sudo apt-get update
sudo apt-get install -yq software-properties-common htop p7zip-full
curl -O https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub
sudo add-apt-repository "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
sudo apt-get install -yq cuda
sudo wget https://hashcat.net/files/hashcat-6.1.1.7z -O /opt/hashcat.7z
sudo 7z x /opt/hashcat.7z
sudo git clone --depth 1 https://github.com/danielmiessler/SecLists.git /opt/SecLists
sudo touch /opt/finish_installation
SCRIPT

 metadata = {
   ssh-keys = "${var.username}:${tls_private_key.ssh_key.public_key_openssh}"
 }
 scheduling {
     automatic_restart   = true
     on_host_maintenance = "TERMINATE"
   }
guest_accelerator {
  type = var.gpu_type
  count = var.gpu_count
  }
 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
    }
  }
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

/*
// Removed due to existence of default configuration
resource "google_compute_firewall" "default" {
 name    = "hashcat-firewall"
 network = "hashcat-network"

 allow {
   protocol = "tcp"
   ports    = ["22"]
 }
}
*/