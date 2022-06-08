
// Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.compartment_ocid
}

data "oci_core_images" "this" {
  compartment_id   = var.compartment_ocid
  operating_system = var.instance_os
  shape            = var.instance_shape
}

// for now, assume we just have a single subnet in the given compartment associated with the VCN
data "oci_core_subnet" "this" {
  subnet_id = var.subnet_ocid
}

// Use a data source to get a pre-existing private endpoint. This private endpoint could already be created via CLI, SDK, console, etc
// in your tenancy
data "oci_resourcemanager_private_endpoint" "this" {
  private_endpoint_id = var.private_endpoint_ocid
}

// Resolves the private IP of the customer's private endpoint to a NAT IP. Used as the host address in the "remote-exec" resource
data "oci_resourcemanager_private_endpoint_reachable_ip" "this" {
  private_endpoint_id = data.oci_resourcemanager_private_endpoint.this.private_endpoint_id
  private_ip          = oci_core_instance.this.private_ip
}