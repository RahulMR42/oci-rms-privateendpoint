// Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

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
