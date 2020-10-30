resource "local_file" "ssh_key" {
    content = tls_private_key.ssh_key.private_key_pem
    filename = "${path.module}/ssh_key.pem"
    file_permission = "0600"
}

output "public_ip" {
    value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}

output "username" {
    value = var.username
}