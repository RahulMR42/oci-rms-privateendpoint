
// Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "private_endpoint" {
  description = "The returned resource attributes for the private endpoint."
  value       = oci_resourcemanager_private_endpoint.this
}


