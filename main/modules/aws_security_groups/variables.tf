variable "name" {}
variable "description" {}
variable "vpc_id" {}

//ingress
variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

# //egress
# variable "egress_from_port"{}
# variable "egress_to_port"{}
# variable "egress_protocol"{}
# variable "egress_cidr_blocks"{ type = list(string)}