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
