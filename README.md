Use Private Endpoints to access a private resource from Oracle Resource manager
----

### Sample terraform.tfvars 

- Create a file `terraform.tfvars` and add below entries with valid values.

```markdown
# Authentication
tenancy_ocid         = "ocid1.tenancy.xxx"
user_ocid            = "ocid1.user.ocxxx"
fingerprint          = "xxxx"
private_key_path     = "xxx"

# Region
region = "OCI Region"

# Compartment
compartment_ocid = "ocid1.compartment.ocxxx"
```

- Apply the stack.

```markdown
$terraform plan
$terraform apply
```