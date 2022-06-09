
// Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.


// The RMS private endpoint resource. Requires a VCN with a private subnet
resource "oci_resourcemanager_private_endpoint" "this" {
  compartment_id = var.compartment_ocid
  display_name   = var.private_endpoint_display_name
  description    = "Private Endpoint to remote-exec in Private Instance"
  vcn_id         = oci_core_vcn.this.id
  subnet_id      = oci_core_subnet.this.id
  defined_tags                   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}


// Resource to establish the SSH connection. Must have the compute instance created first.
resource "null_resource" "remote-exec" {
  depends_on = [oci_core_instance.privateinstance,oci_identity_policy.ormpolicy]
  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "8m"
      host        = data.oci_resourcemanager_private_endpoint_reachable_ip.this.ip_address
      user        = "opc"
      private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
    // write to a file on the compute instance via the private access SSH connection
    inline = [
      "hostname",
      "echo 'remote exec showcase ' > ~/remoteExecTest.txt",
      "echo '-------------Reading from file remoteExecTest.txt ----------------- '",
      "cat ~/remoteExecTest.txt",
      "echo '-------------Reading from file remoteExecTest.txt ----------------- '"
    ]
  }
}

