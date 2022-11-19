# TF code base

## Introduction

This module make several vpc resources on Oracle cloud

<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Requirements

No requirements.

## Usage

Basic usage of this module is as follows:

```hcl

module "example" {
	 source  = "<module-path>"

	 # Required variables
	 compartment_ocid  = 
	 ig_route_id  = 
	 vcn_cidr  = 
	 vcn_id  = 
	 vcn_ipv6cidr  = 

	 # Optional variables
	 freeform_tags  = {
  "module": "oracle-terraform-modules/vcn/oci",
  "terraformed": "please do not edit manually"
}
	 label_prefix  = "terraform-oci"
	 netnum  = "1"
	 newbits  = "8"
	 vcn_nsg_name  = "nsg"
	 vcn_seclist_name  = "seclist"
	 vcn_subnet_name  = "subnet"
}
```

## Resources

| Name | Type |
|------|------|
| [oci_core_network_security_group.vcn_nsg](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_network_security_group) | resource |
| [oci_core_network_security_group_security_rule.vcn_nsg_rule_01](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.vcn_nsg_rule_02](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.vcn_nsg_rule_03](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.vcn_nsg_rule_04](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.vcn_nsg_rule_05](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.vcn_nsg_rule_06](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.vcn_nsg_rule_07](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.vcn_nsg_rule_08](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.vcn_nsg_rule_09](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.vcn_nsg_rule_10](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.vcn_nsg_rule_11](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.vcn_nsg_rule_12](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_security_list.vcn_seclist](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_subnet.vcn_subnet](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_ocid"></a> [compartment\_ocid](#input\_compartment\_ocid) | compartment ocid where to create all resources | `string` | n/a | yes |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | simple key-value pairs to tag the created resources using freeform OCI Free-form tags. | `map(any)` | <pre>{<br>  "module": "oracle-terraform-modules/vcn/oci",<br>  "terraformed": "please do not edit manually"<br>}</pre> | no |
| <a name="input_ig_route_id"></a> [ig\_route\_id](#input\_ig\_route\_id) | n/a | `any` | n/a | yes |
| <a name="input_label_prefix"></a> [label\_prefix](#input\_label\_prefix) | a string that will be prepended to all resources | `string` | `"terraform-oci"` | no |
| <a name="input_netnum"></a> [netnum](#input\_netnum) | zero-based index of the subnet when the network is masked with the newbit. use as netnum parameter for cidrsubnet function | `string` | `"1"` | no |
| <a name="input_newbits"></a> [newbits](#input\_newbits) | new mask for the subnet within the virtual network. use as newbits parameter for cidrsubnet function | `string` | `"8"` | no |
| <a name="input_vcn_cidr"></a> [vcn\_cidr](#input\_vcn\_cidr) | The list of IPv4 CIDR blocks the VCN will use. | `any` | n/a | yes |
| <a name="input_vcn_id"></a> [vcn\_id](#input\_vcn\_id) | n/a | `any` | n/a | yes |
| <a name="input_vcn_ipv6cidr"></a> [vcn\_ipv6cidr](#input\_vcn\_ipv6cidr) | n/a | `any` | n/a | yes |
| <a name="input_vcn_nsg_name"></a> [vcn\_nsg\_name](#input\_vcn\_nsg\_name) | a part name of network security group | `string` | `"nsg"` | no |
| <a name="input_vcn_seclist_name"></a> [vcn\_seclist\_name](#input\_vcn\_seclist\_name) | a part name of security list | `string` | `"seclist"` | no |
| <a name="input_vcn_subnet_name"></a> [vcn\_subnet\_name](#input\_vcn\_subnet\_name) | a part name of subnet | `string` | `"subnet"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nsg_id"></a> [nsg\_id](#output\_nsg\_id) | id of network security group that is created |
| <a name="output_seclist_all_attributes"></a> [seclist\_all\_attributes](#output\_seclist\_all\_attributes) | all attributes of created security list |
| <a name="output_seclist_id"></a> [seclist\_id](#output\_seclist\_id) | id of security list that is created |
| <a name="output_security_lists_id"></a> [security\_lists\_id](#output\_security\_lists\_id) | id of security\_lists that is created |
| <a name="output_subnet_all_attributes"></a> [subnet\_all\_attributes](#output\_subnet\_all\_attributes) | all attributes of created subnet |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | id of subnet that is created |
| <a name="output_subnet_name"></a> [subnet\_name](#output\_subnet\_name) | id of subnet that is created |
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->
## Footer

Contributor Names
