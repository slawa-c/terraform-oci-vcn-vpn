variable "compartment_ocid" {
  description = "compartment ocid where to create all resources"
  type        = string
  # no default value, asking user to explicitly set this variable's value. see codingconventions.adoc
}

variable "label_prefix" {
  description = "a string that will be prepended to all resources"
  type        = string
  default     = "terraform-oci"
}

variable "freeform_tags" {
  description = "simple key-value pairs to tag the created resources using freeform OCI Free-form tags."
  type        = map(any)
  default = {
    terraformed = "please do not edit manually"
    module      = "oracle-terraform-modules/vcn/oci"
  }
}

# subnets parameters

variable "netnum" {
  description = "zero-based index of the subnet when the network is masked with the newbit. use as netnum parameter for cidrsubnet function"
  default = {
    bastion = 32
    web     = 16
  }
  type = map
}

variable "newbits" {
  description = "new mask for the subnet within the virtual network. use as newbits parameter for cidrsubnet function"
  default = {
    bastion = 13
    web     = 11
  }
  type = map
}

variable "vcn_id" {
  
}

variable "ig_route_id" {
  
}

variable "vcn_cidr" {
  description = "The list of IPv4 CIDR blocks the VCN will use."

}
variable "vcn_ipv6cidr" {
  
}