variable "subnet_ids" {
    description = "List of my subnets ids"
    default = ["subnet-abc123", "subnet-def456", "subnet-ghi789"]
}
variable "security_group_ids" {
    description = "List of my security groups"
    default = ["sg-123456"]
}
variable "region" {
  description = "default region"
}