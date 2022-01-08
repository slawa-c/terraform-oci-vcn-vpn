terraform {
  backend "s3" {
    bucket   = "lzadm-terraform-states"
    key      = "networking/terraform.tfstate"
    region   = "eu-marseille-1"
    endpoint = "https://axzhyuzcr5wv.compat.objectstorage.eu-marseille-1.oraclecloud.com"
    shared_credentials_file     = "~/.oci/api_keys/tf_shared_credentials"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}

# data "terraform_remote_state" "governance" {
#   backend = "s3"
#   config = {
#     bucket = "lzadm-terraform-states"
#     key = "governance/terraform.tfstate"
#     region = "eu-marseille-1"
#     endpoint = "https://axzhyuzcr5wv.compat.objectstorage.eu-marseille-1.oraclecloud.com"
#     shared_credentials_file = "~/.oci/api_keys/tf_shared_credentials"
#     skip_region_validation = true
#     skip_credentials_validation = true
#     skip_metadata_api_check = true
#     force_path_style = true
#   }
# }

# Resources

module "vcn" {
  source  = "oracle-terraform-modules/vcn/oci"
  version = "3.1.0"

  # general oci parameters
  compartment_id = var.compartment_ocid
  label_prefix   = var.label_prefix
  freeform_tags  = var.freeform_tags

  # vcn parameters
  create_drg               = var.create_drg               # boolean: true or false
  create_internet_gateway  = var.create_internet_gateway  # boolean: true or false
  lockdown_default_seclist = var.lockdown_default_seclist # boolean: true or false
  create_nat_gateway       = var.create_nat_gateway       # boolean: true or false
  create_service_gateway   = var.create_service_gateway   # boolean: true or false
  enable_ipv6              = var.enable_ipv6
  vcn_cidrs                = var.vcn_cidrs # List of IPv4 CIDRs
  vcn_dns_label            = var.vcn_dns_label
  vcn_name                 = var.vcn_name

  # gateways parameters
  drg_display_name              = var.drg_display_name
  internet_gateway_display_name = var.internet_gateway_display_name
  nat_gateway_display_name      = var.nat_gateway_display_name
  service_gateway_display_name  = var.service_gateway_display_name

  # routing rules

  internet_gateway_route_rules = var.internet_gateway_route_rules # this module input shows how to pass routing information to the vcn module through  Variable Input. Can be initialized in a *.tfvars or *.auto.tfvars file
  # nat_gateway_route_rules      = local.nat_gateway_route_rules    # this module input shows how to pass routing information to the vcn module through Local Values.
}

module "subnets" {
  source = "./modules/subnets"
  compartment_ocid = var.compartment_ocid
  netnum  = var.netnum
  newbits = var.newbits
  vcn_id = module.vcn.vcn_id
  ig_route_id = module.vcn.ig_route_id
  vcn_cidr = var.vcn_cidrs[0]
  vcn_ipv6cidr = join(",",module.vcn.vcn_all_attributes[*].ipv6cidr_blocks[0])

  # other required variables

}

# resource "oci_core_local_peering_gateway" "lpg" {
#   # this is a Local Peering Gateway created to demonstrate how to use a gateway generated outside of the module as a target for a routing rule
#   compartment_id = var.compartment_ocid
#   vcn_id         = module.vcn.vcn_id
#   display_name   = "terraform-oci-lpg"
# }


# resource "oci_core_vcn" "generated_oci_core_vcn" {
# 	cidr_blocks = ["10.2.0.0/16"]
# 	# compartment_id = "ocid1.tenancy.oc1..aaaaaaaa5l5lugr4vxmu2r3aa3yh76ylywz4xdj742iuohadu475ea7mndga"
# 	compartment_id = var.compartment_ocid
# 	display_name = "vpn-wg01-vcn-test"
# 	dns_label = "vpnwg01vcntest"
# 	is_ipv6enabled = "true"
# }

# resource "oci_core_internet_gateway" "test_internet_gateway" {
#     #Required
#     compartment_id = var.compartment_id
#     vcn_id = oci_core_vcn.test_vcn.id

#     #Optional
#     enabled = var.internet_gateway_enabled
#     defined_tags = {"Operations.CostCenter"= "42"}
#     display_name = var.internet_gateway_display_name
#     freeform_tags = {"Department"= "Finance"}
# }