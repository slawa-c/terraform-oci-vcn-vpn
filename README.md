# Example reusing vpn-wg-oci and extending to create other network resources

[rootvariables]:https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/examples/module_composition/variables.tf
[sampletfvars]:https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/examples/module_composition/terraform.tfvars.example
[terraformoptions]:https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/docs/terraformoptions.adoc
[terraform-oci-vcn]:https://registry.terraform.io/modules/oracle-terraform-modules/vcn/oci/latest
[customer-secret-key]:https://docs.oracle.com/en-us/iaas/Content/Identity/Tasks/managingcredentials.htm#To4

__Note: This is an example to demonstrate reusing this Terraform module to create additional network resources. Ensure you evaluate your own security needs when creating security lists, network security groups etc.__

## Requirements

Add to your OCI login [customer-secret-key] (previosly "S3 Access key") to maintain Terraform state of your project at OCI bucket in "S3 compatible mode"

## Create a new Terraform project

As an example, we’ll be using [terraform-oci-vcn] to create
additional network resources in the VCN. The steps required are the following:

1. Create a new directory for your project e.g. mynetwork

2. Create the following files in root directory of your project:

- `variables.tf`
- `locals.tf`
- `provider.tf`
- `main.tf`
- `terraform.tfvars`

3. Define the oci provider

```HCL
provider "oci" {
  tenancy_ocid         = var.tenancy_ocid
  user_ocid            = var.user_ocid
  fingerprint          = var.fingerprint
  private_key_path     = var.private_key_path
  region               = var.region
  disable_auto_retries = false
}
```

## Define project variables

## Define Terraform remote state

Write down to shared credentials api access key file like that: `~/.oci/api_keys/tf_shared_credentials` outside the folder of current project, we use that file when define access to terraform remote state at S3 bucket

```HCL
[default]
region=eu-marseille-1
aws_access_key_id=4546546...333
aws_secret_access_key=Afcvf...ggg=
```

At `main.tf` add next terraform backend definition:

```HCL
terraform {
  backend "s3" {
    bucket                      = "terraform-states"
    key                         = "networking/terraform.tfstate"
    region                      = "eu-marseille-1"
    endpoint                    = "https://<namespaces>.compat.objectstorage.<region>.oraclecloud.com"
    shared_credentials_file     = "~/.oci/api_keys/tf_shared_credentials"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}
```

### Variables to reuse the vcn module

1. Define the vcn parameters in the root `variables.tf`.
See an example for [`variables.tf`][rootvariables].

2. Add additional variables if you need to.

## Define your modules

1. Define the vcn module in root `main.tf`

```HCL
module "vcn" {
  source  = "oracle-terraform-modules/vcn/oci"

  # general oci parameters
  compartment_id = var.compartment_ocid
  label_prefix   = var.label_prefix

  # vcn parameters
  create_internet_gateway = var.create_internet_gateway
  create_nat_gateway      = var.create_nat_gateway
  create_service_gateway  = var.create_service_gateway
  create_drg               = var.create_drg
  drg_display_name         = var.drg_display_name
  tags                     = var.freeform_tags
  vcn_cidrs                = var.vcn_cidrs
  vcn_dns_label            = var.vcn_dns_label
  vcn_name                 = var.vcn_name
  lockdown_default_seclist = var.lockdown_default_seclist
}
```

2. Enter appropriate values for `terraform.tfvars`. Review [Terraform Options][terraformoptions] for reference.
You can also use this example [terraform.tfvars][sampletfvars]. Just remove the `.example` extension.

## Add your own modules

1. Create your own module e.g. subnets. In modules directory, create a subnets directory:

```shell
mkdir subnets
```

2. Define the additional variables(e.g. subnet masks) in the root and module variable file (`variables.tf`) e.g.

```HCL
variable "netnum" {
  description = "zero-based index of the subnet when the network is masked with the newbit. use as netnum parameter for cidrsubnet function"
  default = "1"
  type = string
}

variable "newbits" {
  description = "new mask for the subnet within the virtual network. use as newbits parameter for cidrsubnet function"
  default = "8"
  type = string
}
```

3. Create the security lists and subnets in `security.tf` and `subnets.tf` respectively in the subnets module:

```HCL
resource "oci_core_security_list" "vcn_seclist" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.label_prefix}-${var.vcn_seclist_name}"

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  egress_security_rules {
    protocol    = "all"
    destination = "::/0"
  }

  ingress_security_rules {
    # allow ssh
    protocol = 6
    source   = "0.0.0.0/0"

    tcp_options {
      min = 22
      max = 22
    }
  }
  ingress_security_rules {
    description = "allow ICMP echo"
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol    = "1"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
  }
  ingress_security_rules {
    description = "allow ipv6 ssh"
    protocol    = "6"
    source      = "::/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "22"
      min = "22"
    }
  }
  ingress_security_rules {
    icmp_options {
      code = "0"
      type = "2"
    }
    protocol    = "58"
    source      = "::/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
  }
  vcn_id = var.vcn_id
}


resource "oci_core_subnet" "vcn_subnet" {
  cidr_block                 = cidrsubnet(var.vcn_cidr, var.newbits, var.netnum)
  ipv6cidr_block             = cidrsubnet(var.vcn_ipv6cidr, var.newbits, var.netnum)
  compartment_id             = var.compartment_ocid
  display_name               = "${var.label_prefix}-${var.vcn_subnet_name}"
  dns_label                  = var.vcn_subnet_name
  prohibit_public_ip_on_vnic = false
  route_table_id             = var.ig_route_id
  security_list_ids          = [oci_core_security_list.vcn_seclist.id]
  vcn_id                     = var.vcn_id
}
```

4. Add the subnets module in the `main.tf`

```HCL
module "subnets" {
  source           = "./modules/subnets"
  compartment_ocid = var.compartment_ocid
  label_prefix     = var.label_prefix
  vcn_seclist_name = "sl-public-1"
  vcn_subnet_name  = "public1"
  netnum           = var.netnum
  newbits          = var.newbits
  vcn_id           = module.vcn.vcn_id
  ig_route_id      = module.vcn.ig_route_id
  vcn_cidr         = var.vcn_cidrs[0]
  vcn_ipv6cidr     = join(",", module.vcn.vcn_all_attributes[*].ipv6cidr_blocks[0])

}
```

5. Update your terraform variable file and add the database parameters:

```HCL
# subnets

netnum = "1"

newbits = "8"
```