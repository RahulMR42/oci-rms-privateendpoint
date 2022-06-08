
// Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

terraform {
  required_version = ">= 0.12.0"
}

// The public/private key used to SSH to the compute instance
resource "tls_private_key" "public_private_key_pair" {
  algorithm = "RSA"
}

// Compute instance that our SSH connection will be established with. 
resource "oci_core_instance" "this" {
  compartment_id      = var.compartment_ocid
  display_name        = var.instance_display_name
  availability_domain = var.availability_domain_name != null ? var.availability_domain_name : data.oci_identity_availability_domains.ADs.availability_domains[0].name
  shape               = var.instance_shape
  // specify the subnet and that there is no public IP assigned to the instance
  create_vnic_details {
    subnet_id        = data.oci_core_subnet.this.id
    assign_public_ip = false
  }
  extended_metadata = {
    ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh
  }

  // use latest oracle linux image via data source
  source_details {
    source_id   = data.oci_core_images.this.images[0].id
    source_type = "image"
  }
  shape_config {
    memory_in_gbs = var.instance_shape_config_memory_in_gbs
    ocpus         = var.instance_ocpus
  }
}

// Resource to establish the SSH connection. Must have the compute instance created first.
resource "null_resource" "remote-exec" {
  depends_on = [oci_core_instance.this]
  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = data.oci_resourcemanager_private_endpoint_reachable_ip.this.ip_address
      user        = "opc"
      private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
    // write to a file on the compute instance via the private access SSH connection
    inline = [
      "echo 'remote exec showcase' > ~/remoteExecTest.txt"
    ]
  }
}