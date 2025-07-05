resource "oci_core_network_security_group" "vcn_nsg" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.label_prefix}-${var.vcn_nsg_name}"
  freeform_tags  = var.freeform_tags
  vcn_id         = var.vcn_id

  #count = (var.autonomous_database_visibility == "Private") ? 1 : 0
}

resource "oci_core_network_security_group_security_rule" "vcn_nsg_rule_01" {
  #description = <<Optional value not found in discovery>>
  #destination = <<Optional value not found in discovery>>
  destination_type          = ""
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.vcn_nsg.id
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  stateless                 = "false"
  tcp_options {
    destination_port_range {
      max = "22"
      min = "22"
    }
    #source_port_range = <<Optional value not found in discovery>>
  }
}

resource "oci_core_network_security_group_security_rule" "vcn_nsg_rule_02" {
  #description = <<Optional value not found in discovery>>
  #destination = <<Optional value not found in discovery>>
  destination_type          = ""
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.vcn_nsg.id
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  stateless                 = "false"
  tcp_options {
    destination_port_range {
      max = "80"
      min = "80"
    }
    #source_port_range = <<Optional value not found in discovery>>
  }
}

resource "oci_core_network_security_group_security_rule" "vcn_nsg_rule_03" {
  #description = <<Optional value not found in discovery>>
  #destination = <<Optional value not found in discovery>>
  destination_type          = ""
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.vcn_nsg.id
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  stateless                 = "false"
  tcp_options {
    destination_port_range {
      max = "443"
      min = "443"
    }
    #source_port_range = <<Optional value not found in discovery>>
  }
}

resource "oci_core_network_security_group_security_rule" "vcn_nsg_rule_04" {
  #description = <<Optional value not found in discovery>>
  #destination = <<Optional value not found in discovery>>
  destination_type          = ""
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.vcn_nsg.id
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  stateless                 = "false"
  tcp_options {
    destination_port_range {
      max = "9090"
      min = "9090"
    }
    #source_port_range = <<Optional value not found in discovery>>
  }
}

resource "oci_core_network_security_group_security_rule" "vcn_nsg_rule_05" {
  #description = <<Optional value not found in discovery>>
  #destination = <<Optional value not found in discovery>>
  destination_type          = ""
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.vcn_nsg.id
  protocol                  = "6"
  source                    = "::/0"
  source_type               = "CIDR_BLOCK"
  stateless                 = "false"
  tcp_options {
    destination_port_range {
      max = "22"
      min = "22"
    }
    #source_port_range = <<Optional value not found in discovery>>
  }
}

resource "oci_core_network_security_group_security_rule" "vcn_nsg_rule_06" {
  #description = <<Optional value not found in discovery>>
  #destination = <<Optional value not found in discovery>>
  destination_type          = ""
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.vcn_nsg.id
  protocol                  = "6"
  source                    = "::/0"
  source_type               = "CIDR_BLOCK"
  stateless                 = "false"
  tcp_options {
    destination_port_range {
      max = "80"
      min = "80"
    }
    #source_port_range = <<Optional value not found in discovery>>
  }
}

resource "oci_core_network_security_group_security_rule" "vcn_nsg_rule_07" {
  #description = <<Optional value not found in discovery>>
  #destination = <<Optional value not found in discovery>>
  destination_type          = ""
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.vcn_nsg.id
  protocol                  = "6"
  source                    = "::/0"
  source_type               = "CIDR_BLOCK"
  stateless                 = "false"
  tcp_options {
    destination_port_range {
      max = "443"
      min = "443"
    }
    #source_port_range = <<Optional value not found in discovery>>
  }
}

resource "oci_core_network_security_group_security_rule" "vcn_nsg_rule_08" {
  #description = <<Optional value not found in discovery>>
  #destination = <<Optional value not found in discovery>>
  destination_type          = ""
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.vcn_nsg.id
  protocol                  = "6"
  source                    = "::/0"
  source_type               = "CIDR_BLOCK"
  stateless                 = "false"
  tcp_options {
    destination_port_range {
      max = "9090"
      min = "9090"
    }
    #source_port_range = <<Optional value not found in discovery>>
  }
}


resource "oci_core_network_security_group_security_rule" "vcn_nsg_rule_09" {
  #description = <<Optional value not found in discovery>>
  #destination = <<Optional value not found in discovery>>
  destination_type          = ""
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.vcn_nsg.id
  protocol                  = "1"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  stateless                 = "false"
}

resource "oci_core_network_security_group_security_rule" "vcn_nsg_rule_10" {
  #description = <<Optional value not found in discovery>>
  #destination = <<Optional value not found in discovery>>
  destination_type          = ""
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.vcn_nsg.id
  protocol                  = "58"
  source                    = "::/0"
  source_type               = "CIDR_BLOCK"
  stateless                 = "false"
}

resource "oci_core_network_security_group_security_rule" "vcn_nsg_rule_11" {
  destination               = "::/0"
  destination_type          = "CIDR_BLOCK"
  direction                 = "EGRESS"
  network_security_group_id = oci_core_network_security_group.vcn_nsg.id
  protocol                  = "all"
  #source = <<Optional value not found in discovery>>
  source_type = ""
  stateless   = "false"
}

resource "oci_core_network_security_group_security_rule" "vcn_nsg_rule_12" {
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
  direction                 = "EGRESS"
  network_security_group_id = oci_core_network_security_group.vcn_nsg.id
  protocol                  = "all"
  #source = <<Optional value not found in discovery>>
  source_type = ""
  stateless   = "false"
}

resource "oci_core_network_security_group_security_rule" "vcn_nsg_rule_13" {
  #description = <<Optional value not found in discovery>>
  #destination = <<Optional value not found in discovery>>
  destination_type          = ""
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.vcn_nsg.id
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  stateless                 = "false"
  description               = "Allow Minecraft server port"
  tcp_options {
    destination_port_range {
      max = "25565"
      min = "25565"
    }
    #source_port_range = <<Optional value not found in discovery>>
  }
}

resource "oci_core_network_security_group_security_rule" "vcn_nsg_rule_14" {
  #description = <<Optional value not found in discovery>>
  #destination = <<Optional value not found in discovery>>
  destination_type          = ""
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.vcn_nsg.id
  protocol                  = "6"
  source                    = "::/0"
  source_type               = "CIDR_BLOCK"
  stateless                 = "false"
  description               = "Allow Minecraft server port"
  tcp_options {
    destination_port_range {
      max = "25565"
      min = "25565"
    }
    #source_port_range = <<Optional value not found in discovery>>
  }
}

resource "oci_core_network_security_group_security_rule" "vcn_nsg_rule_15" {
  #description = <<Optional value not found in discovery>>
  #destination = <<Optional value not found in discovery>>
  destination_type          = ""
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.vcn_nsg.id
  protocol                  = "17"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  stateless                 = "false"
  description               = "Allow Minecraft server port"
  udp_options {
    destination_port_range {
      max = "25565"
      min = "25565"
    }
    #source_port_range = <<Optional value not found in discovery>>
  }
}

resource "oci_core_network_security_group_security_rule" "vcn_nsg_rule_16" {
  #description = <<Optional value not found in discovery>>
  #destination = <<Optional value not found in discovery>>
  destination_type          = ""
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.vcn_nsg.id
  protocol                  = "17"
  source                    = "::/0"
  source_type               = "CIDR_BLOCK"
  stateless                 = "false"
  description               = "Allow Minecraft server port"
  udp_options {
    destination_port_range {
      max = "25565"
      min = "25565"
    }
    #source_port_range = <<Optional value not found in discovery>>
  }
}