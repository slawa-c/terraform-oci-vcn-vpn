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
<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.6.1 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.1.0 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | >= 4.57.0 |

## Usage

Basic usage of this module is as follows:

```hcl

module "example" {
	 source  = "<module-path>"

	 # Required variables
	 compartment_ocid  = 
	 fingerprint  = 
	 private_key_path  = 
	 region  = 
	 source_ocid  = 
	 tenancy_ocid  = 
	 user_ocid  = 

	 # Optional variables
	 block_storage_sizes_in_gbs  = [
  50
]
	 boot_volume_backup_policy  = "disabled"
	 create_drg  = false
	 create_internet_gateway  = false
	 create_nat_gateway  = false
	 create_service_gateway  = false
	 defined_tags  = null
	 drg_display_name  = "drg"
	 enable_ipv6  = true
	 freeform_tags  = {
  "module": "oracle-terraform-modules/vcn/oci",
  "terraformed": "please do not edit manually"
}
	 instance_ad_number  = 1
	 instance_count  = 1
	 instance_display_name  = "module_instance_flex"
	 instance_flex_memory_in_gbs  = null
	 instance_flex_ocpus  = null
	 instance_state  = "RUNNING"
	 internet_gateway_display_name  = "igw"
	 internet_gateway_route_rules  = null
	 label_prefix  = "terraform-oci"
	 lockdown_default_seclist  = true
	 namespace  = "frl3g9kf1jkd"
	 nat_gateway_display_name  = "natgw"
	 netnum  = "1"
	 newbits  = "8"
	 public_ip  = "NONE"
	 service_gateway_display_name  = "svcgw"
	 shape  = "VM.Standard.A1.Flex"
	 source_type  = "image"
	 ssh_public_keys  = null
	 tf_state_bucket  = "lzadm-terraform-states"
	 vcn_cidrs  = [
  "10.2.0.0/16"
]
	 vcn_dns_label  = "vcnmodule"
	 vcn_name  = "vcn-module"
}
```

## Resources

| Name | Type |
|------|------|
| [oci_core_ipv6.srv_ipv6](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_ipv6) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_block_storage_sizes_in_gbs"></a> [block\_storage\_sizes\_in\_gbs](#input\_block\_storage\_sizes\_in\_gbs) | Sizes of volumes to create and attach to each instance. | `list(string)` | <pre>[<br>  50<br>]</pre> | no |
| <a name="input_boot_volume_backup_policy"></a> [boot\_volume\_backup\_policy](#input\_boot\_volume\_backup\_policy) | Choose between default backup policies : gold, silver, bronze. Use disabled to affect no backup policy on the Boot Volume. | `string` | `"disabled"` | no |
| <a name="input_compartment_ocid"></a> [compartment\_ocid](#input\_compartment\_ocid) | compartment ocid where to create all resources | `string` | n/a | yes |
| <a name="input_create_drg"></a> [create\_drg](#input\_create\_drg) | whether to create Dynamic Routing Gateway. If set to true, creates a Dynamic Routing Gateway. | `bool` | `false` | no |
| <a name="input_create_internet_gateway"></a> [create\_internet\_gateway](#input\_create\_internet\_gateway) | whether to create the internet gateway | `bool` | `false` | no |
| <a name="input_create_nat_gateway"></a> [create\_nat\_gateway](#input\_create\_nat\_gateway) | whether to create a nat gateway in the vcn | `bool` | `false` | no |
| <a name="input_create_service_gateway"></a> [create\_service\_gateway](#input\_create\_service\_gateway) | whether to create a service gateway | `bool` | `false` | no |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | predefined and scoped to a namespace to tag the resources created using defined tags. | `map(string)` | `null` | no |
| <a name="input_drg_display_name"></a> [drg\_display\_name](#input\_drg\_display\_name) | (Updatable) Name of Dynamic Routing Gateway. Does not have to be unique. | `string` | `"drg"` | no |
| <a name="input_enable_ipv6"></a> [enable\_ipv6](#input\_enable\_ipv6) | Whether IPv6 is enabled for the VCN. If enabled, Oracle will assign the VCN a IPv6 /56 CIDR block. | `bool` | `true` | no |
| <a name="input_fingerprint"></a> [fingerprint](#input\_fingerprint) | fingerprint of oci api private key | `string` | n/a | yes |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | simple key-value pairs to tag the created resources using freeform OCI Free-form tags. | `map(any)` | <pre>{<br>  "module": "oracle-terraform-modules/vcn/oci",<br>  "terraformed": "please do not edit manually"<br>}</pre> | no |
| <a name="input_instance_ad_number"></a> [instance\_ad\_number](#input\_instance\_ad\_number) | The availability domain number of the instance. If none is provided, it will start with AD-1 and continue in round-robin. | `number` | `1` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of identical instances to launch from a single module. | `number` | `1` | no |
| <a name="input_instance_display_name"></a> [instance\_display\_name](#input\_instance\_display\_name) | (Updatable) A user-friendly name for the instance. Does not have to be unique, and it's changeable. | `string` | `"module_instance_flex"` | no |
| <a name="input_instance_flex_memory_in_gbs"></a> [instance\_flex\_memory\_in\_gbs](#input\_instance\_flex\_memory\_in\_gbs) | (Updatable) The total amount of memory available to the instance, in gigabytes. | `number` | `null` | no |
| <a name="input_instance_flex_ocpus"></a> [instance\_flex\_ocpus](#input\_instance\_flex\_ocpus) | (Updatable) The total number of OCPUs available to the instance. | `number` | `null` | no |
| <a name="input_instance_state"></a> [instance\_state](#input\_instance\_state) | (Updatable) The target state for the instance. Could be set to RUNNING or STOPPED. | `string` | `"RUNNING"` | no |
| <a name="input_internet_gateway_display_name"></a> [internet\_gateway\_display\_name](#input\_internet\_gateway\_display\_name) | (Updatable) Name of Internet Gateway. Does not have to be unique. | `string` | `"igw"` | no |
| <a name="input_internet_gateway_route_rules"></a> [internet\_gateway\_route\_rules](#input\_internet\_gateway\_route\_rules) | (Updatable) List of routing rules to add to Internet Gateway Route Table | `list(map(string))` | `null` | no |
| <a name="input_label_prefix"></a> [label\_prefix](#input\_label\_prefix) | a string that will be prepended to all resources | `string` | `"terraform-oci"` | no |
| <a name="input_lockdown_default_seclist"></a> [lockdown\_default\_seclist](#input\_lockdown\_default\_seclist) | whether to remove all default security rules from the VCN Default Security List | `bool` | `true` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | namespace name for S3 buckets | `string` | `"frl3g9kf1jkd"` | no |
| <a name="input_nat_gateway_display_name"></a> [nat\_gateway\_display\_name](#input\_nat\_gateway\_display\_name) | (Updatable) Name of NAT Gateway. Does not have to be unique. | `string` | `"natgw"` | no |
| <a name="input_netnum"></a> [netnum](#input\_netnum) | zero-based index of the subnet when the network is masked with the newbit. use as netnum parameter for cidrsubnet function | `string` | `"1"` | no |
| <a name="input_newbits"></a> [newbits](#input\_newbits) | new mask for the subnet within the virtual network. use as newbits parameter for cidrsubnet function | `string` | `"8"` | no |
| <a name="input_private_key_path"></a> [private\_key\_path](#input\_private\_key\_path) | path to oci api private key used | `string` | n/a | yes |
| <a name="input_public_ip"></a> [public\_ip](#input\_public\_ip) | Whether to create a Public IP to attach to primary vnic and which lifetime. Valid values are NONE, RESERVED or EPHEMERAL. | `string` | `"NONE"` | no |
| <a name="input_region"></a> [region](#input\_region) | the oci region where resources will be created | `string` | n/a | yes |
| <a name="input_service_gateway_display_name"></a> [service\_gateway\_display\_name](#input\_service\_gateway\_display\_name) | (Updatable) Name of Service Gateway. Does not have to be unique. | `string` | `"svcgw"` | no |
| <a name="input_shape"></a> [shape](#input\_shape) | The shape of an instance. | `string` | `"VM.Standard.A1.Flex"` | no |
| <a name="input_source_ocid"></a> [source\_ocid](#input\_source\_ocid) | The OCID of an image or a boot volume to use, depending on the value of source\_type. | `string` | n/a | yes |
| <a name="input_source_type"></a> [source\_type](#input\_source\_type) | The source type for the instance. | `string` | `"image"` | no |
| <a name="input_ssh_public_keys"></a> [ssh\_public\_keys](#input\_ssh\_public\_keys) | Public SSH keys to be included in the ~/.ssh/authorized\_keys file for the default user on the instance. To provide multiple keys, see docs/instance\_ssh\_keys.adoc. | `string` | `null` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | tenancy ocid where to create the sources | `string` | n/a | yes |
| <a name="input_tf_state_bucket"></a> [tf\_state\_bucket](#input\_tf\_state\_bucket) | name of existing OCI s3 bucket for terraform state | `string` | `"lzadm-terraform-states"` | no |
| <a name="input_user_ocid"></a> [user\_ocid](#input\_user\_ocid) | ocid of user that terraform will use to create the resources | `string` | n/a | yes |
| <a name="input_vcn_cidrs"></a> [vcn\_cidrs](#input\_vcn\_cidrs) | The list of IPv4 CIDR blocks the VCN will use. | `list(string)` | <pre>[<br>  "10.2.0.0/16"<br>]</pre> | no |
| <a name="input_vcn_dns_label"></a> [vcn\_dns\_label](#input\_vcn\_dns\_label) | A DNS label for the VCN, used in conjunction with the VNIC's hostname and subnet's DNS label to form a fully qualified domain name (FQDN) for each VNIC within this subnet | `string` | `"vcnmodule"` | no |
| <a name="input_vcn_name"></a> [vcn\_name](#input\_vcn\_name) | user-friendly name of to use for the vcn to be appended to the label\_prefix | `string` | `"vcn-module"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_module_compute"></a> [module\_compute](#output\_module\_compute) | n/a |
| <a name="output_module_subnets"></a> [module\_subnets](#output\_module\_subnets) | n/a |
| <a name="output_module_vcn"></a> [module\_vcn](#output\_module\_vcn) | vcn and gateways information |
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->