output "security_lists_id" {
  description = "id of security_lists that is created"
  value       = oci_core_security_list.vcn_seclist.id
}

output "subnet_id" {
  description = "id of subnet that is created"
  value       = oci_core_subnet.vcn_subnet.id
}

output "seclist_all_attributes" {
  description = "all attributes of created vcn"
  value       = { for k, v in oci_core_security_list.vcn_seclist : k => v }
}
