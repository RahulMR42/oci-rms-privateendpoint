

// Compute instance that our SSH connection will be established with.
resource "oci_core_instance" "privateinstance" {
  compartment_id      = var.compartment_ocid
  defined_tags                   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
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
