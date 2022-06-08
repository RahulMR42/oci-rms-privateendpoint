
// Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

terraform {
  required_version = ">= 0.12.0"
}

// VCN holding the private subnet
resource "oci_core_vcn" "this" {
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_ocid
  display_name   = var.vcn_display_name
}

// Private subnet the compute instance will reside in
resource "oci_core_subnet" "this" {
  compartment_id             = var.compartment_ocid
  display_name               = var.subnet_display_name
  vcn_id                     = oci_core_vcn.this.id
  prohibit_public_ip_on_vnic = true
  cidr_block                 = cidrsubnet(var.vcn_cidr, 8, 1)
  security_list_ids          = [oci_core_security_list.this.id]
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
    subnet_id        = oci_core_subnet.this.id
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

// The RMS private endpoint resource. Requires a VCN with a private subnet
resource "oci_resourcemanager_private_endpoint" "this" {
  compartment_id = var.compartment_ocid
  display_name   = var.private_endpoint_display_name
  description    = "Private Endpoint to remote-exec in Private Instance"
  vcn_id         = oci_core_vcn.this.id
  subnet_id      = oci_core_subnet.this.id
}

resource "oci_core_security_list" "this" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "Allow SSH Communication Security List"
  // Lock down ingress and egress traffic to the VCN cidr block. Can be restricted further to be subnet cidr range
  // Only allow SSH communication on specific port
  ingress_security_rules {
    tcp_options {
      min = 22
      max = 22
    }

    protocol = 6
    source   = var.vcn_cidr
  }
  egress_security_rules {
    tcp_options {
      min = 22
      max = 22
    }

    protocol    = 6
    destination = var.vcn_cidr
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