## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_identity_group" "rms_pe_group" {
     provider       = oci.home_region
    compartment_id = var.tenancy_ocid
    description = "Group for orm PE execution"
    name           = "ormpe_group_${random_string.randomstring.result}"
    defined_tags                   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }

}

resource "oci_identity_user_group_membership" "rms_pe_group_member" {
  depends_on = [oci_identity_group.rms_pe_group]
  provider   = oci.home_region
  group_id   = oci_identity_group.rms_pe_group.id
  user_id    = var.user_ocid
  defined_tags                   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}


resource "oci_identity_policy" "ormpolicy" {
  provider       = oci.home_region
  name           = "ormpolicies-${random_string.randomstring.result}"
  description    = "policy created for oci orm "
  compartment_id = var.compartment_ocid
  defined_tags                   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
  statements = [
    "Allow group Administrators to manage orm-private-endpoints in compartment id ${var.compartment_ocid}",
    "Allow group Administrators to use virtual-network-family in compartment id ${var.compartment_ocid}",
    "Allow group ${oci_identity_group.rms_pe_group.name} to manage orm-private-endpoints in compartment id ${var.compartment_ocid}",
    "Allow group ${oci_identity_group.rms_pe_group.name} to use virtual-network-family in compartment id ${var.compartment_ocid}",


  ]
}