resource "oci_core_subnet" "bastion" {
  cidr_block                 = cidrsubnet(var.vcn_cidr, var.newbits["bastion"], var.netnum["bastion"])
  ipv6cidr_block             = cidrsubnet(var.vcn_ipv6cidr, var.newbits["bastion"], var.netnum["bastion"])
  compartment_id             = var.compartment_ocid
  display_name               = "${var.label_prefix}-bastion"
  dns_label                  = "bastion"
  prohibit_public_ip_on_vnic = false
  route_table_id             = var.ig_route_id
  security_list_ids          = [oci_core_security_list.bastion.id]
  vcn_id                     = var.vcn_id
}

resource "oci_core_subnet" "web" {
  cidr_block                 = cidrsubnet(var.vcn_cidr, var.newbits["web"], var.netnum["web"])
  ipv6cidr_block             = cidrsubnet(var.vcn_ipv6cidr, var.newbits["web"], var.netnum["web"])
  compartment_id             = var.compartment_ocid
  display_name               = "${var.label_prefix}-web"
  dns_label                  = "web"
  prohibit_public_ip_on_vnic = false
  route_table_id             = var.ig_route_id
  security_list_ids          = [oci_core_security_list.web.id]
  vcn_id                     = var.vcn_id
}