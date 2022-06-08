
// Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "compartment_ocid" {}
variable "tenancy_ocid" {}
variable "region" {}

variable "vcn_display_name" {
  default = "testVCN"
}

variable "vcn_cidr" {
  description = "VCN's CIDR IP Block"
  default     = "10.0.0.0/16"
}

variable "subnet_display_name" {
  default = "testPrivateSubnet"
}

variable "instance_display_name" {
  default = "testCreatePrivateEndpointInstance"
}

variable "private_endpoint_display_name" {
  default = "testResourceManagerPrivateEndpoint"
}

variable "availability_domain_name" {
  default = null
}

## Instance

variable "instance_shape" {
  default = "VM.Standard.E3.Flex"
}

variable "instance_ocpus" {
  default = 1
}

variable "instance_shape_config_memory_in_gbs" {
  default = 16
}

variable "instance_os" {
  description = "Operating system."
  default     = "Oracle Linux"
}

provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  region       = var.region
}
  