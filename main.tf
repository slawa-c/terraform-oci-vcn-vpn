terraform {
  backend "s3" {
    bucket                      = "lzadm-terraform-states"
    key                         = "networking/terraform.tfstate"
    region                      = "eu-marseille-1"
    endpoint                    = "https://axzhyuzcr5wv.compat.objectstorage.eu-marseille-1.oraclecloud.com"
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
  nat_gateway_route_rules      = local.nat_gateway_route_rules    # this module input shows how to pass routing information to the vcn module through Local Values.
}

module "subnets" {
  source           = "./modules/subnets"
  compartment_ocid = var.compartment_ocid
  label_prefix     = var.label_prefix
  freeform_tags    = var.freeform_tags
  vcn_seclist_name = "sl-public-1"
  vcn_subnet_name  = "public1"
  vcn_nsg_name     = "public-instance-nsg1"
  netnum           = var.netnum
  newbits          = var.newbits
  vcn_id           = module.vcn.vcn_id
  ig_route_id      = module.vcn.ig_route_id
  vcn_cidr         = var.vcn_cidrs[0]
  vcn_ipv6cidr     = join(",", module.vcn.vcn_all_attributes[*].ipv6cidr_blocks[0])

}

# * This module will create a Flex Compute Instance, using default values: 1 OCPU, 16 GB memory.
# * `instance_flex_memory_in_gbs` and `instance_flex_ocpus` are not provided: default values will be applied.
module "instance_flex" {
  source = "oracle-terraform-modules/compute-instance/oci"
  version = "2.4.0-RC1"
  # general oci parameters
  compartment_ocid = var.compartment_ocid
  freeform_tags    = var.freeform_tags
  defined_tags     = var.defined_tags
  # compute instance parameters
  ad_number                   = var.instance_ad_number
  instance_count              = var.instance_count
  instance_display_name       = var.instance_display_name
  instance_state              = var.instance_state
  shape                       = var.shape
  source_ocid                 = var.source_ocid
  source_type                 = var.source_type
  instance_flex_memory_in_gbs = var.instance_flex_memory_in_gbs # only used if shape is Flex type
  instance_flex_ocpus         = var.instance_flex_ocpus         # only used if shape is Flex type
  # baseline_ocpu_utilization = var.baseline_ocpu_utilization
  # operating system parameters
  ssh_public_keys = var.ssh_public_keys
  # networking parameters
  public_ip            = var.public_ip # NONE, RESERVED or EPHEMERAL
  subnet_ocids         = [module.subnets.subnet_id]
  primary_vnic_nsg_ids = [module.subnets.nsg_id]
  # storage parameters
  boot_volume_backup_policy  = var.boot_volume_backup_policy
  block_storage_sizes_in_gbs = var.block_storage_sizes_in_gbs
}

# resource "oci_core_local_peering_gateway" "lpg" {
#   # this is a Local Peering Gateway created to demonstrate how to use a gateway generated outside of the module as a target for a routing rule
#   compartment_id = var.compartment_ocid
#   vcn_id         = module.vcn.vcn_id
#   display_name   = "terraform-oci-lpg"
# }

