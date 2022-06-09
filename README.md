Use Private Endpoints to access a private resource from Oracle Resource manager
----

### Procedure.

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

- Output 

- Delete the stack 

```markdown
terraform destroy
```

### Contributors

- Author : Rahul M R. 
- Collaborators : Vimal Meena
- Last release : June 2022