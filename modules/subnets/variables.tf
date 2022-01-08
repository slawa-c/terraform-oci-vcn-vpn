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

variable "vcn_seclist_name" {
  description = "a part name of security list"
  type        = string
  default     = "seclist"
}
variable "vcn_subnet_name" {
  description = "a part name of subnet"
  type        = string
  default     = "subnet"
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
  default = "1"
  type = string
}

variable "newbits" {
  description = "new mask for the subnet within the virtual network. use as newbits parameter for cidrsubnet function"
  default = "8"
  type = string
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