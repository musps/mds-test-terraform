variable bucket {
  default = "mds-mai"
}

variable public_key_path {
}

variable private_key_path {
}

variable ami_id {
}

variable ssh_user {
  default = "ubuntu"
}

variable app_port {
  default = 8080
}

variable db_name {
  default = "mds_db"
}

variable db_username {
  default = "mds_user"
}

variable db_password {
}

variable db_port {
  default = 5432
}

variable cird_block_main {
  default = "172.2.0.0/16"
}

variable cird_block_bastion {
  default = "172.2.2.0/24"
}

variable cird_block_ursho {
  default = "172.2.1.0/24"
}
