output "module_vcn" {
  description = "vcn and gateways information"
  value = {
    drg_id              = module.vcn.drg_id
    internet_gateway_id = module.vcn.internet_gateway_id
    nat_gateway_id      = module.vcn.nat_gateway_id
    service_gateway_id  = module.vcn.service_gateway_id
    vcn_id              = module.vcn.vcn_id
    ipv6cidr_block      = join(",", module.vcn.vcn_all_attributes[*].ipv6cidr_blocks[0])
  }
}

output "module_subnets" {
  value = {
    subnet_name = module.subnets.subnet_name
    subnet_id   = module.subnets.subnet_id
    nsg_id      = module.subnets.nsg_id
  }
}

output "module_compute" {
  value = {
    instance_id         = join(",", module.instance_flex.instance_id)
    instance_private_ip = join(",", module.instance_flex.private_ip)
    instance_public_ip  = join(",", module.instance_flex.public_ip)
    vnic_id             = join(",", module.instance_flex.vnic_attachment_all_attributes[0].vnic_attachments[*].vnic_id)
    # vnic_param = module.instance_flex.vnic_attachment_all_attributes[*]
    instance_public_ipv6 = oci_core_ipv6.srv_ipv6.ip_address

  }
}
# output "local_peering_gateway" {
#   description = "local peering gateways information"
#   value       = oci_core_local_peering_gateway.lpg.id
# }
