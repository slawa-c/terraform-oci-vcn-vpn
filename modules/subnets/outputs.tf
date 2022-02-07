output "security_lists_id" {
  description = "id of security_lists that is created"
  value       = oci_core_security_list.vcn_seclist.id
}

output "subnet_id" {
  description = "id of subnet that is created"
  value       = oci_core_subnet.vcn_subnet.id
}

output "subnet_name" {
  description = "id of subnet that is created"
  value       = oci_core_subnet.vcn_subnet.display_name
}

output "subnet_all_attributes" {
  description = "all attributes of created subnet"
  value       = { for k, v in oci_core_subnet.vcn_subnet : k => v }
}

output "seclist_id" {
  description = "id of security list that is created"
  value       = oci_core_security_list.vcn_seclist.id
}

output "nsg_id" {
  description = "id of network security group that is created"
  value       = oci_core_network_security_group.vcn_nsg.id
}

output "seclist_all_attributes" {
  description = "all attributes of created security list"
  value       = { for k, v in oci_core_security_list.vcn_seclist : k => v }
}
