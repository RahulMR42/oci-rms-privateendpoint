
// Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_core_images" "this" {
  compartment_id   = var.compartment_ocid
  operating_system = var.instance_os
  shape            = var.instance_shape
}

// Resolves the private IP of the customer's private endpoint to a NAT IP. Used as the host address in the "remote-exec" resource
data "oci_resourcemanager_private_endpoint_reachable_ip" "this" {
  private_endpoint_id = oci_resourcemanager_private_endpoint.this.id
  private_ip          = oci_core_instance.privateinstance.private_ip
}